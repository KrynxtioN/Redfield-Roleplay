Skinshop = {Marker_Enter = {}, Marker_Leave = {}, Marker_Buy = {}, Ped = {},
	["Marker"] = {
		{461.39999389648,-1500.8000488281,31.04588508606},
		{477.42919921875,-1534.5981445313,19.669803619385},
		{499.48403930664,-1360.6166992188,16.369129180908},
		{2244.2758789063,-1665.5360107422,15.4765625},
		{-1882.2955322266,866.54260253906,35.171875},
		{-1694.5063476563,951.84637451172,24.890625},
		{-2373.7780761719,910.11846923828,45.4453125},
		{2112.9284667969,-1211.4588623047,23.962869644165},
		{-2489.861328125,-29.028966903687,25.6171875},
		{2779.8171386719,2453.8310546875,11.0625},
		{2802.9311523438,2430.7153320313,11.0625},
		{1657.0363769531,1733.3309326172,10.82811164856},
		{2101.8933105469,2257.4916992188,11.0234375},
		{-206.18521118164,1062.2905273438,19.7421875},
	},
}

local Skin_Price = {
	[0] = 500,
	[1] = 500,
	[2] = 1000,
	[3] = 500,
	[4] = 500,
	[5] = 600,
	[6] = 500,
	[7] = 500,
	[8] = 500,
	[9] = 500,
	[10] = 500,
	[11] = 500,
	[12] = 500,
	[13] = 500,
	[14] = 500,
	[15] = 500,
	[16] = 500,
	[17] = 500,
	[18] = 500,
	[19] = 500,
	[20] = 500,
	[21] = 200,
	[22] = 200,
	[23] = 500,
	[24] = 500,
	[25] = 88,
	[26] = 500,
	[27] = 500,
	[28] = 500,
	[29] = 500,
	[30] = 500,
	[31] = 200,
	[32] = 200,
	[33] = 200,
	[34] = 500,
	[35] = 500,
	[36] = 500,
	[37] = 500,
	[38] = 500,
	[39] = 200,
	[40] = 200,
	[41] = 200,
	[42] = 500,
	[43] = 500,
	[44] = 500,
	[45] = 500,
	[46] = 500,
	[47] = 1000,
	[48] = 600,
	[49] = 500,
	[50] = 500,
}

for i,v in ipairs(Skinshop["Marker"])do
	Skinshop.Marker_Enter[i] = createPickup(v[1],v[2],v[3],3,1318,50)
	setElementData(Skinshop.Marker_Enter[i],"ID",i)
	Skinshop.Ped[i] = createPed(181,498.10000610352,-77.5,998.79998779297)
	setElementRotation(Skinshop.Ped[i],0,0,0)
	setElementInterior(Skinshop.Ped[i],5)
	setElementDimension(Skinshop.Ped[i],i)

	Skinshop.Marker_Leave[i] = createPickup(227.56288146973,-8.089524269104,1002.2109375,3,1318,50)
	setElementInterior(Skinshop.Marker_Leave[i],5)
	setElementDimension(Skinshop.Marker_Leave[i],i)

	Skinshop.Marker_Buy[i] = createMarker(206.38053894043,-7.6360974311829,1001.2109375,"cylinder",1,255,255,255,100)
	setElementInterior(Skinshop.Marker_Buy[i],5)
	setElementDimension(Skinshop.Marker_Buy[i],i)

	addEventHandler("onPickupHit",Skinshop.Marker_Enter[i],function(player)
		if not isPedInVehicle(player) then
			if getElementDimension(player) == getElementDimension(source) then
				triggerClientEvent(player,"ladeBalken",player)
				local x,y,z = getElementPosition(player)
				setElementData(player,"saveposx",x)
				setElementData(player,"saveposy",y)
				setElementData(player,"saveposz",z)

				setTimer(function(player,marker)
					if isElement(player) then
						setElementPosition(player,225.03228759766,-8.1898946762085,1002.2109375)
						setElementRotation(player,0,0,0)
						setElementInterior(player,5)
						setElementDimension(player,getElementData(marker,"ID"))
					end
				end,1500,1,player,source)
			end
		end
	end)

	addEventHandler("onPickupHit",Skinshop.Marker_Leave[i],function(player)
		if not isPedInVehicle(player) then
			if getElementDimension(player) == getElementDimension(source) then
				triggerClientEvent(player,"ladeBalken",player)

				setTimer(function(player)
					if isElement(player) then
						setElementPosition(player,getElementData(player,"saveposx"),getElementData(player,"saveposy"),getElementData(player,"saveposz"))
						setElementDimension(player,0)
						setElementInterior(player,0)
						setElementData(player,"saveposx",nil)
						setElementData(player,"saveposy",nil)
						setElementData(player,"saveposz",nil)
					end
				end,1500,1,player)
			end
		end
	end)

	addEventHandler("onMarkerHit",Skinshop.Marker_Buy[i],function(player)
		if not isPedInVehicle(player) then
			if getElementDimension(player) == getElementDimension(source) then
				triggerClientEvent(player,"open_skinshop",player)
			end
		end
	end)
end

addEvent("skinchange",true)
addEventHandler("skinchange",root,function(skinid,index)
	skinid = tonumber(skinid)
	index = tonumber(index)
	if not skinid or not index or not Skin_Price[index] then return end

	local price = Skin_Price[index]
	local money = tonumber(getElementData(client,"Money")) or 0
	setCameraTarget(client,client)

	if money >= price then
		setElementData(client,"Money",money-price)
		setElementPosition(client,204.2998046875,-12.3447265625,1001.2109375)
		setElementRotation(client,0,0,0)
		setElementData(client,"Skin",skinid)
		setElementModel(client,skinid)

		if getElementData(client,"AchUmgezogen") == 0 then
			setElementData(client,"AchUmgezogen",1)
			achievementInfo(client)
		end
	else
		infobox_func(client,getText(client,"Skinshop1"),255,0,0)
	end
end)

addEvent("dont_skinbuy",true)
addEventHandler("dont_skinbuy",root,function()
	triggerClientEvent(client,"ladeBalken",client)
	setTimer(function(player)
		if isElement(player) then
			setCameraTarget(player,player)
			setElementPosition(player,204.2998046875,-12.3447265625,1001.2109375)
			setElementRotation(player,0,0,0)
		end
	end,1500,1,client)
end)