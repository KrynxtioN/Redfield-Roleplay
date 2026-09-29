local sx, sy = guiGetScreenSize()
local scale = math.min(sx / 1920, sy / 1080)
local helpVisible = false
local selectedCategory = 0
local helpScroll = 0
local visibleCategories = 7

local categories = {
	{name = "HelpCatGeneral", text = "HelpGeneral"},
	{name = "HelpCatGettingStarted", text = "HelpGettingStarted"},
	{name = "HelpCatJobs", text = "HelpJobs"},
	{name = "HelpCatVehicles", text = "HelpVehicles"},
	{name = "HelpCatLicenses", text = "HelpLicenses"},
	{name = "HelpCatBank", text = "HelpBank"},
	{name = "HelpCatHouses", text = "HelpHouses"},
	{name = "HelpCatHunger", text = "HelpHunger"},
	{name = "HelpCatWeapons", text = "HelpWeapons"},
	{name = "HelpCatPhone", text = "HelpPhone"},
	{name = "HelpCatFactionSystem", text = "HelpFactionSystem"},
	{name = "HelpCatFaction", dynamic = true},
	{name = "HelpCatLevel", text = "HelpLevel"},
	{name = "HelpCatCommands", text = "HelpCommands"}
}

local function factionHelp()
	local faction = tonumber(getElementData(localPlayer, "Fraktion")) or 0
	if faction == 0 then return getText("HelpFactionNone") end
	if faction == 1 then return getText("HelpFactionPolice") end
	if faction == 4 then return getText("HelpFactionReporter") end
	if faction == 2 or faction == 3 or faction == 5 or faction == 6 then return getText("HelpFactionEvil") end
	return getText("HelpFactionNone")
end

local function isCursorOnElement(x, y, width, height)
	if not isCursorShowing() then return false end
	local cx, cy = getCursorPosition()
	if not cx or not cy then return false end
	cx, cy = cx * sx, cy * sy
	return cx >= x and cx <= x + width and cy >= y and cy <= y + height
end

local function getHelpLayout()
	local width = math.min(820 * scale, sx * 0.70)
	local height = math.min(430 * scale, sy * 0.70)
	local x = (sx - width) / 2
	local y = (sy - height) / 2
	local padding = 15 * scale
	local categoryWidth = 230 * scale
	return x, y, width, height, padding, categoryWidth
end

local function getHelpText()
	if selectedCategory <= 0 or not categories[selectedCategory] then return getText("HelpHint") end
	local category = categories[selectedCategory]
	if category.dynamic then return factionHelp() end
	return getText(category.text)
end

