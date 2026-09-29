local reporterVehicle = {
	[1] = createVehicle(582,3.4000000953674,1163.3000488281,19.799999237061,0,0,296),
	[2] = createVehicle(582,2.9000000953674,1167.8000488281,19.700000762939,0,0,295),
	[3] = createVehicle(582,2.7998046875,1172.2998046875,19.60000038147,0,0,295),
	[4] = createVehicle(582,2.9000000953674,1177.1999511719,19.60000038147,0,0,295),
	[5] = createVehicle(480,19.700000762939,1164.0999755859,19.39999961853,0,0,0),
	[6] = createVehicle(480,23.2001953125,1164.099609375,19.39999961853,0,0,0),
	[7] = createVehicle(586,24.799999237061,1181.6999511719,18.89999961853,0,0,77),
	[8] = createVehicle(586,24.799999237061,1183.5,18.799999237061,0,0,77),
	[9] = createVehicle(586,24.60000038147,1185.3000488281,18.799999237061,0,0,78)
}

for i = 1,#reporterVehicle do
	local vehicle = reporterVehicle[i]
	setElementFrozen(vehicle,true)
	setVehiclePlateText(vehicle,"Reporter")
	setElementData(vehicle,"Benzin",100)
	setElementData(vehicle,"Besitzer","Reporter")
	setElementData(vehicle,"ReporterVehicle",true)
	setVehicleColor(vehicle,250,150,0)
	addEventHandler("onVehicleExplode",vehicle,function()
		local veh = source
		setTimer(function()
			if not isElement(veh) then return end
			respawnVehicle(veh)
			setElementData(veh,"Benzin",100)
			setElementFrozen(veh,true)
		end,15000,1)
	end)
	addEventHandler("onVehicleStartEnter",vehicle,function(player,seat)
		if getElementType(player) ~= "player" then return end
		if seat ~= 0 then return end
		if not isReporter(player) then
			cancelEvent()
			infobox_func(player,getText(player,"Reporter13"),255,0,0)
			return
		end
		setElementFrozen(source,false)
	end)
end

function setLive(player,cmd,target)
	if getElementData(player,"loggedin") ~= 1 or not isReporter(player) then return end
	if not target then
		infobox_func(player,getText(player,"Reporter1"),255,255,255)
		return
	end
	local tplayer = getPlayerFromName(target)
	if not isElement(tplayer) then
		infobox_func(player,getText(player,"Reporter2"),255,0,0)
		return
	end
	if tplayer == player then
		infobox_func(player,getText(player,"Reporter3"),255,0,0)
		return
	end
	if getElementData(tplayer,"isLive") == true then
		infobox_func(player,getText(player,"Reporter4"):format(getPlayerName(tplayer)),255,0,0)
		return
	end
	setElementData(tplayer,"isLive",true)
	infobox_func(player,getText(player,"Reporter5"):format(getPlayerName(tplayer)),0,255,0)
	infobox_func(tplayer,getText(tplayer,"Reporter6"):format(getPlayerName(player)),0,255,0)
end
addCommandHandler("setlive",setLive)

function endLive(player)
	if getElementData(player,"loggedin") ~= 1 then return end
	if getElementData(player,"isLive") ~= true then
		infobox_func(player,getText(player,"Reporter7"),255,0,0)
		return
	end
	setElementData(player,"isLive",false)
	infobox_func(player,getText(player,"Reporter8"),0,255,0)
end
addCommandHandler("endlive",endLive)

function writeRootReporter(player,cmd,...)
	if getElementData(player,"loggedin") ~= 1 or not isReporter(player) then return end
	local text = table.concat({...}," ")
	if text == "" then
		infobox_func(player,getText(player,"Reporter9"),255,255,255)
		return
	end
	if not isPedInVehicle(player) then
		infobox_func(player,getText(player,"Reporter10"),255,0,0)
		return
	end
	local veh = getPedOccupiedVehicle(player)
	if not isElement(veh) or getElementData(veh,"ReporterVehicle") ~= true then
		infobox_func(player,getText(player,"Reporter10"),255,0,0)
		return
	end
	for _,target in ipairs(getElementsByType("player")) do
		outputChatBox(getText(target,"Reporter11"):format(getPlayerName(player),text),target,250,150,0)
	end
