function isCop(player)
	return isElement(player) and tonumber(getElementData(player, "Fraktion")) == 1
end

function isYakuza(player)
	return isElement(player) and tonumber(getElementData(player, "Fraktion")) == 2
end

function isBiker(player)
	return isElement(player) and tonumber(getElementData(player, "Fraktion")) == 3
end

function isReporter(player)
	return isElement(player) and tonumber(getElementData(player, "Fraktion")) == 4
end

function isBallas(player)
	return isElement(player) and tonumber(getElementData(player, "Fraktion")) == 5
end

function isSurenos(player)
	return isElement(player) and tonumber(getElementData(player, "Fraktion")) == 6
end

function isEvil(player)
	return isYakuza(player) or isBiker(player) or isBallas(player) or isSurenos(player)
end

local function findFactionPlayer(name)
	if not name or name == "" then return nil end
	local search = name:lower()
	local found = nil
	for _, target in ipairs(getElementsByType("player")) do
		local playerName = getPlayerName(target):gsub("#%x%x%x%x%x%x", "")
		local cleanName = playerName:lower()
		if cleanName == search then return target end
		if cleanName:find(search, 1, true) then
			if found then return nil end
			found = target
		end
	end
	return found
end

local function getFactionMembers(faction)
	local members = {}
	for _, player in ipairs(getElementsByType("player")) do
		if getElementData(player, "loggedin") == 1 and (tonumber(getElementData(player, "Fraktion")) or 0) == faction then
			table.insert(members, {
				name = getPlayerName(player),
				rank = tonumber(getElementData(player, "Fraktionrang")) or 0
			})
		end
	end
	table.sort(members, function(a, b)
		if a.rank == b.rank then return a.name:lower() < b.name:lower() end
		return a.rank > b.rank
	end)
	return members
end

local function sendFactionMenuData(player)
	if not isElement(player) or getElementData(player, "loggedin") ~= 1 then return end
	local faction = tonumber(getElementData(player, "Fraktion")) or 0
	if faction <= 0 then return end
	local result = dbPoll(dbQuery(dbConnection, "SELECT Geld,Drogen,Materialien,Waffenpakete FROM kassen WHERE Besitzer = ? LIMIT 1", faction), -1)
	if not result or not result[1] then
		infobox_func(player, getText(player, "FactionS25"), 255, 0, 0)
		return
	end
	local data = {
		money = tonumber(result[1].Geld) or 0,
		drugs = tonumber(result[1].Drogen) or 0,
		mats = tonumber(result[1].Materialien) or 0,
		members = getFactionMembers(faction)
	}
	if isEvil(player) then data.weapons = tonumber(result[1].Waffenpakete) or 0 end
	triggerClientEvent(player, "receiveFactionMenuData", player, data)
end

local function refreshFactionMembers(faction)
	for _, player in ipairs(getElementsByType("player")) do
		if getElementData(player, "loggedin") == 1 and (tonumber(getElementData(player, "Fraktion")) or 0) == faction then
			triggerClientEvent(player, "refreshFactionMenu", player)
		end
	end
end

function fraktionLeave(player)
	if getElementData(player, "loggedin") ~= 1 then return end
	local faction = tonumber(getElementData(player, "Fraktion")) or 0
	local rank = tonumber(getElementData(player, "Fraktionrang")) or 0
	if faction <= 0 then
		infobox_func(player, getText(player, "FactionS1"), 255, 0, 0)
		return
	end
	if rank >= 5 then
		infobox_func(player, getText(player, "FactionS2"), 255, 0, 0)
		return
	end
	setElementData(player, "Fraktion", 0)
	setElementData(player, "Fraktionrang", 0)
	infobox_func(player, getText(player, "FactionS3"), 0, 255, 0)
	refreshFactionMembers(faction)
end
addCommandHandler("fleave", fraktionLeave)

