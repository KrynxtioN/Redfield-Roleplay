local goPizzaLadenMarker={

[1] = createPickup(-1808.3822021484,945.3701171875,23.848808288574,3,1318,50),
[2] = createPickup(-1721.3131103516,1359.7663574219,6.6736726760864,3,1318,50),
[3] = createPickup(2105.474,-1806.535,13.555,3,1318,50),
[4] = createPickup(2756.748,2477.368,11.062,3,1318,50),
[5] = createPickup(2330.648,2533.395,10.82,3,1318,50),
[6] = createPickup(2083.309,2224.7,11.023,3,1318,50),
[7] = createPickup(2331.825,75.036,26.621,3,1318,50),
[8] = createPickup(1367.407,248.438,19.567,3,1318,50),
[9] = createPickup(212.427,-202.231,1.578,3,1318,50),

}

for i,pizzamarker in pairs(goPizzaLadenMarker)do
	addEventHandler('onPickupHit',pizzamarker,function(player)
		if(not(isPedInVehicle(player)))then
			triggerClientEvent(player,"ladeBalken",player)
		
			local x,y,z = getElementPosition(player)
			setElementData(player,'saveposx',x)
			setElementData(player,'saveposy',y)
			setElementData(player,'saveposz',z)
			
			setTimer(function()
				setElementPosition(player,372.29998779297,-131.80000305176,1001.5)
				setPedRotation(player,0)
				setElementInterior(player,5)
				setElementDimension(player,i)
				
				pizzaGuy = createPed(155,374.70001220703,-117.09999847412,1001.5,180)
				setElementInterior(pizzaGuy,5)
				setElementDimension(pizzaGuy,i)
				
				pizzamarkerLeave = createMarker(372.29998779297,-133.39999389648,1000.5999755859,'cylinder',1,0,0,200)
				setElementInterior(pizzamarkerLeave,5)
				setElementDimension(pizzamarkerLeave,i)
				pizzamarkerKaufen = createMarker(374.70001220703,-119,1000.5999755859,'cylinder',1,0,0,200)
				setElementInterior(pizzamarkerKaufen,5)
				setElementDimension(pizzamarkerKaufen,i)
					
				addEventHandler('onMarkerHit',pizzamarkerLeave,pizzariaLeave)
				addEventHandler('onMarkerHit',pizzamarkerKaufen,pizzariaKaufen)
			end,1500,1)
		end
	end)
end

function pizzariaLeave(player)
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

function pizzariaKaufen(player)
	triggerClientEvent(player,'openPizzaWindow',player)
end

function buyPizza(pizza)
	if(pizza == 'klein')then
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
	elseif(pizza == 'mittel')then
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
	elseif(pizza == 'groß')then
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
addEvent('buyPizza',true)
addEventHandler('buyPizza',root,buyPizza)