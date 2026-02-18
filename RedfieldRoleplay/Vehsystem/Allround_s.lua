local carPrices={

[411]=55000,
[541]=45000,
[415]=30000,
[429]=27500,
[480]=40000,
[477]=130000,
[561]=17500,
[404]=5000,
[458]=22000,
[479]=11000,
[589]=13500,
[522]=26000,
[521]=9000,
[549]=1000,
[542]=1200,
[527]=4000,
[518]=5000,
[405]=4500,
[426]=6000,
[516]=3000,
[529]=4000,
[551]=7000,
[585]=8000,
[512]=180000,
[519]=250000,
[593]=150000,
[513]=125000,
[469]=40000,
[487]=80000,
[484]=200000,
[493]=100000,
[452]=80000,
[446]=120000,
[454]=250000,
[453]=70000,
[473]=30000,
[472]=50000,

}

function getCarData(name,slot,data)
	local sql = dbQuery(dbConnection,"SELECT * FROM cardata WHERE Besitzer = '"..name.."' AND Slot = '"..slot.."'")
	
	if(sql)then
		local rows = dbPoll(sql,-1)
		for k,cardata in pairs(rows)do
			return cardata[data]
		end
	end
end

function setCarData(name,slot,data,value)
	local sql = dbQuery(dbConnection,"UPDATE cardata SET "..data.." = "..value.." WHERE Besitzer = '"..name.."' AND Slot = '"..slot.."'")
	
	if(sql)then
		local rows = dbPoll(sql,-1)
		for k,cardata in pairs(rows)do
			return true
		end
	end
end

function vehicleEnter(player,seat)
	if(seat == 0)then
		bindKey(player,'x','down',motorAn,player)
		bindKey(player,'l','down',lichtAn,player)
	end
end
addEventHandler('onVehicleEnter',root,vehicleEnter)

function vehicleExit(player,seat)
	if(seat == 0)then
		unbindKey(player,'x','down',motorAn,player)
		unbindKey(player,'l','down',lichtAn,player)
	end
end
addEventHandler('onVehicleExit',root,vehicleExit)

function motorAn(player)
	if(isPedInVehicle(player))then
		if(getPedOccupiedVehicleSeat(player) == 0)then
			local veh = getPedOccupiedVehicle(player)
			
			if(getElementData(veh,'Benzin') > 0)then
				if(not(isElement(fahrzeugTimer)))then
					if(getVehicleEngineState(veh))then
						setVehicleEngineState(veh,false)
					else
						local motorStuerztAb = math.random(1,20)
						
						if(not(motorStuerztAb == 16))then
							fahrzeugTimer=setTimer(function()
								setVehicleEngineState(veh,true)
							end,1000,1)
						else
							getChatBox(player,55)
						end
					end
				end
			else
				getChatBox(player,56)
			end
		end
	end
end

function lichtAn(player)
	if(isPedInVehicle(player))then
		if(getPedOccupiedVehicleSeat(player) == 0)then
			local veh = getPedOccupiedVehicle(player)
			
			if(getVehicleOverrideLights(veh) ~= 2)then
				setVehicleOverrideLights(veh,2)
			else
				setVehicleOverrideLights(veh,1)
			end
		end
	end
end

function respawnVeh(player,cmd,slot)
	local besitzer=getPlayerName(player)
	
	if(slot)then
		if(_G['vehicle'..getPlayerName(player)..slot])then
			if(isElement(_G['vehicle'..getPlayerName(player)..slot]))then
				destroyElement(_G['vehicle'..getPlayerName(player)..slot])
			end
			local x,y,z = getCarData(besitzer,slot,'X'),getCarData(besitzer,slot,'Y'),getCarData(besitzer,slot,'Z')
			local rotation = getCarData(besitzer,slot,'Rotation')
			local id = getCarData(besitzer,slot,'Autoid')
			_G['vehicle'..getPlayerName(player)..slot]=createVehicle(id,x,y,z,0,0,rotation,besitzer)
			setElementData(_G['vehicle'..getPlayerName(player)..slot],'Besitzer',besitzer)
			setElementData(_G['vehicle'..getPlayerName(player)..slot],'Slot',slot)
			setVehicleEngineState(_G['vehicle'..getPlayerName(player)..slot],false)
			setVehicleLocked(_G['vehicle'..getPlayerName(player)..slot],true)
			
			getChatBox(player,57)
		else
			getChatBox(player,58)
		end
	else
		getChatBox(player,59)
	end
end
addCommandHandler('respawnen',respawnVeh)

