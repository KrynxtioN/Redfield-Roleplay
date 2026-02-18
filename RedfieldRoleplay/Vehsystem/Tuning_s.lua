setGarageOpen(7,true)
setGarageOpen(10,true)
setGarageOpen(15,true)
setGarageOpen(18,true)
setGarageOpen(33,true)
	
tuning1 = createMarker(2644.9609375,-2045.8447265625,12.640233039856,'cylinder',3,0,0,200)
tuning2 = createMarker(1041.7705078125,-1012.9990234375,31.080799102783,'cylinder',3,0,0,200)
tuning3 = createMarker(2386.48828125,1051.6982421875,8.9280261993408,'cylinder',3,0,0,200)
tuning4 = createMarker(-2725.255859375,217.642578125,2.484375,'cylinder',3,0,0,200)
tuning5 = createMarker(-1935.8095703125,246.93359375,33.4609375,'cylinder',3,0,0,200)
	
tuning1Blip = createBlip(2644.9609375,-2045.8447265625,13.640233039856,27,0,0,0,0,0,0,200,root)
tuning2Blip = createBlip(1041.7705078125,-1012.9990234375,32.080799102783,27,0,0,0,0,0,0,200,root)
tuning3Blip = createBlip(2386.48828125,1051.6982421875,9.9280261993408,27,0,0,0,0,0,0,200,root)
tuning4Blip = createBlip(-2725.255859375,217.642578125,4.484375,27,0,0,0,0,0,0,200,root)
tuning5Blip = createBlip(-1935.8095703125,246.93359375,34.4609375,27,0,0,0,0,0,0,200,root)

function createTuningWindow(player)
	if(isPedInVehicle(player))then
		local veh = getPedOccupiedVehicle(player)
		if(getPedOccupiedVehicleSeat(player) == 0)then
			if(getElementData(veh,'Besitzer') == getPlayerName(player))then
				triggerClientEvent(player,'openTuningWindow',player)
			end
		end
	end
end
addEventHandler('onMarkerHit',tuning1,createTuningWindow)
addEventHandler('onMarkerHit',tuning2,createTuningWindow)
addEventHandler('onMarkerHit',tuning3,createTuningWindow)
addEventHandler('onMarkerHit',tuning4,createTuningWindow)
addEventHandler('onMarkerHit',tuning5,createTuningWindow)

addEvent('changeColor',true)
addEventHandler('changeColor',root,function(r,g,b)
	local veh = getPedOccupiedVehicle(source)
	setVehicleColor(veh,r,g,b)
	
	local besitzer = getElementData(veh,'Besitzer')
	local slot = getElementData(veh,'Slot')
	if(besitzer and slot)then
		if(besitzer == getPlayerName(source))then
			setCarData(besitzer,slot,'R',r)
			setCarData(besitzer,slot,'G',g)
			setCarData(besitzer,slot,'B',b)
		end
	end
end)