local dutypickup = createPickup(256.93380737305,70.434516906738,1003.640625,3,1239,50)
setElementInterior(dutypickup,6)

function dutypickuphit(player)
	if getElementType(player) ~= "player" then return end
	if getElementData(player,"loggedin") ~= 1 or not isCop(player) then return end
	infobox_func(player,getText(player,"Police1"),255,255,255)
end
addEventHandler("onPickupHit",dutypickup,dutypickuphit)

function dutycops(player,cmd,duty)
	if getElementData(player,"loggedin") ~= 1 or not isCop(player) then return end
	if getElementInterior(player) ~= 6 then return end
	local x,y,z = getElementPosition(player)
	if getDistanceBetweenPoints3D(256.93380737305,70.434516906738,1003.640625,x,y,z) >= 5 then return end
	if not duty then
		infobox_func(player,getText(player,"Police2"),255,255,255)
		return
	end
	if getElementData(player,"copDuty") == true then
		infobox_func(player,getText(player,"Police3"),255,0,0)
		return
	end
	duty = duty:lower()
	if duty == "normal" then
		changeSkin(player)
		giveWeapon(player,3,1,true)
		giveWeapon(player,24,30,true)
		if (tonumber(getElementData(player,"Rang")) or 0) > 0 then
			giveWeapon(player,29,300,true)
			giveWeapon(player,31,300,true)
		end
	elseif duty == "swat" then
		setElementModel(player,285)
		giveWeapon(player,24,30,true)
		giveWeapon(player,29,300,true)
		giveWeapon(player,31,300,true)
		giveWeapon(player,34,25,true)
	else
		infobox_func(player,getText(player,"Police2"),255,255,255)
		return
	end
	setElementData(player,"copDuty",true)
	unbindKey(player,"f4","down",copVehicleCams)
	bindKey(player,"f4","down",copVehicleCams)
	infobox_func(player,getText(player,"Police4"),0,255,0)
end
addCommandHandler("duty",dutycops)

function copVehicleCams(player)
	if not isElement(player) or not isPedInVehicle(player) then return end
	local veh = getPedOccupiedVehicle(player)
	if isElement(veh) and getElementData(veh,"copVehicleYo") == true then
		triggerClientEvent(player,"bindKeysForPC",player)
	end
end

function offdutycops(player)
	if getElementData(player,"loggedin") ~= 1 or not isCop(player) then return end
	local x,y,z = getElementPosition(player)
	local nearDuty = getElementInterior(player) == 6 and getDistanceBetweenPoints3D(256.93380737305,70.434516906738,1003.640625,x,y,z) < 5
	local nearSecond = getDistanceBetweenPoints3D(258.8518371582,109.27908325195,1003.21875,x,y,z) < 5
	if not nearDuty and not nearSecond then return end
	if getElementData(player,"copDuty") ~= true then
		infobox_func(player,getText(player,"Police5"),255,0,0)
		return
	end
	setElementData(player,"copDuty",false)
	unbindKey(player,"f4","down",copVehicleCams)
	infobox_func(player,getText(player,"Police6"),0,255,0)
end
addCommandHandler("offduty",offdutycops)

local copVehicle = {
	[1] = createVehicle(497,-215.19999694824,992.5,30.799999237061,0,0,90),
	[2] = createVehicle(497,-215.2001953125,977.900390625,30.799999237061,0,0,90),
	[3] = createVehicle(598,-227.80000305176,1048.5,-3.5999999046326,0,0,180),
	[4] = createVehicle(598,-223.89999389648,1048.5,-3.5999999046326,0,0,180),
	[5] = createVehicle(598,-219.89999389648,1048.5,-3.5999999046326,0,0,180),
	[6] = createVehicle(598,-215.89999389648,1048.5,-3.5999999046326,0,0,180),
	[7] = createVehicle(598,-211.89999389648,1048.5,-3.5999999046326,0,0,180),
	[8] = createVehicle(598,-207.89999389648,1048.5,-3.5999999046326,0,0,180),
	[9] = createVehicle(598,-203.89999389648,1048.5,-3.5999999046326,0,0,180),
	[10] = createVehicle(598,-199.89999389648,1048.5,-3.5999999046326,0,0,180),
	[11] = createVehicle(598,-195.89999389648,1048.5,-3.5999999046326,0,0,180),
	[12] = createVehicle(598,-191.89999389648,1048.5,-3.5999999046326,0,0,180),
	[13] = createVehicle(598,-187.89999389648,1048.5,-3.5999999046326,0,0,180),
	[14] = createVehicle(598,-183.89999389648,1048.5,-3.5999999046326,0,0,180),
	[15] = createVehicle(598,-179.89999389648,1048.5,-3.5999999046326,0,0,180),
	[16] = createVehicle(598,-175.89999389648,1048.5,-3.5999999046326,0,0,180),
	[17] = createVehicle(427,-177.19999694824,1017.9000244141,-3.2000000476837,0,0,90),
	[18] = createVehicle(427,-177.19999694824,1012.9000244141,-3.2000000476837,0,0,90),
	[19] = createVehicle(427,-177.19999694824,1007.9000244141,-3.2000000476837,0,0,90),
	[20] = createVehicle(523,-222.60000610352,1034.0999755859,-3.7999999523163,0,0,0),
	[21] = createVehicle(523,-225.60000610352,1034.0999755859,-3.7999999523163,0,0,0),
	[22] = createVehicle(523,-228.60000610352,1034.0999755859,-3.7999999523163,0,0,0),
	[23] = createVehicle(523,-231.60000610352,1034.0999755859,-3.7999999523163,0,0,0),
	[24] = createVehicle(523,-234.60000610352,1034.0999755859,-3.7999999523163,0,0,0),
	[25] = createVehicle(523,-237.60000610352,1034.0999755859,-3.7999999523163,0,0,0)
}

