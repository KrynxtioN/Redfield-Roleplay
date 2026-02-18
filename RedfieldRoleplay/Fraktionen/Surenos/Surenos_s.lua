local surenosCars = {

[1] = createVehicle(567,-386.900390625,2199.6005859375,42.400001525879,0,0,280),
[2] = createVehicle(567,-395.20001220703,2198,42.400001525879,0,0,280),
[3] = createVehicle(534,-356,2218,42.299999237061,0,0,90),
[4] = createVehicle(482,-373.099609375,2232.400390625,42.700000762939,0,0,174),
[5] = createVehicle(482,-370.10000610352,2233.5,42.700000762939,0,0,174),
[6] = createVehicle(482,-360.5,2237.6000976563,42.700000762939,0,0,144),
[7] = createVehicle(482,-359.20001220703,2234.3000488281,42.700000762939,0,0,144),
[8] = createVehicle(468,-391.40350341797,2232.5014648438,42.481899261475,0,0,0),
[9] = createVehicle(468,-392.67910766602,2232.318359375,42.483444213867,0,0,0),
[10] = createVehicle(468,-394.21148681641,2231.8337402344,42.48482131958,0,0,0),

}

for i=1,#surenosCars do
	setElementData(surenosCars[i],'Benzin',100)
	setElementData(surenosCars[i],'Besitzer','Surenos')
	setVehiclePlateText(surenosCars[i],'Surenos')
	setVehicleColor(surenosCars[i],200,200,0)
	setElementFrozen(surenosCars[i],true)
	
	addEventHandler('onVehicleStartEnter',surenosCars[i],function(player)
		if(not(isSurenos(player)))then
			cancelEvent()
			getChatBox(player,84)
		else
			setElementFrozen(surenosCars[i],false)
		end
	end)
end

local surenosIn = createPickup(-376.91302490234,2242.3215332031,42.618461608887,3,1318,50)
local surenosOut = createPickup(318.62072753906,1114.4799804688,1083.8828125,3,1318,50)
setElementInterior(surenosOut,5)

addEventHandler('onPickupHit',surenosIn,function(player)
	if(isSurenos(player))then
		triggerClientEvent(player,"ladeBalken",player)
		setTimer(function()
			setElementPosition(player,318.60000610352,1116.8000488281,1083.9000244141)
			setPedRotation(player,0)
			setElementInterior(player,5)
		end,1500,1)
	end
end)
addEventHandler('onPickupHit',surenosOut,function(player)
	triggerClientEvent(player,"ladeBalken",player)
	setTimer(function()
		setElementPosition(player,-378,2242,42.599998474121)
		setPedRotation(player,108)
		setElementInterior(player,0)
	end,1500,1)
end)