function lockVehicle(player,cmd,slot)
	if(slot)then
		if(_G['vehicle'..getPlayerName(player)..slot])then
			local x,y,z = getElementPosition(_G['vehicle'..getPlayerName(player)..slot])
			if(getDistanceBetweenPoints3D(x,y,z,getElementPosition(player))<20)then
				local lock = isVehicleLocked(_G['vehicle'..getPlayerName(player)..slot])
				if(lock == false)then
					getChatBox(player,61)
					setVehicleLocked(_G['vehicle'..getPlayerName(player)..slot],true)
				else
					getChatBox(player,62)
					setVehicleLocked(_G['vehicle'..getPlayerName(player)..slot],false)
				end
			else
				getChatBox(player,60)
			end
		else
			getChatBox(player,58)
		end
	else
		getChatBox(player,59)
	end
end
addCommandHandler('lock',lockVehicle)

function sellVehicle(player,cmd,slot)
	local besitzer = getPlayerName(player)
	
	if(slot)then
		if(_G['vehicle'..getPlayerName(player)..slot])then
			local id = getCarData(besitzer,slot,'Autoid')
			local price = carPrices[id]
			destroyElement(_G['vehicle'..getPlayerName(player)..slot])
			givePlayerMoney(player,price/100*50)
			if(isGerman(player))then
				infobox_func(player,'Du hast dein Fahrzeug verkauft und 50% des Kaufpreises wiederbekommen. ('..price/100*50 ..'$)',255,255,255)
			end
			if(isEnglish(player))then
				infobox_func(player,'You sold your Vehicle. You get back 50% of the purchase price. ('..price/100*50 ..'$)',255,255,255)
			end
			dbExec(dbConnection,"DELETE FROM `cardata` WHERE `Besitzer` = '"..getPlayerName(player).."' AND `Slot` = '"..slot.."'")
		else
			getChatBox(player,58)
		end
	else
		getChatBox(player,59)
	end
end
addCommandHandler('sellcar',sellVehicle)

function parkVehicle(player)
	local veh = getPedOccupiedVehicle(player)
	if(veh)then
		local besitzer = getElementData(veh,'Besitzer')
		local slot = getElementData(veh,'Slot')
		if(besitzer and slot)then
			if(besitzer == getPlayerName(player))then
				local x,y,z = getElementPosition(veh)
				local rx,ry,rz = getElementRotation(veh)
				setCarData(besitzer,slot,'X',x)
				setCarData(besitzer,slot,'Y',y)
				setCarData(besitzer,slot,'Z',z)
				setCarData(besitzer,slot,'Rotation',rz)
				getChatBox(player,63)
			else
				getChatBox(player,64)
			end
		end
	end
end
addCommandHandler('park',parkVehicle)

function CheckBenzin()
	local players = getElementsByType('player')

	for theKey,thePlayer in ipairs(players)do
		if(isPedInVehicle(thePlayer))then
			local veh = getPedOccupiedVehicle(thePlayer)
			local Besitzer = getElementData(veh,'Besitzer')
			local Benzin = getElementData(veh,'Benzin')
			local NewBenzin = Benzin-1
			local Slot = getElementData(veh,'Slot')
			
			if(veh)then
				if(getVehicleEngineState(veh))then
					if(Benzin > 0)then
						if(Besitzer)then
							if(Besitzer == 'Police' or Besitzer == 'Reporter' or Besitzer == 'System' or Besitzer == 'Yakuza' or Besitzer == 'Biker' or Besitzer == 'Ballas' or Besitzer == 'Surenos')then
								setElementData(veh,'Benzin',NewBenzin)
							else
								setCarData(Besitzer,Slot,'Benzin',NewBenzin)
								setElementData(veh,'Benzin',NewBenzin)
							end
						end
					end
				end
			end
		end
	end
end
setTimer(CheckBenzin,30000,0)

function clickVehicle(button,state,player)
	if(button == 'left' and state == 'down')then
		if(getElementType(source) == 'vehicle')then
			if(getElementData(player,'redfieldClick') == false)then
				local x,y,z = getElementPosition(player)
				local x1,y1,z1 = getElementPosition(source)
				
				if(getDistanceBetweenPoints3D(x1,y1,z1,x,y,z) < 10)then
					local Besitzer = getElementData(source,'Besitzer')
					local Benzin = getElementData(source,'Benzin')
					
					if(not(Besitzer))then
						Besitzer = 'Keine Angabe'
					end
					if(not(Benzin))then 
						enzin = 'Keine Angabe'
					end
					
					if(isGerman(player))then
						outputChatBox('Dieses Fahrzeug gehört: '..Besitzer,player,200,100,0)
						outputChatBox('Tank: '..Benzin..' Liter',player,200,100,0)
					elseif(isEnglish(player))then
						outputChatBox('The owner of this Vehicle is: '..Besitzer,player,200,100,0)
						outputChatBox('Gas: '..Benzin..' Liter',player,200,100,0)
					end
				end
			end
		end
	end
end
addEventHandler('onElementClicked',root,clickVehicle)