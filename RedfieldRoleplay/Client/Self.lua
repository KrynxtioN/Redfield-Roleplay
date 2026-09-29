local sx, sy = guiGetScreenSize()
local selfVisible = false
local selectedTab = 1
local selectedSpawn = 1
local availableSpawns = {}

local factionNames = {
	[0] = {[0] = "Zivilist", [1] = "Civilian"},
	[1] = {[0] = "Police", [1] = "Police"},
	[2] = {[0] = "Yakuza", [1] = "Yakuza"},
	[3] = {[0] = "Biker", [1] = "Biker"},
	[4] = {[0] = "Reporter", [1] = "Reporter"},
	[5] = {[0] = "Ballas", [1] = "Ballas"},
	[6] = {[0] = "Surenos", [1] = "Surenos"}
}

local spawns = {
	{key = "SelfSpawnNoob", x = -204.96250915527, y = 1212.2875976563, z = 19.7421875, int = 0},
	{key = "SelfSpawnHouse", house = true},
	{key = "SelfSpawnPolice", faction = 1, x = 251.93380737305, y = 70.434516906738, z = 1003.640625, int = 6},
	{key = "SelfSpawnYakuza", faction = 2, x = -2160.41796875, y = 638.86529541016, z = 1057.5860595703, int = 1},
	{key = "SelfSpawnBiker", faction = 3, x = -226.13352966309, y = 1410.9614257813, z = 27.7734375, int = 18},
	{key = "SelfSpawnReporter", faction = 4, x = -2022.2545166016, y = -114.60018157959, z = 1035.171875, int = 3},
	{key = "SelfSpawnBallas", faction = 5, x = 963.08654785156, y = 2102.0639648438, z = 1011.02734375, int = 1},
	{key = "SelfSpawnSurenos", faction = 6, x = 325.65753173828, y = 1124.7043457031, z = 1083.8828125, int = 5}
}

local function lang()
	return tonumber(getElementData(localPlayer, "Language")) == 1 and 1 or 0
end

local function data(key)
	return getElementData(localPlayer, key) or 0
end

local function mark(value)
	return tonumber(value) == 0 and "[_]" or "[X]"
end

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
	if hover or active then background = tocolor(0, 100, 200, 255) end
	dxDrawRectangle(x, y, width, height, background, false)
	dxDrawRectangle(x, y + height - 2, width, 2, tocolor(0, 100, 200, 255), false)
	dxDrawText(text, x + 5, y, x + width - 5, y + height, tocolor(255, 255, 255, 255), 1, "default-bold", "center", "center", true, false, false)
end

local function getSelfLayout()
	local width = sx * 0.54
	local height = sy * 0.43
	local x = (sx - width) / 2
	local y = (sy - height) / 2
	local spawnWidth = width * 0.25
	local gap = width * 0.015
	local mainX = x + spawnWidth + gap
	local mainWidth = width - spawnWidth - gap
	return x, y, width, height, spawnWidth, gap, mainX, mainWidth
end

local function refreshAvailableSpawns()
	availableSpawns = {}
	local faction = tonumber(data("Fraktion")) or 0
	for id, spawn in ipairs(spawns) do
		if (not spawn.faction or spawn.faction == faction) and (not spawn.house or data("Housekey") == 1) then
			table.insert(availableSpawns, {
				id = id,
				spawn = spawn
			})
		end
	end
	if selectedSpawn > #availableSpawns then selectedSpawn = 1 end
end

local function getPlayerInfo()
	local mins = tonumber(data("Spielzeit")) or 0
	local phone = data("Telefonnummer")
	if phone == 0 then phone = getText("SelfNoPhone") end
	local money = tonumber(data("Money")) or 0
	local faction = tonumber(data("Fraktion")) or 0
	local factionName = factionNames[faction] and factionNames[faction][lang()] or factionNames[0][lang()]
	local left = getText("SelfPlayerText"):format(
		getPlayerName(localPlayer),
		string.format("%d:%02d", math.floor(mins / 60), mins % 60),
		tostring(phone),
		money,
		tonumber(data("Bankmoney")) or 0,
		factionName,
		tonumber(data("Fraktionrang")) or 0,
		tonumber(data("Adminrang")) or 0
	)
	local right = getText("SelfKillsText"):format(
		tonumber(data("Kills")) or 0,
		tonumber(data("Tode")) or 0
	)
	return left, right
end

local function getFactionInfo()
	return getText("SelfFactionStats"):format(
		data("Matstransporter"),
		data("Drogentransporter"),
		data("Gwsgestartet"),
		data("Geldtransporter")
	), ""
