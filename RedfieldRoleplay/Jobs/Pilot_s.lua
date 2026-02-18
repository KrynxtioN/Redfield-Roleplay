function pilotJobStarten(player,cmd,mission)
	if(getDistanceBetweenPoints3D(-1421.4528808594,-287.35494995117,14.1484375,getElementPosition(player)) < 5)then
		if(getElementData(player,'Job') == 'Pilot')then
			local flugjobSkills = getElementData(player,'Flugjobskills')
			
			if(mission)then
				if(mission=="1")then
					if(flugjobSkills>=0)then
						getChatBox(player,141)
						vehicle = createVehicle(574,-1468.3977050781,-211.59780883789,14.118999481201,0,0,346)
						setElementData(vehicle,'Benzin',100)
						setElementData(vehicle,'Besitzer','System')
						warpPedIntoVehicle(player,vehicle)
						addEventHandler('onVehicleStartExit',vehicle,function()
							cancelEvent()
							getChatBox(player,140)
						end)
						triggerClientEvent(player,'flugplatzsaubermachen_func',player)
					end
				elseif(mission=="2")then
					if(flugjobSkills>=200)then
						getChatBox(player,142)
						vehicle = createVehicle(583,-1667.400390625,-161.7001953125,13.10000038147,0,0,315)
						setElementData(vehicle,'Benzin',100)
						setElementData(vehicle,'Besitzer','System')
						warpPedIntoVehicle(player,vehicle)
						addEventHandler('onVehicleStartExit',vehicle,function()
							cancelEvent()
							getChatBox(player,140)
						end)
						triggerClientEvent(player,'landebahnvorbereiten_func',player)
					else
						getChatBox(player,137)
					end
				elseif(mission=="3")then
					if(flugjobSkills>=400)then
						getChatBox(player,143)
						vehicle = createVehicle(583,-1667.400390625,-161.7001953125,13.10000038147,0,0,315)
						setElementData(vehicle,'Benzin',100)
						setElementData(vehicle,'Besitzer','System')
						warpPedIntoVehicle(player,vehicle)
						addEventHandler('onVehicleStartExit',vehicle,function()
							cancelEvent()
							getChatBox(player,140)
						end)
						triggerClientEvent(player,'flugbahnkontrollieren_func',player)
					else
						getChatBox(player,137)
					end
				elseif(mission=="4")then
					if(flugjobSkills>=600)then	
						getChatBox(player,144)
						vehicle = createVehicle(512,-1573.5,-91.800003051758,14.89999961853,0,0,0)
						setElementData(vehicle,'Benzin',100)
						setElementData(vehicle,'Besitzer','System')
						warpPedIntoVehicle(player,vehicle)
						addEventHandler('onVehicleStartExit',vehicle,function()
							cancelEvent()
							getChatBox(player,140)
						end)
						triggerClientEvent(player,'duengerspruehen_func',player)
					else
						getChatBox(player,137)
					end
				elseif(mission=="5")then
					if(flugjobSkills>=800)then
						getChatBox(player,145)
						vehicle = createVehicle(577,-1633,-140.39999389648,13.10000038147,0,0,316)
						setElementData(vehicle,'Benzin',100)
						setElementData(vehicle,'Besitzer','System')
						warpPedIntoVehicle(player,vehicle)
						addEventHandler('onVehicleStartExit',vehicle,function()
							cancelEvent()
							getChatBox(player,140)
						end)
						triggerClientEvent(player,'flughafenmarker_func',player)
					else
						getChatBox(player,137)
					end
				end
				setElementData(player,'PilotJobAktiv',true)
			end
		end
	end
end
addCommandHandler('flugjob',pilotJobStarten)