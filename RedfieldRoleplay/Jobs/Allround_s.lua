function giveJobMoney(geld,skillpunkte)
	setElementData(source,'Jobgehalt',getElementData(source,'Jobgehalt') + geld)
	if(getElementData(source,'Spielzeit') < 300)then
		if(isGerman(source))then
			infobox_func(source,'+ '..geld..'$\nDas Geld erhälst du erst beim Payday.',0,255,0)
		elseif(isEnglish(source))then
			infobox_func(source,'+ '..geld..'$\nYou get the money at your next payday.',0,255,0)
		end
	else
		infobox_func(source,'+ '..geld..'$',0,255,0)
	end
	
	if(getElementData(source,'Job') == 'Pilot')then
		giveErfahrungspunkte(source,10)
		if(getElementData(source,'Flugjobskills')<1000)then
			setElementData(source,'Flugjobskills',getElementData(source,'Flugjobskills')+skillpunkte)
		end
	elseif(getElementData(source,'Job') == 'Pizzalieferant')then
		giveErfahrungspunkte(source,10)
		if(getElementData(source,'Pizzajobskills')<600)then
			setElementData(source,'Pizzajobskills',getElementData(source,'Pizzajobskills')+skillpunkte)
		end
	elseif(getElementData(source,'Job') == 'Tankwart')then
		giveErfahrungspunkte(source,35)
		if(getElementData(source,'Tankwartjobskills')<400)then
			setElementData(source,'Tankwartjobskills',getElementData(source,'Tankwartjobskills')+skillpunkte)
		end
	end
end
addEvent('giveJobMoney',true)
addEventHandler('giveJobMoney',root,giveJobMoney)

function stopJob(player)
	if(getElementData(player,'PilotJobAktiv') == true)then
		local veh = getPedOccupiedVehicle(player)
		destroyElement(veh)
		triggerClientEvent(player,'stopPilotJob',player)
		setElementData(player,'PilotJobAktiv',nil)
		spawnPlayer(player,-1421.4528808594,-287.35494995117,14.1484375)
	elseif(getElementData(player,'inholzjob') == true)then
		setElementData(player,'inholzjob',false)
		triggerClientEvent(player,'destroyHolz',player)
	elseif(getElementData(player,'TankwartAktiv') == true)then
		--if(getDistanceBetweenPoints3D(639.02117919922,1683.3165283203,7.1875,getElementPosition(player)) < 20)then
			triggerClientEvent(player,'destroyTankShit',player)
			local veh = getPedOccupiedVehicle(player)
			local anhaenger = getVehicleTowedByVehicle(veh)
			destroyElement(anhaenger)
			destroyElement(veh)
			setElementPosition(player,639.02117919922,1683.3165283203,7.1875)
			setElementData(player,"TankwartAktiv",false)
		--else
		--	getChatBox(player,127)
		--end
	elseif(getElementData(player,"BusfahrerAktiv")==true)then
		--if(getDistanceBetweenPoints3D(12.60000038147,1225.5,19.299999237061,getElementPosition(player))<20)then
			local veh = getPedOccupiedVehicle(player)
			local anhaenger = getVehicleTowedByVehicle(veh)
			destroyElement(anhaenger)
			destroyElement(veh)
			setElementPosition(player,12.60000038147,1225.5,19.299999237061)
			setElementData(player,"BusfahrerAktiv",false)
		--else
		--	getChatBox(player,127)
		--end
	elseif(getElementData(player,"FarmerAktiv")==true)then
		triggerClientEvent(player,"destroyFarmerShit",player)
	end
end
addEvent('stopJob',true)
addEventHandler('stopJob',root,stopJob)
addCommandHandler('stopjob',stopJob)

function jobskills(player)
	local flugjobpoints = getElementData(player,'Flugjobskills')
	local pizzajobpoints = getElementData(player,'Pizzajobskills')
	local holzjobpoints = getElementData(player,'Holzjobskillpunkte')
	local tankwartpoints = getElementData(player,'Tankwartjobskills')
	outputChatBox('Pilotjob: '..flugjobpoints..'/1000')
	outputChatBox('Pizzajob: '..pizzajobpoints..'/600')
	if(isGerman(player))then
	outputChatBox('Holzfäller: '..holzjobpoints..'/400')
	outputChatBox('Tankwart: '..tankwartpoints..'/200')end
	if(isEnglish(player))then
	outputChatBox('Lumberjack: '..holzjobpoints..'/400')
	outputChatBox('Gas station attendant: '..tankwartpoints..'/200')end
end
addCommandHandler('jobskills',jobskills)