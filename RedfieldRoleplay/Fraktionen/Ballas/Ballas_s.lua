local ballasCars = {

[1] = createVehicle(475,2450.1000976563,-2022.4000244141,13.39999961853,0,0,0),
[2] = createVehicle(475,2530.6999511719,-2014.9000244141,13.39999961853,0,0,45),
[3] = createVehicle(567,2478.1000976563,-2004.4000244141,13.5,0,0,90),
[4] = createVehicle(567,2471.1000976563,-2004.4000244141,13.5,0,0,90),
[5] = createVehicle(482,2494.1999511719,-1996.9000244141,13.800000190735,0,0,180),
[6] = createVehicle(482,2494.1999511719,-1990.5999755859,13.699999809265,0,0,180),
[7] = createVehicle(482,2499.1000976563,-2022.3000488281,13.800000190735,0,0,0),
[8] = createVehicle(482,2499.1005859375,-2028.7998046875,13.800000190735,0,0,0),

}

for i=1,#ballasCars do
	setElementData(ballasCars[i],'Benzin',100)
	setElementData(ballasCars[i],'Besitzer','Ballas')
	setVehiclePlateText(ballasCars[i],'Ballas')
	setVehicleColor(ballasCars[i],255,0,200)
	setElementFrozen(ballasCars[i],true)
	
	addEventHandler('onVehicleStartEnter',ballasCars[i],function(player)
		if(not(isBallas(player)))then
			cancelEvent()
			getChatBox(player,84)
		else
			setElementFrozen(ballasCars[i],false)
		end
	end)
end

local BallasIn = createPickup(2524.4104003906,-1998.3729248047,14.113082885742,3,1318,50)
local BallasOut = createPickup(965.37829589844,2107.8344726563,1011.0302734375,3,1318,50)
setElementInterior(BallasOut,1)

addEventHandler('onPickupHit',BallasIn,function(player)
	if(isBallas(player))then
		triggerClientEvent(player,"ladeBalken",player)
		setTimer(function()
			setElementPosition(player,962.90002441406,2107.8999023438,1011)
			setPedRotation(player,82)
			setElementInterior(player,1)
		end,1500,1)
	end
end)

addEventHandler('onPickupHit',BallasOut,function(player)
	triggerClientEvent(player,"ladeBalken",player)
	setTimer(function()
		setElementPosition(player,2523.1999511719,-1999.5,13.800000190735)
		setPedRotation(player,136)
		setElementInterior(player,0)
	end,1500,1)
end)