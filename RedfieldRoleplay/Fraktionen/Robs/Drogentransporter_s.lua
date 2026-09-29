local drogentransporterPickup = createPickup(-1096.4838867188,-1627.3958740234,76.3671875,3,1239,50)
local kostenproGramm = 5
local aktiverDrogentransporter = false
local drogentransporter = nil
local drogentransporterFahrer = nil
local drogentransporterTimer = nil

local function destroyDrogentransporter()
	if isElement(drogentransporterFahrer) then
		triggerClientEvent(drogentransporterFahrer,"destroyDrogentransporterMarker",drogentransporterFahrer)
	end
	if isElement(drogentransporter) then
		destroyElement(drogentransporter)
	end
	if isTimer(drogentransporterTimer) then
		killTimer(drogentransporterTimer)
	end
	drogentransporter = nil
	drogentransporterFahrer = nil
	drogentransporterTimer = nil
	aktiverDrogentransporter = false
end

function drogentransporterPickupHit(player)
	if getElementType(player) ~= "player" then return end
	if getElementData(player,"loggedin") ~= 1 or not isEvil(player) then return end
	infobox_func(player,getText(player,"DrugTruck1"),255,255,255)
end
addEventHandler("onPickupHit",drogentransporterPickup,drogentransporterPickupHit)

function drogenTransporterStarten(player,cmd,menge)
	if getElementData(player,"loggedin") ~= 1 or not isEvil(player) then return end
	if getElementInterior(player) ~= 0 or getElementDimension(player) ~= 0 then return end
	local x,y,z = getElementPosition(player)
	if getDistanceBetweenPoints3D(-1096.4838867188,-1627.3958740234,76.3671875,x,y,z) >= 5 then
		infobox_func(player,getText(player,"DrugTruck2"),255,0,0)
		return
	end
	menge = tonumber(menge)
	if not menge then
		infobox_func(player,getText(player,"DrugTruck3"),255,255,255)
		return
	end
	if menge <= 0 or menge > 10000 or menge ~= math.floor(menge) then
		infobox_func(player,getText(player,"DrugTruck4"),255,0,0)
		return
	end
	if aktiverDrogentransporter then
		infobox_func(player,getText(player,"DrugTruck5"),255,0,0)
		return
	end
	local price = menge * kostenproGramm
	local money = tonumber(getElementData(player,"Money")) or 0
	if money < price then
		infobox_func(player,getText(player,"DrugTruck6"):format(price),255,0,0)
		return
	end
	if isPedInVehicle(player) then
		infobox_func(player,getText(player,"DrugTruck7"),255,0,0)
		return
	end
	local vehicle = createVehicle(455,-1104,-1620.9000244141,76.900001525879,0,0,270)
	if not isElement(vehicle) then
		infobox_func(player,getText(player,"DrugTruck8"),255,0,0)
		return
	end
	aktiverDrogentransporter = true
	drogentransporter = vehicle
	drogentransporterFahrer = player
	setElementData(player,"Money",money-price)
	setElementData(vehicle,"drogen",menge)
	setElementData(vehicle,"Benzin",100)
	setElementData(vehicle,"Besitzer","System")
	setElementData(vehicle,"Drogentransporter",true)
	warpPedIntoVehicle(player,vehicle)
	triggerClientEvent(player,"drogentransporterMarker",player)
	local exp = math.max(1,math.floor(math.random(1,math.max(1,math.floor(menge/7)))))
	giveErfahrungspunkte(player,exp)
	infobox_func(player,getText(player,"DrugTruck9"):format(price),0,255,0)
	setTimer(function(target,experience)
		if isElement(target) then
			infobox_func(target,getText(target,"DrugTruck10"):format(experience),0,255,0)
		end
	end,2000,1,player,exp)
	if math.random(1,2) == 2 then
		for _,target in ipairs(getElementsByType("player")) do
			outputChatBox(getText(target,"DrugTruck11"),target,150,0,0)
		end
	end
	addEventHandler("onVehicleExit",vehicle,function(exitPlayer,seat)
		if seat ~= 0 or exitPlayer ~= drogentransporterFahrer then return end
		triggerClientEvent(exitPlayer,"destroyDrogentransporterMarker",exitPlayer)
	end)
	addEventHandler("onVehicleEnter",vehicle,function(enterPlayer,seat)
		if seat ~= 0 then return end
		if enterPlayer ~= drogentransporterFahrer then
			cancelEvent()
			infobox_func(enterPlayer,getText(enterPlayer,"DrugTruck12"),255,0,0)
			return
		end
		triggerClientEvent(enterPlayer,"drogentransporterMarker",enterPlayer)
	end)
	addEventHandler("onVehicleExplode",vehicle,function()
		local driver = drogentransporterFahrer
		if isElement(driver) then
			infobox_func(driver,getText(driver,"DrugTruck13"),255,0,0)
		end
		destroyDrogentransporter()
	end)
	drogentransporterTimer = setTimer(function()
		local driver = drogentransporterFahrer
		if isElement(driver) then
			infobox_func(driver,getText(driver,"DrugTruck14"),255,0,0)
		end
		destroyDrogentransporter()
	end,3600000,1)
end
addCommandHandler("drogentransporter",drogenTransporterStarten)

function drogentruckAbgabe()
	local player = client
	if not isElement(player) or getElementData(player,"loggedin") ~= 1 then return end
	if not aktiverDrogentransporter or player ~= drogentransporterFahrer then return end
	if not isElement(drogentransporter) or not isPedInVehicle(player) then return end
	local veh = getPedOccupiedVehicle(player)
	if veh ~= drogentransporter or getPedOccupiedVehicleSeat(player) ~= 0 then return end
	local x,y,z = getElementPosition(player)
	if getElementInterior(player) ~= 0 or getElementDimension(player) ~= 0 then return end
	if getDistanceBetweenPoints3D(578.59997558594,1220.3000488281,11.699999809265,x,y,z) > 8 then
		infobox_func(player,getText(player,"DrugTruck15"),255,0,0)
		return
	end
	local menge = tonumber(getElementData(drogentransporter,"drogen")) or 0
	if menge <= 0 or menge > 10000 then
		destroyDrogentransporter()
		return
	end
	setElementData(player,"Drogen",(tonumber(getElementData(player,"Drogen")) or 0)+menge)
	setElementData(player,"Drogentransporter",(tonumber(getElementData(player,"Drogentransporter")) or 0)+1)
	infobox_func(player,getText(player,"DrugTruck16"):format(menge),0,255,0)
	destroyDrogentransporter()
end
addEvent("drogentruckAbgabe",true)
addEventHandler("drogentruckAbgabe",root,drogentruckAbgabe)

addEventHandler("onPlayerQuit",root,function()
	if source == drogentransporterFahrer then
		destroyDrogentransporter()
	end
end)