local sx, sy = guiGetScreenSize()
local scale = math.min(sx / 1920, sy / 1080)

local motelVisible = false

local function isCursorOnElement(x, y, width, height)
	if not isCursorShowing() then return false end
	local cx, cy = getCursorPosition()
	if not cx or not cy then return false end
	cx, cy = cx * sx, cy * sy
	return cx >= x and cx <= x + width and cy >= y and cy <= y + height
end

local function getMotelLayout()
	local width, height = 500 * scale, 310 * scale
	local x, y = (sx - width) / 2, (sy - height) / 2
	local padding = 15 * scale
	return x, y, width, height, padding
end

local function drawButton(text, x, y, width, height)
	local hover = isCursorOnElement(x, y, width, height)
	dxDrawRectangle(x, y, width, height, hover and tocolor(0, 100, 200, 255) or tocolor(30, 30, 30, 255), false)
	dxDrawRectangle(x, y + height - 2 * scale, width, 2 * scale, tocolor(0, 100, 200, 255), false)
	dxDrawText(text, x + 8 * scale, y, x + width - 8 * scale, y + height, tocolor(255, 255, 255, 255), 1 * scale, "default-bold", "center", "center", true)
end

local function drawMotelWindow()
	if not motelVisible then return end

	local x, y, width, height, padding = getMotelLayout()
	local contentWidth = width - padding * 2
	local leftWidth = 210 * scale
	local gap = 12 * scale
	local rightWidth = contentWidth - leftWidth - gap
	local buttonHeight = 44 * scale
	local buttonGap = 10 * scale
	local contentY = y + 20 * scale
	local infoHeight = 205 * scale

	dxDrawRectangle(x, y, width, height, tocolor(0, 0, 0, 240), false)
	dxDrawRectangle(x, y, width, 3 * scale, tocolor(0, 100, 200, 255), false)

	dxDrawRectangle(x + padding + leftWidth + gap, contentY, rightWidth, infoHeight, tocolor(20, 20, 20, 255), false)
	dxDrawRectangle(x + padding + leftWidth + gap, contentY, 3 * scale, infoHeight, tocolor(0, 100, 200, 255), false)
	dxDrawText(getText("Motel8"), x + padding + leftWidth + gap + 15 * scale, contentY + 12 * scale, x + width - padding - 12 * scale, contentY + infoHeight - 12 * scale, tocolor(255, 255, 255, 255), 1 * scale, "default-bold", "left", "top", false, true)

	drawButton(getText("Motel5"), x + padding, contentY, leftWidth, buttonHeight)
	drawButton(getText("Motel6"), x + padding, contentY + buttonHeight + buttonGap, leftWidth, buttonHeight)
	drawButton(getText("Motel7"), x + padding, contentY + infoHeight - buttonHeight, leftWidth, buttonHeight)
end

function closeMotelWindow(sendServer)
	if not motelVisible then return end

	motelVisible = false
	removeEventHandler("onClientRender", root, drawMotelWindow)
	removeEventHandler("onClientClick", root, motelWindowClick)
	showCursor(false)
	setElementData(localPlayer, "redfieldClick", false)

	if sendServer then
		triggerServerEvent("closeMotelSession", localPlayer)
	end
end

function motelWindowClick(button, state)
	if not motelVisible or button ~= "left" or state ~= "down" then return end

	local x, y, width, height, padding = getMotelLayout()
	local contentWidth = width - padding * 2
	local leftWidth = 210 * scale
	local buttonHeight = 44 * scale
	local buttonGap = 10 * scale
	local contentY = y + 20 * scale
	local infoHeight = 205 * scale

	if isCursorOnElement(x + padding, contentY, leftWidth, buttonHeight) then
		triggerServerEvent("zimmerMieten", localPlayer)
		return
	end

	if isCursorOnElement(x + padding, contentY + buttonHeight + buttonGap, leftWidth, buttonHeight) then
		triggerServerEvent("ausmietenMotel", localPlayer)
		return
	end

	if isCursorOnElement(x + padding, contentY + infoHeight - buttonHeight, leftWidth, buttonHeight) then
		closeMotelWindow(true)
	end
end

function motelWindow()
	if motelVisible then return end
	if getElementData(localPlayer, "redfieldClick") == true then return end

	motelVisible = true

	triggerServerEvent("openMotelSession", localPlayer)

	showCursor(true)
	setElementData(localPlayer, "redfieldClick", true)
	addEventHandler("onClientRender", root, drawMotelWindow)
	addEventHandler("onClientClick", root, motelWindowClick)
end
addEvent("motelWindow", true)
addEventHandler("motelWindow", root, motelWindow)

addEvent("closeMotelWindow", true)
addEventHandler("closeMotelWindow", root, function()
	closeMotelWindow(false)
end)

addEventHandler("onClientPlayerWasted", localPlayer, function()
	closeMotelWindow(false)
end)