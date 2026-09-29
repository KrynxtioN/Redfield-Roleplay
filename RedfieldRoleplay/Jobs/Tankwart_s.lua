local tankwartVehicles = {}
local tankwartTrailers = {}
local tankwartTimers = {}

local function destroyTankwartJob(player)
	if isTimer(tankwartTimers[player]) then
		killTimer(tankwartTimers[player])
	end

	tankwartTimers[player] = nil

	if isElement(tankwartVehicles[player]) then
		destroyElement(tankwartVehicles[player])
	end

	if isElement(tankwartTrailers[player]) then
		destroyElement(tankwartTrailers[player])
	end

	tankwartVehicles[player] = nil
	tankwartTrailers[player] = nil

	if isElement(player) then
		setElementData(player,"TankwartAktiv",false)
		triggerClientEvent(player,"destroyTankShit",player)
	end
end

function StartTankwart(player)
	if not isElement(player) or getElementType(player) ~= "player" then return end
	if getElementData(player,"loggedin") ~= 1 then return end

	if getElementData(player,"Job") ~= "Tankwart" then
		return
	end

	local px,py,pz = getElementPosition(player)

	if getDistanceBetweenPoints3D(639.02117919922,1683.3165283203,7.1875,px,py,pz) >= 5 then
		return
	end

	if getElementData(player,"TankwartAktiv") == true then
		infobox_func(player,getText(player,"Tankwart2"),255,0,0)
		return
	end

	local vehicle = createVehicle(403,643.5,1692.5,7.6999998092651,0,0,40)
	local trailer = createVehicle(584,649.7998046875,1685.2001953125,8.1999998092651,0,0,40)

	if not isElement(vehicle) or not isElement(trailer) then
		if isElement(vehicle) then
			destroyElement(vehicle)
		end

		if isElement(trailer) then
			destroyElement(trailer)
		end

		return
	end

	tankwartVehicles[player] = vehicle
	tankwartTrailers[player] = trailer

	setElementData(player,"TankwartAktiv",true)

	setElementData(vehicle,"Benzin",100)
	setElementData(vehicle,"Besitzer","System")

	setElementData(trailer,"Benzin",100)
	setElementData(trailer,"Besitzer","System")

	attachTrailerToVehicle(vehicle,trailer)
	warpPedIntoVehicle(player,vehicle)

	addEventHandler("onVehicleStartExit",vehicle,function(exitingPlayer,seat)
		if exitingPlayer == player and seat == 0 then
			cancelEvent()
			infobox_func(player,getText(player,"Tankwart6"),0,255,0)
		end
	end)

	tankwartTimers[player] = setTimer(function(jobPlayer)
		if not isElement(jobPlayer) then return end

		local jobVehicle = tankwartVehicles[jobPlayer]

		if not isElement(jobVehicle) then
			destroyTankwartJob(jobPlayer)
			return
		end

		if getVehicleOccupant(jobVehicle,0) ~= jobPlayer then
			destroyTankwartJob(jobPlayer)
		end
	end,30000,0,player)

	triggerClientEvent(player,"createTankMarker",player)
	infobox_func(player,getText(player,"Tankwart3"),0,255,0)
end
addCommandHandler("tankjob",StartTankwart)

function AnhaengerCheckTankWart()
	local player = client

	if not player or not isElement(player) then return end
	if getElementData(player,"loggedin") ~= 1 then return end
	if getElementData(player,"Job") ~= "Tankwart" then return end
	if getElementData(player,"TankwartAktiv") ~= true then return end

	local vehicle = getPedOccupiedVehicle(player)

	if not isElement(vehicle) then return end
	if getPedOccupiedVehicleSeat(player) ~= 0 then return end

	if vehicle ~= tankwartVehicles[player] then
		return
	end

	local trailer = getVehicleTowedByVehicle(vehicle)

	if not isElement(trailer) or trailer ~= tankwartTrailers[player] then
		infobox_func(player,getText(player,"Tankwart4"),255,0,0)
		return
	end

	local skills = tonumber(getElementData(player,"Tankwartjobskills")) or 0
	local money = 0

	if skills < 100 then
		money = 200
	elseif skills < 200 then
		money = 400
	else
		money = 600
	end

	giveJobMoney(player,money)

	triggerClientEvent(player,"destroyTankShit",player)
	triggerClientEvent(player,"createTankMarker",player)

	infobox_func(player,getText(player,"Tankwart5"):format(money),0,255,0)
end
addEvent("AnhaengerCheckTankWart",true)
addEventHandler("AnhaengerCheckTankWart",root,AnhaengerCheckTankWart)

addEventHandler("onPlayerQuit",root,function()
	destroyTankwartJob(source)
end)

addEventHandler("onPlayerWasted",root,function()
	if getElementData(source,"TankwartAktiv") == true then
		destroyTankwartJob(source)
	end
end)
