local sx, sy = guiGetScreenSize()
local naviVisible = false
local naviBlip, naviTimer = nil, nil
local selectedDestination = 0
local naviScroll = 0
local visibleDestinations = 8

local destinations = {
	{name = {[0] = "Fort Carson Police Department", [1] = "Fort Carson Police Department"}, x = -217.80000305176, y = 979.20001220703, z = 19.60000038147},
	{name = {[0] = "Fort Carson Motel", [1] = "Fort Carson Motel"}, x = -176.39999389648, y = 1112, z = 19.799999237061},
	{name = {[0] = "Fort Carson Bank", [1] = "Fort Carson Bank"}, x = -179.39999389648, y = 1177.5, z = 20},
	{name = {[0] = "Fort Carson Stadthalle", [1] = "Fort Carson City Hall"}, x = -207.69999694824, y = 1119.1999511719, z = 20.49999961853},
	{name = {[0] = "Dealer", [1] = "Dealer"}, x = 2323.5, y = -1223.3000488281, z = 21.799999237061},
	{name = {[0] = "Möbelhaus", [1] = "Furniture Shop"}, x = 1419.1676025391, y = -1623.7145996094, z = 13.546875},
	{name = {[0] = "Waffentruck", [1] = "Weapon Truck"}, x = 219.03958129883, y = 2.9537336826324, z = 2.578125},
	{name = {[0] = "Yakuza Base", [1] = "Yakuza Base"}, x = 693.70013427734, y = 1967.6844482422, z = 5.5390625},
	{name = {[0] = "Biker Base", [1] = "Biker Base"}, x = -11.165034294128, y = 1379.3729248047, z = 9.3635883331299},
	{name = {[0] = "Ballas Base", [1] = "Ballas Base"}, x = 2524.4104003906, y = -1998.3729248047, z = 14.113082885742},
	{name = {[0] = "Surenos Base", [1] = "Surenos Base"}, x = -376.91302490234, y = 2242.3215332031, z = 42.618461608887},
	{name = {[0] = "Reporter Base", [1] = "Reporter Base"}, x = 13.987555503845, y = 1187.8225097656, z = 19.47974395752}
}

local function lang()
	return tonumber(getElementData(localPlayer, "Language")) == 1 and 1 or 0
end

local function isCursorOnElement(x, y, width, height)
	if not isCursorShowing() then return false end
	local cx, cy = getCursorPosition()
	if not cx or not cy then return false end
	cx, cy = cx * sx, cy * sy
	return cx >= x and cx <= x + width and cy >= y and cy <= y + height
end

local function getNaviLayout()
	local width, height = sx * 0.25, sy * 0.42
	local x, y = (sx - width) / 2, (sy - height) / 2
	local padding = width * 0.04
	return x, y, width, height, padding, width - padding * 2
end

local function drawButton(text, x, y, width, height)
	local hover = isCursorOnElement(x, y, width, height)
	local background = hover and tocolor(0, 100, 200, 255) or tocolor(35, 35, 35, 255)
	dxDrawRectangle(x, y, width, height, background, false)
	dxDrawRectangle(x, y + height - 2, width, 2, tocolor(0, 100, 200, 255), false)
	dxDrawText(text, x + 5, y, x + width - 5, y + height, tocolor(255, 255, 255, 255), 1, "default-bold", "center", "center", true, false, false)
end