function spielerInviten(player, cmd, target)
	if getElementData(player, "loggedin") ~= 1 then return end
	local faction = tonumber(getElementData(player, "Fraktion")) or 0
	local rank = tonumber(getElementData(player, "Fraktionrang")) or 0
	if faction <= 0 or rank < 5 then
		infobox_func(player, getText(player, "FactionS4"), 255, 0, 0)
		return
	end
	if not target then
		infobox_func(player, getText(player, "FactionS5"), 255, 255, 255)
		return
	end
	local tplayer = findFactionPlayer(target)
	if not isElement(tplayer) then
		infobox_func(player, getText(player, "FactionS6"), 255, 0, 0)
		return
	end
	if tplayer == player then
		infobox_func(player, getText(player, "FactionS7"), 255, 0, 0)
		return
	end
	if (tonumber(getElementData(tplayer, "Fraktion")) or 0) > 0 then
		infobox_func(player, getText(player, "FactionS8"), 255, 0, 0)
		return
	end
	setElementData(tplayer, "Fraktion", faction)
	setElementData(tplayer, "Fraktionrang", 0)
	infobox_func(player, getText(player, "FactionS9"):format(getPlayerName(tplayer)), 0, 255, 0)
	infobox_func(tplayer, getText(tplayer, "FactionS10"):format(getPlayerName(player)), 0, 255, 0)
	if (tonumber(getElementData(tplayer, "AchFraktion")) or 0) == 0 then
		setElementData(tplayer, "AchFraktion", 1)
		achievementInfo(tplayer)
	end
	refreshFactionMembers(faction)
end
addCommandHandler("invite", spielerInviten)

function spielerUninviten(player, cmd, target)
	if getElementData(player, "loggedin") ~= 1 then return end
	local faction = tonumber(getElementData(player, "Fraktion")) or 0
	local rank = tonumber(getElementData(player, "Fraktionrang")) or 0
	if faction <= 0 or rank < 5 then
		infobox_func(player, getText(player, "FactionS4"), 255, 0, 0)
		return
	end
	if not target then
		infobox_func(player, getText(player, "FactionS11"), 255, 255, 255)
		return
	end
	local tplayer = findFactionPlayer(target)
	if not isElement(tplayer) then
		infobox_func(player, getText(player, "FactionS6"), 255, 0, 0)
		return
	end
	if tplayer == player then
		infobox_func(player, getText(player, "FactionS7"), 255, 0, 0)
		return
	end
	if (tonumber(getElementData(tplayer, "Fraktion")) or 0) ~= faction then
		infobox_func(player, getText(player, "FactionS12"), 255, 0, 0)
		return
	end
	if (tonumber(getElementData(tplayer, "Fraktionrang")) or 0) >= 5 then
		infobox_func(player, getText(player, "FactionS13"), 255, 0, 0)
		return
	end
	setElementData(tplayer, "Fraktion", 0)
	setElementData(tplayer, "Fraktionrang", 0)
	infobox_func(player, getText(player, "FactionS14"):format(getPlayerName(tplayer)), 0, 255, 0)
	infobox_func(tplayer, getText(tplayer, "FactionS15"):format(getPlayerName(player)), 255, 0, 0)
	outputlog(getPlayerName(tplayer) .. " wurde von " .. getPlayerName(player) .. " uninvitet", "Fraktion")
	refreshFactionMembers(faction)
end
addCommandHandler("uninvite", spielerUninviten)

function spielerRangsetzen(player, cmd, target, rang)
	if getElementData(player, "loggedin") ~= 1 then return end
	local faction = tonumber(getElementData(player, "Fraktion")) or 0
	local playerRank = tonumber(getElementData(player, "Fraktionrang")) or 0
	if faction <= 0 or playerRank < 5 then
		infobox_func(player, getText(player, "FactionS4"), 255, 0, 0)
		return
	end
	if not target or not rang then
		infobox_func(player, getText(player, "FactionS16"), 255, 255, 255)
		return
	end
	local tplayer = findFactionPlayer(target)
	rang = tonumber(rang)
	if not isElement(tplayer) then
		infobox_func(player, getText(player, "FactionS6"), 255, 0, 0)
		return
	end
	if not rang or rang < 0 or rang > 4 or rang ~= math.floor(rang) then
		infobox_func(player, getText(player, "FactionS17"), 255, 0, 0)
		return
	end
	if (tonumber(getElementData(tplayer, "Fraktion")) or 0) ~= faction then
		infobox_func(player, getText(player, "FactionS12"), 255, 0, 0)
		return
	end
	setElementData(tplayer, "Fraktionrang", rang)
	infobox_func(player, getText(player, "FactionS18"):format(getPlayerName(tplayer), rang), 0, 255, 0)
	infobox_func(tplayer, getText(tplayer, "FactionS19"):format(rang), 0, 255, 0)
	refreshFactionMembers(faction)
end
addCommandHandler("giverang", spielerRangsetzen)

