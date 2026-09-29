local sx, sy = guiGetScreenSize()
local scale = math.min(sx / 1920, sy / 1080)

local bonusshopVisible = false
local selectedItem = nil

local bonusshopItems = {
	{key = "leben", name = "Bonusshop3", price = "25 EXP"},
	{key = "weste", name = "Bonusshop4", price = "25 EXP"}
}

local function isCursorOnElement(x, y, width, height)
	if not isCursorShowing() then return false end
	local cx, cy = getCursorPosition()
	if not cx or not cy then return false end
	cx, cy = cx * sx, cy * sy
	return cx >= x and cx <= x + width and cy >= y and cy <= y + height
end

local function getBonusshopLayout()
	local width, height = 450 * scale, 360 * scale
	local x, y = (sx - width) / 2, (sy - height) / 2
	local padding = 15 * scale
	local headerHeight = 42 * scale
	local columnHeight = 34 * scale
	local rowHeight = 50 * scale
	return x, y, width, height, padding, headerHeight, columnHeight, rowHeight
end

local function drawButton(text, x, y, width, height)
	local hover = isCursorOnElement(x, y, width, height)
	dxDrawRectangle(x, y, width, height, hover and tocolor(0, 100, 200, 255) or tocolor(30, 30, 30, 255), false)
	dxDrawRectangle(x, y + height - 2 * scale, width, 2 * scale, tocolor(0, 100, 200, 255), false)
	dxDrawText(text, x + 5 * scale, y, x + width - 5 * scale, y + height, tocolor(255, 255, 255, 255), 1 * scale, "default-bold", "center", "center", true)
end

local function drawBonusshop()
	if not bonusshopVisible then return end

	local x, y, width, height, padding, headerHeight, columnHeight, rowHeight = getBonusshopLayout()
	local contentWidth = width - padding * 2
	local priceWidth = 120 * scale
	local nameWidth = contentWidth - priceWidth
	local listY = y + padding + headerHeight
	local buttonHeight = 42 * scale
	local buttonGap = 10 * scale
	local buttonWidth = (contentWidth - buttonGap) / 2
	local buttonY = y + height - padding - buttonHeight

	dxDrawRectangle(x, y, width, height, tocolor(0, 0, 0, 240), false)
	dxDrawRectangle(x, y, width, 3 * scale, tocolor(0, 100, 200, 255), false)

	dxDrawRectangle(x + padding, listY, contentWidth, columnHeight, tocolor(20, 20, 20, 255), false)
	dxDrawText(getText("Bonusshop1"), x + padding + 10 * scale, listY, x + padding + nameWidth, listY + columnHeight, tocolor(200, 200, 200, 255), 1 * scale, "default-bold", "left", "center")
	dxDrawText(getText("Bonusshop2"), x + padding + nameWidth, listY, x + padding + contentWidth - 10 * scale, listY + columnHeight, tocolor(200, 200, 200, 255), 1 * scale, "default-bold", "right", "center")

	for i, item in ipairs(bonusshopItems) do
		local rowY = listY + columnHeight + (i - 1) * rowHeight
		local hover = isCursorOnElement(x + padding, rowY, contentWidth, rowHeight - 2 * scale)

		if selectedItem == i then
			dxDrawRectangle(x + padding, rowY, contentWidth, rowHeight - 2 * scale, tocolor(0, 100, 200, 255), false)
		elseif hover then
			dxDrawRectangle(x + padding, rowY, contentWidth, rowHeight - 2 * scale, tocolor(35, 35, 35, 255), false)
		else
			dxDrawRectangle(x + padding, rowY, contentWidth, rowHeight - 2 * scale, tocolor(22, 22, 22, 255), false)
		end

		dxDrawText(getText(item.name), x + padding + 10 * scale, rowY, x + padding + nameWidth, rowY + rowHeight - 2 * scale, tocolor(255, 255, 255, 255), 1 * scale, "default-bold", "left", "center", true)
		dxDrawText(item.price, x + padding + nameWidth, rowY, x + padding + contentWidth - 10 * scale, rowY + rowHeight - 2 * scale, tocolor(255, 255, 255, 255), 1 * scale, "default-bold", "right", "center")
	end

	drawButton(getText("Bonusshop5"), x + padding, buttonY, buttonWidth, buttonHeight)
	drawButton(getText("Bonusshop6"), x + padding + buttonWidth + buttonGap, buttonY, buttonWidth, buttonHeight)
end

function closeBonusshopWindow()
	if not bonusshopVisible then return end
	bonusshopVisible = false
	selectedItem = nil
	removeEventHandler("onClientRender", root, drawBonusshop)
	removeEventHandler("onClientClick", root, bonusshopClick)
	showCursor(false)
	setElementData(localPlayer, "redfieldClick", false)
end

function bonusshopClick(button, state)
	if not bonusshopVisible or button ~= "left" or state ~= "down" then return end

	local x, y, width, height, padding, headerHeight, columnHeight, rowHeight = getBonusshopLayout()
	local contentWidth = width - padding * 2
	local listY = y + padding + headerHeight
	local buttonHeight = 42 * scale
	local buttonGap = 10 * scale
	local buttonWidth = (contentWidth - buttonGap) / 2
	local buttonY = y + height - padding - buttonHeight

	for i, item in ipairs(bonusshopItems) do
		local rowY = listY + columnHeight + (i - 1) * rowHeight
		if isCursorOnElement(x + padding, rowY, contentWidth, rowHeight - 2 * scale) then
			selectedItem = i
			return
		end
	end

	if isCursorOnElement(x + padding, buttonY, buttonWidth, buttonHeight) then
		if not selectedItem or not bonusshopItems[selectedItem] then
			infobox(getText("Bonusshop7"), 255, 0, 0)
			return
		end
		triggerServerEvent("bonusshopserverbuy", localPlayer, bonusshopItems[selectedItem].key)
		return
	end

	if isCursorOnElement(x + padding + buttonWidth + buttonGap, buttonY, buttonWidth, buttonHeight) then
		closeBonusshopWindow()
	end
end

function bonusshopWindow()
	if bonusshopVisible then return end
	if getElementData(localPlayer, "redfieldClick") == true then return end

	bonusshopVisible = true
	selectedItem = nil
	showCursor(true)
	setElementData(localPlayer, "redfieldClick", true)
	addEventHandler("onClientRender", root, drawBonusshop)
	addEventHandler("onClientClick", root, bonusshopClick)
end
addCommandHandler("bonusshop", bonusshopWindow)

addEventHandler("onClientPlayerWasted", localPlayer, function()
	closeBonusshopWindow()
end)