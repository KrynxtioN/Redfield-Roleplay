local jobNames = {
	pizza = "Pizzalieferant",
	tankwart = "Tankwart",
	pilot = "Pilot",
	holzfaeller = "Holzfaeller",
	busfahrer = "Busfahrer",
	farmer = "Farmer"
}

local jobStartTexts = {
	tankwart = "Job11",
	pilot = "Job12",
	holzfaeller = "Job13",
	busfahrer = "Job14",
	farmer = "Job15"
}

addEvent("acceptJob",true)
addEventHandler("acceptJob",root,function(typ)
	local player = client
	if not player or not isElement(player) then return end
	if getElementData(player,"loggedin") ~= 1 then return end
	if not jobNames[typ] then return end
	if tonumber(getElementData(player,"Arbeitsgenehmigung")) ~= 1 then
		infobox_func(player,getText(player,"Job3"),255,255,255)
		return
	end
	setElementData(player,"Job",jobNames[typ])
	infobox_func(player,getText(player,"Job4"),255,255,255)
	if jobStartTexts[typ] then
		infobox_func(player,getText(player,jobStartTexts[typ]),0,200,0)
	end
	triggerClientEvent(player,"jobAccepted",player)
end)

function giveJobMoney(player,geld,skillpunkte)
	if not player or not isElement(player) then return end
	geld = tonumber(geld) or 0
	skillpunkte = tonumber(skillpunkte) or 0
	if geld <= 0 then return end
	geld = math.floor(geld)
	skillpunkte = math.max(0,math.floor(skillpunkte))
	local jobgehalt = tonumber(getElementData(player,"Jobgehalt")) or 0
	local spielzeit = tonumber(getElementData(player,"Spielzeit")) or 0
	setElementData(player,"Jobgehalt",jobgehalt+geld)
	if spielzeit < 300 then
		infobox_func(player,getText(player,"Job16"):format(geld),0,255,0)
	else
		infobox_func(player,getText(player,"Job17"):format(geld),0,255,0)
	end
	local job = getElementData(player,"Job")
	if job == "Pilot" then
		giveErfahrungspunkte(player,10)
		local skills = tonumber(getElementData(player,"Flugjobskills")) or 0
		setElementData(player,"Flugjobskills",math.min(1000,skills+skillpunkte))
	elseif job == "Pizzalieferant" then
		giveErfahrungspunkte(player,10)
		local skills = tonumber(getElementData(player,"Pizzajobskills")) or 0
		setElementData(player,"Pizzajobskills",math.min(600,skills+skillpunkte))
	elseif job == "Tankwart" then
		giveErfahrungspunkte(player,35)
		local skills = tonumber(getElementData(player,"Tankwartjobskills")) or 0
		setElementData(player,"Tankwartjobskills",math.min(400,skills+skillpunkte))
	end
end

function stopJob(player)
	if not isElement(player) then return end
	if getElementData(player,"PilotJobAktiv") == true then
		local veh = getPedOccupiedVehicle(player)
		if isElement(veh) then destroyElement(veh) end
		triggerClientEvent(player,"stopPilotJob",player)
		setElementData(player,"PilotJobAktiv",false)
		setElementPosition(player,-1421.4528808594,-287.35494995117,14.1484375)
	elseif getElementData(player,"inholzjob") == true then
		setElementData(player,"inholzjob",false)
		triggerClientEvent(player,"destroyHolz",player)
	elseif getElementData(player,"TankwartAktiv") == true then
		local veh = getPedOccupiedVehicle(player)
		if isElement(veh) then
			local anhaenger = getVehicleTowedByVehicle(veh)
			if isElement(anhaenger) then destroyElement(anhaenger) end
			destroyElement(veh)
		end
		triggerClientEvent(player,"destroyTankShit",player)
		setElementPosition(player,639.02117919922,1683.3165283203,7.1875)
		setElementData(player,"TankwartAktiv",false)
	elseif getElementData(player,"BusfahrerAktiv") == true then
		local veh = getPedOccupiedVehicle(player)
		if isElement(veh) then destroyElement(veh) end
		triggerClientEvent(player,"destroyBusShit",player)
		setElementPosition(player,12.60000038147,1225.5,19.299999237061)
		setElementData(player,"BusfahrerAktiv",false)
	elseif getElementData(player,"FarmerAktiv") == true then
		setElementData(player,"FarmerAktiv",false)
		triggerClientEvent(player,"destroyFarmerShit",player)
	else
		infobox_func(player,getText(player,"Job18"),255,0,0)
		return
	end
	infobox_func(player,getText(player,"Job19"),0,255,0)
end
addCommandHandler("stopjob",stopJob)

function jobskills(player)
	if getElementData(player,"loggedin") ~= 1 then return end
	local flugjobpoints = tonumber(getElementData(player,"Flugjobskills")) or 0
	local pizzajobpoints = tonumber(getElementData(player,"Pizzajobskills")) or 0
	local holzjobpoints = tonumber(getElementData(player,"Holzjobskillpunkte")) or 0
	local tankwartpoints = tonumber(getElementData(player,"Tankwartjobskills")) or 0
	infobox_func(player,getText(player,"Job20"):format(flugjobpoints,pizzajobpoints,holzjobpoints,tankwartpoints),255,255,255)
end
addCommandHandler("jobskills",jobskills)