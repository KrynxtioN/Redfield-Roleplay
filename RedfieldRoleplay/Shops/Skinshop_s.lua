local skinshopInterior={
[1] = createPickup(461.39999389648,-1500.8000488281,31.04588508606,3,1318,50),
[2] = createPickup(477.42919921875,-1534.5981445313,19.669803619385,3,1318,50),
[3] = createPickup(499.48403930664,-1360.6166992188,16.369129180908,3,1318,50),
[4] = createPickup(2244.2758789063,-1665.5360107422,15.4765625,3,1318,50),
[5] = createPickup(-1882.2955322266,866.54260253906,35.171875,3,1318,50),
[6] = createPickup(-1694.5063476563,951.84637451172,24.890625,3,1318,50),
[7] = createPickup(-2373.7780761719,910.11846923828,45.4453125,3,1318,50),
[8] = createPickup(2112.9284667969,-1211.4588623047,23.962869644165,3,1318,50),
[9] = createPickup(-2489.861328125,-29.028966903687,25.6171875,3,1318,50),
[10] = createPickup(2779.8171386719,2453.8310546875,11.0625,3,1318,50),
[11] = createPickup(2802.9311523438,2430.7153320313,11.0625,3,1318,50),
[12] = createPickup(1657.0363769531,1733.3309326172,10.82811164856,3,1318,50),
[13] = createPickup(2101.8933105469,2257.4916992188,11.0234375,3,1318,50),
[14] = createPickup(-206.18521118164,1062.2905273438,19.7421875,3,1318,50),
}

for i,gointoskinshop in pairs(skinshopInterior)do
	addEventHandler('onPickupHit',gointoskinshop,function(player)
		triggerClientEvent(player,"ladeBalken",player)
		
		local x,y,z = getElementPosition(player)
		setElementData(player,'saveposx',x)
		setElementData(player,'saveposy',y)
		setElementData(player,'saveposz',z)
		
		setTimer(function()
			setElementPosition(player,225.03228759766,-8.1898946762085,1002.2109375)
			setPedRotation(player,0)
			setElementInterior(player,5)
			setElementDimension(player,i)
			
			skinmarkerLeave=createPickup(227.56288146973,-8.089524269104,1002.2109375,3,1318,50)
			setElementInterior(skinmarkerLeave,5)
			setElementDimension(skinmarkerLeave,i)
			skinmarkerKaufen=createPickup(206.38053894043,-7.6360974311829,1001.2109375,3,1239,50)
			setElementInterior(skinmarkerKaufen,5)
			setElementDimension(skinmarkerKaufen,i)
			
			addEventHandler('onPickupHit',skinmarkerLeave,skinshop_leave)
			addEventHandler('onPickupHit',skinmarkerKaufen,skinshop_open)
		end,1500,1)
	end)
end

function skinshop_leave(player)
	setElementPosition(player,getElementData(player,'saveposx'),getElementData(player,'saveposy'),getElementData(player,'saveposz'))
	setElementDimension(player,0)
	setElementInterior(player,0)
	setElementData(player,'saveposx',nil)
	setElementData(player,'saveposy',nil)
	setElementData(player,'saveposz',nil)
end

function skinshop_open(player)
	triggerClientEvent(player,'open_skinshop',player)
end

addEvent('skinchange',true)
addEventHandler('skinchange',root,function(player,skinid,preis)
	setCameraTarget(player,player)
	local skinid = tonumber(skinid)
	local preis = tonumber(preis)
	setElementPosition(player,204.2998046875,-12.3447265625,1001.2109375)
	setCameraTarget(player,player)
	if(getPlayerMoney(player) >= preis)then
		takePlayerMoney(player,preis)
		setElementData(player,'Skin',skinid)
		setElementModel(player,skinid)
		updateEventkasse("einzahlen",preis)
		
		if(getElementData(player,'AchUmgezogen') == 0)then
			setElementData(player,'AchUmgezogen',1)
			achievmentInfo(player)
		end
	else 
		getChatBox(player,33)
	end
end)

addEvent('dont_skinbuy',true)
addEventHandler('dont_skinbuy',root,function(player)
	triggerClientEvent(player,"ladeBalken",player)
	setTimer(function()
		setElementPosition(player,204.2998046875,-12.3447265625,1001.2109375)
		setCameraTarget(player,player)
	end,1500,1)
end)