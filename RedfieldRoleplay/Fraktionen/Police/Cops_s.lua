local dutypickup = createPickup(256.93380737305,70.434516906738,1003.640625,3,1239,50)
setElementInterior(dutypickup,6)

function dutypickuphit(player)
	if(isCop(player))then
		getChatBox(player,115)
	end
end
addEventHandler('onPickupHit',dutypickup,dutypickuphit)

function dutycops(player,cmd,duty)
	if(getElementData(player,'loggedin') == 1)then
		if(isCop(player))then
			if(getDistanceBetweenPoints3D(256.93380737305,70.434516906738,1003.640625,getElementPosition(player)) < 5)then
				if(duty)then
					if(getElementData(player,'copDuty') == false)then
						if(duty == 'normal')then
							changeSkin(player)
							if(getElementData(player,'Rang') == 0)then
								giveWeapon(player,3,1,true)
								giveWeapon(player,24,30,true)
							else
								giveWeapon(player,3,1,true)
								giveWeapon(player,24,30,true)
								giveWeapon(player,29,300,true)
								giveWeapon(player,31,300,true)
							end
						elseif(duty == 'swat')then
							setElementModel(player,285)
							giveWeapon(player,24,30,true)
							giveWeapon(player,29,300,true)
							giveWeapon(player,31,300,true)
							giveWeapon(player,34,25,true)
						--[[ elseif(duty =  = 'blut')then
							setElementModel(player,295) ]]--
						end
						setElementData(player,'copDuty',true)
						bindKey(player,'f4','down',copVehicleCams)
						getChatBox(player,116)
					else
						getChatBox(player,117)
					end
				else
					getChatBox(player,118)
				end
			end
		end
	end
end
addCommandHandler('duty',dutycops)

function copVehicleCams(player)
	if(isPedInVehicle(player))then
		local veh = getPedOccupiedVehicle(player)
		if(getElementData(veh,'copVehicleYo') == true)then
			triggerClientEvent(player,'bindKeysForPC',player)
		end
	end
end

function offdutycops(player)
	if(getElementData(player,'loggedin') == 1)then
		if(isCop(player))then
			if(getDistanceBetweenPoints3D(256.93380737305,70.434516906738,1003.640625,getElementPosition(player)) < 5)or(getDistanceBetweenPoints3D(258.8518371582,109.27908325195,1003.21875,getElementPosition(player)) < 5)then
				if(getElementData(player,'copDuty') == true)then
					setElementData(player,'copDuty',false)
					getChatBox(player,119)
					unbindKey(player,'f4','down',copVehicleCams)
				else 
					getChatBox(player,120)
				end
			end
		end
	end
end
addCommandHandler('offduty',offdutycops)