local function drawHelp()
	if not helpVisible then return end
	local x, y, width, height, padding, categoryWidth = getHelpLayout()
	local listX = x + padding
	local listY = y + 48 * scale
	local rowHeight = 38 * scale
	local rowGap = 3 * scale
	local scrollGap = 8 * scale
	local scrollWidth = 4 * scale
	local rowWidth = categoryWidth - scrollGap - scrollWidth
	local listHeight = visibleCategories * rowHeight - rowGap
	local maxScroll = math.max(0, #categories - visibleCategories)
	helpScroll = math.max(0, math.min(maxScroll, helpScroll))

	dxDrawRectangle(x, y, width, height, tocolor(0, 0, 0, 200), false)
	dxDrawRectangle(x, y, width, 3 * scale, tocolor(0, 100, 200, 255), false)
	dxDrawText(getText("HelpCategory"), listX, y + 8 * scale, listX + categoryWidth, y + 40 * scale, tocolor(255, 255, 255, 255), 1, "default-bold", "center", "center")

	for visibleIndex = 1, visibleCategories do
		local categoryIndex = visibleIndex + helpScroll
		local category = categories[categoryIndex]
		if category then
			local rowY = listY + (visibleIndex - 1) * rowHeight
			local hover = isCursorOnElement(listX, rowY, rowWidth, rowHeight - rowGap)
			local background = categoryIndex % 2 == 0 and tocolor(25, 25, 25, 255) or tocolor(35, 35, 35, 255)
			if hover then background = tocolor(45, 45, 45, 255) end
			if selectedCategory == categoryIndex then background = tocolor(0, 100, 200, 255) end
			dxDrawRectangle(listX, rowY, rowWidth, rowHeight - rowGap, background, false)
			dxDrawText(getText(category.name), listX + 8 * scale, rowY, listX + rowWidth - 8 * scale, rowY + rowHeight - rowGap, tocolor(255, 255, 255, 255), 1, "default-bold", "left", "center", true, false, false)
		end
	end

	if #categories > visibleCategories then
		local barX = listX + rowWidth + scrollGap
		local thumbHeight = listHeight * (visibleCategories / #categories)
		local thumbY = listY
		if maxScroll > 0 then thumbY = listY + (listHeight - thumbHeight) * (helpScroll / maxScroll) end
		dxDrawRectangle(barX, listY, scrollWidth, listHeight, tocolor(40, 40, 40, 255), false)
		dxDrawRectangle(barX, thumbY, scrollWidth, thumbHeight, tocolor(0, 100, 200, 255), false)
	end

	local contentX = listX + categoryWidth + 15 * scale
	local contentY = y + 15 * scale
	local contentWidth = x + width - padding - contentX
	local contentHeight = height - 30 * scale
	dxDrawRectangle(contentX, contentY, contentWidth, contentHeight, tocolor(20, 20, 20, 255), false)
	dxDrawRectangle(contentX, contentY, 2 * scale, contentHeight, tocolor(0, 100, 200, 255), false)
	dxDrawText(getHelpText(), contentX + 15 * scale, contentY + 15 * scale, contentX + contentWidth - 15 * scale, contentY + contentHeight - 15 * scale, tocolor(255, 255, 255, 255), 1, "default-bold", "center", "center", true, true, false)
end

local function closeHelp()
	if not helpVisible then return end
	helpVisible = false
	selectedCategory = 0
	helpScroll = 0
	removeEventHandler("onClientRender", root, drawHelp)
	removeEventHandler("onClientClick", root, clickHelp)
	removeEventHandler("onClientKey", root, keyHelp)
	showCursor(false)
	setElementData(localPlayer, "redfieldClick", false)
end

function clickHelp(button, state)
	if not helpVisible or button ~= "left" or state ~= "down" then return end
	local x, y, width, height, padding, categoryWidth = getHelpLayout()
	local listX = x + padding
	local listY = y + 48 * scale
	local rowHeight = 38 * scale
	local rowGap = 3 * scale
	local scrollGap = 8 * scale
	local scrollWidth = 4 * scale
	local rowWidth = categoryWidth - scrollGap - scrollWidth

	for visibleIndex = 1, visibleCategories do
		local categoryIndex = visibleIndex + helpScroll
		local rowY = listY + (visibleIndex - 1) * rowHeight
		if categories[categoryIndex] and isCursorOnElement(listX, rowY, rowWidth, rowHeight - rowGap) then
			selectedCategory = categoryIndex
			return
		end
	end
end

function keyHelp(button, press)
	if not helpVisible or not press then return end
	local x, y, width, height, padding, categoryWidth = getHelpLayout()
	local listX = x + padding
	local listY = y + 48 * scale
	local listHeight = visibleCategories * 38 * scale
	if not isCursorOnElement(listX, listY, categoryWidth, listHeight) then return end

	local maxScroll = math.max(0, #categories - visibleCategories)
	if button == "mouse_wheel_up" then
		helpScroll = math.max(0, helpScroll - 1)
		cancelEvent()
	elseif button == "mouse_wheel_down" then
		helpScroll = math.min(maxScroll, helpScroll + 1)
		cancelEvent()
	end
end

function helpWindow()
	if helpVisible then
		closeHelp()
		return
	end
	if getElementData(localPlayer, "loggedin") ~= 1 or inTutorial == true or getElementData(localPlayer, "redfieldClick") ~= false then return end
	helpVisible = true
	selectedCategory = 0
	helpScroll = 0
	showCursor(true)
	setElementData(localPlayer, "redfieldClick", true)
	addEventHandler("onClientRender", root, drawHelp)
	addEventHandler("onClientClick", root, clickHelp)
	addEventHandler("onClientKey", root, keyHelp)
end

bindKey("f1", "down", helpWindow)