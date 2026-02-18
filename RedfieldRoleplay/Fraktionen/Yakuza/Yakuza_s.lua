local yakuzaIn = createMarker(693.70013427734,1967.6844482422,5.5390625,'corona',1,0,0,200)
local yakuzaOut = createMarker(-2158.6579589844,643.14215087891,1052.375,'corona',1,0,0,200)
setElementInterior(yakuzaOut,1)

addEventHandler('onMarkerHit',yakuzaIn,function(player)
	if(isYakuza(player))then
		setElementPosition(player,-2161.1000976563,642,1052.4000244141)
		setPedRotation(player,90)
		setElementInterior(player,1)
	end
end)

addEventHandler('onMarkerHit',yakuzaOut,function(player)
	setElementPosition(player,693.70001220703,1965.4000244141,5.5)
	setPedRotation(player,180)
	setElementInterior(player,0)
end)

local yakuzaGate = createObject(980,712.599609375,1927.900390625,7.3000001907349,0,0,180)
local yakuzaGateMove = false

addCommandHandler('move',function(player)
	if(isYakuza(player))then
		if(getDistanceBetweenPoints3D(712.599609375,1927.900390625,7.3000001907349,getElementPosition(player))<8)then
			if(yakuzaGateMove == false)then
				moveObject(yakuzaGate,3000,712.599609375,1927.900390625,1.3000001907349)
				yakuzaGateMove = true
				setTimer(function()
					yakuzaGateMove = false
					moveObject(yakuzaGate,3000,712.599609375,1927.900390625,7.3000001907349)
				end,7000,1)
			end
		end
	end
end)

local yakuzaCars={

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
[14] = createVehicle(521,722.5,1951,5.1999998092651,0,0,158),

}

for i=1,#yakuzaCars do
	setElementData(yakuzaCars[i],'Benzin',100)
	setElementData(yakuzaCars[i],'Besitzer','Yakuza')
	setVehiclePlateText(yakuzaCars[i],'Yakuza')
	setVehicleColor(yakuzaCars[i],0,50,255)
	setElementFrozen(yakuzaCars[i],true)
	
	addEventHandler('onVehicleStartEnter',yakuzaCars[i],function(player)
		if(not(isYakuza(player)))then
			cancelEvent()
			getChatBox(player,84)
		else
			setElementFrozen(yakuzaCars[i],false)
		end
	end)
end