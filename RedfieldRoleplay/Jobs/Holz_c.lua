local sx, sy = guiGetScreenSize()
local scale = math.min(sx / 1920, sy / 1080)

local holzjobmarker = {
	{-464.88827514648, 6.5740828514099, 52.596855163574},
	{-464.40997314453, 23.507080078125, 49.468074798584},
	{-448.31390380859, 24.899824142456, 49.783142089844},
	{-436.86318969727, 19.715198516846, 51.32043838501},
	{-449.03115844727, 8.9561500549316, 52.018310546875},
	{-436.80294799805, 0.74320089817047, 52.772216796875},
	{-451.62973022461, -6.8297567367554, 54.319541931152},
	{-448.80157470703, -22.947471618652, 56.520484924316},
	{-437.52938842773, -12.761728286743, 54.06884765625},
	{-434.16989135742, -28.562366485596, 57.03689956665}
}

local holzmarkerpickup = nil
local holzmarkerblip = nil
local holzCollecting = false
local holzWindowOpen = false
local holzEdit = nil

function holzjobStart()
	if isElement(holzmarkerpickup) then destroyElement(holzmarkerpickup) end
	if isElement(holzmarkerblip) then destroyElement(holzmarkerblip) end

	holzCollecting = false

	local position = holzjobmarker[math.random(1, #holzjobmarker)]
	holzmarkerpickup = createPickup(position[1], position[2], position[3], 3, 1318, 50)
	holzmarkerblip = createBlip(position[1], position[2], position[3], 0, 2, 255, 0, 0)

	addEventHandler("onClientPickupHit", holzmarkerpickup, function(element)
		if element ~= localPlayer or holzCollecting then return end

		holzCollecting = true

		if isElement(holzmarkerpickup) then destroyElement(holzmarkerpickup) end
		if isElement(holzmarkerblip) then destroyElement(holzmarkerblip) end

		holzmarkerpickup = nil
		holzmarkerblip = nil

		toggleAllControls(false)

		setTimer(function()
			toggleAllControls(true)
			triggerServerEvent("holzCollected", localPlayer)
		end, 4000, 1)
	end)
end
addEvent("holzjobStart", true)
addEventHandler("holzjobStart", root, holzjobStart)

function destroyHolz()
	if isElement(holzmarkerpickup) then destroyElement(holzmarkerpickup) end
	if isElement(holzmarkerblip) then destroyElement(holzmarkerblip) end

	holzmarkerpickup = nil
	holzmarkerblip = nil
	holzCollecting = false

	toggleAllControls(true)
end
addEvent("destroyHolz", true)
addEventHandler("destroyHolz", root, destroyHolz)

local function isCursorOnElement(x, y, w, h)
	if not isCursorShowing() then return false end

	local cx, cy = getCursorPosition()
	if not cx or not cy then return false end

	cx, cy = cx * sx, cy * sy
	return cx >= x and cx <= x + w and cy >= y and cy <= y + h
end

local function getHolzLayout()
	local w, h = 500 * scale, 320 * scale
	local x, y = (sx - w) / 2, (sy - h) / 2
	local padding = 15 * scale
	return x, y, w, h, padding
end

local function drawHolzButton(text, x, y, w, h)
	local hover = isCursorOnElement(x, y, w, h)
	dxDrawRectangle(x, y, w, h, hover and tocolor(0, 100, 200, 255) or tocolor(30, 30, 30, 255), false)
	dxDrawRectangle(x, y + h - 2 * scale, w, 2 * scale, tocolor(0, 100, 200, 255), false)
	dxDrawText(text, x + 8 * scale, y, x + w - 8 * scale, y + h, tocolor(255, 255, 255, 255), 1 * scale, "default-bold", "center", "center", true)
end

local function renderHolzWindow()
	if not holzWindowOpen then return end

	local x, y, w, h, padding = getHolzLayout()
	local contentW = w - padding * 2
	local infoY = y + 20 * scale
	local infoH = 85 * scale
	local editY = y + 125 * scale
	local editH = 45 * scale
	local buttonH = 48 * scale
	local buttonGap = 10 * scale
	local buttonW = (contentW - buttonGap) / 2
	local buttonY = y + h - padding - buttonH
	local menge = isElement(holzEdit) and guiGetText(holzEdit) or ""

	dxDrawRectangle(x, y, w, h, tocolor(0, 0, 0, 240), false)
	dxDrawRectangle(x, y, w, 3 * scale, tocolor(0, 100, 200, 255), false)

	dxDrawRectangle(x + padding, infoY, contentW, infoH, tocolor(20, 20, 20, 255), false)
	dxDrawRectangle(x + padding, infoY, 3 * scale, infoH, tocolor(0, 100, 200, 255), false)
	dxDrawText(getText("Holzjob12"), x + padding + 15 * scale, infoY + 8 * scale, x + w - padding - 15 * scale, infoY + infoH - 8 * scale, tocolor(255, 255, 255, 255), 1 * scale, "default-bold", "left", "center", true, true)

	local editHover = isCursorOnElement(x + padding, editY, contentW, editH)
	dxDrawRectangle(x + padding, editY, contentW, editH, editHover and tocolor(35, 35, 35, 255) or tocolor(20, 20, 20, 255), false)
	dxDrawRectangle(x + padding, editY + editH - 2 * scale, contentW, 2 * scale, tocolor(0, 100, 200, 255), false)
	dxDrawText(menge, x + padding + 12 * scale, editY, x + w - padding - 12 * scale, editY + editH, tocolor(255, 255, 255, 255), 1 * scale, "default-bold", "left", "center", true)

	drawHolzButton(getText("Holzjob14"), x + padding, buttonY, buttonW, buttonH)
	drawHolzButton(getText("Holzjob13"), x + padding + buttonW + buttonGap, buttonY, buttonW, buttonH)
end

local function createHolzEdit()
	if isElement(holzEdit) then destroyElement(holzEdit) end

	holzEdit = guiCreateEdit(-1, -1, 1, 1, "", false)
	guiEditSetMaxLength(holzEdit, 10)
	guiSetAlpha(holzEdit, 0)
	guiBringToFront(holzEdit)
	guiFocus(holzEdit)
	guiSetInputEnabled(true)
end

local function closeHolzWindow()
	if not holzWindowOpen then return end

	holzWindowOpen = false

	removeEventHandler("onClientRender", root, renderHolzWindow)
	removeEventHandler("onClientClick", root, holzWindowClick)
	unbindKey("f3", "down", closeHolzWindow)

	if isElement(holzEdit) then destroyElement(holzEdit) end
	holzEdit = nil

	guiSetInputEnabled(false)
	showCursor(false)
	setElementData(localPlayer, "redfieldClick", false)
end

local function getHolzMenge()
	if not isElement(holzEdit) then return false end

	local menge = tonumber(guiGetText(holzEdit))

	if not menge or menge <= 0 or menge ~= math.floor(menge) then
		infobox(getText("Holzjob7"), 255, 0, 0)
		return false
	end

	return menge
end

function holzWindowClick(button, state)
	if not holzWindowOpen or button ~= "left" or state ~= "down" then return end

	local x, y, w, h, padding = getHolzLayout()
	local contentW = w - padding * 2
	local editY = y + 125 * scale
	local editH = 45 * scale
	local buttonH = 48 * scale
	local buttonGap = 10 * scale
	local buttonW = (contentW - buttonGap) / 2
	local buttonY = y + h - padding - buttonH

	if isCursorOnElement(x + padding, editY, contentW, editH) then
		if isElement(holzEdit) then
			guiBringToFront(holzEdit)
			guiFocus(holzEdit)
			guiSetInputEnabled(true)
		end
		return
	end

	if isCursorOnElement(x + padding, buttonY, buttonW, buttonH) then
		local menge = getHolzMenge()
		if not menge then return end

		triggerServerEvent("sellBirkenholz", localPlayer, menge)
		return
	end

	if isCursorOnElement(x + padding + buttonW + buttonGap, buttonY, buttonW, buttonH) then
		local menge = getHolzMenge()
		if not menge then return end

		triggerServerEvent("sellEichenholz", localPlayer, menge)
	end
end

function holzWindow()
	if holzWindowOpen then return end
	if getElementData(localPlayer, "redfieldClick") == true then return end

	holzWindowOpen = true
	showCursor(true)
	setElementData(localPlayer, "redfieldClick", true)

	createHolzEdit()

	addEventHandler("onClientRender", root, renderHolzWindow)
	addEventHandler("onClientClick", root, holzWindowClick)
	bindKey("f3", "down", closeHolzWindow)
end
addEvent("holzWindow", true)
addEventHandler("holzWindow", root, holzWindow)

addEventHandler("onClientPlayerWasted", localPlayer, function()
	destroyHolz()
	closeHolzWindow()
end)