function givePlayerLicense(lizenz)
	if(lizenz == 'Motorradschein')then
		if(getElementData(source,'Motorradschein') == 0)then
			if(getPlayerMoney(source) >= 3000)then
				takePlayerMoney(source,3000)
				getChatBox(source,46)
				giveErfahrungspunkte(source,80)
				updateEventkasse("einezahlen",3000)
				setElementData(source,'Motorradschein',1)
			else
				getChatBox(source,33)
			end
		else
			getChatBox(source,47)
		end
	elseif(lizenz == 'Lkwschein')then
		if(getElementData(source,'Lkwschein') == 0)then
			if(getPlayerMoney(source) >= 8000)then
				takePlayerMoney(source,8000)
				getChatBox(source,46)
				giveErfahrungspunkte(source,140)
				updateEventkasse("einezahlen",8000)
				setElementData(source,'Lkwschein',1)
			else
				getChatBox(source,33)
			end
		else
			getChatBox(source,47)
		end
	elseif(lizenz == 'Helikopterschein')then
		if(getElementData(source,'Helikopterschein') == 0)then
			if(getPlayerMoney(source) >= 20000)then
				takePlayerMoney(source,20000)
				getChatBox(source,46)
				giveErfahrungspunkte(source,250)
				updateEventkasse("einezahlen",20000)
				setElementData(source,'Helikopterschein',1)
			else
				getChatBox(source,33)
			end
		else
			getChatBox(source,47)
		end
	elseif(lizenz == 'Flugschein')then
		if(getElementData(source,'Flugschein') == 0)then
			if(getPlayerMoney(source) >= 40000)then
				takePlayerMoney(source,40000)
				getChatBox(source,46)
				giveErfahrungspunkte(source,400)
				updateEventkasse("einezahlen",40000)
				setElementData(source,'Flugschein',1)
			else
				getChatBox(source,33)
			end
		else
			getChatBox(source,47)
		end
	elseif(lizenz == 'Bootschein')then
		if(getElementData(source,'Bootschein') == 0)then
			if(getPlayerMoney(source) >= 9000)then
				takePlayerMoney(source,9000)
				getChatBox(source,46)
				giveErfahrungspunkte(source,160)
				updateEventkasse("einezahlen",9000)
				setElementData(source,'Bootschein',1)
			else
				getChatBox(source,33)
			end
		else
			getChatBox(source,47)
		end
	elseif(lizenz == 'Personalausweis')then
		if(getElementData(source,'Personalausweis') == 0)then
			if(getPlayerMoney(source) >= 50)then
				takePlayerMoney(source,50)
				getChatBox(source,46)
				giveErfahrungspunkte(source,20)
				updateEventkasse("einezahlen",50)
				setElementData(source,'Personalausweis',1)
			else
				getChatBox(source,33)
			end
		else
			getChatBox(source,47)
		end
	elseif(lizenz == 'Arbeitsgenehmigung')then
		if(getElementData(source,'Arbeitsgenehmigung') == 0)then
			if(getPlayerMoney(source) >= 50)then
				takePlayerMoney(source,50)
				getChatBox(source,46)
				giveErfahrungspunkte(source,20)
				updateEventkasse("einezahlen",50)
				setElementData(source,'Arbeitsgenehmigung',1)
			else
				getChatBox(source,33)
			end
		else
			getChatBox(source,47)
		end
	end
end
addEvent('givePlayerLicense',true)
addEventHandler('givePlayerLicense',root,givePlayerLicense)

function startPraxisCarlicense(player)
	if(getElementData(player,'Autoschein') == 0)then
		if(getPlayerMoney(player) >= 1400)then
			takePlayerMoney(player,1400)
			updateEventkasse("einezahlen",1400)
			triggerClientEvent(player,'clientPraxisCarlicense',player)
			vehicle=createVehicle(405,-220.19999694824,1094.8000488281,19.60000038147,0,0,270)
			warpPedIntoVehicle(player,vehicle)
			setElementData(vehicle,'Benzin',100)
			setElementData(vehicle,'Besitzer','System')
			setElementInterior(player,0)
			setElementDimension(player,0)
			getChatBox(player,50)
			
			addEventHandler('onVehicleStartExit',vehicle,function()
				cancelEvent()
				getChatBox(source,48)
			end)
		else
			getChatBox(source,33)
		end
	else
		getChatBox(source,47)
	end
end
addEvent('startPraxisCarlicense',true)
addEventHandler('startPraxisCarlicense',root,startPraxisCarlicense)

function giveCarlicense(player)
	local veh = getPedOccupiedVehicle(player)
	destroyElement(veh)
	getChatBox(player,49)
	giveErfahrungspunkte(player,300)
	setElementData(player,'Autoschein',1)
	if(getElementData(player,'AchCarlicense') == 0)then
		setElementData(player,'AchCarlicense',1)
		achievmentInfo(player)
	end
end
addEvent('giveCarlicense',true)
addEventHandler('giveCarlicense',root,giveCarlicense)