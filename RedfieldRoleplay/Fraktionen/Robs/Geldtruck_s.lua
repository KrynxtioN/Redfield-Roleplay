local geldtruck_aktiv = false
local geldtruck_cash = 10000
local geld_gate = false
local geldtruck_refresh = 1800000
local geldtruck_vehicle = nil
local geldtruck_vehicle_marker = nil
local refreshGTTimer = nil

local geldtruck_gate = createObject(3055,2740.6000976563,-2004.5999755859,13.60000038147,0,90,0)
local geldtruck_marker = createMarker(2741,-2002.9000244141,12.60000038147,"cylinder",3,0,0,0)
setElementAlpha(geldtruck_marker,0)

local function resetGeldtruckGate()
	if not geld_gate then return end
	geld_gate = false
	moveObject(geldtruck_gate,5000,2740.6000976563,-2004.5999755859,13.60000038147)
end

local function destroyGeldtruck()
	if isElement(geldtruck_vehicle) then
		for _,player in ipairs(getVehicleOccupants(geldtruck_vehicle)) do
			if isElement(player) then
				triggerClientEvent(player,"destroyGeldtruckShit",player)
			end
		end
		destroyElement(geldtruck_vehicle)
	end
	if isElement(geldtruck_vehicle_marker) then destroyElement(geldtruck_vehicle_marker) end
	geldtruck_vehicle = nil
	geldtruck_vehicle_marker = nil
end

function vehicle_geldtruck_create()
	destroyGeldtruck()
	geldtruck_vehicle = createVehicle(428,2741.1000976563,-2008.4000244141,13.800000190735,0,0,0)
	if not isElement(geldtruck_vehicle) then return end
	setVehicleColor(geldtruck_vehicle,0,0,0)
	geldtruck_vehicle_marker = createMarker(0,0,0,"arrow",0.6,200,0,0)
	if isElement(geldtruck_vehicle_marker) then attachElements(geldtruck_vehicle_marker,geldtruck_vehicle,0,0,2.3) end
	setElementData(geldtruck_vehicle,"Benzin",100)
	setElementData(geldtruck_vehicle,"Besitzer","System")
	setElementData(geldtruck_vehicle,"Geldtransporter",true)
	addEventHandler("onVehicleExplode",geldtruck_vehicle,function()
		if source ~= geldtruck_vehicle then return end
		geldtruck_aktiv = false
		destroyGeldtruck()
		resetGeldtruckGate()
		if isTimer(refreshGTTimer) then killTimer(refreshGTTimer) end
		refreshGTTimer = nil
		setTimer(vehicle_geldtruck_create,15000,1)
	end)
	addEventHandler("onVehicleStartExit",geldtruck_vehicle,function(player,seat)
		if seat ~= 0 then return end
		triggerClientEvent(player,"destroyGeldtruckShit",player)
	end)
	addEventHandler("onVehicleStartEnter",geldtruck_vehicle,function(player,seat)
		if seat ~= 0 then return end
		if getElementData(player,"loggedin") ~= 1 or not isCop(player) or getElementData(player,"copDuty") ~= true then
			cancelEvent()
			infobox_func(player,getText(player,"MoneyTruck1"),255,0,0)
			return
		end
		if geldtruck_aktiv and getVehicleController(source) and getVehicleController(source) ~= player then
			cancelEvent()
			return
		end
		geldtruck_aktiv = true
		triggerClientEvent(player,"createGeldtruckSachen",player)
		if not isTimer(refreshGTTimer) then
			for _,target in ipairs(getElementsByType("player")) do
				outputChatBox(getText(target,"MoneyTruck2"),target,150,0,0)
			end
			refreshGTTimer = setTimer(function()
				refreshGTTimer = nil
				geldtruck_aktiv = false
				destroyGeldtruck()
				resetGeldtruckGate()
				setTimer(vehicle_geldtruck_create,5000,1)
			end,geldtruck_refresh,1)
		end
	end)
end

addEventHandler("onMarkerHit",geldtruck_marker,function(player)
	if getElementType(player) ~= "player" then return end
	if getElementData(player,"loggedin") ~= 1 or not isCop(player) or getElementData(player,"copDuty") ~= true then return end
	if geld_gate then
		infobox_func(player,getText(player,"MoneyTruck3"),255,0,0)
		return
	end
	geld_gate = true
	moveObject(geldtruck_gate,5000,2740.6000976563,-2004.5999755859,8.1000003814697)
end)

function geldtruckMoney()
	local player = client
	if not isElement(player) or getElementData(player,"loggedin") ~= 1 then return end
	if not isCop(player) or getElementData(player,"copDuty") ~= true then return end
	if not geldtruck_aktiv or not isElement(geldtruck_vehicle) then return end
	if not isPedInVehicle(player) or getPedOccupiedVehicle(player) ~= geldtruck_vehicle then return end
	if getPedOccupiedVehicleSeat(player) ~= 0 then return end
	local x,y,z = getElementPosition(geldtruck_vehicle)
	if getElementInterior(geldtruck_vehicle) ~= 0 or getElementDimension(geldtruck_vehicle) ~= 0 then return end
	if getDistanceBetweenPoints3D(-196.61231994629,986.69573974609,19.305110931396,x,y,z) > 8 then
		infobox_func(player,getText(player,"MoneyTruck4"),255,0,0)
		return
	end
	local money = tonumber(getElementData(player,"Money")) or 0
	setElementData(player,"Money",money+geldtruck_cash)
	setElementData(player,"Geldtransporter",(tonumber(getElementData(player,"Geldtransporter")) or 0)+1)
	infobox_func(player,getText(player,"MoneyTruck5"):format(geldtruck_cash),0,255,0)
	triggerClientEvent(player,"destroyGeldtruckShit",player)
	geldtruck_aktiv = false
	if isTimer(refreshGTTimer) then killTimer(refreshGTTimer) end
	refreshGTTimer = nil
	destroyGeldtruck()
	resetGeldtruckGate()
	setTimer(vehicle_geldtruck_create,15000,1)
end
addEvent("geldtruckMoney",true)
addEventHandler("geldtruckMoney",root,geldtruckMoney)

addEventHandler("onPlayerQuit",root,function()
	if isElement(geldtruck_vehicle) and getVehicleController(geldtruck_vehicle) == source then
		geldtruck_aktiv = false
		if isTimer(refreshGTTimer) then killTimer(refreshGTTimer) end
		refreshGTTimer = nil
		destroyGeldtruck()
		resetGeldtruckGate()
		setTimer(vehicle_geldtruck_create,15000,1)
	end
end)

vehicle_geldtruck_create()