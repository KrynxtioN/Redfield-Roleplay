BurgerShop = {Marker_Enter = {}, Marker_Leave = {}, Marker_Buy = {}, Ped = {},
	["Marker"] = {
		{-2336.861,-166.727,35.5557,3,1318,50},
		{-2356.456,1008.131,50.898,3,1318,50},
		{-1912.433,827.927,35.23,3,1318,50},
		{810.486,-1616.065,13.547,3,1318,50},
		{1199.532,-918.503,43.119,3,1318,50},
		{2169.804,2795.715,10.82,3,1318,50},
		{1872.643,2071.749,11.062,3,1318,50},
		{2472.864,2034.171,11.062,3,1318,50},
		{1157.919,2072.185,11.062,3,1318,50},
		{2366.804,2071.029,10.82,3,1318,50},
	},
}

for i,v in ipairs(BurgerShop["Marker"])do
	BurgerShop.Marker_Enter[i] = createPickup(v[1],v[2],v[3],3,1318,50)
	setElementData(BurgerShop.Marker_Enter[i],"ID",i)
	BurgerShop.Ped[i] = createPed(205,376.60000610352,-65.900001525879,1001.5)
	setElementRotation(BurgerShop.Ped[i],0,0,300)
	setElementInterior(BurgerShop.Ped[i],10)
	setElementDimension(BurgerShop.Ped[i],i)
	
	BurgerShop.Marker_Leave[i] = createPickup(363,-75.099998474121,1000.5999755859,3,1318,50)
	setElementInterior(BurgerShop.Marker_Leave[i],10)
	setElementDimension(BurgerShop.Marker_Leave[i],i)
	
	BurgerShop.Marker_Buy[i] = createMarker(376.60000610352,-67.599998474121,1000.5999755859,"cylinder",1,255,255,255,100)
	setElementInterior(BurgerShop.Marker_Buy[i],10)
	setElementDimension(BurgerShop.Marker_Buy[i],i)
	
	addEventHandler("onPickupHit",BurgerShop.Marker_Enter[i],function(player)
		if(not(isPedInVehicle(player)))then
			if(getElementDimension(player) == getElementDimension(source))then
				triggerClientEvent(player,"ladeBalken",player)
				
				local x,y,z = getElementPosition(player)
				setElementData(player,'saveposx',x)
				setElementData(player,'saveposy',y)
				setElementData(player,'saveposz',z)
				
				setTimer(function(player,marker)
					if(isElement(player))then
						setElementPosition(player,364.60000610352,-73.699996948242,1001.5)
						setElementRotation(player,0,0,300)
						setElementInterior(player,10)
						setElementDimension(player,getElementData(marker,"ID"))
					end
				end,1500,1,player,source)
			end
		end
	end)
	
	addEventHandler("onPickupHit",BurgerShop.Marker_Leave[i],function(player)
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
	
	addEventHandler("onMarkerHit",BurgerShop.Marker_Buy[i],function(player)
		if(not(isPedInVehicle(player)))then
			if(getElementDimension(player) == getElementDimension(source))then
				triggerClientEvent(player,"openBurgerWindow",player)
			end
		end
	end)
end

function buyburger(burger)
	local preis = 0
	if(burger == "klein")then preis = 10 end
	if(burger == "mittel")then preis = 25 end
	if(burger == "groß")then preis = 50 end
	if(tonumber(getElementData(client,"Money")) >= tonumber(preis))then
		setElementData(client,"Money",tonumber(getElementData(client,"Money")) - preis)
		infobox_func(client,getText(client,"BurgerShop7"),0,255,0)
		updateEventkasse("einzahlen",preis)
		setElementData(client,"Hunger",getElementData(client,"Hunger")+preis)
		if(getElementData(client,"Hunger") > 100)then
			setElementData(client,"Hunger",100)
		end
	else infobox_func(client,getText(client,"BurgerShop6"),255,0,0)end
end
addEvent('buyburger',true)
addEventHandler('buyburger',root,buyburger)