for i = 1,#copVehicle do
	local vehicle = copVehicle[i]
	setElementFrozen(vehicle,true)
	setVehiclePlateText(vehicle,"Police")
	setElementData(vehicle,"Benzin",100)
	setElementData(vehicle,"Besitzer","Police")
	setElementData(vehicle,"copVehicleYo",true)
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
		if seat == 0 then
			if not isCop(player) or getElementData(player,"copDuty") ~= true then
				cancelEvent()
				infobox_func(player,getText(player,"Police7"),255,0,0)
				return
			end
			setElementFrozen(source,false)
			return
		end
		if getElementData(player,"wantedCard") == true and getPlayerWantedLevel(player) > 0 then
			infobox_func(player,getText(player,"Police8"),255,0,0)
			toggleAllControls(player,false)
			setTimer(function(target)
				if not isElement(target) then return end
				toggleAllControls(target,true)
				setElementData(target,"wantedCard",false)
				setPlayerWantedLevel(target,0)
				setElementData(target,"Wanteds",0)
				infobox_func(target,getText(target,"Police9"),0,255,0)
			end,13000,1,player)
		end
	end)
end

local einknastenMarker = createMarker(-216.42816162109,972.83435058594,18.324136734009,"cylinder",3,255,255,0)
setElementAlpha(einknastenMarker,75)

function einknastenMarkerHit(player)
	if getElementType(player) ~= "player" then return end
	if isCop(player) and getElementData(player,"copDuty") == true and isPedInVehicle(player) then
		infobox_func(player,getText(player,"Police10"),255,255,255)
	end
end
addEventHandler("onMarkerHit",einknastenMarker,einknastenMarkerHit)

function einknastenFunc(player,cmd,target)
	if getElementData(player,"loggedin") ~= 1 then return end
	if not isCop(player) or getElementData(player,"copDuty") ~= true then return end
	if not target then
		infobox_func(player,getText(player,"Police11"),255,255,255)
		return
	end
	local tplayer = getPlayerFromName(target)
	if not isElement(tplayer) then
		infobox_func(player,getText(player,"Police12"),255,0,0)
		return
	end
	if tplayer == player then
		infobox_func(player,getText(player,"Police13"),255,0,0)
		return
	end
	local x,y,z = getElementPosition(player)
	if getDistanceBetweenPoints3D(-216.42816162109,972.83435058594,18.324136734009,x,y,z) >= 5 then
		infobox_func(player,getText(player,"Police14"),255,0,0)
		return
	end
	local tx,ty,tz = getElementPosition(tplayer)
	if getElementInterior(player) ~= getElementInterior(tplayer) or getElementDimension(player) ~= getElementDimension(tplayer) or getDistanceBetweenPoints3D(x,y,z,tx,ty,tz) >= 5 then
		infobox_func(player,getText(player,"Police15"),255,0,0)
		return
	end
	local wanteds = getPlayerWantedLevel(tplayer)
	if wanteds <= 0 then
		infobox_func(player,getText(player,"Police16"),255,0,0)
		return
	end
	local prisonTime = wanteds*4
	giveErfahrungspunkte(player,50)
	setElementData(tplayer,"Knastzeit",prisonTime)
	infobox_func(player,getText(player,"Police17"):format(getPlayerName(tplayer)),0,255,0)
	infobox_func(tplayer,getText(tplayer,"Police18"):format(getPlayerName(player),prisonTime),0,255,0)
	for _,targetPlayer in ipairs(getElementsByType("player")) do
		outputChatBox(getText(targetPlayer,"Police19"):format(getPlayerName(tplayer),getPlayerName(player)),targetPlayer,120,120,120)
	end
	inDenKnast(tplayer)
