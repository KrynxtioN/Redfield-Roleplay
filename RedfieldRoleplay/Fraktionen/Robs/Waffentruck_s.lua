local waffentruckPickup = createPickup(219.03958129883,2.9537336826324,2.578125,3,1239,50)
local waffenpaketPreis = 2500

local function isValidWaffentruck(player)
	if not isElement(player) or getElementType(player) ~= "player" then return false end
	if getElementData(player,"loggedin") ~= 1 or not isEvil(player) then return false end
	if not isPedInVehicle(player) or getPedOccupiedVehicleSeat(player) ~= 0 then return false end
	local veh = getPedOccupiedVehicle(player)
	if not isElement(veh) or getElementModel(veh) ~= 482 then return false end
	return veh
end

addEventHandler("onPickupHit",waffentruckPickup,function(player)
	local veh = isValidWaffentruck(player)
	if not veh then return end
	infobox_func(player,getText(player,"WeaponTruck1"),255,255,255)
end)

function loadweapons_func(player)
	local veh = isValidWaffentruck(player)
	if not veh then
		infobox_func(player,getText(player,"WeaponTruck2"),255,0,0)
		return
	end
	local x,y,z = getElementPosition(player)
	if getElementInterior(player) ~= getElementInterior(waffentruckPickup) or getElementDimension(player) ~= getElementDimension(waffentruckPickup) or getDistanceBetweenPoints3D(219.03958129883,2.9537336826324,2.578125,x,y,z) >= 10 then
		infobox_func(player,getText(player,"WeaponTruck3"),255,0,0)
		return
	end
	if getElementData(veh,"paketeBeladen") == true then
		infobox_func(player,getText(player,"WeaponTruck4"),255,0,0)
		return
	end
	local faction = tonumber(getElementData(player,"Fraktion")) or 0
	if faction <= 0 then return end
	local query = dbQuery(dbConnection,"SELECT Geld FROM kassen WHERE Besitzer = ? LIMIT 1",faction)
	local result = dbPoll(query,-1)
	if not result or not result[1] then
		infobox_func(player,getText(player,"WeaponTruck5"),255,0,0)
		return
	end
	local factionMoney = tonumber(result[1].Geld) or 0
	if factionMoney < waffenpaketPreis then
		infobox_func(player,getText(player,"WeaponTruck6"):format(waffenpaketPreis),255,0,0)
		return
	end
	local success = dbExec(dbConnection,"UPDATE kassen SET Geld = Geld - ? WHERE Besitzer = ? AND Geld >= ?",waffenpaketPreis,faction,waffenpaketPreis)
	if not success then
		infobox_func(player,getText(player,"WeaponTruck7"),255,0,0)
		return
	end
	setElementData(veh,"paketeBeladen",true)
	infobox_func(player,getText(player,"WeaponTruck8"):format(waffenpaketPreis),0,255,0)
end
addCommandHandler("loadweapons",loadweapons_func)