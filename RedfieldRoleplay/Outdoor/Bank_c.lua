local sx, sy = guiGetScreenSize()
local scale = math.min(sx / 1920, sy / 1080)

local bankverwaltungVisible = false

local function isCursorOnElement(x, y, width, height)
	if not isCursorShowing() then return false end
	local cx, cy = getCursorPosition()
	if not cx or not cy then return false end
	cx, cy = cx * sx, cy * sy
	return cx >= x and cx <= x + width and cy >= y and cy <= y + height
end

local function getBankverwaltungLayout()
	local width, height = 460 * scale, 300 * scale
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

local function drawBankverwaltung()
	if not bankverwaltungVisible then return end

	local x, y, width, height, padding = getBankverwaltungLayout()
	local contentWidth = width - padding * 2
	local textY = y + 18 * scale
	local textHeight = 115 * scale
	local buttonHeight = 42 * scale
	local buttonGap = 10 * scale
	local buttonWidth = (contentWidth - buttonGap) / 2
	local buttonY = textY + textHeight + 15 * scale
	local closeY = buttonY + buttonHeight + 10 * scale

	dxDrawRectangle(x, y, width, height, tocolor(0, 0, 0, 240), false)
	dxDrawRectangle(x, y, width, 3 * scale, tocolor(0, 100, 200, 255), false)
	dxDrawRectangle(x + padding, textY, contentWidth, textHeight, tocolor(20, 20, 20, 255), false)
	dxDrawRectangle(x + padding, textY, 3 * scale, textHeight, tocolor(0, 100, 200, 255), false)
	dxDrawText(getText("Bankverwaltung4"), x + padding + 15 * scale, textY + 10 * scale, x + width - padding - 15 * scale, textY + textHeight - 10 * scale, tocolor(255, 255, 255, 255), 1 * scale, "default-bold", "center", "center", true, true)

	drawButton(getText("Bankverwaltung1"), x + padding, buttonY, buttonWidth, buttonHeight)
	drawButton(getText("Bankverwaltung2"), x + padding + buttonWidth + buttonGap, buttonY, buttonWidth, buttonHeight)
	drawButton(getText("Bankverwaltung3"), x + padding, closeY, contentWidth, buttonHeight)
end

function closeBankverwaltungWindow()
	if not bankverwaltungVisible then return end

	bankverwaltungVisible = false
	removeEventHandler("onClientRender", root, drawBankverwaltung)
	removeEventHandler("onClientClick", root, bankverwaltungClick)
	showCursor(false)
	setElementData(localPlayer, "redfieldClick", false)
end

function bankverwaltungClick(button, state)
	if not bankverwaltungVisible or button ~= "left" or state ~= "down" then return end

	local x, y, width, height, padding = getBankverwaltungLayout()
	local contentWidth = width - padding * 2
	local textY = y + 18 * scale
	local textHeight = 115 * scale
	local buttonHeight = 42 * scale
	local buttonGap = 10 * scale
	local buttonWidth = (contentWidth - buttonGap) / 2
	local buttonY = textY + textHeight + 15 * scale
	local closeY = buttonY + buttonHeight + 10 * scale

	if isCursorOnElement(x + padding, buttonY, buttonWidth, buttonHeight) then
		triggerServerEvent("createBankAccount", localPlayer)
		return
	end

	if isCursorOnElement(x + padding + buttonWidth + buttonGap, buttonY, buttonWidth, buttonHeight) then
		triggerServerEvent("requestBankPin", localPlayer)
		return
	end

	if isCursorOnElement(x + padding, closeY, contentWidth, buttonHeight) then
		closeBankverwaltungWindow()
	end
end

function bankverwaltungWindow()
	if bankverwaltungVisible then return end
	if getElementData(localPlayer, "redfieldClick") == true then return end

	bankverwaltungVisible = true
	showCursor(true)
	setElementData(localPlayer, "redfieldClick", true)
	addEventHandler("onClientRender", root, drawBankverwaltung)
	addEventHandler("onClientClick", root, bankverwaltungClick)
end
addEvent("bankverwaltungWindow", true)
addEventHandler("bankverwaltungWindow", root, bankverwaltungWindow)

addEventHandler("onClientPlayerWasted", localPlayer, function()
	closeBankverwaltungWindow()
end)