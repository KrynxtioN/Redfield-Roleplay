local sx, sy = guiGetScreenSize()
local fkasseVisible = false
local selectedTab = 1
local selectedItem = "money"
local amountText = ""
local amountActive = false
local commandScroll = 0
local maxVisibleCommands = 5
local factionData = {
	money = 0,
	drugs = 0,
	mats = 0,
	weapons = 0,
	members = {}
}
local lastRefresh = 0

local function isCursorOnElement(x, y, width, height)
	if not isCursorShowing() then return false end
	local cx, cy = getCursorPosition()
	if not cx or not cy then return false end
	cx, cy = cx * sx, cy * sy
	return cx >= x and cx <= x + width and cy >= y and cy <= y + height
end

local function drawButton(text, x, y, width, height, active)
	local hover = isCursorOnElement(x, y, width, height)
	local background = tocolor(35, 35, 35, 255)
	local border = tocolor(0, 100, 200, 255)
	local textColor = tocolor(255, 255, 255, 255)
	if hover then background = tocolor(0, 100, 200, 255) end
	if active then background = tocolor(0, 100, 200, 255) end
	dxDrawRectangle(x, y, width, height, background, false)
	dxDrawRectangle(x, y, width, 2, border, false)
	dxDrawRectangle(x, y + height - 2, width, 2, border, false)
	dxDrawRectangle(x, y, 2, height, border, false)
	dxDrawRectangle(x + width - 2, y, 2, height, border, false)
	dxDrawText(text, x, y, x + width, y + height, textColor, 1, "default-bold", "center", "center", true, false, false)
end

local function drawSelection(text, x, y, width, height, selected)
	local hover = isCursorOnElement(x, y, width, height)
	local background = tocolor(25, 25, 25, 255)
	if hover then background = tocolor(35, 35, 35, 255) end
	if selected then background = tocolor(0, 100, 200, 255) end
	dxDrawRectangle(x, y, width, height, background, false)
	dxDrawRectangle(x, y + height - 2, width, 2, tocolor(0, 100, 200, 255), false)
	dxDrawText(text, x + 5, y, x + width - 5, y + height, tocolor(255, 255, 255, 255), 1, "default-bold", "center", "center", true, false, false)
end

local function drawEdit(text, x, y, width, height, active)
	local hover = isCursorOnElement(x, y, width, height)
	local border = tocolor(80, 80, 80, 255)
	if hover or active then border = tocolor(0, 100, 200, 255) end
	dxDrawRectangle(x, y, width, height, tocolor(240, 240, 240, 255), false)
	dxDrawRectangle(x, y, width, 2, border, false)
	dxDrawRectangle(x, y + height - 2, width, 2, border, false)
	dxDrawRectangle(x, y, 2, height, border, false)
	dxDrawRectangle(x + width - 2, y, 2, height, border, false)
	if text == "" then
		dxDrawText("0", x + 10, y, x + width - 10, y + height, tocolor(120, 120, 120, 255), 1, "default", "left", "center", true, false, false)
	else
		dxDrawText(text, x + 10, y, x + width - 10, y + height, tocolor(25, 25, 25, 255), 1, "default-bold", "left", "center", true, false, false)
	end
	if active and getTickCount() % 1000 < 500 then
		local textWidth = dxGetTextWidth(text, 1, "default-bold")
		local cursorX = math.min(x + 10 + textWidth + 2, x + width - 10)
		dxDrawRectangle(cursorX, y + 8, 1, height - 16, tocolor(0, 100, 200, 255), false)
	end
end

local function getFactionLayout()
	local width = sx * 0.42
	local height = sy * 0.52
	local x = (sx - width) / 2
	local y = (sy - height) / 2
	local padding = width * 0.025
	local contentWidth = width - padding * 2
	return x, y, width, height, padding, contentWidth
end

local function getFactionName()
	local language = tonumber(getElementData(localPlayer, "Language")) or 0
	local faction = tonumber(getElementData(localPlayer, "Fraktion")) or 0
	local names = {
		[1] = {[0] = "Polizei", [1] = "Police"},
		[2] = {[0] = "Yakuza", [1] = "Yakuza"},
		[3] = {[0] = "Biker", [1] = "Biker"},
		[4] = {[0] = "Reporter", [1] = "Reporter"},
		[5] = {[0] = "Ballas", [1] = "Ballas"},
		[6] = {[0] = "Surenos", [1] = "Surenos"}
	}
	if names[faction] then return names[faction][language] or names[faction][0] end
	return "-"
end

local function requestFactionData()
	if not fkasseVisible then return end
	triggerServerEvent("requestFactionMenuData", localPlayer)
	lastRefresh = getTickCount()
end

