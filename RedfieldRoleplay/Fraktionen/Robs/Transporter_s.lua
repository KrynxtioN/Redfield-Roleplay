local copstealcardo = false
local copstealtruck = nil
local copstealcar = nil
local copstealblip = nil
local copstealDriver = nil
local copstealRespawnTimer = nil

local function destroyCopStealVehicles()
	if isElement(copstealDriver) then
		triggerClientEvent(copstealDriver,"destroyTransporterFirstMarker",copstealDriver)
		triggerClientEvent(copstealDriver,"destroyTransporterSecondMarker",copstealDriver)
	end
	if isElement(copstealblip) then destroyElement(copstealblip) end
	if isElement(copstealcar) then destroyElement(copstealcar) end
	if isElement(copstealtruck) then destroyElement(copstealtruck) end
	copstealblip = nil
	copstealcar = nil
	copstealtruck = nil
	copstealDriver = nil
	copstealcardo = false
end

local function scheduleCopStealRespawn(delay)
	if isTimer(copstealRespawnTimer) then killTimer(copstealRespawnTimer) end
	copstealRespawnTimer = setTimer(function()
		copstealRespawnTimer = nil
		createStealPDVehicle()
	end,delay,1)
end

function createStealPDVehicle()
	destroyCopStealVehicles()
	for _,player in ipairs(getElementsByType("player")) do
		outputChatBox(getText(player,"CopSteal3"),player,150,0,0)
	end
	copstealtruck = createVehicle(578,63.400001525879,1159.6999511719,19.39999961853,0,0,0)
	copstealcar = createVehicle(598,1702,681,10.699999809265,0,0,0)
	if not isElement(copstealtruck) or not isElement(copstealcar) then
		destroyCopStealVehicles()
		scheduleCopStealRespawn(60000)
		return
	end
	setElementFrozen(copstealcar,true)
	setVehicleDamageProof(copstealcar,true)
	setElementData(copstealcar,"Benzin",0)
	setElementData(copstealcar,"Besitzer","Police")
	setElementData(copstealtruck,"Benzin",100)
	setElementData(copstealtruck,"Besitzer","System")
	setElementData(copstealtruck,"CopStealTruck",true)
	copstealblip = createBlip(63.400001525879,1159.6999511719,19.39999961853,0,2,0,0,255,255,0,200,root)
	addEventHandler("onElementClicked",copstealcar,function(button,state,player)
		if button ~= "left" or state ~= "down" then return end
		if not isElement(player) or getElementData(player,"loggedin") ~= 1 then return end
		if copstealcardo then
			infobox_func(player,getText(player,"CopSteal4"),255,0,0)
			return
		end
		if not isPedInVehicle(player) or getPedOccupiedVehicle(player) ~= copstealtruck or getPedOccupiedVehicleSeat(player) ~= 0 then
			infobox_func(player,getText(player,"CopSteal5"),255,0,0)
			return
		end
		if player ~= copstealDriver then return end
		local x,y,z = getElementPosition(player)
		if getElementInterior(player) ~= 0 or getElementDimension(player) ~= 0 or getDistanceBetweenPoints3D(1702,681,10.699999809265,x,y,z) >= 10 then
			infobox_func(player,getText(player,"CopSteal6"),255,0,0)
			return
		end
		copstealcardo = true
		setElementFrozen(copstealcar,false)
		attachElements(copstealcar,copstealtruck,0,-1,0.5)
		triggerClientEvent(player,"destroyTransporterFirstMarker",player)
		triggerClientEvent(player,"transporterSecondMarker",player)
		infobox_func(player,getText(player,"CopSteal7"),0,255,0)
	end)
	addEventHandler("onVehicleEnter",copstealtruck,function(player,seat)
		if seat ~= 0 then return end
		if getElementData(player,"loggedin") ~= 1 then
			cancelEvent()
			return
		end
		if copstealDriver and isElement(copstealDriver) and copstealDriver ~= player then
			cancelEvent()
			infobox_func(player,getText(player,"CopSteal8"),255,0,0)
			return
		end
		copstealDriver = player
		if isElement(copstealblip) then
			destroyElement(copstealblip)
			copstealblip = nil
		end
		if not copstealcardo then
			triggerClientEvent(player,"transporterFirstMarker",player)
		else
			triggerClientEvent(player,"transporterSecondMarker",player)
		end
	end)
	addEventHandler("onVehicleExit",copstealtruck,function(player,seat)
		if seat ~= 0 or player ~= copstealDriver then return end
		triggerClientEvent(player,"destroyTransporterFirstMarker",player)
		triggerClientEvent(player,"destroyTransporterSecondMarker",player)
	end)
	addEventHandler("onVehicleExplode",copstealtruck,function()
		local driver = copstealDriver
		if isElement(driver) then infobox_func(driver,getText(driver,"CopSteal9"),255,0,0) end
		destroyCopStealVehicles()
		scheduleCopStealRespawn(4000000)
	end)
	addEventHandler("onVehicleExplode",copstealcar,function()
		local driver = copstealDriver
		if isElement(driver) then infobox_func(driver,getText(driver,"CopSteal9"),255,0,0) end
		destroyCopStealVehicles()
		scheduleCopStealRespawn(4000000)
	end)
	scheduleCopStealRespawn(4000000)
end

function finisCopTransporter()
	local player = client
	if not isElement(player) or getElementData(player,"loggedin") ~= 1 then return end
	if player ~= copstealDriver or not copstealcardo then return end
	if not isElement(copstealtruck) or not isElement(copstealcar) then return end
	if not isPedInVehicle(player) or getPedOccupiedVehicle(player) ~= copstealtruck or getPedOccupiedVehicleSeat(player) ~= 0 then return end
	if not isElementAttached(copstealcar) or getElementAttachedTo(copstealcar) ~= copstealtruck then return end
	local x,y,z = getElementPosition(copstealtruck)
	if getElementInterior(copstealtruck) ~= 0 or getElementDimension(copstealtruck) ~= 0 then return end
	if getDistanceBetweenPoints3D(-1422.6063232422,2598.7263183594,55.6875,x,y,z) > 8 then
		infobox_func(player,getText(player,"CopSteal10"),255,0,0)
		return
	end
	local money = math.random(12000,16000)
	setElementData(player,"Bankmoney",(tonumber(getElementData(player,"Bankmoney")) or 0)+money)
	outputChatBox(getText(player,"CopSteal11"):format(money),player,255,255,255)
	triggerClientEvent(player,"destroyTransporterFirstMarker",player)
	triggerClientEvent(player,"destroyTransporterSecondMarker",player)
	if isTimer(copstealRespawnTimer) then killTimer(copstealRespawnTimer) end
	copstealRespawnTimer = nil
	destroyCopStealVehicles()
	scheduleCopStealRespawn(4000000)
end
addEvent("finisCopTransporter",true)
addEventHandler("finisCopTransporter",root,finisCopTransporter)

addEventHandler("onPlayerQuit",root,function()
	if source ~= copstealDriver then return end
	destroyCopStealVehicles()
	if isTimer(copstealRespawnTimer) then killTimer(copstealRespawnTimer) end
	copstealRespawnTimer = nil
	scheduleCopStealRespawn(4000000)
end)

setTimer(createStealPDVehicle,3600000,1)