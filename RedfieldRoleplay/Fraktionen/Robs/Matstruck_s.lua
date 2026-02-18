local matstransporterPickup = createPickup(-2615.6049804688,193.17247009277,4.4504776000977,3,1239,50)
local kostenProMaterial = 3
local aktivermatstransporter = false

function matstransporterPickupHit(player)
	if(isEvil(player))then
		getChatBox(player,106)
	end
end
addEventHandler('onPickupHit',matstransporterPickup,matstransporterPickupHit)

function matstransporterStarten(player,cmd,menge)
	if(isEvil(player))then
		if(getDistanceBetweenPoints3D(-2615.6049804688,193.17247009277,4.4504776000977,getElementPosition(player)) < 5)then
			if(menge)then
				if(aktivermatstransporter == false)then
					local menge = tonumber(menge)
					
					if(menge < 10001)then
						local price = menge*kostenProMaterial
						
						if(getPlayerMoney(player) >= price)then
							aktivermatstransporter = true
							setTimer(function()
								aktivermatstransporter = false
								if(isElement(matstransporter))then
									destroyElement(matstransporter)
								end
							end,3600000,1)
							
							local nachrichtChance = math.random(1,2)
						
							takePlayerMoney(player,price)
							getChatBox(player,107)
							setTimer(function()
								if(isGerman(player))then
									infobox_func(player,'Du erhälst '..math.random(menge/7)..' EXP für das Starten des Transporters.',0,255,0)
								elseif(isEnglish(player))then
									infobox_func(player,'You get '..math.random(menge/7)..' EXP for start a Transporter.',0,255,0)
								end
							end,2000,1)
							giveErfahrungspunkte(player,math.random(menge/7))
							
							matstruckVehicle = createVehicle(455,-2613.6000976563,186.19999694824,4.9000000953674,0,0,0)
							setElementData(matstruckVehicle,'mats',menge)
							warpPedIntoVehicle(player,matstruckVehicle)
							triggerClientEvent(player,'matstransporterMarker',player)
							setElementData(matstruckVehicle,'Benzin',100)
							setElementData(matstruckVehicle,'Besitzer','System')
							
							addEventHandler('onVehicleExit',matstruckVehicle,matstransporterExit)
							addEventHandler('onVehicleEnter',matstruckVehicle,matstransporterEnter)
							
							if(nachrichtChance == 2)then outputChatBox('Ein Matstransporter wurde beladen!',root,150,0,0)end
						else
							if(isGerman(player))then
								infobox_func('Du hast nicht genug Geld! Du brauchst '..price..'$',255,0,0)
							elseif(isEnglish(player))then
								infobox_func('You have not enough Money! You need '..price..'$',255,0,0)
							end
						end
					else
						getChatBox(player,108)
					end
				else
					getChatBox(player,109)
				end
			else
				getChatBox(player,110)
			end
		end
	end
end
addCommandHandler('matstransporter',matstransporterStarten)

function matstransporterExit(player)
	if(getPedOccupiedVehicleSeat(player) == 0)then
		triggerClientEvent(player,'destroymatstransporterMarker',player)
	end
end
function matstransporterEnter(player)
	if(getPedOccupiedVehicleSeat(player) == 0)then
		triggerClientEvent(player,'matstransporterMarker',player)
	end
end

function matstruckAbgabe(player)
	if(isPedInVehicle(player))then
		local veh = getPedOccupiedVehicle(player)
		
		if(veh == matstruckVehicle)then
			menge = getElementData(matstruckVehicle,'mats')
			triggerClientEvent(player,'destroymatstransporterMarker',player)
			destroyElement(matstruckVehicle)
			if(isGerman(player))then
				infobox_func(player,'Du erhälst '..menge..'Materialien.',0,255,0)
			elseif(isEnglish(player))then
				infobox_func(player,'You get '..menge..' mats.',0,255,0)
			end
			setElementData(player,'Mats',getElementData(player,'Mats')+menge)
			setElementData(player,'Matstransporter',getElementData(player,'Matstransporter')+1)
		end
	end
end
addEvent('matstruckAbgabe',true)
addEventHandler('matstruckAbgabe',root,matstruckAbgabe)