end

local function getLicenseInfo()
	local left = getText("SelfLicenseText"):format(
		mark(data("Autoschein")),
		mark(data("Motorradschein")),
		mark(data("Lkwschein")),
		mark(data("Helischein")),
		mark(data("Flugschein")),
		mark(data("Bootschein")),
		mark(data("Personalausweis")),
		mark(data("Arbeitsgenehmigung"))
	)
	local right = getText("SelfGunLicense"):format(mark(data("Waffenschein")))
	return left, right
end

local function getAchievementInfo()
	local keys = {
		"AchUmgezogen",
		"AchFahrzeug",
		"Ach1Million",
		"AchKonto",
		"AchGestorben",
		"AchCarlicence",
		"AchFraktion",
		"AchLevel5",
		"AchBonusshopbuy",
		"Ach25TausendEXP",
		"AchMiniMission",
		"AchPayday",
		"Ach5Hours",
		"AchHouse",
		"AchSpawn",
		"AchHolz"
	}
	local marks = {}
	for i, key in ipairs(keys) do
		marks[i] = mark(data(key))
	end
	local left = getText("SelfAchievements1"):format(unpack(marks, 1, 8))
	local right = getText("SelfAchievements2"):format(unpack(marks, 9, 16))
	return left, right
end

local function getCurrentInfo()
	if selectedTab == 1 then return getPlayerInfo() end
	if selectedTab == 2 then return getFactionInfo() end
	if selectedTab == 3 then return getLicenseInfo() end
	if selectedTab == 4 then return getAchievementInfo() end
	return "", ""
end

local function drawSelf()
	if not selfVisible then return end
	local x, y, width, height, spawnWidth, gap, mainX, mainWidth = getSelfLayout()

	dxDrawRectangle(x, y, spawnWidth, height, tocolor(0, 0, 0, 240), false)
	dxDrawRectangle(mainX, y, mainWidth, height, tocolor(0, 0, 0, 240), false)
	dxDrawRectangle(x, y, spawnWidth, 3, tocolor(0, 100, 200, 255), false)
	dxDrawRectangle(mainX, y, mainWidth, 3, tocolor(0, 100, 200, 255), false)

	local padding = width * 0.015
	local spawnX = x + padding
	local spawnY = y + height * 0.07
	local spawnContentWidth = spawnWidth - padding * 2
	local rowHeight = height * 0.105

	dxDrawText(getText("SelfSpawn"), spawnX, y + height * 0.015, x + spawnWidth - padding, y + height * 0.065, tocolor(255, 255, 255, 255), 1, "default-bold", "center", "center")

	for i, entry in ipairs(availableSpawns) do
		local rowY = spawnY + (i - 1) * rowHeight
		if rowY + rowHeight <= y + height * 0.79 then
			local hover = isCursorOnElement(spawnX, rowY, spawnContentWidth, rowHeight - 4)
			local background = tocolor(25, 25, 25, 255)
			if hover then background = tocolor(35, 35, 35, 255) end
			if selectedSpawn == i then background = tocolor(0, 100, 200, 255) end
			dxDrawRectangle(spawnX, rowY, spawnContentWidth, rowHeight - 4, background, false)
			dxDrawText(getText(entry.spawn.key), spawnX + 5, rowY, spawnX + spawnContentWidth - 5, rowY + rowHeight - 4, tocolor(255, 255, 255, 255), 1, "default-bold", "center", "center", true)
		end
	end

	drawButton(getText("SelfChangeSpawn"), spawnX, y + height * 0.84, spawnContentWidth, height * 0.10, false)

	local mainPadding = mainWidth * 0.025
	local tabY = y + height * 0.06
	local tabGap = mainWidth * 0.012
	local tabWidth = (mainWidth - mainPadding * 2 - tabGap) / 2
	local tabHeight = height * 0.10

	drawButton(getText("SelfPlayerInfo"), mainX + mainPadding, tabY, tabWidth, tabHeight, selectedTab == 1)
	drawButton(getText("SelfFactionInfo"), mainX + mainPadding + tabWidth + tabGap, tabY, tabWidth, tabHeight, selectedTab == 2)
	drawButton(getText("SelfLicenses"), mainX + mainPadding, tabY + tabHeight + height * 0.025, tabWidth, tabHeight, selectedTab == 3)
	drawButton(getText("SelfAchievements"), mainX + mainPadding + tabWidth + tabGap, tabY + tabHeight + height * 0.025, tabWidth, tabHeight, selectedTab == 4)

	local leftText, rightText = getCurrentInfo()
	local contentY = y + height * 0.32
	local contentHeight = height * 0.49
	local contentGap = mainWidth * 0.015
	local leftWidth = mainWidth * 0.47
	local rightX = mainX + mainPadding + leftWidth + contentGap
	local rightWidth = mainWidth - mainPadding * 2 - leftWidth - contentGap

	dxDrawRectangle(mainX + mainPadding, contentY, leftWidth, contentHeight, tocolor(20, 20, 20, 255), false)
	dxDrawRectangle(rightX, contentY, rightWidth, contentHeight, tocolor(20, 20, 20, 255), false)
	dxDrawText(leftText, mainX + mainPadding + 12, contentY + 10, mainX + mainPadding + leftWidth - 12, contentY + contentHeight - 10, tocolor(255, 255, 255, 255), 1, "default-bold", "center", "top", true, true, false)
	dxDrawText(rightText, rightX + 12, contentY + 10, rightX + rightWidth - 12, contentY + contentHeight - 10, tocolor(255, 255, 255, 255), 1, "default-bold", "center", "top", true, true, false)

	drawButton(getText("SelfClose"), mainX + mainPadding, y + height * 0.84, mainWidth - mainPadding * 2, height * 0.10, false)