local function drawStorage(x, y, width, height, padding)
	local itemY = y + height * 0.25
	local itemHeight = height * 0.075
	local gap = width * 0.012
	local itemWidth = (width - padding * 2 - gap * 2) / 3
	local moneyX = x + padding
	local drugsX = moneyX + itemWidth + gap
	local matsX = drugsX + itemWidth + gap
	drawSelection(getText("FactionC1"), moneyX, itemY, itemWidth, itemHeight, selectedItem == "money")
	drawSelection(getText("FactionC2"), drugsX, itemY, itemWidth, itemHeight, selectedItem == "drugs")
	drawSelection(getText("FactionC3"), matsX, itemY, itemWidth, itemHeight, selectedItem == "mats")

	local valueY = y + height * 0.345
	local valueHeight = height * 0.075
	local value = factionData.money
	if selectedItem == "drugs" then value = factionData.drugs end
	if selectedItem == "mats" then value = factionData.mats end
	dxDrawText(getText("FactionC12"):format(value), x + padding, valueY, x + width - padding, valueY + valueHeight, tocolor(255, 255, 255, 255), 1, "default-bold", "center", "center")

	if factionData.weapons ~= nil then
		dxDrawText(getText("FactionC13"):format(factionData.weapons), x + padding, y + height * 0.405, x + width - padding, y + height * 0.46, tocolor(180, 180, 180, 255), 1, "default-bold", "center", "center")
	end

	local editY = y + height * 0.48
	local editHeight = height * 0.085
	drawEdit(amountText, x + padding, editY, width - padding * 2, editHeight, amountActive)

	local buttonGap = width * 0.015
	local buttonY = y + height * 0.61
	local buttonHeight = height * 0.09
	local buttonWidth = (width - padding * 2 - buttonGap) / 2
	drawButton(getText("FactionC4"), x + padding, buttonY, buttonWidth, buttonHeight, false)
	drawButton(getText("FactionC5"), x + padding + buttonWidth + buttonGap, buttonY, buttonWidth, buttonHeight, false)
end

