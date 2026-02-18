function setLive(player,cmd,target)
	if(getElementData(player,'loggedin') == 1)then
		if(isReporter(player))then
			if(target)then
				local tplayer = getPlayerFromName(target)
				setElementData(tplayer,'isLive',true)
				if(isGerman(player))then
					infobox_func(player,'Du hast '..getPlayerName(tplayer)..' Live geschaltet.',0,255,0)
				elseif(isGerman(tplayer))then
					infobox_func(player,'Du wurdest von '..getPlayerName(player)..' Live geschaltet, tippe /endlive zum beenden.',0,255,0)
				end
				if(isEnglish(player))then
					infobox_func(player,'You interviewed '..getPlayerName(tplayer)..'.',0,255,0)
				elseif(isEnglish(tplayer))then 
					infobox_func(tplayer,getPlayerName(player)..' will be interviewed you.',0,255,0)
				end
			else
				getChatBox(player,10)
			end
		end
	end
end
addCommandHandler('setlive',setLive)

function endLive(player)
	if(getElementData(player,'isLive') == true)then
		setElementData(player,'isLive',false)
		getChatBox(player,97)
	end
end
addCommandHandler('endlive',endLive)

function writeRootReporter(player,cmd,...)
	local parametersTable = {...}
	local stringWithAllParameters = table.concat(parametersTable,' ')
	if(isReporter(player))then
		if(#stringWithAllParameters > 0)then
			if(isPedInVehicle(player))then
				local veh = getPedOccupiedVehicle(player)
				if(getElementData(veh,'ReporterVehicle'))then
					outputChatBox('Reporter '..getPlayerName(player)..': '..stringWithAllParameters,root,250,150,0)
				else
					getChatBox(player,98)
				end
			else
				getChatBox(player,98)
			end
		else
			getChatBox(player,7)
		end
	end
end
addCommandHandler('news',writeRootReporter)

local reporterSchranke1Move = false
local reporterSchranke2Move = false
local reporterSchranke1 = createObject(968,9.6000003814697,1188.0999755859,19.200000762939,0,270,0)
local reporterSchranke2 = createObject(968,15.900390625,1188.2001953125,19.10000038147,0,268,180)

function openReporterSchranke1(player)
	if(isReporter(player))then
		if(reporterSchranke1Move == false)then
			if(getDistanceBetweenPoints3D(9.6000003814697,1188.0999755859,19.200000762939,getElementPosition(player)) < 4)then
				reporterSchranke1Move = true
				moveObject(reporterSchranke1,3000,9.6000003814697,1188.0999755859,19.200000762939,0,90,0)
				setTimer(function()
					reporterSchranke1Move = false
					moveObject(reporterSchranke1,3000,9.6000003814697,1188.0999755859,19.200000762939,0,-90,0)
				end,5000,1)
			end
		end
	end
end
addCommandHandler('move',openReporterSchranke1)

function openReporterSchranke2(player)
	if(isReporter(player))then
		if(reporterSchranke2Move == false)then
			if(getDistanceBetweenPoints3D(15.900390625,1188.2001953125,19.10000038147,getElementPosition(player)) < 4)then
				reporterSchranke2Move = true
				moveObject(reporterSchranke2,3000,15.900390625,1188.2001953125,19.10000038147,0,90,0)
				setTimer(function()
					reporterSchranke2Move = false
					moveObject(reporterSchranke2,3000,15.900390625,1188.2001953125,19.10000038147,0,-90,0)
				end,5000,1)
			end
		end
	end
end
addCommandHandler('move',openReporterSchranke2)

local reporterVehicle = {

[1] = createVehicle(582,3.4000000953674,1163.3000488281,19.799999237061,0,0,296),
[2] = createVehicle(582,2.9000000953674,1167.8000488281,19.700000762939,0,0,295),
[3] = createVehicle(582,2.7998046875,1172.2998046875,19.60000038147,0,0,295),
[4] = createVehicle(582,2.9000000953674,1177.1999511719,19.60000038147,0,0,295),
[5] = createVehicle(480,19.700000762939,1164.0999755859,19.39999961853,0,0,0),
[6] = createVehicle(480,23.2001953125,1164.099609375,19.39999961853,0,0,0),
[7] = createVehicle(586,24.799999237061,1181.6999511719,18.89999961853,0,0,77),
[8] = createVehicle(586,24.799999237061,1183.5,18.799999237061,0,0,77),
[9] = createVehicle(586,24.60000038147,1185.3000488281,18.799999237061,0,0,78),

}

for i=1,#reporterVehicle do
	setElementFrozen(reporterVehicle[i],true)
	setVehiclePlateText(reporterVehicle[i],'Reporter')
	setElementData(reporterVehicle[i],'Benzin',100)
	setElementData(reporterVehicle[i],'Besitzer','Reporter')
	setElementData(reporterVehicle[i],'ReporterVehicle',true)
	setVehicleColor(reporterVehicle[i],250,150,0)
	
	addEventHandler('onVehicleStartEnter',reporterVehicle[i],function(player)
		if(getPedOccupiedVehicleSeat(player) == 0)then
			if(not(isReporter(player)))then
				cancelEvent()
				getChatBox(player,84)
			else
				setElementFrozen(reporterVehicle[i],false)
			end
		end
	end)
end

local reporterIn = createPickup(13.987555503845,1187.8225097656,19.47974395752,3,1318,50)
local reporterOut = createPickup(-2026.8526611328,-103.60303497314,1035.1829833984,3,1318,50)
setElementInterior(reporterOut,3)

addEventHandler('onPickupHit',reporterIn,function(player)
	if(isReporter(player))then
		triggerClientEvent(player,"ladeBalken",player)
		setTimer(function()
			setElementPosition(player,-2028.5999755859,-105.09999847412,1035.1999511719)
			setPedRotation(player,100)
			setElementInterior(player,3)
		end,1500,1)
	end
end)

addEventHandler('onPickupHit',reporterOut,function(player)
	triggerClientEvent(player,"ladeBalken",player)
	setTimer(function()
		setElementPosition(player,13.89999961853,1189.5999755859,19.299999237061)
		setPedRotation(player,0)
		setElementInterior(player,0)
	end,1500,1)
end)