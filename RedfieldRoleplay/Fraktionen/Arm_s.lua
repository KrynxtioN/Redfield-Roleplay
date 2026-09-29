local yakuzaarm = createPickup(-2165.6899414063,646.27423095703,1052.375,3,353,50)
local bikerarm = createPickup(-217.61991882324,1401.9215087891,27.7734375,3,353,50)
local ballasarm = createPickup(961.10998535156,2112.453125,1011.0234375,3,353,50)
local surenosarm = createPickup(312.75573730469,1124.1958007813,1083.8828125,3,353,50)
setElementInterior(bikerarm,18)
setElementInterior(yakuzaarm,1)
setElementInterior(ballasarm,1)
setElementInterior(surenosarm,5)

local armPositions = {
	[2] = {-2165.6899414063,646.27423095703,1052.375,1},
	[3] = {-217.61991882324,1401.9215087891,27.7734375,18},
	[5] = {961.10998535156,2112.453125,1011.0234375,1},
	[6] = {312.75573730469,1124.1958007813,1083.8828125,5}
}

local function isPlayerAtArm(player)
	local faction = tonumber(getElementData(player,"Fraktion")) or 0
	local position = armPositions[faction]
	if not position then return false end
	if getElementInterior(player) ~= position[4] or getElementDimension(player) ~= 0 then return false end
	local x,y,z = getElementPosition(player)
	return getDistanceBetweenPoints3D(position[1],position[2],position[3],x,y,z) < 5
end

function armPickupHit(player)
	if getElementType(player) ~= "player" then return end
	if getElementData(player,"loggedin") ~= 1 or not isEvil(player) then return end
	infobox_func(player,getText(player,"Arm1"),255,255,255)
end
addEventHandler("onPickupHit",yakuzaarm,armPickupHit)
addEventHandler("onPickupHit",bikerarm,armPickupHit)
addEventHandler("onPickupHit",ballasarm,armPickupHit)
addEventHandler("onPickupHit",surenosarm,armPickupHit)

function takeWeaponPackage(player)
	if getElementData(player,"loggedin") ~= 1 or not isEvil(player) then return end
	if not isPlayerAtArm(player) then
		infobox_func(player,getText(player,"Arm2"),255,0,0)
		return
	end
	local faction = tonumber(getElementData(player,"Fraktion")) or 0
	local result = dbPoll(dbQuery(dbConnection,"SELECT Waffenpakete FROM kassen WHERE Besitzer = ? LIMIT 1",faction),-1)
	if not result or not result[1] then
		infobox_func(player,getText(player,"Arm3"),255,0,0)
		return
	end
	local packages = tonumber(result[1].Waffenpakete) or 0
	if packages < 1 then
		infobox_func(player,getText(player,"Arm4"),255,0,0)
		return
	end
	if not dbExec(dbConnection,"UPDATE kassen SET Waffenpakete = Waffenpakete - 1 WHERE Besitzer = ? AND Waffenpakete >= 1",faction) then
		infobox_func(player,getText(player,"Arm3"),255,0,0)
		return
	end
	giveWeapon(player,24,50,true)
	giveWeapon(player,29,250,true)
	giveWeapon(player,31,300,true)
	giveWeapon(player,33,50,true)
	infobox_func(player,getText(player,"Arm5"),0,255,0)
end
addCommandHandler("arm",takeWeaponPackage)