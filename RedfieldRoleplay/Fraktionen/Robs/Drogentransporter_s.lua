local drogentransporterPickup = createPickup(-1096.4838867188,-1627.3958740234,76.3671875,3,1239,50)
local kostenproGramm = 5
local aktiverDrogentransporter = false

function drogentransporterPickupHit(player)
	if(isEvil(player))then
		getChatBox(player,111)
	end
end
addEventHandler("onPickupHit",drogentransporterPickup,drogentransporterPickupHit)

function drogenTransporterStarten(player,cmd,menge)
	if(isEvil(player))then
		if(getDistanceBetweenPoints3D(-1096.4838867188,-1627.3958740234,76.3671875,getElementPosition(player)) < 5)then
			if(menge)then
				if(aktiverDrogentransporter == false)then
					local menge = tonumber(menge)
					
					if(menge<10001)then
						local price = menge*kostenproGramm
						
						if(getPlayerMoney(player) >= price)then
							aktiverDrogentransporter = true
							setTimer(function()
								aktiverDrogentransporter = false
								if(isElement(drogentransporter))then
									destroyElement(drogentransporter)
								end
							end,3600000,1)
							
							local nachrichtChance = math.random(1,2)
						
							takePlayerMoney(player,price)
							getChatBox(player,107)
							setTimer(function()
								if(isGerman(player))then
									infobox_func(player,"Du erhälst "..math.random(menge/7).." EXP für das Starten des Transporters.",0,255,0)
								elseif(isEnglish(player))then
									infobox_func(player,"You get "..math.random(menge/7).." EXP for start a Transporter.",0,255,0)
								end
							end,2000,1)
							giveErfahrungspunkte(player,math.random(menge/7))
							
							drogentruckVehicle = createVehicle(455,-1104,-1620.9000244141,76.900001525879,0,0,270)
							setElementData(drogentruckVehicle,"drogen",menge)
							warpPedIntoVehicle(player,drogentruckVehicle)
							triggerClientEvent(player,"drogentransporterMarker",player)
							setElementData(drogentruckVehicle,"Benzin",100)
							setElementData(drogentruckVehicle,"Besitzer","System")
							
							addEventHandler("onVehicleExit",drogentruckVehicle,drogentransporterExit)
							addEventHandler("onVehicleEnter",drogentruckVehicle,drogentransporterEnter)
							
							if(nachrichtChance == 2)then outputChatBox("Ein Drogentransporter wurde beladen!",root,150,0,0)end
						else
							if(isGerman(player))then
								infobox_func("Du hast nicht genug Geld! Du brauchst "..price.."$",255,0,0)
							elseif(isEnglish(player))then
								infobox_func("You have not enough Money! You need "..price.."$",255,0,0)
							end
						end
					else
						getChatBox(player,112)
					end
				else
					getChatBox(player,113)
				end
			else
				getChatBox(player,114)
			end
		end
	end
end
addCommandHandler("drogentransporter",drogenTransporterStarten)

function drogentransporterExit(player)
	if(getPedOccupiedVehicleSeat(player) == 0)then
		triggerClientEvent(player,"destroyDrogentransporterMarker",player)
	end
end
function drogentransporterEnter(player)
	if(getPedOccupiedVehicleSeat(player) == 0)then
		triggerClientEvent(player,"drogentransporterMarker",player)
	end
end

function drogentruckAbgabe(player)
	if(isPedInVehicle(player))then
		local veh = getPedOccupiedVehicle(player)
		
		if(veh == drogentruckVehicle)then
			menge = getElementData(drogentruckVehicle,"drogen")
			triggerClientEvent(player,"destroyDrogentransporterMarker",player)
			destroyElement(drogentruckVehicle)
			if(isGerman(player))then
				infobox_func(player,"Du erhälst "..menge.."g Drogen.",0,255,0)
			elseif(isEnglish(player))then
				infobox_func(player,"You get "..menge.." gram Weed.",0,255,0)
			end
			setElementData(player,"Drogen",getElementData(player,"Drogen")+menge)
			setElementData(player,"Drogentransporter",getElementData(player,"Drogentransporter")+1)
		end
	end
end
addEvent("drogentruckAbgabe",true)
addEventHandler("drogentruckAbgabe",root,drogentruckAbgabe)