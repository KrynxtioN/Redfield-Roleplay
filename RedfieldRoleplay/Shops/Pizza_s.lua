PizzaShop = {Marker_Enter = {}, Marker_Leave = {}, Marker_Buy = {}, Ped = {},
	["Marker"] = {
		{-1808.3822021484,945.3701171875,23.848808288574},
		{-1721.3131103516,1359.7663574219,6.6736726760864},
		{2105.474,-1806.535,13.555},
		{2756.748,2477.368,11.062},
		{2330.648,2533.395,10.82},
		{2083.309,2224.7,11.023},
		{2331.825,75.036,26.621},
		{1367.407,248.438,19.567},
		{212.427,-202.231,1.578},
	},
}

for i,v in ipairs(PizzaShop["Marker"])do
	PizzaShop.Marker_Enter[i] = createPickup(v[1],v[2],v[3],3,1318,50)
	setElementData(PizzaShop.Marker_Enter[i],"ID",i)
	PizzaShop.Ped[i] = createPed(155,374.70001220703,-117.09999847412,1001.5)
	setElementRotation(PizzaShop.Ped[i],0,0,180)
	setElementInterior(PizzaShop.Ped[i],5)
	setElementDimension(PizzaShop.Ped[i],i)
	
	PizzaShop.Marker_Leave[i] = createPickup(372.29998779297,-133.39999389648,1000.5999755859,3,1318,50)
	setElementInterior(PizzaShop.Marker_Leave[i],5)
	setElementDimension(PizzaShop.Marker_Leave[i],i)
	
	PizzaShop.Marker_Buy[i] = createMarker(374.70001220703,-119,1000.5999755859,"cylinder",1,255,255,255,100)
	setElementInterior(PizzaShop.Marker_Buy[i],5)
	setElementDimension(PizzaShop.Marker_Buy[i],i)
	
	addEventHandler("onPickupHit",PizzaShop.Marker_Enter[i],function(player)
		if(not(isPedInVehicle(player)))then
			if(getElementDimension(player) == getElementDimension(source))then
				triggerClientEvent(player,"ladeBalken",player)
				
				local x,y,z = getElementPosition(player)
				setElementData(player,'saveposx',x)
				setElementData(player,'saveposy',y)
				setElementData(player,'saveposz',z)
				
				setTimer(function(player,marker)
					if(isElement(player))then
						setElementPosition(player,372.29998779297,-131.80000305176,1001.5)
						setElementRotation(player,0,0,0)
						setElementInterior(player,5)
						setElementDimension(player,i)
						setElementDimension(player,getElementData(marker,"ID"))
					end
				end,1500,1,player,source)
			end
		end
	end)
	
	addEventHandler("onPickupHit",PizzaShop.Marker_Leave[i],function(player)
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
	
	addEventHandler("onMarkerHit",PizzaShop.Marker_Buy[i],function(player)
		if(not(isPedInVehicle(player)))then
			if(getElementDimension(player) == getElementDimension(source))then
				triggerClientEvent(player,"openPizzaWindow",player)
			end
		end
	end)
end

function buyPizza(pizza)
	local preis = 0
	if(pizza == "klein")then preis = 10 end
	if(pizza == "mittel")then preis = 25 end
	if(pizza == "groß")then preis = 50 end
	
	if(tonumber(getElementData(client,"Money")) >= tonumber(preis))then
		setElementData(client,"Money",tonumber(getElementData(client,"Money")) - preis)
		infobox_func(client,getText(client,"PizzaShop7"),0,255,0)
		updateEventkasse("einzahlen",preis)
		setElementData(client,"Hunger",getElementData(client,"Hunger")+preis)
		if(getElementData(client,"Hunger") > 100)then
			setElementData(client,"Hunger",100)
		end
	else infobox_func(client,getText(client,"PizzaShop6"),255,0,0)end
end
addEvent('buyPizza',true)
addEventHandler('buyPizza',root,buyPizza)