function startBusfahrer(player)
	if(getElementData(player,"loggedin")==1)then
		if(getElementData(player,"Job")=="Busfahrer")then
			if(getDistanceBetweenPoints3D(12.60000038147,1225.5,19.299999237061,getElementPosition(player))<5)then
				vehicle=createVehicle(431,-2.2999999523163,1232.9000244141,19.60000038147,0,0,180)
				setElementData(vehicle,"Benzin",100)
				setElementData(vehicle,"Besitzer","System")
				warpPedIntoVehicle(player,vehicle)
				setElementData(player,"BusfahrerAktiv",true)
				getChatBox(player,146)
				addEventHandler("onVehicleStartExit",vehicle,function(player)
					cancelEvent()
					getChatBox(player,129)
				end)
				triggerClientEvent(player,"startBusfahrerMarker",player)
			end
		end
	end
end
addCommandHandler("busjob",startBusfahrer)

addEvent("frozePlayer",true)
addEventHandler("frozePlayer",root,function(player)
	veh=getPedOccupiedVehicle(player)
	setElementFrozen(veh,true)
	setTimer(function()
		setElementFrozen(veh,false)
	end,7000,1,player)
end)

addEvent("stopbus",true)
addEventHandler("stopbus",root,function(player)
	local veh=getPedOccupiedVehicle(player)
	destroyElement(veh)
	setElementData(player,"BusfahrerAktiv",false)
end)