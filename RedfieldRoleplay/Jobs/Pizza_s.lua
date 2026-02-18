local pizzaroller = {
[1] = createVehicle(448,2105.5,-1823.6999511719,13.199999809265,0,0,152),
[2] = createVehicle(448,2106.8000488281,-1823.6999511719,13.199999809265,0,0,152),
[3] = createVehicle(448,2108.1000976563,-1823.6999511719,13.199999809265,0,0,152),
[4] = createVehicle(448,2109.5,-1823.6999511719,13.199999809265,0,0,152),
[5] = createVehicle(448,2111,-1823.6999511719,13.199999809265,0,0,152),
[6] = createVehicle(448,2112.5,-1823.7998046875,13.199999809265,0,0,152),
[7] = createVehicle(448,2114,-1823.7998046875,13.199999809265,0,0,152),
[8] = createVehicle(448,2115.5,-1823.6999511719,13.199999809265,0,0,152),
[9] = createVehicle(448,2117,-1823.6999511719,13.199999809265,0,0,152),
[10] = createVehicle(448,2118.5,-1823.6999511719,13.199999809265,0,0,152),
}

for i = 1,#pizzaroller do
	setElementFrozen(pizzaroller[i],true)
	setVehicleColor(pizzaroller[i],150,0,0)
	setElementData(pizzaroller[i],'Benzin',100)
	setElementData(pizzaroller[i],'Besitzer','System')
	setVehicleEngineState(pizzaroller[i],false)
	
	addEventHandler('onVehicleExit',pizzaroller[i],function(player)
		respawnVehicle(pizzaroller[i]) 
		setVehicleEngineState(pizzaroller[i],false)
		setElementFrozen(pizzaroller[i],true)
		setElementPosition(player,2122.1867675781,-1823.1586914063,13.557378768921)
		triggerClientEvent(player,'destroyPizzaShit',player)
	end)
	
	addEventHandler('onVehicleStartEnter',pizzaroller[i],function(player)
		if(getElementData(player,'Job') == 'Pizzalieferant')then
			setElementFrozen(pizzaroller[i],false)
			triggerClientEvent(player,'startPizzaJob',player)
		else
			cancelEvent()
			getChatBox(player,84)
		end
	end)
end

local sultanpizza = {
[1] = createVehicle(560,2122,-1782.9000244141,13.199999809265,0,0,0),
[2] = createVehicle(560,2118.8999023438,-1782.9000244141,13.199999809265,0,0,0),
[3] = createVehicle(560,2115.8000488281,-1782.9000244141,13.199999809265,0,0,0),
[4] = createVehicle(560,2112.6999511719,-1782.9000244141,13.199999809265,0,0,0),
[5] = createVehicle(560,2109.5,-1782.9000244141,13.199999809265,0,0,0),
[6] = createVehicle(560,2106.3000488281,-1782.9000244141,13.199999809265,0,0,0),
[7] = createVehicle(560,2103,-1782.9000244141,13.199999809265,0,0,0),
}

for i = 1,#sultanpizza do
	setElementFrozen(sultanpizza[i],true)
	setVehicleColor(sultanpizza[i],150,0,0)
	setElementData(sultanpizza[i],'Benzin',100)
	setElementData(sultanpizza[i],'Besitzer','System')
	setVehicleEngineState(sultanpizza[i],false)
	pizza=createObject(1582,0,0,0)
	attachElements(pizza,sultanpizza[i],0,-0.2,0.8)
	
	addEventHandler('onVehicleExit',sultanpizza[i],function(player)
		respawnVehicle(sultanpizza[i]) 
		setVehicleEngineState(sultanpizza[i],false)
		setElementFrozen(sultanpizza[i],true)
		setElementPosition(player,2122.1867675781,-1823.1586914063,13.557378768921)
		triggerClientEvent(player,'destroyPizzaShit',player)
	end)
	
	addEventHandler('onVehicleStartEnter',sultanpizza[i],function(player)
		if(getElementData(player,'Job') == 'Pizzalieferant')then
			if(getElementData(player,"Pizzajobskills")>=200)then
				setElementFrozen(sultanpizza[i],false)
				triggerClientEvent(player,'startPizzaJob',player)
			else
				cancelEvent()
				getChatBox(player,137)
			end
		else
			cancelEvent()
			getChatBox(player,84)
		end
	end)
end

local lkwpizza = {
[1] = createVehicle(456,2126.2998046875,-1817.099609375,13.800000190735,0,0,0),
[2] = createVehicle(456,2126.3000488281,-1807.1999511719,13.800000190735,0,0,0),
[3] = createVehicle(456,2126.3000488281,-1797.4000244141,13.800000190735,0,0,0),
}

for i = 1,#lkwpizza do
	setElementFrozen(lkwpizza[i],true)
	setVehicleColor(lkwpizza[i],150,0,0)
	setElementData(lkwpizza[i],'Benzin',100)
	setElementData(lkwpizza[i],'Besitzer','System')
	setVehicleEngineState(lkwpizza[i],false)
	
	addEventHandler('onVehicleExit',lkwpizza[i],function(player)
		respawnVehicle(lkwpizza[i]) 
		setVehicleEngineState(lkwpizza[i],false)
		setElementFrozen(lkwpizza[i],true)
		setElementPosition(player,2122.1867675781,-1823.1586914063,13.557378768921)
		triggerClientEvent(player,'destroyPizzaShit',player)
	end)
	
	addEventHandler('onVehicleStartEnter',lkwpizza[i],function(player)
		if(getElementData(player,'Job') == 'Pizzalieferant')then
			if(getElementData(player,"Pizzajobskills")>=400)then
				setElementFrozen(lkwpizza[i],false)
				triggerClientEvent(player,'startPizzaJob',player)
			else
				cancelEvent()
				getChatBox(player,137)
			end
		else
			cancelEvent()
			getChatBox(player,84)
		end
	end)
end