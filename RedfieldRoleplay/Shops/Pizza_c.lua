local sx, sy = guiGetScreenSize()
local scale = math.min(sx / 1920, sy / 1080)

local pizzaOpen = false

local pizzaItems = {
	{key = "klein", text = "PizzaShop2"},
	{key = "mittel", text = "PizzaShop3"},
	{key = "groß", text = "PizzaShop4"}
}

local function isCursorOnElement(x, y, w, h)
	if not isCursorShowing() then return false end
	local cx, cy = getCursorPosition()
	if not cx or not cy then return false end
	cx, cy = cx * sx, cy * sy
	return cx >= x and cx <= x + w and cy >= y and cy <= y + h
end

local function getPizzaLayout()
	local w, h = 460 * scale, 330 * scale
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

local function renderPizza()
	if not pizzaOpen then return end

	local x, y, w, h, padding = getPizzaLayout()
	local contentW = w - padding * 2
	local infoY = y + 18 * scale
	local infoH = 70 * scale
	local buttonH = 44 * scale
	local buttonGap = 10 * scale
	local buttonY = infoY + infoH + 15 * scale

	dxDrawRectangle(x, y, w, h, tocolor(0, 0, 0, 240), false)
	dxDrawRectangle(x, y, w, 3 * scale, tocolor(0, 100, 200, 255), false)
	dxDrawRectangle(x + padding, infoY, contentW, infoH, tocolor(20, 20, 20, 255), false)
	dxDrawRectangle(x + padding, infoY, 3 * scale, infoH, tocolor(0, 100, 200, 255), false)
	dxDrawText(getText("PizzaShop1"), x + padding + 15 * scale, infoY + 8 * scale, x + w - padding - 15 * scale, infoY + infoH - 8 * scale, tocolor(255, 255, 255, 255), 1 * scale, "default-bold", "center", "center", true, true)

	for i, item in ipairs(pizzaItems) do
		local currentY = buttonY + (i - 1) * (buttonH + buttonGap)
		drawButton(getText(item.text), x + padding, currentY, contentW, buttonH)
	end

	local closeY = buttonY + #pizzaItems * (buttonH + buttonGap)
	drawButton(getText("PizzaShop5"), x + padding, closeY, contentW, buttonH)
end

function closePizzaWindow()
	if not pizzaOpen then return end
	pizzaOpen = false
	removeEventHandler("onClientRender", root, renderPizza)
	removeEventHandler("onClientClick", root, pizzaClick)
	showCursor(false)
	setElementData(localPlayer, "redfieldClick", false)
end

function pizzaClick(button, state)
	if not pizzaOpen or button ~= "left" or state ~= "down" then return end

	local x, y, w, h, padding = getPizzaLayout()
	local contentW = w - padding * 2
	local infoY = y + 18 * scale
	local infoH = 70 * scale
	local buttonH = 44 * scale
	local buttonGap = 10 * scale
	local buttonY = infoY + infoH + 15 * scale

	for i, item in ipairs(pizzaItems) do
		local currentY = buttonY + (i - 1) * (buttonH + buttonGap)
		if isCursorOnElement(x + padding, currentY, contentW, buttonH) then
			triggerServerEvent("buyPizza", localPlayer, item.key)
			return
		end
	end

	local closeY = buttonY + #pizzaItems * (buttonH + buttonGap)
	if isCursorOnElement(x + padding, closeY, contentW, buttonH) then
		closePizzaWindow()
	end
end

function pizzaWindow()
	if pizzaOpen then return end
	if getElementData(localPlayer, "redfieldClick") == true then return end

	pizzaOpen = true
	showCursor(true)
	setElementData(localPlayer, "redfieldClick", true)
	addEventHandler("onClientRender", root, renderPizza)
	addEventHandler("onClientClick", root, pizzaClick)
end
addEvent("openPizzaWindow", true)
addEventHandler("openPizzaWindow", root, pizzaWindow)

addEventHandler("onClientPlayerWasted", localPlayer, function()
	closePizzaWindow()
end)