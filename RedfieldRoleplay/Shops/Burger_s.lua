local goBurgerLadenMarker={

[1] = createPickup(-2336.861,-166.727,35.5557,3,1318,50),
[2] = createPickup(-2356.456,1008.131,50.898,3,1318,50),
[3] = createPickup(-1912.433,827.927,35.23,3,1318,50),
[4] = createPickup(810.486,-1616.065,13.547,3,1318,50),
[5] = createPickup(1199.532,-918.503,43.119,3,1318,50),
[6] = createPickup(2169.804,2795.715,10.82,3,1318,50),
[7] = createPickup(1872.643,2071.749,11.062,3,1318,50),
[8] = createPickup(2472.864,2034.171,11.062,3,1318,50),
[9] = createPickup(1157.919,2072.185,11.062,3,1318,50),
[10] = createPickup(2366.804,2071.029,10.82,3,1318,50),

}

for i,Burgermarker in pairs(goBurgerLadenMarker)do
	addEventHandler('onPickupHit',Burgermarker,function(player)
		if(not(isPedInVehicle(player)))then
			triggerClientEvent(player,"ladeBalken",player)
		
			local x,y,z = getElementPosition(player)
			setElementData(player,'saveposx',x)
			setElementData(player,'saveposy',y)
			setElementData(player,'saveposz',z)
			
			setTimer(function()
				setElementPosition(player,364.60000610352,-73.699996948242,1001.5)
				setPedRotation(player,300)
				setElementInterior(player,10)
				setElementDimension(player,i)
				
				BurgerGuy = createPed(205,376.60000610352,-65.900001525879,1001.5,180)
				setElementInterior(BurgerGuy,10)
				setElementDimension(BurgerGuy,i)
				
				BurgermarkerLeave = createMarker(363,-75.099998474121,1000.5999755859,'cylinder',1,0,0,200)
				setElementInterior(BurgermarkerLeave,10)
				setElementDimension(BurgermarkerLeave,i)
				BurgermarkerKaufen = createMarker(376.60000610352,-67.599998474121,1000.5999755859,'cylinder',1,0,0,200)
				setElementInterior(BurgermarkerKaufen,10)
				setElementDimension(BurgermarkerKaufen,i)
					
				addEventHandler('onMarkerHit',BurgermarkerLeave,BurgerLeave)
				addEventHandler('onMarkerHit',BurgermarkerKaufen,BurgerKaufen)
			end,1500,1)
		end
	end)
end

function BurgerLeave(player)
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

function BurgerKaufen(player)
	triggerClientEvent(player,'openBurgerWindow',player)
end

function buyburger(burger)
	if(burger == 'klein')then
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
	elseif(burger == 'mittel')then
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
	elseif(burger == 'groß')then
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
addEvent('buyburger',true)
addEventHandler('buyburger',root,buyburger)