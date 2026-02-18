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
[18] = createVehicle(554,2.7001953125,1402.099609375,9.3999996185303,0,0,219.99572753906),

}

for i=1,#bikerCars do
	setElementData(bikerCars[i],'Benzin',100)
	setElementData(bikerCars[i],'Besitzer','Biker')
	setVehiclePlateText(bikerCars[i],'Biker')
	setVehicleColor(bikerCars[i],100,50,50)
	setElementFrozen(bikerCars[i],true)
	
	addEventHandler('onVehicleStartEnter',bikerCars[i],function(player)
		if(not(isBiker(player)))then
			cancelEvent()
			getChatBox(player,84)
		else
			setElementFrozen(bikerCars[i],false)
		end
	end)
end

local BikerIn = createPickup(-11.165034294128,1379.3729248047,9.3635883331299,3,1318,50)
local BikerOut = createPickup(-229.29277038574,1401.2086181641,27.765625,3,1318,50)
setElementInterior(BikerOut,18)

addEventHandler('onPickupHit',BikerIn,function(player)
	if(isBiker(player))then
		triggerClientEvent(player,"ladeBalken",player)
		setTimer(function()
			setElementPosition(player,-227.30000305176,1401.1999511719,27.799999237061)
			setPedRotation(player,270)
			setElementInterior(player,18)
		end,1500,1)
	end
end)

addEventHandler('onPickupHit',BikerOut,function(player)
	triggerClientEvent(player,"ladeBalken",player)
	setTimer(function()
		setElementPosition(player,-9.2458391189575,1378.9780273438,9.171875)
		setPedRotation(player,285)
		setElementInterior(player,0)
	end,1500,1)
end)

local gateBiker=createObject(980,-33.099609375,1347.2001953125,11,0,0,94)
local gateBikerMove=false

function moveBikerGate(player)
	if(isBiker(player))then
		if(getDistanceBetweenPoints3D(-33.099609375,1347.2001953125,11,getElementPosition(player))<12)then
			if(gateBikerMove==false)then
				gateBikerMove=true
				moveObject(gateBiker,3000,-33.099609375,1347.2001953125,5)
				setTimer(function()
					gateBikerMove=false
					moveObject(gateBiker,3000,-33.099609375,1347.2001953125,11)
				end,8000,1)
			end
		end
	end
end
addCommandHandler("move",moveBikerGate)