end
addCommandHandler("arrest",einknastenFunc)

function WantedsGeben(player,cmd,target,reason,anzahl)
	if getElementData(player,"loggedin") ~= 1 then return end
	if not isCop(player) or getElementData(player,"copDuty") ~= true then return end
	if not target or not reason or not anzahl then
		infobox_func(player,getText(player,"Police20"),255,255,255)
		return
	end
	local tplayer = getPlayerFromName(target)
	if not isElement(tplayer) then
		infobox_func(player,getText(player,"Police12"),255,0,0)
		return
	end
	anzahl = tonumber(anzahl)
	if not anzahl or anzahl < 0 or anzahl > 6 or anzahl ~= math.floor(anzahl) then
		infobox_func(player,getText(player,"Police21"),255,0,0)
		return
	end
	setPlayerWantedLevel(tplayer,anzahl)
	setElementData(tplayer,"Wanteds",anzahl)
	infobox_func(player,getText(player,"Police22"):format(getPlayerName(tplayer),anzahl),0,255,0)
	outputChatBox(getText(tplayer,"Police23"):format(getPlayerName(player),anzahl,reason),tplayer,200,0,0)
end
addCommandHandler("su",WantedsGeben)

local tiefgarageGate = createObject(3055,-218.80000305176,1008.4000244141,20.89999961853,0,0,0)
local tiefgarageGateMove = false

function movePoliceGate(player)
	if getElementData(player,"loggedin") ~= 1 or not isCop(player) then return end
	local x,y,z = getElementPosition(player)
	if getElementInterior(player) ~= 0 or getElementDimension(player) ~= 0 then return end
	if getDistanceBetweenPoints3D(-218.80000305176,1008.4000244141,20.89999961853,x,y,z) > 15 then return end
	if tiefgarageGateMove then
		infobox_func(player,getText(player,"Police24"),255,0,0)
		return
	end
	tiefgarageGateMove = true
	moveObject(tiefgarageGate,2000,-218.80000305176,1008.4000244141,14.89999961853)
	setTimer(function()
		if not isElement(tiefgarageGate) then return end
		moveObject(tiefgarageGate,2000,-218.80000305176,1008.4000244141,20.89999961853)
		setTimer(function()
			tiefgarageGateMove = false
		end,2000,1)
	end,8000,1)
end
addCommandHandler("move",movePoliceGate)

local tiefgarageRaus = createMarker(-253.80000305176,1060.0999755859,-4.0999999046326,"cylinder",5,0,0,200)
local tiefgarageRein = createMarker(-218.80000305176,1002,18.799999237061,"cylinder",5,0,0,200)

addEventHandler("onMarkerHit",tiefgarageRein,function(player)
	if getElementType(player) ~= "player" then return end
	if getElementData(player,"loggedin") ~= 1 or not isCop(player) then return end
	triggerClientEvent(player,"ladeBalken",player)
	setTimer(function(target)
		if not isElement(target) then return end
		if isPedInVehicle(target) then
			local veh = getPedOccupiedVehicle(target)
			if not isElement(veh) then return end
			setElementPosition(veh,-253.80000305176,1048.8000488281,-3.4000000953674)
			setElementRotation(veh,0,0,180)
		else
			setElementPosition(target,-253.80000305176,1048.8000488281,-3.4000000953674)
			setPedRotation(target,180)
		end
	end,1500,1,player)
end)

addEventHandler("onMarkerHit",tiefgarageRaus,function(player)
	if getElementType(player) ~= "player" then return end
	if getElementData(player,"loggedin") ~= 1 or not isCop(player) then return end
	triggerClientEvent(player,"ladeBalken",player)
	setTimer(function(target)
		if not isElement(target) then return end
		if isPedInVehicle(target) then
			local veh = getPedOccupiedVehicle(target)
			if isElement(veh) then setElementPosition(veh,-217.75604248047,1013.1880493164,19.59450340271) end
		else
			setElementPosition(target,-217.75604248047,1013.1880493164,19.59450340271)
		end
	end,1500,1,player)
end)