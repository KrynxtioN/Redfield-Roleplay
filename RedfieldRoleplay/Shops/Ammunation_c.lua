local sx, sy = guiGetScreenSize()
local scale = math.min(sx / 1920, sy / 1080)

local ammunationOpen = false

local ammunationItems = {
	{key = "deagle", text = "Ammunation5"},
	{key = "mp5", text = "Ammunation6"},
	{key = "m4", text = "Ammunation7"},
	{key = "rifle", text = "Ammunation8"},
	{key = "shotgun", text = "Ammunation9"},
	{key = "uzi", text = "Ammunation10"},
	{key = "ak47", text = "Ammunation11"},
	{key = "weste", text = "Ammunation12"}
}

local function isCursorOnElement(x, y, w, h)
	if not isCursorShowing() then return false end
	local cx, cy = getCursorPosition()
	if not cx or not cy then return false end
	cx, cy = cx * sx, cy * sy
	return cx >= x and cx <= x + w and cy >= y and cy <= y + h
end

local function getAmmunationLayout()
	local w, h = 560 * scale, 360 * scale
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

local function renderAmmunation()
	if not ammunationOpen then return end

	local x, y, w, h, padding = getAmmunationLayout()
	local contentW = w - padding * 2
	local gap = 10 * scale
	local buttonW = (contentW - gap) / 2
	local buttonH = 48 * scale
	local startY = y + 25 * scale

	dxDrawRectangle(x, y, w, h, tocolor(0, 0, 0, 240), false)
	dxDrawRectangle(x, y, w, 3 * scale, tocolor(0, 100, 200, 255), false)

	for i, item in ipairs(ammunationItems) do
		local column = (i - 1) % 2
		local row = math.floor((i - 1) / 2)
		local buttonX = x + padding + column * (buttonW + gap)
		local buttonY = startY + row * (buttonH + gap)
		drawButton(getText(item.text), buttonX, buttonY, buttonW, buttonH)
	end

	local closeY = startY + 4 * (buttonH + gap) + 5 * scale
	drawButton(getText("Ammunation13"), x + padding, closeY, contentW, buttonH)
end

function closeAmmunation()
	if not ammunationOpen then return end
	ammunationOpen = false
	removeEventHandler("onClientRender", root, renderAmmunation)
	removeEventHandler("onClientClick", root, ammunationClick)
	showCursor(false)
	setElementData(localPlayer, "redfieldClick", false)
end

function ammunationClick(button, state)
	if not ammunationOpen or button ~= "left" or state ~= "down" then return end

	local x, y, w, h, padding = getAmmunationLayout()
	local contentW = w - padding * 2
	local gap = 10 * scale
	local buttonW = (contentW - gap) / 2
	local buttonH = 48 * scale
	local startY = y + 25 * scale

	for i, item in ipairs(ammunationItems) do
		local column = (i - 1) % 2
		local row = math.floor((i - 1) / 2)
		local buttonX = x + padding + column * (buttonW + gap)
		local buttonY = startY + row * (buttonH + gap)

		if isCursorOnElement(buttonX, buttonY, buttonW, buttonH) then
			if item.key == "weste" then
				triggerServerEvent("weste", localPlayer, localPlayer)
			else
				triggerServerEvent("buyAmmunation", localPlayer, item.key)
			end
			return
		end
	end

	local closeY = startY + 4 * (buttonH + gap) + 5 * scale
	if isCursorOnElement(x + padding, closeY, contentW, buttonH) then
		closeAmmunation()
	end
end

function ammuWindow()
	if ammunationOpen then return end
	if getElementData(localPlayer, "redfieldClick") == true then return end

	ammunationOpen = true
	showCursor(true)
	setElementData(localPlayer, "redfieldClick", true)
	addEventHandler("onClientRender", root, renderAmmunation)
	addEventHandler("onClientClick", root, ammunationClick)
end
addEvent("ammuWindow", true)
addEventHandler("ammuWindow", root, ammuWindow)

addEventHandler("onClientPlayerWasted", localPlayer, function()
	closeAmmunation()
end)