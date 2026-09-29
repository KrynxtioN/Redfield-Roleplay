Ammunation = {Marker_Enter = {}, Marker_Leave = {}, Marker_Buy1 = {}, Marker_Buy2 = {}, Ped = {},
	["Marker"] = {
		{-316.16064453125,829.91748046875,14.2421875},
		{776.73138427734,1871.3670654297,4.9063653945923},
		{2539.5424804688,2083.9372558594,10.8203125},
		{2159.5427246094,943.11407470703,10.8203125},
		{-1508.8822021484,2610.6958007813,55.8359375},
		{-2625.8186035156,208.25175476074,4.8125},
		{243.29010009766,-178.36006164551,1.5821628570557},
		{1368.9987792969,-1279.5389404297,13.546875},
		{2400.4089355469,-1981.9901123047,13.546875},
	},
}

local Ammo_Price = {
	["deagle"] = {24,250,14},
	["mp5"] = {29,900,90},
	["m4"] = {31,1500,200},
	["rifle"] = {33,1200,30},
	["shotgun"] = {25,300,20},
	["uzi"] = {28,1000,300},
	["ak47"] = {30,1800,150}
}

for i,v in ipairs(Ammunation["Marker"])do
	Ammunation.Marker_Enter[i] = createPickup(v[1],v[2],v[3],3,1318,50)
	setElementData(Ammunation.Marker_Enter[i],"ID",i)
	
	Ammunation.Marker_Buy1[i] = createMarker(287.39999389648,-109.59999847412,1000.5999755859,"cylinder",1,255,255,255,100)
	Ammunation.Marker_Buy2[i] = createMarker(287.39999389648,-106.30000305176,1000.5999755859,"cylinder",1,255,255,255,100)
	setElementInterior(Ammunation.Marker_Buy1[i],6)
	setElementInterior(Ammunation.Marker_Buy2[i],6)
	setElementDimension(Ammunation.Marker_Buy1[i],i)
	setElementDimension(Ammunation.Marker_Buy2[i],i)
	
	Ammunation.Marker_Leave[i] = createPickup(296.83898925781,-112.06053924561,1001.515625,3,1318,50)
	setElementInterior(Ammunation.Marker_Leave[i],6)
	setElementDimension(Ammunation.Marker_Leave[i],i)
	
	addEventHandler("onPickupHit",Ammunation.Marker_Enter[i],function(player)
		if(not(isPedInVehicle(player)))then
			if(getElementDimension(player) == getElementDimension(source))then
				triggerClientEvent(player,"ladeBalken",player)
			
				local x,y,z = getElementPosition(player)
				setElementData(player,'saveposx',x)
				setElementData(player,'saveposy',y)
				setElementData(player,'saveposz',z)
				
				setTimer(function(player,marker)
					if(isElement(player))then
						setElementPosition(player,296.89999389648,-110.30000305176,1001.5)
						setElementRotation(player,0,0,180)
						setElementInterior(player,6)
						setElementDimension(player,i)
					end
				end,1500,1,player,source)
			end
		end
	end)
	
	addEventHandler("onPickupHit",Ammunation.Marker_Leave[i],function(player)
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
	
	addEventHandler("onMarkerHit",Ammunation.Marker_Buy1[i],function(player)
		if(not(isPedInVehicle(player)))then
			if(getElementDimension(player) == getElementDimension(source))then
				if(getElementData(player,"Waffenschein") == 1)then
					triggerClientEvent(player,"ammuWindow",player)
				else
					infobox_func(player,getText("Ammunation1"),255,0,0)
				end
			end
		end
	end)
end

function buyAmmunation(gun)
	local weapon = Ammo_Price[gun][1]
	local money = Ammo_Price[gun][2]
	local ammo = Ammo_Price[gun][3]

	if(tonumber(getElementData(client,"Money")) >= money)then
		setElementData(client,"Money",tonumber(getElementData(client,"Money"))-money)
		giveWeapon(client,weapon,ammo,true)
		infobox_func(client,getText(client,"Ammunation3"),0,255,0)
		updateEventkasse("einzahlen",money)
	else
		infobox_func(client,getText(client,"Ammunation2"),255,0,0)
	end
end
addEvent('buyAmmunation',true)
addEventHandler('buyAmmunation',root,buyAmmunation)

function weste()
	if(tonumber(getElementData(client,"Money")) >= money)then
		setElementData(client,"Money",tonumber(getElementData(client,"Money"))-30)
		setPedArmor(client,100)
		infobox_func(client,getText(client,"Ammunation4"),0,255,0)
	else
		infobox_func(client,getText(client,"Ammunation2"),0,255,0)
	end
end
addEvent('weste',true)
addEventHandler('weste',root,weste)