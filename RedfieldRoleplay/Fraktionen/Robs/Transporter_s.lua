local copstealcardo=false

function createStealPDVehicle()
	if(isElement(copstealblip))then
		destroyElement(copstealblip)
	end
	if(isElement(copstealtruck))then
		destroyElement(copstealtruck)
	end
	if(isElement(copstealcar))then
		destroyElement(copstealcar)
	end
	copstealcardo=false
	
	outputChatBox('Ein Fahrzeug kann gestohlen werden!',root,150,0,0)

	copstealtruck=createVehicle(578,63.400001525879,1159.6999511719,19.39999961853,0,0,0)
	copstealcar=createVehicle(598,1702,681,10.699999809265,0,0,0)
	setElementFrozen(copstealcar,true)
	setVehicleDamageProof(copstealcar,true)
	setElementData(copstealcar,'Benzin',0)
	setElementData(copstealcar,'Besitzer','Police')
	setElementData(copstealtruck,'Benzin',100)
	setElementData(copstealtruck,'Besitzer','System')
	copstealblip=createBlip(63.400001525879,1159.6999511719,19.39999961853,0,2,0,0,255,255,0,200,root)
	
	addEventHandler('onElementClicked',copstealcar,function(button,state,player)
		if(state=='down')then
			if(copstealcardo == false)then
				if(getDistanceBetweenPoints3D(1702,681,10.699999809265,getElementPosition(player)) < 10)then
					if(isPedInVehicle(player))then
						local veh = getPedOccupiedVehicle(player)
						if(veh == copstealtruck)then
							copstealcardo=true
							attachElements(copstealcar,copstealtruck,0,-1,0.5)
							triggerClientEvent(player,'destroyTransporterFirstMarker',player)
							triggerClientEvent(player,'transporterSecondMarker',player)
							getChatBox(player,90)
						end
					end
				end
			end
		end
	end)
	
	addEventHandler('onVehicleEnter',copstealtruck,function(player)
		if(getPedOccupiedVehicleSeat(player) == 0)then
			if(copstealcardo == false)then
				if(isElement(copstealblip))then
					destroyElement(copstealblip)
				end
				triggerClientEvent(player,'transporterFirstMarker',player)
			else
				triggerClientEvent(player,'transporterSecondMarker',player)
			end
		end
	end)
	addEventHandler('onVehicleExit',copstealtruck,function(player)
		triggerClientEvent(player,'destroyTransporterFirstMarker',player)
		triggerClientEvent(player,'destroyTransporterSecondMarker',player)
	end)
	
	setTimer(createStealPDVehicle,4000000,1)
end
setTimer(createStealPDVehicle,3600000,1)

addEvent('finisCopTransporter',true)
addEventHandler('finisCopTransporter',root,function(player)
	local money = math.random(12000,16000)
	if(isGerman(player))then
		outputChatBox('Denny am Handy: Gut gemacht, Bro! Ich überweise dir '..money..'$.',player,255,255,255)
	elseif(isEnglish(player))then
		outputChatBox('Denny on mobile: Well done, Bro! I will transfer you '..money..'$.',player,255,255,255)
	end
	setElementData(player,'Bankmoney',getElementData(player,'Bankmoney')+money)
	triggerClientEvent(player,'destroyTransporterSecondMarker',player)
	if(isElement(copstealcar))then
		destroyElement(copstealcar)
	end
	if(isElement(copstealtruck))then
		destroyElement(copstealtruck)
	end
end)