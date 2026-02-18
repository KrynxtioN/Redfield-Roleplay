local ammunationMarker = {

[1] = createPickup(-316.16064453125,829.91748046875,14.2421875,3,1318,50),
[2] = createPickup(776.73138427734,1871.3670654297,4.9063653945923,3,1318,50),
[3] = createPickup(2539.5424804688,2083.9372558594,10.8203125,3,1318,50),
[4] = createPickup(2159.5427246094,943.11407470703,10.8203125,3,1318,50),
[5] = createPickup(-1508.8822021484,2610.6958007813,55.8359375,3,1318,50),
[6] = createPickup(-2625.8186035156,208.25175476074,4.8125,3,1318,50),
[7] = createPickup(243.29010009766,-178.36006164551,1.5821628570557,3,1318,50),
[8] = createPickup(1368.9987792969,-1279.5389404297,13.546875,3,1318,50),
[9] = createPickup(2400.4089355469,-1981.9901123047,13.546875,3,1318,50),

}

for i,ammumarker in pairs(ammunationMarker)do
	addEventHandler('onPickupHit',ammumarker,function(player)
		if(not(isPedInVehicle(player)))then
			triggerClientEvent(player,"ladeBalken",player)
		
			local x,y,z = getElementPosition(player)
			setElementData(player,'saveposx',x)
			setElementData(player,'saveposy',y)
			setElementData(player,'saveposz',z)
			
			setTimer(function()
				setElementPosition(player,296.89999389648,-110.30000305176,1001.5)
				setElementInterior(player,6)
				setElementDimension(player,i)

				ammuraus = createPickup(296.83898925781,-112.06053924561,1001.515625,3,1318,50)
				addEventHandler('onPickupHit',ammuraus,ammuraus_func)
				setElementInterior(ammuraus,6)
				setElementDimension(ammuraus,i)
			
				ammu1 = createMarker(287.39999389648,-109.59999847412,1000.5999755859,'cylinder',1,0,0,200)
				ammu2 = createMarker(287.39999389648,-106.30000305176,1000.5999755859,'cylinder',1,0,0,200)
				setElementInterior(ammu1,6)
				setElementInterior(ammu2,6)
				setElementDimension(ammu1,i)
				setElementDimension(ammu2,i)
					
				addEventHandler('onMarkerHit',ammu1,ammuWindow)
				addEventHandler('onMarkerHit',ammu2,ammuWindow)
			end,1500,1)
		end
	end)
end

function ammuraus_func(player)
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

function ammuWindow(player)
	if(getElementData(player,'Waffenschein') == 1)then
		triggerClientEvent(player,'ammuWindow',player)
	else
		getChatBox(player,36)
	end
end

function buyAmmunation(weapon,money,ammo)
	weapon = tonumber(weapon)
	money = tonumber(money)
	ammo = tonumber(ammo)

	if(getPlayerMoney(source) >= money)then
		takePlayerMoney(source,money)
		giveWeapon(source,weapon,ammo,true)
		getChatBox(player,34)
		updateEventkasse("einzahlen",money)
	else
		getChatBox(source,33)
	end
end
addEvent('buyAmmunation',true)
addEventHandler('buyAmmunation',root,buyAmmunation)

function weste(player)
	if(getPlayerMoney(player) >= 30)then
		takePlayerMoney(player,30)
		setPedArmor(player,100)
		getChatBox(player,35)
	else
		getChatBox(player,33)
	end
end
addEvent('weste',true)
addEventHandler('weste',root,weste)