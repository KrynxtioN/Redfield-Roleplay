local pizzaroller = {
	createVehicle(448,2105.5,-1823.6999511719,13.199999809265,0,0,152),
	createVehicle(448,2106.8000488281,-1823.6999511719,13.199999809265,0,0,152),
	createVehicle(448,2108.1000976563,-1823.6999511719,13.199999809265,0,0,152),
	createVehicle(448,2109.5,-1823.6999511719,13.199999809265,0,0,152),
	createVehicle(448,2111,-1823.6999511719,13.199999809265,0,0,152),
	createVehicle(448,2112.5,-1823.7998046875,13.199999809265,0,0,152),
	createVehicle(448,2114,-1823.7998046875,13.199999809265,0,0,152),
	createVehicle(448,2115.5,-1823.6999511719,13.199999809265,0,0,152),
	createVehicle(448,2117,-1823.6999511719,13.199999809265,0,0,152),
	createVehicle(448,2118.5,-1823.6999511719,13.199999809265,0,0,152),
}

local sultanpizza = {
	createVehicle(560,2122,-1782.9000244141,13.199999809265,0,0,0),
	createVehicle(560,2118.8999023438,-1782.9000244141,13.199999809265,0,0,0),
	createVehicle(560,2115.8000488281,-1782.9000244141,13.199999809265,0,0,0),
	createVehicle(560,2112.6999511719,-1782.9000244141,13.199999809265,0,0,0),
	createVehicle(560,2109.5,-1782.9000244141,13.199999809265,0,0,0),
	createVehicle(560,2106.3000488281,-1782.9000244141,13.199999809265,0,0,0),
	createVehicle(560,2103,-1782.9000244141,13.199999809265,0,0,0),
}

local lkwpizza = {
	createVehicle(456,2126.2998046875,-1817.099609375,13.800000190735,0,0,0),
	createVehicle(456,2126.3000488281,-1807.1999511719,13.800000190735,0,0,0),
	createVehicle(456,2126.3000488281,-1797.4000244141,13.800000190735,0,0,0),
}

local pizzaJobVehicles = {}
local pizzaJobType = {}
local pizzaJobPlayer = {}

local function setupPizzaVehicle(vehicle,jobType)
	setElementFrozen(vehicle,true)
	setVehicleColor(vehicle,150,0,0)
	setElementData(vehicle,"Benzin",100)
	setElementData(vehicle,"Besitzer","System")
	setVehicleEngineState(vehicle,false)

	pizzaJobVehicles[vehicle] = true
	pizzaJobType[vehicle] = jobType

	addEventHandler("onVehicleStartEnter",vehicle,function(player,seat)
		if seat ~= 0 then return end
		if getElementData(player,"loggedin") ~= 1 then
			cancelEvent()
			return
		end

		if getElementData(player,"Job") ~= "Pizzalieferant" then
			cancelEvent()
			infobox_func(player,getText(player,"Pizzajob6"),255,0)
			return
		end

		local skills = tonumber(getElementData(player,"Pizzajobskills")) or 0

		if jobType == 2 and skills < 200 then
			cancelEvent()
			infobox_func(player,getText(player,"Pizzajob7"),255,0)
			return
		end

		if jobType == 3 and skills < 400 then
			cancelEvent()
			infobox_func(player,getText(player,"Pizzajob7"),255,0)
			return
		end

		local currentPlayer = pizzaJobPlayer[vehicle]

		if isElement(currentPlayer) and currentPlayer ~= player then
			cancelEvent()
			return
		end

		setElementFrozen(vehicle,false)
		pizzaJobPlayer[vehicle] = player

		triggerClientEvent(player,"startPizzaJob",player)
	end)

	addEventHandler("onVehicleExit",vehicle,function(player,seat)
		if seat ~= 0 then return end

		if pizzaJobPlayer[vehicle] == player then
			pizzaJobPlayer[vehicle] = nil
		end

		triggerClientEvent(player,"destroyPizzaShit",player)

		respawnVehicle(vehicle)
		setVehicleEngineState(vehicle,false)
		setElementFrozen(vehicle,true)
		setElementData(vehicle,"Benzin",100)

		setElementPosition(player,2122.1867675781,-1823.1586914063,13.557378768921)
	end)

	addEventHandler("onVehicleExplode",vehicle,function()
		local player = pizzaJobPlayer[vehicle]

		if isElement(player) then
			triggerClientEvent(player,"destroyPizzaShit",player)
		end

		pizzaJobPlayer[vehicle] = nil

		setTimer(function(veh)
			if not isElement(veh) then return end

			respawnVehicle(veh)
			setVehicleEngineState(veh,false)
			setElementFrozen(veh,true)
			setElementData(veh,"Benzin",100)
		end,5000,1,vehicle)
	end)
end

for _,vehicle in ipairs(pizzaroller) do
	setupPizzaVehicle(vehicle,1)
end

for _,vehicle in ipairs(sultanpizza) do
	setupPizzaVehicle(vehicle,2)

	local pizza = createObject(1582,0,0,0)

	if isElement(pizza) then
		attachElements(pizza,vehicle,0,-0.2,0.8)
	end
end

for _,vehicle in ipairs(lkwpizza) do
	setupPizzaVehicle(vehicle,3)
end

addEvent("pizzaDeliveryFinished",true)
addEventHandler("pizzaDeliveryFinished",root,function()
	local player = client
	if not player or not isElement(player) then return end
	if getElementData(player,"loggedin") ~= 1 then return end
	if getElementData(player,"Job") ~= "Pizzalieferant" then return end

	local vehicle = getPedOccupiedVehicle(player)

	if not isElement(vehicle) then return end
	if getPedOccupiedVehicleSeat(player) ~= 0 then return end
	if not pizzaJobVehicles[vehicle] then return end
	if pizzaJobPlayer[vehicle] ~= player then return end

	local jobType = pizzaJobType[vehicle]
	local skills = tonumber(getElementData(player,"Pizzajobskills")) or 0
	local money = 0
	local skillPoints = 0

	if jobType == 1 then
		money = 25+math.random(5,10)
		skillPoints = 1
	elseif jobType == 2 then
		if skills < 200 then return end

		money = 75+math.random(5,10)
		skillPoints = 2
	elseif jobType == 3 then
		if skills < 400 then return end

		if skills < 600 then
			money = 250
		else
			money = 400
		end

		skillPoints = 3
	else
		return
	end

	giveJobMoney(player,money,skillPoints)

	infobox_func(player,getText(player,"Pizzajob5"):format(money),0,255,0)
end)

addEventHandler("onPlayerQuit",root,function()
	local vehicle = getPedOccupiedVehicle(source)

	if isElement(vehicle) and pizzaJobVehicles[vehicle] then
		pizzaJobPlayer[vehicle] = nil

		respawnVehicle(vehicle)
		setVehicleEngineState(vehicle,false)
		setElementFrozen(vehicle,true)
		setElementData(vehicle,"Benzin",100)
	end
end)

addEventHandler("onPlayerWasted",root,function()
	local vehicle = getPedOccupiedVehicle(source)

	if isElement(vehicle) and pizzaJobVehicles[vehicle] then
		pizzaJobPlayer[vehicle] = nil

		triggerClientEvent(source,"destroyPizzaShit",source)

		respawnVehicle(vehicle)
		setVehicleEngineState(vehicle,false)
		setElementFrozen(vehicle,true)
		setElementData(vehicle,"Benzin",100)
	end
end)