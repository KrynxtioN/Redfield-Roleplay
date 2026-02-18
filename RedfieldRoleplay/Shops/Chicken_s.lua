local chickenMarker={

[1] = createPickup(2398.51978,-1899.19775,13.54688,3,1318,50),
[2] = createPickup(2419.71411,-1509.07349,24.00000,3,1318,50),
[3] = createPickup(928.91223,-1352.93433,13.34375,3,1318,50),
[4] = createPickup(-2155.31714,-2460.16821,30.85156,3,1318,50),
[5] = createPickup(-2671.60376,257.92438,4.63281,3,1318,50),
[6] = createPickup(-1816.62280,618.67236,35.17188,3,1318,50),
[7] = createPickup(2845.93188,2415.43701,11.06250,3,1318,50),
[8] = createPickup(2393.20605,2041.56494,10.82031,3,1318,50),
[9] = createPickup(173.05795288086,1177.1352539063,14.7578125,3,1318,50),

}

for i, chickenmarker in pairs(chickenMarker)do
	addEventHandler('onPickupHit',chickenmarker,function(player)
		if(not(isPedInVehicle(player)))then
			triggerClientEvent(player,"ladeBalken",player)
		
			local x,y,z = getElementPosition(player)
			setElementData(player,'saveposx',x)
			setElementData(player,'saveposy',y)
			setElementData(player,'saveposz',z)
			
			setTimer(function()
				setElementPosition(player,365.20651245117,-9.0741882324219,1001.8515625)
				setPedRotation(player,0)
				setElementInterior(player,9)
				setElementDimension(player,i)
				
				chickenPed = createPed(167,369.60000610352,-4.5,1001.9000244141,180)
				setElementInterior(chickenPed,9)
				setElementDimension(chickenPed,i)
					
				chickenmarkerRaus = createPickup(365.01297, -11.84305, 1001.85156,3,1318,50)
				setElementInterior(chickenmarkerRaus,9)
				setElementDimension(chickenmarkerRaus,i)
				chickenKaufen = createMarker(369.60000610352,-6.1999998092651,1000.9000244141,'cylinder',1,0,0,200)
				setElementInterior(chickenKaufen,9)
				setElementDimension(chickenKaufen,i)
					
				addEventHandler('onMarkerHit',chickenKaufen,chicken_open)
				addEventHandler('onPickupHit',chickenmarkerRaus,chicken_leave)
			end,1500,1)
		end
	end)
end

function chicken_leave(player)
	triggerClientEvent(player,"ladeBalken",player)
	setTimer(function()
		setElementPosition(player,getElementData(player,'saveposx'),getElementData(player,'saveposy'),getElementData(player,'saveposz'))
		setElementDimension(player,0)
		setElementInterior(player,0)
		setElementData(player,'saveposx',nil)
		setElementData(player,'saveposy',nil)
		setElementData(player,'saveposz',nil)
	end,1500,1)
end

function chicken_open(player)
	triggerClientEvent(player,'openChickenWindow',player)
end

function buyChicken(chicken)
	if(chicken == 'klein')then
		if(getPlayerMoney(source)>=10)then
			takePlayerMoney(source,10)
			getChatBox(source,78)
			updateEventkasse("einzahlen",10)
			setElementData(source,'Hunger',getElementData(source,'Hunger') + 25)
			if(getElementData(source,'Hunger') > 100)then
				setElementData(source,'Hunger',100)
			end
		else
			getChatBox(source,33)
		end
	elseif(chicken == 'mittel')then
		if(getPlayerMoney(source)>=25)then
			takePlayerMoney(source,25)
			getChatBox(source,78)
			updateEventkasse("einzahlen",25)
			setElementData(source,'Hunger',getElementData(source,'Hunger') + 50)
			if(getElementData(source,'Hunger') > 100)then
				setElementData(source,'Hunger',100)
			end
		else
			getChatBox(source,33)
		end
	elseif(chicken == 'groß')then
		if(getPlayerMoney(source)>=50)then
			takePlayerMoney(source,50)
			getChatBox(source,78)
			updateEventkasse("einzahlen",50)
			setElementData(source,'Hunger',getElementData(source,'Hunger') + 100)
			if(getElementData(source,'Hunger') > 100)then
				setElementData(source,'Hunger',100)
			end
		else
			getChatBox(source,33)
		end
	end
end
addEvent('buyChicken',true)
addEventHandler('buyChicken',root,buyChicken)