end
addCommandHandler("news",writeRootReporter)

local reporterSchranke1Move = false
local reporterSchranke2Move = false
local reporterSchranke1 = createObject(968,9.6000003814697,1188.0999755859,19.200000762939,0,270,0)
local reporterSchranke2 = createObject(968,15.900390625,1188.2001953125,19.10000038147,0,268,180)

function openReporterSchranke1(player)
	if getElementData(player,"loggedin") ~= 1 or not isReporter(player) then return end
	if getElementInterior(player) ~= 0 or getElementDimension(player) ~= 0 then return end
	local x,y,z = getElementPosition(player)
	if getDistanceBetweenPoints3D(9.6000003814697,1188.0999755859,19.200000762939,x,y,z) >= 4 then return end
	if reporterSchranke1Move then
		infobox_func(player,getText(player,"Reporter12"),255,0,0)
		return
	end
	reporterSchranke1Move = true
	moveObject(reporterSchranke1,3000,9.6000003814697,1188.0999755859,19.200000762939,0,90,0)
	setTimer(function()
		if not isElement(reporterSchranke1) then return end
		moveObject(reporterSchranke1,3000,9.6000003814697,1188.0999755859,19.200000762939,0,-90,0)
		setTimer(function()
			reporterSchranke1Move = false
		end,3000,1)
	end,5000,1)
end
addCommandHandler("move",openReporterSchranke1)

function openReporterSchranke2(player)
	if getElementData(player,"loggedin") ~= 1 or not isReporter(player) then return end
	if getElementInterior(player) ~= 0 or getElementDimension(player) ~= 0 then return end
	local x,y,z = getElementPosition(player)
	if getDistanceBetweenPoints3D(15.900390625,1188.2001953125,19.10000038147,x,y,z) >= 4 then return end
	if reporterSchranke2Move then
		infobox_func(player,getText(player,"Reporter12"),255,0,0)
		return
	end
	reporterSchranke2Move = true
	moveObject(reporterSchranke2,3000,15.900390625,1188.2001953125,19.10000038147,0,90,0)
	setTimer(function()
		if not isElement(reporterSchranke2) then return end
		moveObject(reporterSchranke2,3000,15.900390625,1188.2001953125,19.10000038147,0,-90,0)
		setTimer(function()
			reporterSchranke2Move = false
		end,3000,1)
	end,5000,1)
end
addCommandHandler("move",openReporterSchranke2)

local reporterIn = createPickup(13.987555503845,1187.8225097656,19.47974395752,3,1318,50)
local reporterOut = createPickup(-2026.8526611328,-103.60303497314,1035.1829833984,3,1318,50)
setElementInterior(reporterOut,3)

addEventHandler("onPickupHit",reporterIn,function(player)
	if getElementType(player) ~= "player" then return end
	if getElementData(player,"loggedin") ~= 1 then return end
	if not isReporter(player) then
		infobox_func(player,getText(player,"Reporter14"),255,0,0)
		return
	end
	triggerClientEvent(player,"ladeBalken",player)
	setTimer(function(target)
		if not isElement(target) then return end
		setElementInterior(target,3)
		setElementDimension(target,0)
		setElementPosition(target,-2028.5999755859,-105.09999847412,1035.1999511719)
		setPedRotation(target,100)
	end,1500,1,player)
end)

addEventHandler("onPickupHit",reporterOut,function(player)
	if getElementType(player) ~= "player" then return end
	if getElementData(player,"loggedin") ~= 1 or not isReporter(player) then return end
	triggerClientEvent(player,"ladeBalken",player)
	setTimer(function(target)
		if not isElement(target) then return end
		setElementInterior(target,0)
		setElementDimension(target,0)
		setElementPosition(target,13.89999961853,1189.5999755859,19.299999237061)
		setPedRotation(target,0)
	end,1500,1,player)
end)

addEventHandler("onPlayerQuit",root,function()
	if getElementData(source,"isLive") == true then
		setElementData(source,"isLive",false)
	end
end)