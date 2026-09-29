local busVehicles = {}
local busPoints = {}

function startBusfahrer(player)
	if getElementData(player,"loggedin") ~= 1 then return end
	if getElementData(player,"Job") ~= "Busfahrer" then return end
	local x,y,z = getElementPosition(player)
	if getDistanceBetweenPoints3D(12.60000038147,1225.5,19.299999237061,x,y,z) >= 5 then return end
	if getElementData(player,"BusfahrerAktiv") == true then
		infobox_func(player,getText(player,"Busjob1"),255,0,0)
		return
	end
	local vehicle = createVehicle(431,-2.2999999523163,1232.9000244141,19.60000038147,0,0,180)
	if not isElement(vehicle) then return end
	busVehicles[player] = vehicle
	busPoints[player] = 0
	setElementData(vehicle,"Benzin",100)
	setElementData(vehicle,"Besitzer","System")
	setElementData(player,"BusfahrerAktiv",true)
	warpPedIntoVehicle(player,vehicle)
	infobox_func(player,getText(player,"Busjob2"),0,255,0)
	addEventHandler("onVehicleStartExit",vehicle,function(exitingPlayer,seat)
		if exitingPlayer == player and seat == 0 then
			cancelEvent()
			infobox_func(player,getText(player,"Busjob3"),255,0,0)
		end
	end)
	addEventHandler("onVehicleExplode",vehicle,function()
		if busVehicles[player] == source then
			busVehicles[player] = nil
			busPoints[player] = nil
			if isElement(player) then
				setElementData(player,"BusfahrerAktiv",false)
				triggerClientEvent(player,"destroyBusShit",player)
			end
		end
	end)
	triggerClientEvent(player,"startBusfahrerMarker",player)
end
addCommandHandler("busjob",startBusfahrer)

addEvent("busMarkerReached",true)
addEventHandler("busMarkerReached",root,function(point)
	local player = client
	if not player or not isElement(player) then return end
	if getElementData(player,"loggedin") ~= 1 then return end
	if getElementData(player,"Job") ~= "Busfahrer" then return end
	if getElementData(player,"BusfahrerAktiv") ~= true then return end
	local vehicle = getPedOccupiedVehicle(player)
	if not isElement(vehicle) or vehicle ~= busVehicles[player] then return end
	if getPedOccupiedVehicleSeat(player) ~= 0 then return end
	point = tonumber(point)
	if not point or point ~= (busPoints[player] or 0)+1 then return end
	if point < 1 or point > 39 then return end
	busPoints[player] = point
end)

addEvent("frozePlayer",true)
addEventHandler("frozePlayer",root,function(point)
	local player = client
	if not player or not isElement(player) then return end
	if getElementData(player,"BusfahrerAktiv") ~= true then return end
	local vehicle = getPedOccupiedVehicle(player)
	if not isElement(vehicle) or vehicle ~= busVehicles[player] then return end
	if getPedOccupiedVehicleSeat(player) ~= 0 then return end
	point = tonumber(point)
	if not point or busPoints[player] ~= point then return end
	setElementFrozen(vehicle,true)
	setTimer(function(veh)
		if isElement(veh) then setElementFrozen(veh,false) end
	end,7000,1,vehicle)
end)

addEvent("busJobFinished",true)
addEventHandler("busJobFinished",root,function()
	local player = client
	if not player or not isElement(player) then return end
	if getElementData(player,"BusfahrerAktiv") ~= true then return end
	if busPoints[player] ~= 39 then return end
	local vehicle = getPedOccupiedVehicle(player)
	if not isElement(vehicle) or vehicle ~= busVehicles[player] then return end
	if getPedOccupiedVehicleSeat(player) ~= 0 then return end
	local money = 39*75
	giveJobMoney(player,money)
	infobox_func(player,getText(player,"Busjob4"):format(money),0,255,0)
	if isElement(busVehicles[player]) then destroyElement(busVehicles[player]) end
	busVehicles[player] = nil
	busPoints[player] = nil
	setElementData(player,"BusfahrerAktiv",false)
	triggerClientEvent(player,"destroyBusShit",player)
end)

addEventHandler("onPlayerWasted",root,function()
	if busVehicles[source] then
		if isElement(busVehicles[source]) then destroyElement(busVehicles[source]) end
		busVehicles[source] = nil
		busPoints[source] = nil
		setElementData(source,"BusfahrerAktiv",false)
		triggerClientEvent(source,"destroyBusShit",source)
	end
end)

addEventHandler("onPlayerQuit",root,function()
	if isElement(busVehicles[source]) then destroyElement(busVehicles[source]) end
	busVehicles[source] = nil
	busPoints[source] = nil
end)