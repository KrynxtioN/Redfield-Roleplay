local bikerCars = {
	[1] = createVehicle(482,12.2998046875,1335.900390625,9.3999996185303,0,0,0),
	[2] = createVehicle(482,8.900390625,1335.7001953125,9.3999996185303,0,0,0),
	[3] = createVehicle(482,5.099609375,1335.7001953125,9.3999996185303,0,0,0),
	[4] = createVehicle(482,1.400390625,1335.599609375,9.3999996185303,0,0,0),
	[5] = createVehicle(566,32.099609375,1371.599609375,9.1000003814697,0,0,90),
	[6] = createVehicle(566,33.2001953125,1367.099609375,9.1000003814697,0,0,90),
	[7] = createVehicle(566,32.5,1363,9.1000003814697,0,0,90),
	[8] = createVehicle(463,-11.7998046875,1368.5,8.8000001907349,0,0,265.99548339844),
	[9] = createVehicle(463,-11.400390625,1369.7998046875,8.8000001907349,0,0,265.98999023438),
	[10] = createVehicle(463,-11.099609375,1371.2001953125,8.8000001907349,0,0,265.98999023438),
	[11] = createVehicle(463,-10.7998046875,1372.7001953125,8.8000001907349,0,0,265.98999023438),
	[12] = createVehicle(463,-10.5,1374.099609375,8.8000001907349,0,0,265.98999023438),
	[13] = createVehicle(463,-10.099609375,1375.599609375,8.8000001907349,0,0,265.98999023438),
	[14] = createVehicle(463,-9.7998046875,1377,8.8000001907349,0,0,265.98999023438),
	[15] = createVehicle(409,31.7998046875,1347,9.1000003814697,0,0,109.9951171875),
	[16] = createVehicle(487,19.599609375,1382.900390625,9.3999996185303,0,0,90),
	[17] = createVehicle(422,-2,1399.2998046875,9.3000001907349,0,0,217.99621582031),
	[18] = createVehicle(554,2.7001953125,1402.099609375,9.3999996185303,0,0,219.99572753906)
}

for i = 1,#bikerCars do
	local vehicle = bikerCars[i]
	setElementData(vehicle,"Benzin",100)
	setElementData(vehicle,"Besitzer","Biker")
	setVehiclePlateText(vehicle,"Biker")
	setVehicleColor(vehicle,100,50,50)
	setElementFrozen(vehicle,true)
	addEventHandler("onVehicleExplode",vehicle,function()
		local veh = source
		setTimer(function()
			if isElement(veh) then
				respawnVehicle(veh)
				setElementData(veh,"Benzin",100)
				setElementFrozen(veh,true)
			end
		end,15000,1)
	end)
	addEventHandler("onVehicleStartEnter",vehicle,function(player)
		if not isElement(player) or getElementType(player) ~= "player" then return end
		if not isBiker(player) then
			cancelEvent()
			infobox_func(player,getText(player,"FactionVehicle1"),255,0,0)
			return
		end
		setElementFrozen(source,false)
	end)
end

local BikerIn = createPickup(-11.165034294128,1379.3729248047,9.3635883331299,3,1318,50)
local BikerOut = createPickup(-229.29277038574,1401.2086181641,27.765625,3,1318,50)
setElementInterior(BikerOut,18)

addEventHandler("onPickupHit",BikerIn,function(player)
	if getElementType(player) ~= "player" then return end
	if getElementData(player,"loggedin") ~= 1 then return end
	if not isBiker(player) then
		infobox_func(player,getText(player,"FactionBiker1"),255,0,0)
		return
	end
	triggerClientEvent(player,"ladeBalken",player)
	setTimer(function(target)
		if not isElement(target) then return end
		setElementInterior(target,18)
		setElementDimension(target,0)
		setElementPosition(target,-227.30000305176,1401.1999511719,27.799999237061)
		setPedRotation(target,270)
	end,1500,1,player)
end)

addEventHandler("onPickupHit",BikerOut,function(player)
	if getElementType(player) ~= "player" then return end
	if getElementData(player,"loggedin") ~= 1 then return end
	if not isBiker(player) then return end
	triggerClientEvent(player,"ladeBalken",player)
	setTimer(function(target)
		if not isElement(target) then return end
		setElementInterior(target,0)
		setElementDimension(target,0)
		setElementPosition(target,-9.2458391189575,1378.9780273438,9.171875)
		setPedRotation(target,285)
	end,1500,1,player)
end)

local gateBiker = createObject(980,-33.099609375,1347.2001953125,11,0,0,94)
local gateBikerMove = false

function moveBikerGate(player)
	if getElementData(player,"loggedin") ~= 1 or not isBiker(player) then return end
	local x,y,z = getElementPosition(player)
	if getElementInterior(player) ~= 0 or getElementDimension(player) ~= 0 then return end
	if getDistanceBetweenPoints3D(-33.099609375,1347.2001953125,11,x,y,z) >= 12 then return end
	if gateBikerMove then
		infobox_func(player,getText(player,"FactionGate1"),255,0,0)
		return
	end
	gateBikerMove = true
	moveObject(gateBiker,3000,-33.099609375,1347.2001953125,5)
	setTimer(function()
		if not isElement(gateBiker) then return end
		moveObject(gateBiker,3000,-33.099609375,1347.2001953125,11)
		setTimer(function()
			gateBikerMove = false
		end,3000,1)
	end,8000,1)
end
addCommandHandler("move",moveBikerGate)