local function drawNavi()
	if not naviVisible then return end
	local x, y, width, height, padding, contentWidth = getNaviLayout()
	dxDrawRectangle(x, y, width, height, tocolor(0, 0, 0, 240), false)
	dxDrawRectangle(x, y, width, 3, tocolor(0, 100, 200, 255), false)
	dxDrawText(getText("NaviDestination"), x + padding, y + height * 0.025, x + width - padding, y + height * 0.105, tocolor(255, 255, 255, 255), 1.2, "default-bold", "center", "center")

	local listY = y + height * 0.12
	local listHeight = height * 0.68
	local rowHeight = listHeight / visibleDestinations
	local maxScroll = math.max(0, #destinations - visibleDestinations)
	if naviScroll > maxScroll then naviScroll = maxScroll end

	for row = 1, visibleDestinations do
		local id = row + naviScroll
		local destination = destinations[id]
		if not destination then break end
		local rowY = listY + (row - 1) * rowHeight
		local hover = isCursorOnElement(x + padding, rowY, contentWidth, rowHeight - 2)
		local background = row % 2 == 0 and tocolor(25, 25, 25, 255) or tocolor(35, 35, 35, 255)
		if hover then background = tocolor(45, 45, 45, 255) end
		if selectedDestination == id then background = tocolor(0, 100, 200, 255) end
		dxDrawRectangle(x + padding, rowY, contentWidth, rowHeight - 2, background, false)
		dxDrawText(destination.name[lang()], x + padding + 10, rowY, x + width - padding - 15, rowY + rowHeight - 2, tocolor(255, 255, 255, 255), 1, "default-bold", "left", "center", true, false, false)
	end

	if #destinations > visibleDestinations then
		local barX = x + width - padding - 4
		local barHeight = listHeight
		local thumbHeight = barHeight * (visibleDestinations / #destinations)
		local thumbY = listY
		if maxScroll > 0 then thumbY = listY + (barHeight - thumbHeight) * (naviScroll / maxScroll) end
		dxDrawRectangle(barX, listY, 3, barHeight, tocolor(50, 50, 50, 255), false)
		dxDrawRectangle(barX, thumbY, 3, thumbHeight, tocolor(0, 100, 200, 255), false)
	end

	local buttonY = y + height * 0.84
	local buttonHeight = height * 0.10
	local buttonGap = width * 0.03
	local buttonWidth = (contentWidth - buttonGap) / 2
	drawButton(getText("NaviShow"), x + padding, buttonY, buttonWidth, buttonHeight)
	drawButton(getText("NaviClose"), x + padding + buttonWidth + buttonGap, buttonY, buttonWidth, buttonHeight)
end

local function closeNavi()
	if not naviVisible then return end
	naviVisible = false
	selectedDestination = 0
	naviScroll = 0
	removeEventHandler("onClientRender", root, drawNavi)
	removeEventHandler("onClientClick", root, clickNavi)
	removeEventHandler("onClientKey", root, keyNavi)
	showCursor(false)
	setElementData(localPlayer, "redfieldClick", false)
end

function clickNavi(button, state)
	if not naviVisible or button ~= "left" or state ~= "down" then return end
	local x, y, width, height, padding, contentWidth = getNaviLayout()
	local listY = y + height * 0.12
	local listHeight = height * 0.68
	local rowHeight = listHeight / visibleDestinations

	for row = 1, visibleDestinations do
		local id = row + naviScroll
		if destinations[id] then
			local rowY = listY + (row - 1) * rowHeight
			if isCursorOnElement(x + padding, rowY, contentWidth, rowHeight - 2) then
				selectedDestination = id
				return
			end
		end
	end

	local buttonY = y + height * 0.84
	local buttonHeight = height * 0.10
	local buttonGap = width * 0.03
	local buttonWidth = (contentWidth - buttonGap) / 2

	if isCursorOnElement(x + padding, buttonY, buttonWidth, buttonHeight) then
		if selectedDestination <= 0 or not destinations[selectedDestination] then
			infobox(getText("NaviSelect"), 255, 100, 100)
			return
		end
		local destination = destinations[selectedDestination]
		if isElement(naviBlip) then destroyElement(naviBlip) end
		if isTimer(naviTimer) then killTimer(naviTimer) end
		naviBlip = createBlip(destination.x, destination.y, destination.z, 41, 0, 0, 0, 0, 0, 9999)
		naviTimer = setTimer(function()
			if isElement(naviBlip) then destroyElement(naviBlip) end
			naviBlip = nil
		end, 300000, 1)
		infobox(getText("NaviMarked"), 255, 255, 255)
		return
	end

	if isCursorOnElement(x + padding + buttonWidth + buttonGap, buttonY, buttonWidth, buttonHeight) then closeNavi() end
end

function keyNavi(button, press)
	if not naviVisible or not press then return end
	local maxScroll = math.max(0, #destinations - visibleDestinations)
	if button == "mouse_wheel_up" then
		naviScroll = math.max(0, naviScroll - 1)
		cancelEvent()
	elseif button == "mouse_wheel_down" then
		naviScroll = math.min(maxScroll, naviScroll + 1)
		cancelEvent()
	end
end

function navi_func()
	if naviVisible or getElementData(localPlayer, "redfieldClick") == true then return end
	naviVisible = true
	selectedDestination = 0
	naviScroll = 0
	setElementData(localPlayer, "redfieldClick", true)
	showCursor(true)
	addEventHandler("onClientRender", root, drawNavi)
	addEventHandler("onClientClick", root, clickNavi)
	addEventHandler("onClientKey", root, keyNavi)
end
addCommandHandler("navi", navi_func)

addEventHandler("onClientPlayerWasted", localPlayer, function()
	if naviVisible then closeNavi() end
end)