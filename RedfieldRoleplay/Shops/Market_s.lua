local gosupermarktLadenMarker={

[1] = createPickup(-2442.6064453125,753.44964599609,35.136966705322,3,1318,50),
[2] = createPickup(2194.9331054688,1991.1153564453,12.2,3,1318,50),
[3] = createPickup(2884.728,2453.8388,11.06,3,1318,50),
[4] = createPickup(1937.825,2307.234,10.82,3,1318,50),
[5] = createPickup(2097.69,2224.582,11.023,3,1318,50),
[6] = createPickup(2247.694,2396.168,10.82,3,1318,50),
[7] = createPickup(2452.481,2065.165,10.82,3,1318,50),
[8] = createPickup(2546.466,1972.659,10.82,3,1318,50),
[9] = createPickup(1315.4521484375,-898.7373046875,39.578125,3,1318,50),
[10] = createPickup(2423.611328125,-1742.2548828125,13.546875,3,1318,50),
[11] = createPickup(999.969,-920.073,42.328,3,1318,50),
[12] = createPickup(1352.436,-1759.125,13.508,3,1318,50),
[13] = createPickup(-180.742,1034.869,19.742,3,1318,50),
[14] = createPickup(-1562.534,-2732.942,48.743,3,1318,50),

}

for i,supermarktmarker in pairs(gosupermarktLadenMarker)do
	addEventHandler('onPickupHit',supermarktmarker,function(player)
		if(not(isPedInVehicle(player)))then
			triggerClientEvent(player,"ladeBalken",player)
		
			local x,y,z = getElementPosition(player)
			setElementData(player,'saveposx',x)
			setElementData(player,'saveposy',y)
			setElementData(player,'saveposz',z)
			
			setTimer(function()
				setElementPosition(player,-27.39999961853,-56.700000762939,1003.5)
				setPedRotation(player,0)
				setElementInterior(player,6)
				setElementDimension(player,i)
				
				supermarktGuy = createPed(182,-23.5,-57.299999237061,1003.5,0)
				setElementInterior(supermarktGuy,6)
				setElementDimension(supermarktGuy,i)
				
				supermarktmarkerLeave = createMarker(-27.39999961853,-58,1002.5999755859,'cylinder',1,0,0,200)
				setElementInterior(supermarktmarkerLeave,6)
				setElementDimension(supermarktmarkerLeave,i)
				supermarktmarkerKaufen = createMarker(-23.5,-55.5,1002.5999755859,'cylinder',1,0,0,200)
				setElementInterior(supermarktmarkerKaufen,6)
				setElementDimension(supermarktmarkerKaufen,i)
					
				addEventHandler('onMarkerHit',supermarktmarkerLeave,supermarktLeave)
				addEventHandler('onMarkerHit',supermarktmarkerKaufen,supermarktKaufen)
			end,1500,1)
		end
	end)
end

function supermarktLeave(player)
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

function supermarktKaufen(player)
	triggerClientEvent(player,'opensupermarktWindow',player)
end

function takemoneyshop(money)
	takePlayerMoney(source,money)
	updateEventkasse("einzahlen",money)
end
addEvent('takemoneyshop',true)
addEventHandler('takemoneyshop',root,takemoneyshop)

function buylos()
	local win = math.random(1,500)
	
	if(win > 0 and win < 101)then
		getChatBox(65)
		givePlayerMoney(source,50)
	elseif(win > 100 and win < 500)then
		getChatBox(66)
	elseif(win == 500)then
		getChatBox(66)
		givePlayerMoney(source,12000)
	end
end
addEvent('los',true)
addEventHandler('los',root,buylos)