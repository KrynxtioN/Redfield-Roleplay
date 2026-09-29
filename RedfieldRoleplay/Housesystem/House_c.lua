local sx, sy = guiGetScreenSize()
local scale = math.min(sx / 1920, sy / 1080)
local houseMenuVisible = false

local function isCursorOnElement(x, y, width, height)
	if not isCursorShowing() then return false end
	local cx, cy = getCursorPosition()
	if not cx or not cy then return false end
	cx, cy = cx * sx, cy * sy
	return cx >= x and cx <= x + width and cy >= y and cy <= y + height
end

local function getHouseLayout()
	local width = 480 * scale
	local height = 250 * scale
	local x = (sx - width) / 2
	local y = (sy - height) / 2
	local padding = 15 * scale
	return x, y, width, height, padding
end

local function drawButton(text, x, y, width, height)
	local hover = isCursorOnElement(x, y, width, height)
	dxDrawRectangle(x, y, width, height, hover and tocolor(0, 100, 200, 255) or tocolor(30, 30, 30, 255), false)
	dxDrawRectangle(x, y + height - 2 * scale, width, 2 * scale, tocolor(0, 100, 200, 255), false)
	dxDrawText(text, x + 8 * scale, y, x + width - 8 * scale, y + height, tocolor(255, 255, 255, 255), 1, "default-bold", "center", "center", true, false, false)
end

local function drawHouseWindow()
	if not houseMenuVisible then return end

	local x, y, width, height, padding = getHouseLayout()
	local contentWidth = width - padding * 2
	local buttonGap = 10 * scale
	local buttonHeight = 42 * scale
	local buttonWidth = (contentWidth - buttonGap) / 2
	local buttonY = y + 137 * scale
	local closeY = buttonY + buttonHeight + 10 * scale

	dxDrawRectangle(x, y, width, height, tocolor(0, 0, 0, 235), false)
	dxDrawRectangle(x, y, width, 3 * scale, tocolor(0, 100, 200, 255), false)

	dxDrawRectangle(x + padding, y + 18 * scale, contentWidth, 100 * scale, tocolor(20, 20, 20, 255), false)
	dxDrawRectangle(x + padding, y + 18 * scale, 3 * scale, 100 * scale, tocolor(0, 100, 200, 255), false)

	dxDrawText(getText("House2"), x + padding + 15 * scale, y + 28 * scale, x + width - padding - 15 * scale, y + 108 * scale, tocolor(255, 255, 255, 255), 1, "default-bold", "center", "center", true, true, false)

	drawButton(getText("House3"), x + padding, buttonY, buttonWidth, buttonHeight)
	drawButton(getText("House4"), x + padding + buttonWidth + buttonGap, buttonY, buttonWidth, buttonHeight)
	drawButton(getText("House5"), x + padding, closeY, contentWidth, buttonHeight)
end

local function closeHouseWindow()
	if not houseMenuVisible then return end
	houseMenuVisible = false
	removeEventHandler("onClientRender", root, drawHouseWindow)
	removeEventHandler("onClientClick", root, houseMenuClick)
	showCursor(false)
	setElementData(localPlayer, "redfieldClick", false)
end

function houseMenuClick(button, state)
	if not houseMenuVisible or button ~= "left" or state ~= "down" then return end

	local x, y, width, height, padding = getHouseLayout()
	local contentWidth = width - padding * 2
	local buttonGap = 10 * scale
	local buttonHeight = 42 * scale
	local buttonWidth = (contentWidth - buttonGap) / 2
	local buttonY = y + 137 * scale
	local closeY = buttonY + buttonHeight + 10 * scale

	if isCursorOnElement(x + padding, buttonY, buttonWidth, buttonHeight) then
		triggerServerEvent("house_heilen", localPlayer)
		return
	end

	if isCursorOnElement(x + padding + buttonWidth + buttonGap, buttonY, buttonWidth, buttonHeight) then
		triggerServerEvent("house_eat", localPlayer)
		return
	end

	if isCursorOnElement(x + padding, closeY, contentWidth, buttonHeight) then
		closeHouseWindow()
	end
end

function houseWindow()
	if houseMenuVisible then return end
	if getElementData(localPlayer, "redfieldClick") == true then return end

	if getElementData(localPlayer, "isPlayerInHouse") ~= true then
		infobox(getText("House1"), 255, 0, 0)
		return
	end

	houseMenuVisible = true
	showCursor(true)
	setElementData(localPlayer, "redfieldClick", true)
	addEventHandler("onClientRender", root, drawHouseWindow)
	addEventHandler("onClientClick", root, houseMenuClick)
end

bindKey("f2", "down", houseWindow)