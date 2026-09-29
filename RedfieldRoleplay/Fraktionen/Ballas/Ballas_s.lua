local ballasCars = {
	[1] = createVehicle(475,2450.1000976563,-2022.4000244141,13.39999961853,0,0,0),
	[2] = createVehicle(475,2530.6999511719,-2014.9000244141,13.39999961853,0,0,45),
	[3] = createVehicle(567,2478.1000976563,-2004.4000244141,13.5,0,0,90),
	[4] = createVehicle(567,2471.1000976563,-2004.4000244141,13.5,0,0,90),
	[5] = createVehicle(482,2494.1999511719,-1996.9000244141,13.800000190735,0,0,180),
	[6] = createVehicle(482,2494.1999511719,-1990.5999755859,13.699999809265,0,0,180),
	[7] = createVehicle(482,2499.1000976563,-2022.3000488281,13.800000190735,0,0,0),
	[8] = createVehicle(482,2499.1005859375,-2028.7998046875,13.800000190735,0,0,0)
}

for i = 1,#ballasCars do
	local vehicle = ballasCars[i]
	setElementData(vehicle,"Benzin",100)
	setElementData(vehicle,"Besitzer","Ballas")
	setVehiclePlateText(vehicle,"Ballas")
	setVehicleColor(vehicle,255,0,200)
	setElementFrozen(vehicle,true)
	addEventHandler("onVehicleExplode",vehicle,function()
		local veh = source
		setTimer(function()
			if isElement(veh) then
				respawnVehicle(veh)
				setElementData(veh,"Benzin",100)
				setElementFrozen(veh,true)
			end
		end,15000,1)
	end)
	addEventHandler("onVehicleStartEnter",vehicle,function(player)
		if not isElement(player) or getElementType(player) ~= "player" then return end
		if not isBallas(player) then
			cancelEvent()
			infobox_func(player,getText(player,"FactionVehicle1"),255,0,0)
			return
		end
		setElementFrozen(source,false)
	end)
end

local BallasIn = createPickup(2524.4104003906,-1998.3729248047,14.113082885742,3,1318,50)
local BallasOut = createPickup(965.37829589844,2107.8344726563,1011.0302734375,3,1318,50)
setElementInterior(BallasOut,1)

addEventHandler("onPickupHit",BallasIn,function(player)
	if getElementType(player) ~= "player" then return end
	if getElementData(player,"loggedin") ~= 1 then return end
	if not isBallas(player) then
		infobox_func(player,getText(player,"FactionBallas1"),255,0,0)
		return
	end
	triggerClientEvent(player,"ladeBalken",player)
	setTimer(function(target)
		if not isElement(target) then return end
		setElementInterior(target,1)
		setElementDimension(target,0)
		setElementPosition(target,962.90002441406,2107.8999023438,1011)
		setPedRotation(target,82)
	end,1500,1,player)
end)

addEventHandler("onPickupHit",BallasOut,function(player)
	if getElementType(player) ~= "player" then return end
	if getElementData(player,"loggedin") ~= 1 then return end
	if not isBallas(player) then return end
	triggerClientEvent(player,"ladeBalken",player)
	setTimer(function(target)
		if not isElement(target) then return end
		setElementInterior(target,0)
		setElementDimension(target,0)
		setElementPosition(target,2523.1999511719,-1999.5,13.800000190735)
		setPedRotation(target,136)
	end,1500,1,player)
end)