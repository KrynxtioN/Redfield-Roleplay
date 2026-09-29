ChickenShop = {Marker_Enter = {}, Marker_Leave = {}, Marker_Buy = {}, Ped = {},
	["Marker"] = {
		{2398.51978,-1899.19775,13.54688},
		{2419.71411,-1509.07349,24.00000},
		{928.91223,-1352.93433,13.34375},
		{-2155.31714,-2460.16821,30.85156},
		{-2671.60376,257.92438,4.63281},
		{-1816.62280,618.67236,35.17188},
		{2845.93188,2415.43701,11.06250},
		{2393.20605,2041.56494,10.82031},
		{173.05795288086,1177.1352539063,14.7578125},
	},
}

for i,v in ipairs(ChickenShop["Marker"])do
	ChickenShop.Marker_Enter[i] = createPickup(v[1],v[2],v[3],3,1318,50)
	setElementData(ChickenShop.Marker_Enter[i],"ID",i)
	ChickenShop.Ped[i] = createPed(167,369.60000610352,-4.5,1001.9000244141)
	setElementRotation(ChickenShop.Ped[i],0,0,180)
	setElementInterior(ChickenShop.Ped[i],9)
	setElementDimension(ChickenShop.Ped[i],i)
	
	ChickenShop.Marker_Leave[i] = createPickup(363,-75.099998474121,1000.5999755859,3,1318,50)
	setElementInterior(ChickenShop.Marker_Leave[i],9)
	setElementDimension(ChickenShop.Marker_Leave[i],i)
	
	ChickenShop.Marker_Buy[i] = createMarker(369.60000610352,-6.1999998092651,1000.9000244141,"cylinder",1,255,255,255,100)
	setElementInterior(ChickenShop.Marker_Buy[i],9)
	setElementDimension(ChickenShop.Marker_Buy[i],i)
	
	addEventHandler("onPickupHit",ChickenShop.Marker_Enter[i],function(player)
		if(not(isPedInVehicle(player)))then
			if(getElementDimension(player) == getElementDimension(source))then
				triggerClientEvent(player,"ladeBalken",player)
				
				local x,y,z = getElementPosition(player)
				setElementData(player,'saveposx',x)
				setElementData(player,'saveposy',y)
				setElementData(player,'saveposz',z)
				
				setTimer(function(player,marker)
					if(isElement(player))then
						setElementPosition(player,365.20651245117,-9.0741882324219,1001.8515625)
						setElementRotation(player,0,0,300)
						setElementInterior(player,9)
						setElementDimension(player,i)
						setElementDimension(player,getElementData(marker,"ID"))
					end
				end,1500,1,player,source)
			end
		end
	end)
	
	addEventHandler("onPickupHit",ChickenShop.Marker_Leave[i],function(player)
		if(not(isPedInVehicle(player)))then
			if(getElementDimension(player) == getElementDimension(source))then
				triggerClientEvent(player,"ladeBalken",player)
				setTimer(function(player)
					if(isElement(player))then
						setElementPosition(player,getElementData(player,'saveposx'),getElementData(player,'saveposy'),getElementData(player,'saveposz'))
						setElementDimension(player,0)
						setElementInterior(player,0)
						setElementData(player,'saveposx',nil)
						setElementData(player,'saveposy',nil)
						setElementData(player,'saveposz',nil)
					end
				end,1500,1,player)
			end
		end
	end)
	
	addEventHandler("onMarkerHit",ChickenShop.Marker_Buy[i],function(player)
		if(not(isPedInVehicle(player)))then
			if(getElementDimension(player) == getElementDimension(source))then
				triggerClientEvent(player,"openChickenWindow",player)
			end
		end
	end)
end

function chicken_open(player)
	triggerClientEvent(player,'openChickenWindow',player)
end

function buyChicken(chicken)
	local preis = 0
	if(chicken == "klein")then preis = 10 end
	if(chicken == "mittel")then preis = 25 end
	if(chicken == "groß")then preis = 50 end
	
	if(tonumber(getElementData(client,"Money")) >= tonumber(preis))then
		setElementData(client,"Money",tonumber(getElementData(client,"Money")) - preis)
		infobox_func(client,getText(client,"ChickenShop2"),0,255,0)
		updateEventkasse("einzahlen",preis)
		setElementData(client,"Hunger",getElementData(client,"Hunger")+preis)
		if(getElementData(client,"Hunger") > 100)then
			setElementData(client,"Hunger",100)
		end
	else infobox_func(client,getText(client,"ChickenShop1"),255,0,0)end
end
addEvent('buyChicken',true)
addEventHandler('buyChicken',root,buyChicken)