function inDenKnast(player)
	if not isElement(player) then return end
	local cells = {
		{264.20001220703, 77.5, 1001},
		{264.20001220703, 82.199996948242, 1001},
		{264.10000610352, 86.599998474121, 1001}
	}
	local cell = cells[math.random(1, #cells)]
	setElementInterior(player, 6)
	setElementDimension(player, 0)
	setElementPosition(player, cell[1], cell[2], cell[3])
	setPedRotation(player, 270)
	setElementModel(player, 62)
	setElementData(player, "imKnast", true)
	setPlayerWantedLevel(player, 0)
	setElementData(player, "Wanteds", 0)
end

function ausDemKnast(player)
	if not isElement(player) then return end
	setElementInterior(player, 0)
	setElementDimension(player, 0)
	setElementPosition(player, -216, 978.5, 19.5)
	setPedRotation(player, 270)
	local skin = tonumber(getElementData(player, "Skin"))
	if skin then setElementModel(player, skin) end
	setElementData(player, "imKnast", false)
end

factionskins = {
	[1] = {[0] = 71, [1] = 280, [2] = 281, [3] = 282, [4] = 283, [5] = 288},
	[2] = {[0] = 122, [1] = 121, [2] = 118, [3] = 120, [4] = 123, [5] = 49},
	[3] = {[0] = 292, [1] = 181, [2] = 291, [3] = 247, [4] = 248, [5] = 100},
	[4] = {[0] = 250, [1] = 188, [2] = 185, [3] = 59, [4] = 187, [5] = 147},
	[5] = {[0] = 13, [1] = 297, [2] = 296, [3] = 103, [4] = 102, [5] = 104},
	[6] = {[0] = 114, [1] = 175, [2] = 174, [3] = 173, [4] = 116, [5] = 115}
}

local yakuzaClothes = createPickup(-2170.7202148438, 646.21838378906, 1052.375, 3, 1275, 50)
local bikerClothes = createPickup(-221.30963134766, 1407.095703125, 27.7734375, 3, 1275, 50)
local surenosClothes = createPickup(321.8908996582, 1117.1495361328, 1083.8828125, 3, 1275, 50)
local ballasClothes = createPickup(961.19213867188, 2102.1723632813, 1011.0274658203, 3, 1275, 50)
local reporterClothes = createPickup(-2022.5893554688, -114.51982879639, 1035.171875, 3, 1275, 50)
setElementInterior(yakuzaClothes, 1)
setElementInterior(bikerClothes, 18)
setElementInterior(surenosClothes, 5)
setElementInterior(ballasClothes, 1)
setElementInterior(reporterClothes, 3)

local clothesPositions = {
	[2] = {-2170.7202148438, 646.21838378906, 1052.375, 1},
	[3] = {-221.30963134766, 1407.095703125, 27.7734375, 18},
	[4] = {-2022.5893554688, -114.51982879639, 1035.171875, 3},
	[5] = {961.19213867188, 2102.1723632813, 1011.0274658203, 1},
	[6] = {321.8908996582, 1117.1495361328, 1083.8828125, 5}
}

function changeSkin(player)
	if getElementData(player, "loggedin") ~= 1 then return end
	local faction = tonumber(getElementData(player, "Fraktion")) or 0
	local rank = tonumber(getElementData(player, "Fraktionrang")) or 0
	local position = clothesPositions[faction]
	if not position or not factionskins[faction] or not factionskins[faction][rank] then return end
	if getElementInterior(player) ~= position[4] or getElementDimension(player) ~= 0 then
		infobox_func(player, getText(player, "FactionS20"), 255, 0, 0)
		return
	end
	local x, y, z = getElementPosition(player)
	if getDistanceBetweenPoints3D(position[1], position[2], position[3], x, y, z) >= 5 then
		infobox_func(player, getText(player, "FactionS20"), 255, 0, 0)
		return
	end
	local skin = factionskins[faction][rank]
	setElementModel(player, skin)
	if faction ~= 1 then setElementData(player, "Skin", skin) end
	infobox_func(player, getText(player, "FactionS21"), 0, 255, 0)
end
addCommandHandler("fskin", changeSkin)

function clothesMarkerHit(player)
	if getElementType(player) ~= "player" then return end
	if getElementData(player, "loggedin") ~= 1 or (tonumber(getElementData(player, "Fraktion")) or 0) <= 0 then return end
	infobox_func(player, getText(player, "FactionS22"), 255, 255, 255)
end
addEventHandler("onPickupHit", yakuzaClothes, clothesMarkerHit)
addEventHandler("onPickupHit", bikerClothes, clothesMarkerHit)
addEventHandler("onPickupHit", surenosClothes, clothesMarkerHit)
addEventHandler("onPickupHit", ballasClothes, clothesMarkerHit)
addEventHandler("onPickupHit", reporterClothes, clothesMarkerHit)

local selfSpawns = {
	[1] = {x = -204.96250915527, y = 1212.2875976563, z = 19.7421875, interior = 0},
	[3] = {faction = 1, x = 251.93380737305, y = 70.434516906738, z = 1003.640625, interior = 6},
	[4] = {faction = 2, x = -2160.41796875, y = 638.86529541016, z = 1057.5860595703, interior = 1},
	[5] = {faction = 3, x = -226.13352966309, y = 1410.9614257813, z = 27.7734375, interior = 18},
	[6] = {faction = 4, x = -2022.2545166016, y = -114.60018157959, z = 1035.171875, interior = 3},
	[7] = {faction = 5, x = 963.08654785156, y = 2102.0639648438, z = 1011.02734375, interior = 1},
	[8] = {faction = 6, x = 325.65753173828, y = 1124.7043457031, z = 1083.8828125, interior = 5}
}

function changeSpawn(spawnId)
	local player = client
	if not isElement(player) or getElementData(player, "loggedin") ~= 1 then return end

	spawnId = tonumber(spawnId)
	if not spawnId or spawnId ~= math.floor(spawnId) then return end

	local spawn = selfSpawns[spawnId]
	if not spawn then
		infobox_func(player, getText(player, "FactionS23"), 255, 0, 0)
		return
	end

	local faction = tonumber(getElementData(player, "Fraktion")) or 0
	if spawn.faction and spawn.faction ~= faction then
		infobox_func(player, getText(player, "FactionS23"), 255, 0, 0)
		return
	end

	setElementData(player, "SpawnX", spawn.x)
	setElementData(player, "SpawnY", spawn.y)
	setElementData(player, "SpawnZ", spawn.z)
	setElementData(player, "Interior", spawn.interior)
	if (tonumber(getElementData(player, "AchSpawn")) or 0) == 0 then
		setElementData(player, "AchSpawn", 1)
		achievementInfo(player)
	end
	setElementData(player, "ImHaus", 0)
	infobox_func(player, getText(player, "FactionS24"), 0, 255, 0)
end
addEvent("changeSpawn", true)
addEventHandler("changeSpawn", root, changeSpawn)

addEvent("fstate", true)
addEventHandler("fstate", root, function()
	if not client then return end
	sendFactionMenuData(client)
end)

addEvent("requestFactionMenuData", true)
addEventHandler("requestFactionMenuData", root, function()
	if not client then return end
	sendFactionMenuData(client)
end)

function updatefstate(typ, item, menge)
	local player = client
	if not isElement(player) or getElementData(player, "loggedin") ~= 1 then return end
	local faction = tonumber(getElementData(player, "Fraktion")) or 0
	menge = tonumber(menge)
	if faction <= 0 then return end
	if not menge or menge <= 0 or menge ~= math.floor(menge) then
		infobox_func(player, getText(player, "FactionS30"), 255, 0, 0)
		return
	end
	if typ ~= "einzahlen" and typ ~= "auszahlen" then return end
	if item ~= "money" and item ~= "drugs" and item ~= "mats" then return end
	local result = dbPoll(dbQuery(dbConnection, "SELECT Geld,Drogen,Materialien FROM kassen WHERE Besitzer = ? LIMIT 1", faction), -1)
	if not result or not result[1] then
		infobox_func(player, getText(player, "FactionS25"), 255, 0, 0)
		return
	end
	local column, data
	if item == "money" then
		column, data = "Geld", "Money"
	elseif item == "drugs" then
		column, data = "Drogen", "Drogen"
	else
		column, data = "Materialien", "Materialien"
	end
	local storage = tonumber(result[1][column]) or 0
	local inventory = tonumber(getElementData(player, data)) or 0
	if typ == "auszahlen" then
		if storage < menge then
			infobox_func(player, getText(player, "FactionS31"), 255, 0, 0)
			return
		end
		if not dbExec(dbConnection, "UPDATE kassen SET " .. column .. " = " .. column .. " - ? WHERE Besitzer = ? AND " .. column .. " >= ?", menge, faction, menge) then
			infobox_func(player, getText(player, "FactionS25"), 255, 0, 0)
			return
		end
		setElementData(player, data, inventory + menge)
		infobox_func(player, getText(player, "FactionS32"):format(menge), 0, 255, 0)
	else
		if inventory < menge then
			infobox_func(player, getText(player, "FactionS33"), 255, 0, 0)
			return
		end
		if not dbExec(dbConnection, "UPDATE kassen SET " .. column .. " = " .. column .. " + ? WHERE Besitzer = ?", menge, faction) then
			infobox_func(player, getText(player, "FactionS25"), 255, 0, 0)
			return
		end
		setElementData(player, data, inventory - menge)
		infobox_func(player, getText(player, "FactionS34"):format(menge), 0, 255, 0)
	end
	sendFactionMenuData(player)
end
addEvent("updatefstate", true)
addEventHandler("updatefstate", root, updatefstate)

local yakuzaWTAbgabe = createMarker(676.20001220703, 1932.4000244141, 4.5999999046326, "cylinder", 3, 0, 0, 200)
local bikerWTAbgabe = createMarker(-20.2998046875, 1387.900390625, 8.3999996185303, "cylinder", 3, 0, 0, 200)
local surenosWTAbgabe = createMarker(-374.71676635742, 2253.39453125, 41.484375, "cylinder", 3, 0, 0, 200)
local ballasWTAbgabe = createMarker(2530.3103027344, -2005.8442382813, 12.546875, "cylinder", 3, 0, 0, 200)
setElementAlpha(yakuzaWTAbgabe, 50)
setElementAlpha(bikerWTAbgabe, 50)
setElementAlpha(surenosWTAbgabe, 50)
setElementAlpha(ballasWTAbgabe, 50)

local weaponTruckPositions = {
	[2] = {676.20001220703, 1932.4000244141, 4.5999999046326},
	[3] = {-20.2998046875, 1387.900390625, 8.3999996185303},
	[5] = {2530.3103027344, -2005.8442382813, 12.546875},
	[6] = {-374.71676635742, 2253.39453125, 41.484375}
}

local function isAtWeaponTruckDelivery(player)
	local faction = tonumber(getElementData(player, "Fraktion")) or 0
	local position = weaponTruckPositions[faction]
	if not position then return false end
	local x, y, z = getElementPosition(player)
	return getDistanceBetweenPoints3D(position[1], position[2], position[3], x, y, z) < 8
end

function hitWTAbgabe_func(player)
	if getElementType(player) ~= "player" then return end
	if getElementData(player, "loggedin") ~= 1 or not isEvil(player) then return end
	if not isPedInVehicle(player) then return end
	local veh = getPedOccupiedVehicle(player)
	if isElement(veh) and getElementModel(veh) == 482 and isAtWeaponTruckDelivery(player) then
		infobox_func(player, getText(player, "FactionS35"), 255, 255, 255)
	end
end
addEventHandler("onMarkerHit", yakuzaWTAbgabe, hitWTAbgabe_func)
addEventHandler("onMarkerHit", bikerWTAbgabe, hitWTAbgabe_func)
addEventHandler("onMarkerHit", surenosWTAbgabe, hitWTAbgabe_func)
addEventHandler("onMarkerHit", ballasWTAbgabe, hitWTAbgabe_func)

function unloadweapons_func(player)
	if getElementData(player, "loggedin") ~= 1 or not isEvil(player) then return end
	if not isPedInVehicle(player) then
		infobox_func(player, getText(player, "FactionS36"), 255, 0, 0)
		return
	end
	local veh = getPedOccupiedVehicle(player)
	if not isElement(veh) or getElementModel(veh) ~= 482 then
		infobox_func(player, getText(player, "FactionS36"), 255, 0, 0)
		return
	end
	if not isAtWeaponTruckDelivery(player) then
		infobox_func(player, getText(player, "FactionS37"), 255, 0, 0)
		return
	end
	if getElementData(veh, "paketeBeladen") ~= true then
		infobox_func(player, getText(player, "FactionS38"), 255, 0, 0)
		return
	end
	local faction = tonumber(getElementData(player, "Fraktion")) or 0
	if not dbExec(dbConnection, "UPDATE kassen SET Waffenpakete = Waffenpakete + 5 WHERE Besitzer = ?", faction) then
		infobox_func(player, getText(player, "FactionS25"), 255, 0, 0)
		return
	end
	setElementData(veh, "paketeBeladen", false)
	giveErfahrungspunkte(player, 100)
	infobox_func(player, getText(player, "FactionS39"), 0, 255, 0)
	refreshFactionMembers(faction)
end
addCommandHandler("unloadweapons", unloadweapons_func)
