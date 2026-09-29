local sx, sy = guiGetScreenSize()
local scale = math.min(sx / 1920, sy / 1080)

local tankeOpen = false
local tankeEdit = nil

local function isCursorOnElement(x, y, w, h)
	if not isCursorShowing() then return false end
	local cx, cy = getCursorPosition()
	if not cx or not cy then return false end
	cx, cy = cx * sx, cy * sy
	return cx >= x and cx <= x + w and cy >= y and cy <= y + h
end

local function getTankeLayout()
	local w, h = 500 * scale, 290 * scale
	local x, y = (sx - w) / 2, (sy - h) / 2
	local padding = 15 * scale
	return x, y, w, h, padding
end

local function drawButton(text, x, y, w, h)
	local hover = isCursorOnElement(x, y, w, h)
	dxDrawRectangle(x, y, w, h, hover and tocolor(0, 100, 200, 255) or tocolor(30, 30, 30, 255), false)
	dxDrawRectangle(x, y + h - 2 * scale, w, 2 * scale, tocolor(0, 100, 200, 255), false)
	dxDrawText(text, x + 8 * scale, y, x + w - 8 * scale, y + h, tocolor(255, 255, 255, 255), 1 * scale, "default-bold", "center", "center", true)
end

local function createTankeEdit()
	if isElement(tankeEdit) then destroyElement(tankeEdit) end
	tankeEdit = guiCreateEdit(-1, -1, 1, 1, "", true)
	guiEditSetMaxLength(tankeEdit, 3)
	guiSetAlpha(tankeEdit, 0)
	guiBringToFront(tankeEdit)
	guiFocus(tankeEdit)
	guiSetInputEnabled(true)
end

local function renderTanke()
	if not tankeOpen then return end

	local x, y, w, h, padding = getTankeLayout()
	local contentW = w - padding * 2
	local gap = 12 * scale
	local leftW = 220 * scale
	local rightW = contentW - leftW - gap
	local buttonH = 44 * scale
	local buttonGap = 10 * scale
	local startY = y + 20 * scale
	local inputH = 44 * scale
	local inputY = startY + 65 * scale
	local closeY = y + h - padding - buttonH
	local literText = isElement(tankeEdit) and guiGetText(tankeEdit) or ""

	dxDrawRectangle(x, y, w, h, tocolor(0, 0, 0, 240), false)
	dxDrawRectangle(x, y, w, 3 * scale, tocolor(0, 100, 200, 255), false)

	drawButton(getText("Tankstelle4"), x + padding, startY, leftW, buttonH)
	drawButton(getText("Tankstelle5"), x + padding, startY + buttonH + buttonGap, leftW, buttonH)
	drawButton(getText("Tankstelle6"), x + padding, closeY, leftW, buttonH)

	local rightX = x + padding + leftW + gap
	dxDrawRectangle(rightX, startY, rightW, 50 * scale, tocolor(20, 20, 20, 255), false)
	dxDrawRectangle(rightX, startY, 3 * scale, 50 * scale, tocolor(0, 100, 200, 255), false)
	dxDrawText(getText("Tankstelle7"), rightX + 12 * scale, startY, rightX + rightW - 12 * scale, startY + 50 * scale, tocolor(255, 255, 255, 255), 1 * scale, "default-bold", "center", "center", true)

	local inputHover = isCursorOnElement(rightX, inputY, rightW, inputH)
	dxDrawRectangle(rightX, inputY, rightW, inputH, inputHover and tocolor(35, 35, 35, 255) or tocolor(20, 20, 20, 255), false)
	dxDrawRectangle(rightX, inputY + inputH - 2 * scale, rightW, 2 * scale, tocolor(0, 100, 200, 255), false)
	dxDrawText(literText, rightX + 12 * scale, inputY, rightX + rightW - 12 * scale, inputY + inputH, tocolor(255, 255, 255, 255), 1 * scale, "default-bold", "center", "center", true)
end

function closeTankeWindow()
	if not tankeOpen then return end

	tankeOpen = false
	removeEventHandler("onClientRender", root, renderTanke)
	removeEventHandler("onClientClick", root, tankeClick)

	if isElement(tankeEdit) then destroyElement(tankeEdit) end
	tankeEdit = nil

	guiSetInputEnabled(false)
	showCursor(false)
	setElementData(localPlayer, "redfieldClick", false)
end

function tankeClick(button, state)
	if not tankeOpen or button ~= "left" or state ~= "down" then return end

	local x, y, w, h, padding = getTankeLayout()
	local contentW = w - padding * 2
	local gap = 12 * scale
	local leftW = 220 * scale
	local rightW = contentW - leftW - gap
	local buttonH = 44 * scale
	local buttonGap = 10 * scale
	local startY = y + 20 * scale
	local inputH = 44 * scale
	local inputY = startY + 65 * scale
	local closeY = y + h - padding - buttonH
	local rightX = x + padding + leftW + gap

	if isCursorOnElement(x + padding, startY, leftW, buttonH) then
		triggerServerEvent("fulltanken", localPlayer)
		return
	end

	if isCursorOnElement(x + padding, startY + buttonH + buttonGap, leftW, buttonH) then
		local liter = isElement(tankeEdit) and tonumber(guiGetText(tankeEdit)) or nil

		if liter then
			if liter >= 1 and liter <= 100 then
				triggerServerEvent("litertanken", localPlayer, liter)
			else
				infobox(getText("Tankstelle8"), 255, 0, 0)
			end
		else
			infobox(getText("Tankstelle9"), 255, 0, 0)
		end
		return
	end

	if isCursorOnElement(x + padding, closeY, leftW, buttonH) then
		closeTankeWindow()
		return
	end

	if isCursorOnElement(rightX, inputY, rightW, inputH) then
		if isElement(tankeEdit) then guiFocus(tankeEdit) end
	end
end

function tankeWindow()
	if tankeOpen then return end
	if getElementData(localPlayer, "redfieldClick") == true then return end

	local veh = getPedOccupiedVehicle(localPlayer)
	if not veh then
		infobox(getText("Tankstelle10"), 255, 0, 0)
		return
	end

	tankeOpen = true
	showCursor(true)
	setElementData(localPlayer, "redfieldClick", true)
	createTankeEdit()
	addEventHandler("onClientRender", root, renderTanke)
	addEventHandler("onClientClick", root, tankeClick)
end
addEvent("tankeWindow", true)
addEventHandler("tankeWindow", root, tankeWindow)

addEventHandler("onClientPlayerWasted", localPlayer, function()
	closeTankeWindow()
end)