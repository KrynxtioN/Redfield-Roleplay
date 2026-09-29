Bar = {Marker_Enter = {}, Marker_Leave = {}, Marker_Buy = {}, Ped = {},
	["Marker"] = {
		{2310.0864257813,-1643.5386962891,14.827047348022},
		{-2242.1437988281,-88.274787902832,35.3203125},
		{2441.1997070313,2065.4807128906,10.8203125},
	},
}

local Drink_Price = {
	["Whiskey"] = 8,
	["Scotch"] = 10,
	["Vodka"] = 12,
}

for i,v in pairs(Bar["Marker"])do
	Bar.Marker_Enter[i] = createPickup(v[1],v[2],v[3],3,1318,50)
	setElementData(Bar.Marker_Enter[i],"ID",i)
	Bar.Ped[i] = createPed(181,498.10000610352,-77.5,998.79998779297)
	setElementRotation(Bar.Ped[i],0,0,0)
	setElementInterior(Bar.Ped[i],11)
	setElementDimension(Bar.Ped[i],i)
	
	Bar.Marker_Leave[i] = createPickup(502.001953125,-67.56315612793,998.7578125,3,1318,50)
	setElementInterior(Bar.Marker_Leave[i],11)
	setElementDimension(Bar.Marker_Leave[i],i)
	
	Bar.Marker_Buy[i] = createMarker(498.10000610352,-75.800003051758,997.79998779297,"cylinder",1,255,255,255,100)
	setElementInterior(Bar.Marker_Buy[i],11)
	setElementDimension(Bar.Marker_Buy[i],i)
	
	addEventHandler("onPickupHit",Bar.Marker_Enter[i],function(player)
		if(not(isPedInVehicle(player)))then
			if(getElementDimension(player) == getElementDimension(source))then
				triggerClientEvent(player,"ladeBalken",player)
				
				local x,y,z = getElementPosition(player)
				setElementData(player,'saveposx',x)
				setElementData(player,'saveposy',y)
				setElementData(player,'saveposz',z)
				
				setTimer(function(player,marker)
					if(isElement(player))then
						setElementPosition(player,501.89999389648,-70.099998474121,998.79998779297)
						setElementRotation(player,0,0,180)
						setElementInterior(player,11)
						setElementDimension(player,getElementData(marker,"ID"))
					end
				end,1500,1,player,source)
			end
		end
	end)
	
	addEventHandler("onPickupHit",Bar.Marker_Leave[i],function(player)
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
	
	addEventHandler("onMarkerHit",Bar.Marker_Buy[i],function(player)
		if(not(isPedInVehicle(player)))then
			if(getElementDimension(player) == getElementDimension(source))then
				triggerClientEvent(player,"openBarWindow",player)
			end
		end
	end)
end
			
function BuyAlcohol(drink)
	local preis = Drink_Price[drink]
	if(not(preis))then preis = 10 end
	toggleAllControls(client,false)
	setPedAnimation(client,'VENDING','VEND_Drink2_P')
	setTimer(function(player)
		if(isElement(player))then
			setPedAnimation(player,false)
			toggleAllControls(player,true)
			setElementData(client,"Money",tonumber(getElementData(client,"Money")) - preis)
			setElementData(player,'Hunger',getElementData(player,'Hunger') + preis)
			updateEventkasse("einzahlen",preis)
			if(getElementData(player,'Hunger') > 100)then
				setElementData(player,'Hunger',100)
			end
			infobox_func(player,getText(player,"Bar1"),0,255,0)
		end
	end,4000,1,client)
end
addEvent('BuyAlcohol',true)
addEventHandler('BuyAlcohol',root,BuyAlcohol)