end

local function closeSelf()
	if not selfVisible then return end
	selfVisible = false
	removeEventHandler("onClientRender", root, drawSelf)
	removeEventHandler("onClientClick", root, clickSelf)
	showCursor(false)
	setElementData(localPlayer, "redfieldClick", false)
end

function clickSelf(button, state)
	if not selfVisible or button ~= "left" or state ~= "down" then return end
	local x, y, width, height, spawnWidth, gap, mainX, mainWidth = getSelfLayout()
	local padding = width * 0.015
	local spawnX = x + padding
	local spawnY = y + height * 0.07
	local spawnContentWidth = spawnWidth - padding * 2
	local rowHeight = height * 0.105

	for i, entry in ipairs(availableSpawns) do
		local rowY = spawnY + (i - 1) * rowHeight
		if rowY + rowHeight <= y + height * 0.79 and isCursorOnElement(spawnX, rowY, spawnContentWidth, rowHeight - 4) then
			selectedSpawn = i
			return
		end
	end

	if isCursorOnElement(spawnX, y + height * 0.84, spawnContentWidth, height * 0.10) then
		local entry = availableSpawns[selectedSpawn]
		if not entry or not entry.spawn then return end
		local spawn = entry.spawn
		if spawn.house then
			triggerServerEvent("SpawnImHaus", localPlayer)
		else
			triggerServerEvent("changeSpawn", localPlayer, spawn.x, spawn.y, spawn.z, spawn.int)
		end
		return
	end

	local mainPadding = mainWidth * 0.025
	local tabY = y + height * 0.06
	local tabGap = mainWidth * 0.012
	local tabWidth = (mainWidth - mainPadding * 2 - tabGap) / 2
	local tabHeight = height * 0.10

	if isCursorOnElement(mainX + mainPadding, tabY, tabWidth, tabHeight) then
		selectedTab = 1
		return
	end
	if isCursorOnElement(mainX + mainPadding + tabWidth + tabGap, tabY, tabWidth, tabHeight) then
		selectedTab = 2
		return
	end
	if isCursorOnElement(mainX + mainPadding, tabY + tabHeight + height * 0.025, tabWidth, tabHeight) then
		selectedTab = 3
		return
	end
	if isCursorOnElement(mainX + mainPadding + tabWidth + tabGap, tabY + tabHeight + height * 0.025, tabWidth, tabHeight) then
		selectedTab = 4
		return
	end
	if isCursorOnElement(mainX + mainPadding, y + height * 0.84, mainWidth - mainPadding * 2, height * 0.10) then
		closeSelf()
	end
end

function self_func()
	if selfVisible then return end
	if getElementData(localPlayer, "redfieldClick") == true then return end
	if inTutorial == true then return end
	refreshAvailableSpawns()
	selectedTab = 1
	selectedSpawn = 1
	selfVisible = true
	setElementData(localPlayer, "redfieldClick", true)
	showCursor(true)
	addEventHandler("onClientRender", root, drawSelf)
	addEventHandler("onClientClick", root, clickSelf)
end
addCommandHandler("self", self_func)

addEventHandler("onClientPlayerWasted", localPlayer, function()
	if selfVisible then closeSelf() end
end)