local function drawMembers(x, y, width, height, padding)
	local startY = y + height * 0.25
	dxDrawText(getText("FactionC14"):format(#factionData.members), x + padding, startY, x + width - padding, startY + height * 0.06, tocolor(255, 255, 255, 255), 1, "default-bold", "left", "center")

	local rowY = startY + height * 0.075
	local rowHeight = height * 0.065
	dxDrawRectangle(x + padding, rowY, width - padding * 2, rowHeight, tocolor(0, 100, 200, 255), false)
	dxDrawText(getText("FactionC15"), x + padding + 10, rowY, x + width * 0.70, rowY + rowHeight, tocolor(255, 255, 255, 255), 1, "default-bold", "left", "center")
	dxDrawText(getText("FactionC16"), x + width * 0.70, rowY, x + width - padding - 10, rowY + rowHeight, tocolor(255, 255, 255, 255), 1, "default-bold", "right", "center")

	for i, member in ipairs(factionData.members) do
		if i > 7 then break end
		local currentY = rowY + rowHeight * i
		local background = i % 2 == 0 and tocolor(25, 25, 25, 255) or tocolor(35, 35, 35, 255)
		dxDrawRectangle(x + padding, currentY, width - padding * 2, rowHeight, background, false)
		dxDrawText(member.name or "-", x + padding + 10, currentY, x + width * 0.70, currentY + rowHeight, tocolor(255, 255, 255, 255), 1, "default", "left", "center", true)
		dxDrawText(tostring(member.rank or 0), x + width * 0.70, currentY, x + width - padding - 10, currentY + rowHeight, tocolor(255, 255, 255, 255), 1, "default-bold", "right", "center")
	end

	if #factionData.members == 0 then
		dxDrawText(getText("FactionC17"), x + padding, rowY + rowHeight, x + width - padding, rowY + rowHeight * 2, tocolor(150, 150, 150, 255), 1, "default", "center", "center")
	end
end

local function getFactionCommands()
	return {
		{"/fleave", getText("FactionC18")},
		{"/fskin", getText("FactionC19")},
		{"/invite [Name]", getText("FactionC21")},
		{"/uninvite [Name]", getText("FactionC22")},
		{"/giverang [Name] [0-4]", getText("FactionC23")},
		{"/unloadweapons", getText("FactionC24")}
	}
end

local function drawCommands(x, y, width, height, padding)
	local commands = getFactionCommands()
	local startY = y + height * 0.25
	local rowHeight = height * 0.09
	local listHeight = rowHeight * maxVisibleCommands
	local maxScroll = math.max(0, #commands - maxVisibleCommands)

	if commandScroll > maxScroll then commandScroll = maxScroll end
	if commandScroll < 0 then commandScroll = 0 end

	for visibleIndex = 1, maxVisibleCommands do
		local commandIndex = visibleIndex + commandScroll
		local command = commands[commandIndex]
		if command then
			local rowY = startY + (visibleIndex - 1) * rowHeight
			local background = visibleIndex % 2 == 0 and tocolor(25, 25, 25, 255) or tocolor(35, 35, 35, 255)
			dxDrawRectangle(x + padding, rowY, width - padding * 2, rowHeight - 2, background, false)
			dxDrawText(command[1], x + padding + 10, rowY, x + width * 0.48, rowY + rowHeight - 2, tocolor(255, 255, 255, 255), 1, "default-bold", "left", "center", true, false, false)
			dxDrawText(command[2], x + width * 0.48, rowY, x + width - padding - 20, rowY + rowHeight - 2, tocolor(255, 255, 255, 255), 1, "default", "right", "center", true, false, false)
		end
	end

	if #commands > maxVisibleCommands then
		local scrollBarX = x + width - padding - 5
		local scrollBarY = startY
		local scrollBarHeight = listHeight
		local thumbHeight = scrollBarHeight * (maxVisibleCommands / #commands)
		local scrollRange = scrollBarHeight - thumbHeight
		local thumbY = scrollBarY
		if maxScroll > 0 then thumbY = scrollBarY + scrollRange * (commandScroll / maxScroll) end
		dxDrawRectangle(scrollBarX, scrollBarY, 3, scrollBarHeight, tocolor(45, 45, 45, 255), false)
		dxDrawRectangle(scrollBarX, thumbY, 3, thumbHeight, tocolor(0, 100, 200, 255), false)
	end
end

local function drawFactionWindow()
	if not fkasseVisible then return end
	if getTickCount() - lastRefresh >= 2000 then requestFactionData() end

	local x, y, width, height, padding = getFactionLayout()
	dxDrawRectangle(x, y, width, height, tocolor(0, 0, 0, 240), false)
	dxDrawRectangle(x, y, width, 3, tocolor(0, 100, 200, 255), false)
	dxDrawText(getFactionName(), x + padding, y + height * 0.035, x + width - padding, y + height * 0.105, tocolor(255, 255, 255, 255), 1.2, "default-bold", "center", "center")

	local tabY = y + height * 0.13
	local tabHeight = height * 0.075
	local tabGap = width * 0.01
	local tabWidth = (width - padding * 2 - tabGap * 2) / 3

	drawButton(getText("FactionC9"), x + padding, tabY, tabWidth, tabHeight, selectedTab == 1)
	drawButton(getText("FactionC10"), x + padding + tabWidth + tabGap, tabY, tabWidth, tabHeight, selectedTab == 2)
	drawButton(getText("FactionC11"), x + padding + (tabWidth + tabGap) * 2, tabY, tabWidth, tabHeight, selectedTab == 3)

	if selectedTab == 1 then
		drawStorage(x, y, width, height, padding)
	elseif selectedTab == 2 then
		drawMembers(x, y, width, height, padding)
	elseif selectedTab == 3 then
		drawCommands(x, y, width, height, padding)
	end

	drawButton(getText("FactionC6"), x + padding, y + height * 0.88, width - padding * 2, height * 0.075, false)
end

local function closeFactionWindow()
	if not fkasseVisible then return end
	fkasseVisible = false
	amountText = ""
	amountActive = false
	commandScroll = 0
	removeEventHandler("onClientRender", root, drawFactionWindow)
	removeEventHandler("onClientClick", root, clickFactionWindow)
	removeEventHandler("onClientCharacter", root, characterFactionWindow)
	removeEventHandler("onClientKey", root, keyFactionWindow)
	showCursor(false)
	setElementData(localPlayer, "redfieldClick", false)
end

local function factionStorageAction(action)
	local amount = tonumber(amountText)
	if not amount or amount <= 0 or amount ~= math.floor(amount) then
		infobox(getText("FactionC7"), 255, 0, 0)
		return
	end
	triggerServerEvent("updatefstate", localPlayer, action, selectedItem, amount)
end

function clickFactionWindow(button, state)
	if not fkasseVisible or button ~= "left" or state ~= "down" then return end

	local x, y, width, height, padding = getFactionLayout()
	local tabY = y + height * 0.13
	local tabHeight = height * 0.075
	local tabGap = width * 0.01
	local tabWidth = (width - padding * 2 - tabGap * 2) / 3

	if isCursorOnElement(x + padding, tabY, tabWidth, tabHeight) then
		selectedTab = 1
		amountActive = false
		return
	end

	if isCursorOnElement(x + padding + tabWidth + tabGap, tabY, tabWidth, tabHeight) then
		selectedTab = 2
		amountActive = false
		return
	end

	if isCursorOnElement(x + padding + (tabWidth + tabGap) * 2, tabY, tabWidth, tabHeight) then
		selectedTab = 3
		amountActive = false
		commandScroll = 0
		return
	end

	if selectedTab == 1 then
		local itemY = y + height * 0.25
		local itemHeight = height * 0.075
		local gap = width * 0.012
		local itemWidth = (width - padding * 2 - gap * 2) / 3
		local moneyX = x + padding
		local drugsX = moneyX + itemWidth + gap
		local matsX = drugsX + itemWidth + gap

		if isCursorOnElement(moneyX, itemY, itemWidth, itemHeight) then
			selectedItem = "money"
			amountActive = false
			return
		end

		if isCursorOnElement(drugsX, itemY, itemWidth, itemHeight) then
			selectedItem = "drugs"
			amountActive = false
			return
		end

		if isCursorOnElement(matsX, itemY, itemWidth, itemHeight) then
			selectedItem = "mats"
			amountActive = false
			return
		end

		local editY = y + height * 0.48
		local editHeight = height * 0.085

		if isCursorOnElement(x + padding, editY, width - padding * 2, editHeight) then
			amountActive = true
			return
		end

		local buttonGap = width * 0.015
		local buttonY = y + height * 0.61
		local buttonHeight = height * 0.09
		local buttonWidth = (width - padding * 2 - buttonGap) / 2

		if isCursorOnElement(x + padding, buttonY, buttonWidth, buttonHeight) then
			amountActive = false
			factionStorageAction("einzahlen")
			return
		end

		if isCursorOnElement(x + padding + buttonWidth + buttonGap, buttonY, buttonWidth, buttonHeight) then
			amountActive = false
			factionStorageAction("auszahlen")
			return
		end
	end

	if isCursorOnElement(x + padding, y + height * 0.88, width - padding * 2, height * 0.075) then
		closeFactionWindow()
		return
	end

	amountActive = false
end

function characterFactionWindow(character)
	if not fkasseVisible or not amountActive or selectedTab ~= 1 then return end
	if not character:match("%d") then return end
	if #amountText >= 12 then return end
	amountText = amountText .. character
end

function keyFactionWindow(button, press)
	if not fkasseVisible or not press then return end

	if selectedTab == 3 then
		local commands = getFactionCommands()
		local maxScroll = math.max(0, #commands - maxVisibleCommands)

		if button == "mouse_wheel_up" then
			commandScroll = math.max(0, commandScroll - 1)
			cancelEvent()
			return
		elseif button == "mouse_wheel_down" then
			commandScroll = math.min(maxScroll, commandScroll + 1)
			cancelEvent()
			return
		end
	end

	if not amountActive then return end

	if button == "backspace" then
		if #amountText > 0 then amountText = amountText:sub(1, -2) end
		cancelEvent()
	elseif button == "enter" then
		amountActive = false
		cancelEvent()
	end
end

function factionWindow()
	if fkasseVisible then return end
	if getElementData(localPlayer, "redfieldClick") == true then return end

	if (tonumber(getElementData(localPlayer, "Fraktion")) or 0) <= 0 then
		infobox(getText("FactionC8"), 255, 0, 0)
		return
	end

	fkasseVisible = true
	selectedTab = 1
	selectedItem = "money"
	amountText = ""
	amountActive = false
	commandScroll = 0
	setElementData(localPlayer, "redfieldClick", true)
	showCursor(true)

	addEventHandler("onClientRender", root, drawFactionWindow)
	addEventHandler("onClientClick", root, clickFactionWindow)
	addEventHandler("onClientCharacter", root, characterFactionWindow)
	addEventHandler("onClientKey", root, keyFactionWindow)

	requestFactionData()
end
bindKey("f5", "down", factionWindow)

addEvent("receiveFactionMenuData", true)
addEventHandler("receiveFactionMenuData", root, function(data)
	if type(data) ~= "table" then return end
	factionData.money = tonumber(data.money) or 0
	factionData.drugs = tonumber(data.drugs) or 0
	factionData.mats = tonumber(data.mats) or 0
	factionData.weapons = data.weapons ~= nil and (tonumber(data.weapons) or 0) or nil
	factionData.members = type(data.members) == "table" and data.members or {}
end)

addEvent("refreshFactionMenu", true)
addEventHandler("refreshFactionMenu", root, function()
	if fkasseVisible then requestFactionData() end
end)

addEventHandler("onClientPlayerWasted", localPlayer, function()
	if fkasseVisible then closeFactionWindow() end
end)