local yakuzaCars = {
	[1] = createVehicle(487,699.09997558594,1901.0999755859,6,0,0,270),
	[2] = createVehicle(409,726.59997558594,1947.9000244141,5.5,0,0,180),
	[3] = createVehicle(482,676.40002441406,1948.5,5.8000001907349,0,0,180),
	[4] = createVehicle(482,681.29998779297,1948.5,5.8000001907349,0,0,180),
	[5] = createVehicle(482,686.5,1948.5,5.8000001907349,0,0,180),
	[6] = createVehicle(482,691.40002441406,1948.5999755859,5.8000001907349,0,0,180),
	[7] = createVehicle(560,700.09997558594,1949.5999755859,5.3000001907349,0,0,200),
	[8] = createVehicle(560,704.099609375,1949.7998046875,5.3000001907349,0,0,200),
	[9] = createVehicle(560,708,1949.900390625,5.3000001907349,0,0,200),
	[10] = createVehicle(560,712.20001220703,1949.9000244141,5.3000001907349,0,0,200),
	[11] = createVehicle(521,717.2998046875,1951,5.1999998092651,0,0,158),
	[12] = createVehicle(521,719.09997558594,1951,5.1999998092651,0,0,158),
	[13] = createVehicle(521,720.79998779297,1951,5.1999998092651,0,0,158),
	[14] = createVehicle(521,722.5,1951,5.1999998092651,0,0,158)
}

for i=1,#yakuzaCars do
	local vehicle = yakuzaCars[i]
	setElementData(vehicle,"Benzin",100)
	setElementData(vehicle,"Besitzer","Yakuza")
	setVehiclePlateText(vehicle,"Yakuza")
	setVehicleColor(vehicle,0,50,255)
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
		if not isYakuza(player) then
			cancelEvent()
			infobox_func(player,getText(player,"FactionVehicle1"),255,0,0)
			return
		end
		setElementFrozen(source,false)
	end)
end

local yakuzaIn = createMarker(693.70013427734,1967.6844482422,5.5390625,"corona",1,0,0,200)
local yakuzaOut = createMarker(-2158.6579589844,643.14215087891,1052.375,"corona",1,0,0,200)
setElementInterior(yakuzaOut,1)

addEventHandler("onMarkerHit",yakuzaIn,function(player)
	if getElementType(player) ~= "player" then return end
	if getElementData(player,"loggedin") ~= 1 then return end
	if not isYakuza(player) then
		infobox_func(player,getText(player,"FactionYakuza1"),255,0,0)
		return
	end
	setElementInterior(player,1)
	setElementDimension(player,0)
	setElementPosition(player,-2161.1000976563,642,1052.4000244141)
	setPedRotation(player,90)
end)

addEventHandler("onMarkerHit",yakuzaOut,function(player)
	if getElementType(player) ~= "player" then return end
	if getElementData(player,"loggedin") ~= 1 then return end
	if not isYakuza(player) then return end
	setElementInterior(player,0)
	setElementDimension(player,0)
	setElementPosition(player,693.70001220703,1965.4000244141,5.5)
	setPedRotation(player,180)
end)

local yakuzaGate = createObject(980,712.599609375,1927.900390625,7.3000001907349,0,0,180)
local yakuzaGateMove = false

function moveYakuzaGate(player)
	if getElementData(player,"loggedin") ~= 1 or not isYakuza(player) then return end
	local x,y,z = getElementPosition(player)
	if getElementInterior(player) ~= 0 or getElementDimension(player) ~= 0 then return end
	if getDistanceBetweenPoints3D(712.599609375,1927.900390625,7.3000001907349,x,y,z) >= 8 then return end
	if yakuzaGateMove then
		infobox_func(player,getText(player,"FactionGate1"),255,0,0)
		return
	end
	yakuzaGateMove = true
	moveObject(yakuzaGate,3000,712.599609375,1927.900390625,1.3000001907349)
	setTimer(function()
		if not isElement(yakuzaGate) then return end
		moveObject(yakuzaGate,3000,712.599609375,1927.900390625,7.3000001907349)
		setTimer(function()
			yakuzaGateMove = false
		end,3000,1)
	end,7000,1)
end
addCommandHandler("move",moveYakuzaGate)