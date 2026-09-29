local sx, sy = guiGetScreenSize()
local scale = math.min(sx / 1920, sy / 1080)

local barOpen = false
local selectedItem = nil

local barItems = {
	{text = "Bar4", price = "$8"},
	{text = "Bar5", price = "$6"},
	{text = "Bar6", price = "$12"}
}

local function isCursorOnElement(x, y, w, h)
	if not isCursorShowing() then return false end
	local cx, cy = getCursorPosition()
	if not cx or not cy then return false end
	cx, cy = cx * sx, cy * sy
	return cx >= x and cx <= x + w and cy >= y and cy <= y + h
end

local function getBarLayout()
	local w, h = 460 * scale, 360 * scale
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

local function renderBar()
	if not barOpen then return end

	local x, y, w, h, padding = getBarLayout()
	local contentW = w - padding * 2
	local columnH = 36 * scale
	local rowH = 48 * scale
	local listY = y + 25 * scale
	local priceW = 110 * scale
	local nameW = contentW - priceW
	local buttonH = 42 * scale
	local buttonGap = 10 * scale
	local buttonW = (contentW - buttonGap) / 2
	local buttonY = y + h - padding - buttonH

	dxDrawRectangle(x, y, w, h, tocolor(0, 0, 0, 240), false)
	dxDrawRectangle(x, y, w, 3 * scale, tocolor(0, 100, 200, 255), false)

	dxDrawRectangle(x + padding, listY, contentW, columnH, tocolor(20, 20, 20, 255), false)
	dxDrawText(getText("Bar2"), x + padding + 10 * scale, listY, x + padding + nameW, listY + columnH, tocolor(200, 200, 200, 255), 1 * scale, "default-bold", "left", "center", true)
	dxDrawText(getText("Bar3"), x + padding + nameW, listY, x + padding + contentW - 10 * scale, listY + columnH, tocolor(200, 200, 200, 255), 1 * scale, "default-bold", "right", "center", true)

	for i, item in ipairs(barItems) do
		local rowY = listY + columnH + (i - 1) * rowH
		local hover = isCursorOnElement(x + padding, rowY, contentW, rowH - 2 * scale)

		if selectedItem == i then
			dxDrawRectangle(x + padding, rowY, contentW, rowH - 2 * scale, tocolor(0, 100, 200, 255), false)
		elseif hover then
			dxDrawRectangle(x + padding, rowY, contentW, rowH - 2 * scale, tocolor(35, 35, 35, 255), false)
		else
			dxDrawRectangle(x + padding, rowY, contentW, rowH - 2 * scale, tocolor(22, 22, 22, 255), false)
		end

		dxDrawText(getText(item.text), x + padding + 10 * scale, rowY, x + padding + nameW, rowY + rowH - 2 * scale, tocolor(255, 255, 255, 255), 1 * scale, "default-bold", "left", "center", true)
		dxDrawText(item.price, x + padding + nameW, rowY, x + padding + contentW - 10 * scale, rowY + rowH - 2 * scale, tocolor(255, 255, 255, 255), 1 * scale, "default-bold", "right", "center")
	end

	drawButton(getText("Bar7"), x + padding, buttonY, buttonW, buttonH)
	drawButton(getText("Bar8"), x + padding + buttonW + buttonGap, buttonY, buttonW, buttonH)
end

function closeBarWindow()
	if not barOpen then return end

	barOpen = false
	selectedItem = nil
	removeEventHandler("onClientRender", root, renderBar)
	removeEventHandler("onClientClick", root, barClick)
	showCursor(false)
	setElementData(localPlayer, "redfieldClick", false)
end

function barClick(button, state)
	if not barOpen or button ~= "left" or state ~= "down" then return end

	local x, y, w, h, padding = getBarLayout()
	local contentW = w - padding * 2
	local columnH = 36 * scale
	local rowH = 48 * scale
	local listY = y + 25 * scale
	local buttonH = 42 * scale
	local buttonGap = 10 * scale
	local buttonW = (contentW - buttonGap) / 2
	local buttonY = y + h - padding - buttonH

	for i = 1, #barItems do
		local rowY = listY + columnH + (i - 1) * rowH
		if isCursorOnElement(x + padding, rowY, contentW, rowH - 2 * scale) then
			selectedItem = i
			return
		end
	end

	if isCursorOnElement(x + padding, buttonY, buttonW, buttonH) then
		if not selectedItem or not barItems[selectedItem] then
			infobox(getText("Bar9"), 255, 0, 0)
			return
		end

		triggerServerEvent("Bar.BuyAlcohol", localPlayer, getText(barItems[selectedItem].text))
		return
	end

	if isCursorOnElement(x + padding + buttonW + buttonGap, buttonY, buttonW, buttonH) then
		closeBarWindow()
	end
end

function barWindow()
	if barOpen then return end
	if getElementData(localPlayer, "redfieldClick") == true then return end

	barOpen = true
	selectedItem = nil
	showCursor(true)
	setElementData(localPlayer, "redfieldClick", true)
	addEventHandler("onClientRender", root, renderBar)
	addEventHandler("onClientClick", root, barClick)
end
addEvent("openBarWindow", true)
addEventHandler("openBarWindow", root, barWindow)

addEventHandler("onClientPlayerWasted", localPlayer, function()
	closeBarWindow()
end)