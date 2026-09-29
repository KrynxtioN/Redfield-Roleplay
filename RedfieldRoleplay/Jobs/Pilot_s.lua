local pilotVehicles = {}
local pilotMissions = {}
local pilotTargets = {}

local pilotMissionData = {
	[1] = {
		skills = 0,
		model = 574,
		spawn = {-1468.3977050781,-211.59780883789,14.118999481201,0,0,346},
		event = "flugplatzsaubermachen_func"
	},
	[2] = {
		skills = 200,
		model = 583,
		spawn = {-1667.400390625,-161.7001953125,13.10000038147,0,0,315},
		event = "landebahnvorbereiten_func"
	},
	[3] = {
		skills = 400,
		model = 583,
		spawn = {-1667.400390625,-161.7001953125,13.10000038147,0,0,315},
		event = "flugbahnkontrollieren_func"
	},
	[4] = {
		skills = 600,
		model = 512,
		spawn = {-1573.5,-91.800003051758,14.89999961853,0,0,0},
		event = "duengerspruehen_func"
	},
	[5] = {
		skills = 800,
		model = 577,
		spawn = {-1633,-140.39999389648,13.10000038147,0,0,316},
		event = "flughafenmarker_func"
	}
}

local function destroyPilotVehicle(player)
	if isElement(pilotVehicles[player]) then
		destroyElement(pilotVehicles[player])
	end

	pilotVehicles[player] = nil
	pilotMissions[player] = nil
	pilotTargets[player] = nil

	if isElement(player) then
		setElementData(player,"PilotJobAktiv",false)
		triggerClientEvent(player,"stopPilotJob",player)
	end
end

function pilotJobStarten(player,cmd,mission)
	if not isElement(player) then return end
	if getElementData(player,"loggedin") ~= 1 then return end
	if getElementData(player,"Job") ~= "Pilot" then return end

	local x,y,z = getElementPosition(player)

	if getDistanceBetweenPoints3D(
		-1421.4528808594,-287.35494995117,14.1484375,
		x,y,z
	) >= 5 then
		return
	end

	if getElementData(player,"PilotJobAktiv") == true then
		infobox_func(player,getText(player,"Pilot1"),255,0,0)
		return
	end

	mission = tonumber(mission)

	if not mission or not pilotMissionData[mission] then
		infobox_func(player,getText(player,"Pilot2"),255,0,0)
		return
	end

	local data = pilotMissionData[mission]
	local skills = tonumber(getElementData(player,"Flugjobskills")) or 0

	if skills < data.skills then
		infobox_func(player,getText(player,"Pilot3"):format(data.skills),255,0,0)
		return
	end

	local spawn = data.spawn

	local vehicle = createVehicle(
		data.model,
		spawn[1],spawn[2],spawn[3],
		spawn[4],spawn[5],spawn[6]
	)

	if not isElement(vehicle) then return end

	pilotVehicles[player] = vehicle
	pilotMissions[player] = mission

	setElementData(player,"PilotJobAktiv",true)

	setElementData(vehicle,"Benzin",100)
	setElementData(vehicle,"Besitzer","System")

	warpPedIntoVehicle(player,vehicle)

	addEventHandler("onVehicleStartExit",vehicle,function(exitingPlayer,seat)
		if exitingPlayer == player and seat == 0 then
			cancelEvent()
			infobox_func(player,getText(player,"Pilot4"),255,0,0)
		end
	end)

	addEventHandler("onVehicleExplode",vehicle,function()
		if pilotVehicles[player] == source then
			destroyPilotVehicle(player)
		end
	end)

	infobox_func(player,getText(player,"Pilot5"):format(mission),0,255,0)

	triggerClientEvent(player,data.event,player)
end
addCommandHandler("flugjob",pilotJobStarten)

addEvent("pilotSetTarget",true)
addEventHandler("pilotSetTarget",root,function(x,y,z)
	local player = client
	if not player or not isElement(player) then return end
	if getElementData(player,"PilotJobAktiv") ~= true then return end
	if not isElement(pilotVehicles[player]) then return end

	x = tonumber(x)
	y = tonumber(y)
	z = tonumber(z)

	if not x or not y or not z then return end

	pilotTargets[player] = {x,y,z}
end)

addEvent("pilotMarkerReached",true)
addEventHandler("pilotMarkerReached",root,function()
	local player = client
	if not player or not isElement(player) then return end
	if getElementData(player,"PilotJobAktiv") ~= true then return end

	local vehicle = getPedOccupiedVehicle(player)

	if not isElement(vehicle) then return end
	if vehicle ~= pilotVehicles[player] then return end
	if getPedOccupiedVehicleSeat(player) ~= 0 then return end

	local target = pilotTargets[player]

	if not target then return end

	local x,y,z = getElementPosition(vehicle)

	if getDistanceBetweenPoints3D(x,y,z,target[1],target[2],target[3]) > 15 then
		return
	end

	local mission = pilotMissions[player]
	local skills = tonumber(getElementData(player,"Flugjobskills")) or 0

	if mission == 1 then
		giveJobMoney(player,25,1)

	elseif mission == 2 then
		giveJobMoney(player,50,1)

	elseif mission == 3 then
		giveJobMoney(player,100,1)

		if math.random(1,3) == 2 then
			local schrauben = math.random(5,13)
			local bonus = schrauben*5

			giveJobMoney(player,bonus,1)

			infobox_func(
				player,
				getText(player,"Pilot6"):format(schrauben,bonus),
				0,255,0
			)
		end

	elseif mission == 4 then
		giveJobMoney(player,200,2)

	elseif mission == 5 then
		local money

		if skills < 1000 then
			money = 300
		else
			money = 500
		end

		giveJobMoney(player,money,3)

		infobox_func(player,getText(player,"Pilot7"):format(money),0,255,0)

		destroyPilotVehicle(player)
		return
	else
		return
	end

	pilotTargets[player] = nil

	triggerClientEvent(player,"pilotCreateNextMarker",player,mission)
end)

addEventHandler("onPlayerQuit",root,function()
	if pilotVehicles[source] then
		destroyPilotVehicle(source)
	end
end)

addEventHandler("onPlayerWasted",root,function()
	if pilotVehicles[source] then
		destroyPilotVehicle(source)
	end
end)