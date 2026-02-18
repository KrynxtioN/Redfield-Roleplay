function StartTankwart(player)
	if(getElementData(player,'Job') == 'Tankwart')then
		if(getDistanceBetweenPoints3D(639.02117919922,1683.3165283203,7.1875,getElementPosition(player)) < 5)then
			local pname=getPlayerName(player)
			setElementData(player,'TankwartAktiv',true)
			_G["vehicle"..pname] = createVehicle(403,643.5,1692.5,7.6999998092651,0,0,40)
			_G["anhaenger"..pname] = createVehicle(584,649.7998046875,1685.2001953125,8.1999998092651,0,0,40)
			attachTrailerToVehicle(_G["vehicle"..pname],_G["anhaenger"..pname])
			setElementData(_G["vehicle"..pname],'Benzin',100)
			setElementData(_G["anhaenger"..pname],'Benzin',100)
			setElementData(_G["vehicle"..pname],'Besitzer','System')
			setElementData(_G["anhaenger"..pname],'Besitzer','System')
			warpPedIntoVehicle(player,_G["vehicle"..pname])
			addEventHandler('onVehicleStartExit',_G["vehicle"..pname],function()
				cancelEvent()
				getChatBox(player,129)
			end)
			_G["checkTrailer"..pname]=setTimer(function()
				if(getVehicleOccupant(_G["vehicle"..pname])==false)then
					destroyElement(_G["vehicle"..pname])
					destroyElement(_G["anhaenger"..pname])
					killTimer(_G["checkTrailer"..pname])
				end
			end,30000,0)
			triggerClientEvent(player,'createTankMarker',player)
		end
	end
end
addCommandHandler('tankjob',StartTankwart)

function AnhaengerCheckTankWart(player)
	local veh = getPedOccupiedVehicle(player)
	local anhaenger = getVehicleTowedByVehicle(veh)
	if(anhaenger)then
		if(getElementData(player,'Tankwartjobskills') < 100)then
			giveJobMoney(200,1)
		elseif(getElementData(player,'Tankwartjobskills') > 99 and getElementData(player,'Tankwartjobskills') < 200)then
			giveJobMoney(400,1)
		else
			giveJobMoney(600,0)
		end
		triggerClientEvent(player,'destroyTankShit',player)
		triggerClientEvent(player,'createTankMarker',player)
	else 
		getChatBox(player,128)
	end
end
addEvent('AnhaengerCheckTankWart',true)
addEventHandler('AnhaengerCheckTankWart',root,AnhaengerCheckTankWart)