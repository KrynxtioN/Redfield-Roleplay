local sx, sy = guiGetScreenSize()
local waffenscheinVisible = false

local function isCursorOnElement(x, y, width, height)
	if not isCursorShowing() then return false end
	local cx, cy = getCursorPosition()
	if not cx or not cy then return false end
	cx, cy = cx * sx, cy * sy
	return cx >= x and cx <= x + width and cy >= y and cy <= y + height
end

local function drawButton(text, x, y, width, height)
	local hover = isCursorOnElement(x, y, width, height)
	local background = hover and tocolor(0, 100, 200, 255) or tocolor(35, 35, 35, 255)
	local border = hover and tocolor(0, 130, 230, 255) or tocolor(0, 100, 200, 255)
	dxDrawRectangle(x, y, width, height, background, false)
	dxDrawRectangle(x, y, width, 2, border, false)
	dxDrawRectangle(x, y + height - 2, width, 2, border, false)
	dxDrawRectangle(x, y, 2, height, border, false)
	dxDrawRectangle(x + width - 2, y, 2, height, border, false)
	dxDrawText(text, x, y, x + width, y + height, tocolor(255, 255, 255, 255), 1, "default-bold", "center", "center", true, false, false)
end

local function getWaffenscheinLayout()
	local width = sx * 0.27
	local height = sy * 0.13
	local x = (sx - width) / 2
	local y = (sy - height) / 2
	local padding = width * 0.03
	local gap = width * 0.04
	local buttonWidth = (width - padding * 2 - gap) / 2
	local buttonHeight = height * 0.25
	local buttonY = y + height * 0.66
	return x, y, width, height, padding, gap, buttonWidth, buttonHeight, buttonY
end

local function drawWaffenschein()
	if not waffenscheinVisible then return end
	local x, y, width, height, padding, gap, buttonWidth, buttonHeight, buttonY = getWaffenscheinLayout()

	-- Schwarzer Main-Hintergrund
	dxDrawRectangle(x, y, width, height, tocolor(0, 0, 0, 235), false)

	-- Blauer Akzent oben
	dxDrawRectangle(x, y, width, 3, tocolor(0, 100, 200, 255), false)

	-- Vorhandener Beschreibungstext
	dxDrawText(getText("GunLicense3"), x + padding, y + height * 0.12, x + width - padding, y + height * 0.55, tocolor(255, 255, 255, 255), 1, "default-bold", "center", "center", true, true, false)

	local buyX = x + padding
	local closeX = buyX + buttonWidth + gap
	drawButton(getText("GunLicense1"), buyX, buttonY, buttonWidth, buttonHeight)
	drawButton(getText("GunLicense2"), closeX, buttonY, buttonWidth, buttonHeight)
end

local function closeWaffenschein()
	if not waffenscheinVisible then return end
	waffenscheinVisible = false
	removeEventHandler("onClientRender", root, drawWaffenschein)
	removeEventHandler("onClientClick", root, clickWaffenschein)
	showCursor(false)
	setElementData(localPlayer, "redfieldClick", false)
end

function clickWaffenschein(button, state)
	if not waffenscheinVisible or button ~= "left" or state ~= "down" then return end
	local x, y, width, height, padding, gap, buttonWidth, buttonHeight, buttonY = getWaffenscheinLayout()
	local buyX = x + padding
	local closeX = buyX + buttonWidth + gap

	if isCursorOnElement(buyX, buttonY, buttonWidth, buttonHeight) then
		triggerServerEvent("buyWaffenschein", localPlayer)
		return
	end
	if isCursorOnElement(closeX, buttonY, buttonWidth, buttonHeight) then
		closeWaffenschein()
	end
end

function openWaffenschein()
	if getElementData(localPlayer, "redfieldClick") == true or waffenscheinVisible then return end
	waffenscheinVisible = true
	showCursor(true)
	setElementData(localPlayer, "redfieldClick", true)
	addEventHandler("onClientRender", root, drawWaffenschein)
	addEventHandler("onClientClick", root, clickWaffenschein)
end
addEvent("openWaffenschein", true)
addEventHandler("openWaffenschein", root, openWaffenschein)

addEvent("closeWaffenschein", true)
addEventHandler("closeWaffenschein", root, closeWaffenschein)

addEventHandler("onClientPlayerWasted", localPlayer, function()
	if waffenscheinVisible then closeWaffenschein() end
end)

addEventHandler("onClientResourceStop", resourceRoot, function()
	if waffenscheinVisible then
		waffenscheinVisible = false
		showCursor(false)
		setElementData(localPlayer, "redfieldClick", false)
	end
end)