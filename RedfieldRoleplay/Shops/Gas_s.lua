Tankstelle = {Marker_Enter = {},
	["Marker"] = {
		{-2244.2653808594,-2561.2934570313,30.921875},
		{658.52795410156,-565.03424072266,15.3359375},
		{1003.8759155273,-940.43975830078,41.1796875},
		{-92.113708496094,-1171.3128662109,1.3799414634705},
		{1597.9239501953,2199.1923828125,9.8203125},
		{2144.8181152344,2748.4426269531,9.8203125},
		{2113.7553710938,920.28552246094,9.8203125},
		{-736.88232421875,2741.0732421875,46.224239349365},
		{-1326.2266845703,2688.9340820313,49.0625},
		{1936.3382568359,-1772.1337890625,12.3828125},
		{62.793960571289,1217.6678466797,17.835973739624},
		{-1612.5341796875,-2723.4165039063,47.5390625},
		{2638.4443359375,1106.2412109375,9.8203125},
		{2203.1423339844,2473.5385742188,9.8203125},
		{-1681.7896728516,407.72265625,5.6796879768372},
		{-2415.208984375,976.42901611328,43.807689666748},
	},
}

for i,v in ipairs(Tankstelle["Marker"])do
	Tankstelle.Marker_Enter[i] = createMarker(v[1],v[2],v[3],"cylinder",5,255,255,255,100)
	
	addEventHandler("onMarkerHit",Tankstelle.Marker_Enter[i],function(hitElement)
		if getElementType(hitElement) ~= "vehicle" then return end

		local driver = getVehicleOccupant(hitElement, 0)
		if not driver then return end

		if getElementDimension(hitElement) ~= getElementDimension(source) then return end
		if getElementInterior(hitElement) ~= getElementInterior(source) then return end
		
		triggerClientEvent(driver,"tankeWindow",driver)
	end)
end

function fulltanken()
	local veh = getPedOccupiedVehicle(client)
	if veh then
		local besitzer = getElementData(veh,"Besitzer")
		local slot = getElementData(veh,"Slot")
		local benzin = tonumber(getElementData(veh,"Benzin")) or 0
		if benzin < 100 then
			infobox_func(client,getText(client,"Tankstelle1"),0,255,0)
			setElementFrozen(veh,true)
			setTimer(function(veh,player,besitzer,slot)
				if isElement(veh) then
					setElementFrozen(veh,false)
					setElementData(veh,"Benzin",100)
					if besitzer and slot then setCarData(besitzer,slot,"Benzin",100) end
					if isElement(player) then infobox_func(player,getText(player,"Tankstelle2"),0,255,0) end
				end
			end,6000,1,veh,client,besitzer,slot)
		else
			infobox_func(client,getText(client,"Tankstelle3"),255,0,0)
		end
	end
end
addEvent("fulltanken",true)
addEventHandler("fulltanken",root,fulltanken)

function litertanken(liter)
	local player = client
	local veh = getPedOccupiedVehicle(player)
	if veh then
		local besitzer = getElementData(veh,"Besitzer")
		local slot = getElementData(veh,"Slot")
		local benzin = tonumber(getElementData(veh,"Benzin")) or 0
		liter = tonumber(liter) or 0
		if benzin < 100 then
			local givebenzin = math.min(benzin + liter,100)
			infobox_func(player,getText(player,"Tankstelle1"),0,255,0)
			setElementFrozen(veh,true)
			setTimer(function(veh,player,besitzer,slot,givebenzin)
				if isElement(veh) then
					setElementFrozen(veh,false)
					setElementData(veh,"Benzin",givebenzin)
					if besitzer and slot then setCarData(besitzer,slot,"Benzin",givebenzin) end
					if isElement(player) then infobox_func(player,getText(player,"Tankstelle2"),0,255,0) end
				end
			end,6000,1,veh,player,besitzer,slot,givebenzin)
		else
			infobox_func(player,getText(player,"Tankstelle3"),255,0,0)
		end
	end
end
addEvent("litertanken",true)
addEventHandler("litertanken",root,litertanken)