local matstransporterPickup = createPickup(-2615.6049804688,193.17247009277,4.4504776000977,3,1239,50)
local kostenProMaterial = 3
local aktivermatstransporter = false
local matstransporter = nil
local matstransporterFahrer = nil
local matstransporterTimer = nil

local function destroyMatstransporter()
	if isElement(matstransporterFahrer) then
		triggerClientEvent(matstransporterFahrer,"destroymatstransporterMarker",matstransporterFahrer)
	end
	if isElement(matstransporter) then destroyElement(matstransporter) end
	if isTimer(matstransporterTimer) then killTimer(matstransporterTimer) end
	matstransporter = nil
	matstransporterFahrer = nil
	matstransporterTimer = nil
	aktivermatstransporter = false
end

function matstransporterPickupHit(player)
	if getElementType(player) ~= "player" then return end
	if getElementData(player,"loggedin") ~= 1 or not isEvil(player) then return end
	infobox_func(player,getText(player,"MatsTruck1"),255,255,255)
end
addEventHandler("onPickupHit",matstransporterPickup,matstransporterPickupHit)

function matstransporterStarten(player,cmd,menge)
	if getElementData(player,"loggedin") ~= 1 or not isEvil(player) then return end
	if getElementInterior(player) ~= 0 or getElementDimension(player) ~= 0 then return end
	local x,y,z = getElementPosition(player)
	if getDistanceBetweenPoints3D(-2615.6049804688,193.17247009277,4.4504776000977,x,y,z) >= 5 then
		infobox_func(player,getText(player,"MatsTruck2"),255,0,0)
		return
	end
	menge = tonumber(menge)
	if not menge then
		infobox_func(player,getText(player,"MatsTruck3"),255,255,255)
		return
	end
	if menge <= 0 or menge > 10000 or menge ~= math.floor(menge) then
		infobox_func(player,getText(player,"MatsTruck4"),255,0,0)
		return
	end
	if aktivermatstransporter then
		infobox_func(player,getText(player,"MatsTruck5"),255,0,0)
		return
	end
	if isPedInVehicle(player) then
		infobox_func(player,getText(player,"MatsTruck6"),255,0,0)
		return
	end
	local price = menge*kostenProMaterial
	local money = tonumber(getElementData(player,"Money")) or 0
	if money < price then
		infobox_func(player,getText(player,"MatsTruck7"):format(price),255,0,0)
		return
	end
	local vehicle = createVehicle(455,-2613.6000976563,186.19999694824,4.9000000953674,0,0,0)
	if not isElement(vehicle) then
		infobox_func(player,getText(player,"MatsTruck8"),255,0,0)
		return
	end
	aktivermatstransporter = true
	matstransporter = vehicle
	matstransporterFahrer = player
	setElementData(player,"Money",money-price)
	setElementData(vehicle,"mats",menge)
	setElementData(vehicle,"Benzin",100)
	setElementData(vehicle,"Besitzer","System")
	setElementData(vehicle,"Matstransporter",true)
	warpPedIntoVehicle(player,vehicle)
	triggerClientEvent(player,"matstransporterMarker",player)
	local exp = math.max(1,math.random(1,math.max(1,math.floor(menge/7))))
	giveErfahrungspunkte(player,exp)
	infobox_func(player,getText(player,"MatsTruck9"):format(price),0,255,0)
	setTimer(function(target,experience)
		if isElement(target) then
			infobox_func(target,getText(target,"MatsTruck10"):format(experience),0,255,0)
		end
	end,2000,1,player,exp)
	if math.random(1,2) == 2 then
		for _,target in ipairs(getElementsByType("player")) do
			outputChatBox(getText(target,"MatsTruck11"),target,150,0,0)
		end
	end
	addEventHandler("onVehicleExit",vehicle,function(exitPlayer,seat)
		if seat ~= 0 or exitPlayer ~= matstransporterFahrer then return end
		triggerClientEvent(exitPlayer,"destroymatstransporterMarker",exitPlayer)
	end)
	addEventHandler("onVehicleEnter",vehicle,function(enterPlayer,seat)
		if seat ~= 0 then return end
		if enterPlayer ~= matstransporterFahrer then
			cancelEvent()
			infobox_func(enterPlayer,getText(enterPlayer,"MatsTruck12"),255,0,0)
			return
		end
		triggerClientEvent(enterPlayer,"matstransporterMarker",enterPlayer)
	end)
	addEventHandler("onVehicleExplode",vehicle,function()
		local driver = matstransporterFahrer
		if isElement(driver) then
			infobox_func(driver,getText(driver,"MatsTruck13"),255,0,0)
		end
		destroyMatstransporter()
	end)
	matstransporterTimer = setTimer(function()
		local driver = matstransporterFahrer
		if isElement(driver) then
			infobox_func(driver,getText(driver,"MatsTruck14"),255,0,0)
		end
		destroyMatstransporter()
	end,3600000,1)
end
addCommandHandler("matstransporter",matstransporterStarten)

function matstruckAbgabe()
	local player = client
	if not isElement(player) or getElementData(player,"loggedin") ~= 1 then return end
	if not isEvil(player) then return end
	if not aktivermatstransporter or player ~= matstransporterFahrer then return end
	if not isElement(matstransporter) or not isPedInVehicle(player) then return end
	if getPedOccupiedVehicle(player) ~= matstransporter or getPedOccupiedVehicleSeat(player) ~= 0 then return end
	local x,y,z = getElementPosition(matstransporter)
	if getElementInterior(matstransporter) ~= 0 or getElementDimension(matstransporter) ~= 0 then return end
	if getDistanceBetweenPoints3D(578.59997558594,1220.3000488281,11.699999809265,x,y,z) > 8 then
		infobox_func(player,getText(player,"MatsTruck15"),255,0,0)
		return
	end
	local menge = tonumber(getElementData(matstransporter,"mats")) or 0
	if menge <= 0 or menge > 10000 or menge ~= math.floor(menge) then
		destroyMatstransporter()
		return
	end
	setElementData(player,"Mats",(tonumber(getElementData(player,"Mats")) or 0)+menge)
	setElementData(player,"Matstransporter",(tonumber(getElementData(player,"Matstransporter")) or 0)+1)
	infobox_func(player,getText(player,"MatsTruck16"):format(menge),0,255,0)
	destroyMatstransporter()
end
addEvent("matstruckAbgabe",true)
addEventHandler("matstruckAbgabe",root,matstruckAbgabe)

addEventHandler("onPlayerQuit",root,function()
	if source == matstransporterFahrer then destroyMatstransporter() end
end)