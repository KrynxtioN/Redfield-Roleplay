local versicherungOpen = false
local sx, sy = guiGetScreenSize()
local scale = math.min(sx / 1920, sy / 1080)

local function isCursorOnElement(x, y, w, h)
	if not isCursorShowing() then return false end
	local cx, cy = getCursorPosition()
	if not cx or not cy then return false end
	cx, cy = cx * sx, cy * sy
	return cx >= x and cx <= x + w and cy >= y and cy <= y + h
end

local function getVersicherungLayout()
	local w, h = 480 * scale, 300 * scale
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

function renderVersicherung()
	if not versicherungOpen then return end

	local x, y, w, h, padding = getVersicherungLayout()
	local contentW = w - padding * 2
	local infoY = y + 52 * scale
	local infoH = 105 * scale
	local buttonW = contentW
	local buttonH = 42 * scale
	local actionY = y + 180 * scale
	local closeY = actionY + buttonH + 10 * scale

	dxDrawRectangle(x, y, w, h, tocolor(0, 0, 0, 240), false)
	dxDrawRectangle(x, y, w, 3 * scale, tocolor(0, 100, 200, 255), false)

	dxDrawText(getText("Versicherung1"), x + padding, y + 10 * scale, x + w - padding, y + 43 * scale, tocolor(255, 255, 255, 255), 1.1 * scale, "default-bold", "center", "center", true)

	dxDrawRectangle(x + padding, infoY, contentW, infoH, tocolor(20, 20, 20, 255), false)
	dxDrawRectangle(x + padding, infoY, 3 * scale, infoH, tocolor(0, 100, 200, 255), false)
	dxDrawText(getText("Versicherung2"), x + padding + 15 * scale, infoY + 10 * scale, x + w - padding - 15 * scale, infoY + infoH - 10 * scale, tocolor(220, 220, 220, 255), 1 * scale, "default-bold", "left", "center", true, true)

	local actionText = tonumber(getElementData(localPlayer, "Versicherung")) == 1 and getText("Versicherung4") or getText("Versicherung3")
	drawButton(actionText, x + padding, actionY, buttonW, buttonH)
	drawButton(getText("Versicherung5"), x + padding, closeY, buttonW, buttonH)
end

function closeVersicherung()
	if not versicherungOpen then return end

	versicherungOpen = false
	setElementData(localPlayer, "redfieldClick", false)
	showCursor(false)
	removeEventHandler("onClientRender", root, renderVersicherung)
	removeEventHandler("onClientClick", root, versicherungClick)
end

function versicherungClick(button, state)
	if not versicherungOpen or button ~= "left" or state ~= "up" then return end

	local x, y, w, h, padding = getVersicherungLayout()
	local contentW = w - padding * 2
	local buttonH = 42 * scale
	local actionY = y + 180 * scale
	local closeY = actionY + buttonH + 10 * scale

	if isCursorOnElement(x + padding, actionY, contentW, buttonH) then
		if tonumber(getElementData(localPlayer, "Versicherung")) == 1 then
			triggerServerEvent("versicherungStop", localPlayer)
		else
			triggerServerEvent("versicherung", localPlayer)
		end
		return
	end

	if isCursorOnElement(x + padding, closeY, contentW, buttonH) then
		closeVersicherung()
	end
end

function versicherungWindow()
	if versicherungOpen then return end
	if getElementData(localPlayer, "redfieldClick") == true then return end

	versicherungOpen = true
	setElementData(localPlayer, "redfieldClick", true)
	showCursor(true)
	addEventHandler("onClientRender", root, renderVersicherung)
	addEventHandler("onClientClick", root, versicherungClick)
end
addEvent("versicherungWindow", true)
addEventHandler("versicherungWindow", root, versicherungWindow)

addEventHandler("onClientPlayerWasted", localPlayer, function()
	closeVersicherung()
end)