local copVehicle = {
[1]=createVehicle(497,-215.19999694824,992.5,30.799999237061,0,0,90),
[2]=createVehicle(497,-215.2001953125,977.900390625,30.799999237061,0,0,90),
[3]=createVehicle(598,-227.80000305176,1048.5,-3.5999999046326,0,0,180),
[4]=createVehicle(598,-223.89999389648,1048.5,-3.5999999046326,0,0,180),
[5]=createVehicle(598,-219.89999389648,1048.5,-3.5999999046326,0,0,180),
[6]=createVehicle(598,-215.89999389648,1048.5,-3.5999999046326,0,0,180),
[7]=createVehicle(598,-211.89999389648,1048.5,-3.5999999046326,0,0,180),
[8]=createVehicle(598,-207.89999389648,1048.5,-3.5999999046326,0,0,180),
[9]=createVehicle(598,-203.89999389648,1048.5,-3.5999999046326,0,0,180),
[10]=createVehicle(598,-199.89999389648,1048.5,-3.5999999046326,0,0,180),
[11]=createVehicle(598,-195.89999389648,1048.5,-3.5999999046326,0,0,180),
[12]=createVehicle(598,-191.89999389648,1048.5,-3.5999999046326,0,0,180),
[13]=createVehicle(598,-187.89999389648,1048.5,-3.5999999046326,0,0,180),
[14]=createVehicle(598,-183.89999389648,1048.5,-3.5999999046326,0,0,180),
[15]=createVehicle(598,-179.89999389648,1048.5,-3.5999999046326,0,0,180),
[16]=createVehicle(598,-175.89999389648,1048.5,-3.5999999046326,0,0,180),
[17]=createVehicle(427,-177.19999694824,1017.9000244141,-3.2000000476837,0,0,90),
[18]=createVehicle(427,-177.19999694824,1012.9000244141,-3.2000000476837,0,0,90),
[19]=createVehicle(427,-177.19999694824,1007.9000244141,-3.2000000476837,0,0,90),
[20]=createVehicle(523,-222.60000610352,1034.0999755859,-3.7999999523163,0,0,0),
[21]=createVehicle(523,-225.60000610352,1034.0999755859,-3.7999999523163,0,0,0),
[22]=createVehicle(523,-228.60000610352,1034.0999755859,-3.7999999523163,0,0,0),
[23]=createVehicle(523,-231.60000610352,1034.0999755859,-3.7999999523163,0,0,0),
[24]=createVehicle(523,-234.60000610352,1034.0999755859,-3.7999999523163,0,0,0),
[25]=createVehicle(523,-237.60000610352,1034.0999755859,-3.7999999523163,0,0,0),
}

for i = 1,#copVehicle do
	setElementFrozen(copVehicle[i],true)
	setVehiclePlateText(copVehicle[i],'Police')
	setElementData(copVehicle[i],'Benzin',100)
	setElementData(copVehicle[i],'Besitzer','Police')
	setElementData(copVehicle[i],'copVehicleYo',true)
	
	addEventHandler('onVehicleStartEnter',copVehicle[i],function(player)
		if(getPedOccupiedVehicleSeat(player) == 0)then
			if(not(isCop(player) and getElementData(player,'copDuty') == true))then
				cancelEvent()
				getChatBox(player,84)
			else
				setElementFrozen(copVehicle[i],false)
			end
		else
			if(getElementData(player,'wantedCard') == true)then
				if(getPlayerWantedLevel(player) > 0)then
					getChatBox(player,121)
					toggleAllControls(player,false)
					setTimer(function()
						toggleAllControls(player,true)
						setElementData(player,'wantedCard',false)
						setPlayerWantedLevel(player,0)
						getChatBox(player,122)
					end,13000,1)
				end
			end
		end
	end)
end

local einknastenMarker = createMarker(-216.42816162109,972.83435058594,18.324136734009,'cylinder',3,255,255,0)
setElementAlpha(einknastenMarker,75)

function einknastenMarkerHit(player)
	if(isCop(player) and getElementData(player,'copDuty') == true)then
		if(isPedInVehicle(player))then
			getChatBox(player,123)
		end
	end
end
addEventHandler('onMarkerHit',einknastenMarker,einknastenMarkerHit)

function einknastenFunc(player,cmd,target)
	if(getElementData(player,'loggedin') == 1)then
		if(isCop(player) and getElementData(player,'copDuty') == true)then
			if(target)then
				local tplayer = getPlayerFromName(target)
				
				if(getDistanceBetweenPoints3D(-216.42816162109,972.83435058594,18.324136734009,getElementPosition(player)) < 5)then
					local x,y,z = getElementPosition(player)
					local x1,y1,z1 = getElementPosition(tplayer)
					if(getDistanceBetweenPoints3D(x1,y1,z1,x,y,z) < 5)then
						if(getPlayerWantedLevel(tplayer)>0)then
							local wntds = getPlayerWantedLevel(tplayer)
							local wntdstime = wntds*4
							giveErfahrungspunkte(player,50)
							setElementData(tplayer,'Knastzeit',wntdstime)
							if(isGerman(player))then
								infobox_func(player,getPlayerName(tplayer)..' wurde eingesperrt.',0,255,0)
							elseif(isEnglish(player))then
								infobox_func(player,'You arrested '..getPlayerName(tplayer)..'.',0,255,0)
							end
							if(isGerman(tplayer))then
								infobox_func(tplayer,getPlayerName(player)..' hat dich für '..wntdstime..' Minuten eingesperrt.',0,255,0)
							elseif(isEnglish(tplayer))then
								infobox_func(tplayer,getPlayerName(player)..' arrested you for '..wntdstime..' minutes.',0,255,0)
							end
							outputChatBox(getPlayerName(tplayer)..' wurde von '..getPlayerName(player)..' eingesperrt!',root,120,120,120)
							inDenKnast(tplayer)
						else
							getChatBox(player,124)
						end
					else
						getChatBox(player,125)
					end
				end
			else
				getChatBox(player,10)		
			end
		end
	end
