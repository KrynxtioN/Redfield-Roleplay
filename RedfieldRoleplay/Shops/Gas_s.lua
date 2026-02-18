local tankstellenmarker={

[1] = createMarker(-2244.2653808594,-2561.2934570313,30.921875,'cylinder',5,0,0,200),
[2] = createMarker(658.52795410156,-565.03424072266,15.3359375,'cylinder',5,0,0,200),
[3] = createMarker(1003.8759155273,-940.43975830078,41.1796875,'cylinder',5,0,0,200),
[4] = createMarker(-92.113708496094,-1171.3128662109,1.3799414634705,'cylinder',5,0,0,200),
[5] = createMarker(1597.9239501953,2199.1923828125,9.8203125,'cylinder',5,0,0,200),
[6] = createMarker(2144.8181152344,2748.4426269531,9.8203125,'cylinder',5,0,0,200),
[7] = createMarker(2113.7553710938,920.28552246094,9.8203125,'cylinder',5,0,0,200),
[8] = createMarker(-736.88232421875,2741.0732421875,46.224239349365,'cylinder',5,0,0,200),
[9] = createMarker(-1326.2266845703,2688.9340820313,49.0625,'cylinder',5,0,0,200),
[10] = createMarker(1936.3382568359,-1772.1337890625,12.3828125,'cylinder',5,0,0,200),
[11] = createMarker(62.793960571289,1217.6678466797,17.835973739624,'cylinder',5,0,0,200),
[12] = createMarker(-1612.5341796875,-2723.4165039063,47.5390625,'cylinder',5,0,0,200),
[13] = createMarker(2638.4443359375,1106.2412109375,9.8203125,'cylinder',5,0,0,200),
[14] = createMarker(2203.1423339844,2473.5385742188,9.8203125,'cylinder',5,0,0,200),
[15] = createMarker(-1681.7896728516,407.72265625,5.6796879768372,'cylinder',5,0,0,200),
[16] = createMarker(-2415.208984375,976.42901611328,43.807689666748,'cylinder',5,0,0,200),

}

for i,tankmarker in pairs(tankstellenmarker)do
	addEventHandler('onMarkerHit',tankmarker,function(player)
		triggerClientEvent(player,'tankeWindow',player)
	end)
end

function fulltanken(player)
	local veh = getPedOccupiedVehicle(player)
	
	if(veh)then
		local besitzer = getElementData(veh,'Besitzer')
		local slot = getElementData(veh,'Slot')
		
		if(besitzer and slot)then
			if(getElementData(veh,'Benzin') < 100)then
				getChatBox(player,68)
				setElementFrozen(veh,true)
				setTimer(function()
					setElementFrozen(veh,false)
					setElementData(veh,'Benzin',100)
					setCarData(besitzer,slot,'Benzin',100)
					getChatBox(player,69)
				end,6000,1)
			else
				getChatBox(player,70)
			end
		end
	end
end
addEvent('fulltanken',true)
addEventHandler('fulltanken',root,fulltanken)

function litertanken(player,liter)
	local veh = getPedOccupiedVehicle(player)
	
	if(veh)then
		local besitzer = getElementData(veh,'Besitzer')
		local slot = getElementData(veh,'Slot')
		
		if(besitzer and slot)then
			if(getElementData(veh,'Benzin') < 100)then
				getChatBox(player,68)
				local benzin = getElementData(veh,'Benzin')
				local literanzahl = liter
				local newbenzin = benzin + literanzahl
				if(newbenzin > 100)then
					givebenzin = 100
				else
					givebenzin = newbenzin
				end
				setElementFrozen(veh,true)
				setTimer(function()
					setElementFrozen(veh,false)
					setElementData(veh,'Benzin',givebenzin)
					setCarData(besitzer,slot,'Benzin',givebenzin)
					getChatBox(player,69)
				end,6000,1)
			else
				getChatBox(player,70)
			end
		end
	end
end
addEvent('litertanken',true)
addEventHandler('litertanken',root,litertanken)