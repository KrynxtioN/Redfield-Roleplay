Supermarkt = {Marker_Enter = {}, Marker_Leave = {}, Marker_Buy = {}, Ped = {},
	["Marker"] = {
		{-2442.6064453125,753.44964599609,35.136966705322},
		{2194.9331054688,1991.1153564453,12.2},
		{2884.728,2453.8388,11.06},
		{1937.825,2307.234,10.82},
		{2097.69,2224.582,11.023},
		{2247.694,2396.168,10.82},
		{2452.481,2065.165,10.82},
		{2546.466,1972.659,10.82},
		{1315.4521484375,-898.7373046875,39.578125},
		{2423.611328125,-1742.2548828125,13.546875},
		{999.969,-920.073,42.328},
		{1352.436,-1759.125,13.508},
		{-180.742,1034.869,19.742},
		{-1562.534,-2732.942,48.743},
	},
}

for i,v in ipairs(Supermarkt["Marker"])do
	Supermarkt.Marker_Enter[i] = createPickup(v[1],v[2],v[3],3,1318,50)
	setElementData(Supermarkt.Marker_Enter[i],"ID",i)
	Supermarkt.Ped[i] = createPed(182,-23.5,-57.299999237061,1003.5)
	setElementRotation(Supermarkt.Ped[i],0,0,0)
	setElementInterior(Supermarkt.Ped[i],6)
	setElementDimension(Supermarkt.Ped[i],i)
	
	Supermarkt.Marker_Leave[i] = createPickup(-27.39999961853,-58,1002.5999755859,3,1318,50)
	setElementInterior(Supermarkt.Marker_Leave[i],6)
	setElementDimension(Supermarkt.Marker_Leave[i],i)
	
	Supermarkt.Marker_Buy[i] = createMarker(-23.5,-55.5,1002.5999755859,"cylinder",1,255,255,255,100)
	setElementInterior(Supermarkt.Marker_Buy[i],6)
	setElementDimension(Supermarkt.Marker_Buy[i],i)
	
	addEventHandler("onPickupHit",Supermarkt.Marker_Enter[i],function(player)
		if(not(isPedInVehicle(player)))then
			if(getElementDimension(player) == getElementDimension(source))then
				triggerClientEvent(player,"ladeBalken",player)
				
				local x,y,z = getElementPosition(player)
				setElementData(player,'saveposx',x)
				setElementData(player,'saveposy',y)
				setElementData(player,'saveposz',z)
				
				setTimer(function(player,marker)
					if(isElement(player))then
						setElementPosition(player,-27.39999961853,-56.700000762939,1003.5)
						setElementRotation(player,0,0,0)
						setElementInterior(player,6)
						setElementDimension(player,i)
						setElementDimension(player,getElementData(marker,"ID"))
					end
				end,1500,1,player,source)
			end
		end
	end)
	
	addEventHandler("onPickupHit",Supermarkt.Marker_Leave[i],function(player)
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
	
	addEventHandler("onMarkerHit",Supermarkt.Marker_Buy[i],function(player)
		if(not(isPedInVehicle(player)))then
			if(getElementDimension(player) == getElementDimension(source))then
				triggerClientEvent(player,"opensupermarktWindow",player)
			end
		end
	end)
end

addEvent("Supermarkt.buy",true)
addEventHandler("Supermarkt.buy",root,function(artikel)
	if(artikel)then
		if(artikel == "Handy" or artikel == "Phone")then
			if(tonumber(getElementData(client,"Money")) >= 350)then
				if(getElementData(client,"Telefonnummer") == 0)then
					local newNR = math.random(1000000,9999999)
					setElementData(client,"Telefonnummer",newNR)
					setElementData(client,"Money",tonumber(getElementData(client,"Money"))-350)
					updateEventkasse("einzahlen",350)
					infobox_func(client,getText(client,"Supermarkt11"):format(newNR),0,255,0)
				else
					infobox_func(client,getText(client,"Supermarkt10"),255,0,0)
				end
			else
				infobox_func(client,getText(client,"Supermarkt9"),255,0,0)
			end
		elseif(artikel == "Snack")then
			if(tonumber(getElementData(client,"Money")) >= 3)then
				setElementData(client,'Hunger',getElementData(client,'Hunger') + 10)
				setElementData(client,"Money",tonumber(getElementData(client,"Money"))-3)
				updateEventkasse("einzahlen",3)
				if(getElementData(client,'Hunger') > 100)then
					setElementData(client,'Hunger',100)
				end
				infobox_func(client,getText(client,"Supermarkt12"),0,255,0)
			else
				infobox_func(client,getText(client,"Supermarkt9"),255,0,0)
			end
		elseif(artikel == "Glückslos" or artikel == "Lottery Ticket")then
			if(tonumber(getElementData(client,"Money")) >= 25)then
				setElementData(client,"Money",tonumber(getElementData(client,"Money"))-25)
				updateEventkasse("einzahlen",25)
				local win = math.random(1,500)
				if(win >= 1 and win <= 100)then
					setElementData(client,"Money",tonumber(getElementData(client,"Money"))+50)
					infobox_func(client,getText(client,"Supermarkt13"),0,255,0)
				elseif(win >= 101 and win <= 499)then
					infobox_func(client,getText(client,"Supermarkt14"),255,0,0)
				elseif(win == 500)then
					setElementData(client,"Money",tonumber(getElementData(client,"Money"))+12000)
					infobox_func(client,getText(client,"Supermarkt15"),0,255,0)
				end
			else
				infobox_func(client,getText(client,"Supermarkt9"),255,0,0)
			end
		end
	end
end)