end
addCommandHandler('arrest',einknastenFunc)

function WantedsGeben(player,cmd,target,reason,anzahl)
	if(isCop(player) and getElementData(player,'copDuty') == true)then
		if(target and reason and anzahl)then
			local tplayer = getPlayerFromName(target)
			
			setPlayerWantedLevel(tplayer,anzahl)
			setElementData(tplayer,'Wanteds',getPlayerWantedLevel(tplayer))
			
			if(isGerman(player))then
				infobox_func(player,'Du hast das Wantedlevel von '..getPlayerName(tplayer)..' auf '..anzahl..' gesetzt.',0,255,0)
			elseif(isEnglish(player))then
				infobox_func(player,'You set the Wanted-Level of '..getPlayerName(tplayer)..' on '..anzahl..'.',0,255,0)
			end
			
			if(isGerman(tplayer))then
				outputChatBox(getPlayerName(player)..' hat dein Wantedlevel auf '..anzahl..' gesetzt! Grund: '..reason,tplayer,200,0,0)
			elseif(isEnglish(tplayer))then
				outputChatBox(getPlayerName(player)..' has set your Wanteds on '..anzahl..'!',tplayer,200,0,0)
			end
		else
			getChatBox(player,126)
		end
	end
end
addCommandHandler('su',WantedsGeben)

local tiefgarageGate=createObject(3055,-218.80000305176,1008.4000244141,20.89999961853,0,0,0)
local tiefgarageGateMove=false

addCommandHandler("move",function(player)
	if(isCop(player))then
		if(tiefgarageGateMove==false)then
			tiefgarageGateMove=true
			moveObject(tiefgarageGate,2000,-218.80000305176,1008.4000244141,14.89999961853)
			setTimer(function()
				moveObject(tiefgarageGate,2000,-218.80000305176,1008.4000244141,20.89999961853)
				tiefgarageGateMove=false
			end,8000,1)
		end
	end
end)

local tiefgarageRaus=createMarker(-253.80000305176,1060.0999755859,-4.0999999046326,"cylinder",5,0,0,200)
local tiefgarageRein=createMarker(-218.80000305176,1002,18.799999237061,"cylinder",5,0,0,200)

addEventHandler("onMarkerHit",tiefgarageRein,function(player)
	if(isCop(player))then
		triggerClientEvent(player,"ladeBalken",player)
		setTimer(function()
			if(isPedInVehicle(player))then
				veh=getPedOccupiedVehicle(player)
				setElementPosition(veh,-253.80000305176,1048.8000488281,-3.4000000953674)
				setElementRotation(veh,180)
			else
				setElementPosition(player,-253.80000305176,1048.8000488281,-3.4000000953674)
				setPedRotation(player,180)
			end
		end,1500,1)
	end
end)

addEventHandler("onMarkerHit",tiefgarageRaus,function(player)
	if(isCop(player))then
		triggerClientEvent(player,"ladeBalken",player)
		setTimer(function()
			if(isPedInVehicle(player))then
				veh=getPedOccupiedVehicle(player)
				setElementPosition(veh,-217.75604248047,1013.1880493164,19.59450340271)
			else
				setElementPosition(player,-217.75604248047,1013.1880493164,19.59450340271)
			end
		end,1500,1)
	end
end)