local noobfaggios = {
	[1] = createVehicle(462,-178.80000305176,1216.5999755859,19.39999961853,0,0,270),
	[2] = createVehicle(462,-178.80000305176,1218.5999755859,19.39999961853,0,0,270),
	[3] = createVehicle(462,-178.80000305176,1220.5999755859,19.39999961853,0,0,270),
	[4] = createVehicle(462,-178.80000305176,1222.5999755859,19.39999961853,0,0,270),
	[5] = createVehicle(462,-178.80000305176,1224.5999755859,19.39999961853,0,0,270),
	[6] = createVehicle(462,-178.80000305176,1226.5999755859,19.39999961853,0,0,270),
	[7] = createVehicle(462,-178.80000305176,1228.5999755859,19.39999961853,0,0,270),
}

local noobfaggioTimer = {}

function respawnNoobFaggio(vehicle)
	if not isElement(vehicle) then return end

	if isTimer(noobfaggioTimer[vehicle]) then
		killTimer(noobfaggioTimer[vehicle])
	end
	noobfaggioTimer[vehicle] = nil

	for _,player in ipairs(getVehicleOccupants(vehicle)) do
		if isElement(player) then
			removePedFromVehicle(player)
		end
	end

	respawnVehicle(vehicle)
	fixVehicle(vehicle)

	setElementData(vehicle,"Benzin",100)
	setElementData(vehicle,"Besitzer","System")
	setElementFrozen(vehicle,true)
	setVehicleColor(vehicle,0,255,0)
end

function startNoobFaggioRespawn(vehicle)
	if not isElement(vehicle) then return end

	if isTimer(noobfaggioTimer[vehicle]) then
		killTimer(noobfaggioTimer[vehicle])
	end

	noobfaggioTimer[vehicle] = setTimer(function(veh)
		if not isElement(veh) then return end

		if not getVehicleOccupant(veh,0) then
			respawnNoobFaggio(veh)
		end
	end,300000,1,vehicle)
end

for i = 1,#noobfaggios do
	local vehicle = noobfaggios[i]

	setElementData(vehicle,"Benzin",100)
	setElementData(vehicle,"Besitzer","System")
	setElementFrozen(vehicle,true)
	setVehicleColor(vehicle,0,255,0)

	addEventHandler("onVehicleStartEnter",vehicle,function(player,seat)
		if seat ~= 0 then return end

		local spielzeit = tonumber(getElementData(player,"Spielzeit")) or 0

		if spielzeit <= 300 then
			setElementFrozen(source,false)

			if isTimer(noobfaggioTimer[source]) then
				killTimer(noobfaggioTimer[source])
				noobfaggioTimer[source] = nil
			end
		else
			infobox_func(player,getText(player,"Noobfaggio1"),255,0,0)
			cancelEvent()
		end
	end)

	addEventHandler("onVehicleExit",vehicle,function(player,seat)
		if seat ~= 0 then return end

		if not getVehicleOccupant(source,0) then
			startNoobFaggioRespawn(source)
		end
	end)

	addEventHandler("onVehicleExplode",vehicle,function()
		startNoobFaggioRespawn(source)
	end)
end

addEventHandler("onPlayerQuit",root,function()
	local vehicle = getPedOccupiedVehicle(source)
	if not vehicle then return end
	if not noobfaggioTimer[vehicle] and getElementData(vehicle,"Besitzer") ~= "System" then return end

	for _,faggio in ipairs(noobfaggios) do
		if faggio == vehicle then
			startNoobFaggioRespawn(vehicle)
			return
		end
	end
end)

addEventHandler("onPlayerWasted",root,function()
	local vehicle = getPedOccupiedVehicle(source)
	if not vehicle then return end

	for _,faggio in ipairs(noobfaggios) do
		if faggio == vehicle then
			startNoobFaggioRespawn(vehicle)
			return
		end
	end
end)