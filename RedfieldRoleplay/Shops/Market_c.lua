local sx, sy = guiGetScreenSize()
local scale = math.min(sx / 1920, sy / 1080)

local supermarktOpen = false
local selectedItem = nil

local supermarktItems = {
	{text = "Supermarkt3", price = "$350"},
	{text = "Supermarkt4", price = "$3"},
	{text = "Supermarkt5", price = "$25"}
}

local function isCursorOnElement(x, y, w, h)
	if not isCursorShowing() then return false end
	local cx, cy = getCursorPosition()
	if not cx or not cy then return false end
	cx, cy = cx * sx, cy * sy
	return cx >= x and cx <= x + w and cy >= y and cy <= y + h
end

local function getSupermarktLayout()
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

local function renderSupermarkt()
	if not supermarktOpen then return end

	local x, y, w, h, padding = getSupermarktLayout()
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
	dxDrawText(getText("Supermarkt1"), x + padding + 10 * scale, listY, x + padding + nameW, listY + columnH, tocolor(200, 200, 200, 255), 1 * scale, "default-bold", "left", "center", true)
	dxDrawText(getText("Supermarkt2"), x + padding + nameW, listY, x + padding + contentW - 10 * scale, listY + columnH, tocolor(200, 200, 200, 255), 1 * scale, "default-bold", "right", "center", true)

	for i, item in ipairs(supermarktItems) do
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

	drawButton(getText("Supermarkt6"), x + padding, buttonY, buttonW, buttonH)
	drawButton(getText("Supermarkt7"), x + padding + buttonW + buttonGap, buttonY, buttonW, buttonH)
end

function closeSupermarktWindow()
	if not supermarktOpen then return end
	supermarktOpen = false
	selectedItem = nil
	removeEventHandler("onClientRender", root, renderSupermarkt)
	removeEventHandler("onClientClick", root, supermarktClick)
	showCursor(false)
	setElementData(localPlayer, "redfieldClick", false)
end

function supermarktClick(button, state)
	if not supermarktOpen or button ~= "left" or state ~= "down" then return end

	local x, y, w, h, padding = getSupermarktLayout()
	local contentW = w - padding * 2
	local columnH = 36 * scale
	local rowH = 48 * scale
	local listY = y + 25 * scale
	local buttonH = 42 * scale
	local buttonGap = 10 * scale
	local buttonW = (contentW - buttonGap) / 2
	local buttonY = y + h - padding - buttonH

	for i = 1, #supermarktItems do
		local rowY = listY + columnH + (i - 1) * rowH
		if isCursorOnElement(x + padding, rowY, contentW, rowH - 2 * scale) then
			selectedItem = i
			return
		end
	end

	if isCursorOnElement(x + padding, buttonY, buttonW, buttonH) then
		if not selectedItem or not supermarktItems[selectedItem] then
			infobox(getText("Supermarkt8"), 255, 0, 0)
			return
		end

		triggerServerEvent("Supermarkt.buy", localPlayer, getText(supermarktItems[selectedItem].text))
		return
	end

	if isCursorOnElement(x + padding + buttonW + buttonGap, buttonY, buttonW, buttonH) then
		closeSupermarktWindow()
	end
end

function supermarktWindow()
	if supermarktOpen then return end
	if getElementData(localPlayer, "redfieldClick") == true then return end

	supermarktOpen = true
	selectedItem = nil
	showCursor(true)
	setElementData(localPlayer, "redfieldClick", true)
	addEventHandler("onClientRender", root, renderSupermarkt)
	addEventHandler("onClientClick", root, supermarktClick)
end
addEvent("opensupermarktWindow", true)
addEventHandler("opensupermarktWindow", root, supermarktWindow)

addEventHandler("onClientPlayerWasted", localPlayer, function()
	closeSupermarktWindow()
end)