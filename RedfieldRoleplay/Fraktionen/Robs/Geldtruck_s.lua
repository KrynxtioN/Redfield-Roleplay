local geldtruck_aktiv = false
local geldtruck_cash = 10000
local geld_gate = false
local geldtruck_refresh = 1800000

local geldtruck_gate = createObject(3055,2740.6000976563,-2004.5999755859,13.60000038147,0,90,0)
local geldtruck_marker = createMarker(2741,-2002.9000244141,12.60000038147,'cylinder',3,0,0,0)
setElementAlpha(geldtruck_marker,0)

addEventHandler('onMarkerHit',geldtruck_marker,function(player)
	if(isCop(player))then
		if(geld_gate == false)then
			geld_gate = true
			moveObject(geldtruck_gate,5000,2740.6000976563,-2004.5999755859,8.1000003814697)
		end
	end
end)

function vehicle_geldtruck_create()
	if(isElement(geldtruck_vehicle))then
		destroyElement(geldtruck_vehicle)
	end
	if(isElement(marker))then
		destroyElement(marker)
	end

	geldtruck_vehicle = createVehicle(428,2741.1000976563,-2008.4000244141,13.800000190735,0,0,0)
	setVehicleColor(geldtruck_vehicle,0,0,0)
	marker=createMarker(0,0,0,'arrow',0.6,200,0,0)
    attachElements(marker,geldtruck_vehicle,0,0,2.3)
	setElementData(geldtruck_vehicle,'Benzin',100)
	setElementData(geldtruck_vehicle,'Besitzer','System')
	
	addEventHandler('onVehicleExplode',geldtruck_vehicle,function()
		destroyElement(geldtruck_vehicle)
		destroyElement(marker)
	end)
	
	addEventHandler('onVehicleStartExit',geldtruck_vehicle,function(player)
		if(getPedOccupiedVehicleSeat(player) == 0)then
			triggerClientEvent(player,'destroyGeldtruckShit',player)
		end
	end)
	
	addEventHandler('onVehicleStartEnter',geldtruck_vehicle,function(player)
		if(getPedOccupiedVehicleSeat(player) == 0)then
			if(not(isCop(player)))and(not(getElementData(player,'copDuty') == true))then
				cancelEvent()
				getChatBix(player,84)
			else
				triggerClientEvent(player,'createGeldtruckSachen',player)
				
				if(not(isTimer(refreshGTTimer)))then
					outputChatBox('Ein Geldtransporter ist auf dem Weg nach Fort Carson!',root,150,0,0)
					refreshGTTimer=setTimer(function()
						geldtruck_aktiv = false
						if(geldtruck_gate == true)then
							geldtruck_gate = false
							moveObject(geldtruck_gate,5000,2740.6000976563,-2004.5999755859,13.60000038147)
							vehicle_geldtruck_create()
							if(isElement(geldtruck_vehicle))then
								destroyElement(geldtruck_vehicle)
							end
						end
					end,geldtruck_refresh,1)
				end
			end
		end
	end)
end
vehicle_geldtruck_create()

function geldtruckMoney(player)
	if(isPedInVehicle(player))then
		local veh = getPedOccupiedVehicle(player)
		if(veh == geldtruck_vehicle)then
			givePlayerMoney(player,geldtruck_cash)
			triggerClientEvent(player,'destroyGeldtruckShit',player)
			destroyElement(geldtruck_vehicle)
			destroyElement(marker)
			setElementData(player,"Geldtransporter",getElementData(player,"Geldtransporter")+1)
		end
	end
end
addEvent('geldtruckMoney',true)
addEventHandler('geldtruckMoney',root,geldtruckMoney)