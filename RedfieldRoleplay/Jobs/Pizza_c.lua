local pizzarollerMarker = {
	{2072.46484375,-1628.9270019531,13.574811935425},
	{1906.880859375,-1119.0152587891,25.760608673096},
	{2087.1635742188,-1166.7205810547,25.420021057129},
	{2082.435546875,-1040.9230957031,31.833154678345},
	{2230.4477539063,-1284.3267822266,25.403818130493},
	{2194.5739746094,-1455.8148193359,25.565704345703},
	{2411.3530273438,-1547.0379638672,24.198656082153},
	{1936.1622314453,-1917.7857666016,15.056922912598},
	{995.24163818359,-1815.2902832031,14.210941314697},
	{1025.7010498047,-1772.2547607422,13.580114364624},
}

local sultanpizzaMarker = {
	{1152.8841552734,-1606.4869384766,13.810521125793},
	{1366.4842529297,-1087.8923339844,24.507755279541},
	{1260.0318603516,-1073.298828125,28.140007019043},
	{1517.7856445313,-1443.6898193359,13.419595718384},
	{1848.4799804688,-1928.0708007813,13.418472290039},
}

local yankeePizzaMarker = {
	{1320.2615966797,-871.27941894531,38.987380981445},
	{1026.5456542969,-916.0625,41.593036651611},
	{1339.8265380859,-1766.4556884766,12.940467834473},
}

local pizzabeladen = false
local beladenmarker = nil
local beladenblip = nil
local pizzaabgabemarker = nil
local pizzaabgabeblip = nil

function destroyPizzaDelivery()
	if isElement(pizzaabgabemarker) then
		destroyElement(pizzaabgabemarker)
	end

	if isElement(pizzaabgabeblip) then
		destroyElement(pizzaabgabeblip)
	end

	pizzaabgabemarker = nil
	pizzaabgabeblip = nil
end

function destroyPizzaShit()
	destroyPizzaDelivery()

	if isElement(beladenmarker) then
		destroyElement(beladenmarker)
	end

	if isElement(beladenblip) then
		destroyElement(beladenblip)
	end

	beladenmarker = nil
	beladenblip = nil
	pizzabeladen = false
end
addEvent("destroyPizzaShit",true)
addEventHandler("destroyPizzaShit",root,destroyPizzaShit)

function createPizzaDeliveryMarker(markerTable)
	destroyPizzaDelivery()

	local position = markerTable[math.random(1,#markerTable)]

	pizzaabgabemarker = createMarker(
		position[1],
		position[2],
		position[3],
		"checkpoint",
		2,
		255,
		0,
		0
	)

	pizzaabgabeblip = createBlip(
		position[1],
		position[2],
		position[3],
		0,
		2,
		255,
		255,
		0
	)

	addEventHandler("onClientMarkerHit",pizzaabgabemarker,function(hit)
		if hit ~= localPlayer then return end

		local vehicle = getPedOccupiedVehicle(localPlayer)

		if not vehicle then return end
		if getPedOccupiedVehicleSeat(localPlayer) ~= 0 then return end

		destroyPizzaDelivery()

		pizzabeladen = false

		infobox(getText("Pizzajob3"),0,255,0)

		triggerServerEvent("pizzaDeliveryFinished",localPlayer)
	end)
end

function startPizzaJob()
	destroyPizzaShit()

	infobox(getText("Pizzajob1"),0,255,0)

	beladenmarker = createMarker(
		2095.8999023438,
		-1805.5,
		12.60000038147,
		"cylinder",
		3,
		0,
		0,
		200
	)

	beladenblip = createBlip(
		2095.8999023438,
		-1805.5,
		12.60000038147,
		0,
		2,
		0,
		255,
		0
	)

	addEventHandler("onClientMarkerHit",beladenmarker,function(hit)
		if hit ~= localPlayer then return end

		local vehicle = getPedOccupiedVehicle(localPlayer)

		if not vehicle then return end
		if getPedOccupiedVehicleSeat(localPlayer) ~= 0 then return end

		if pizzabeladen then
			infobox(getText("Pizzajob4"),255,0,0)
			return
		end

		local skills = tonumber(getElementData(localPlayer,"Pizzajobskills")) or 0

		pizzabeladen = true

		infobox(getText("Pizzajob2"),0,255,0)

		if skills < 200 then
			createPizzaDeliveryMarker(pizzarollerMarker)
		elseif skills < 400 then
			createPizzaDeliveryMarker(sultanpizzaMarker)
		else
			createPizzaDeliveryMarker(yankeePizzaMarker)
		end
	end)
end
addEvent("startPizzaJob",true)
addEventHandler("startPizzaJob",root,startPizzaJob)

addEventHandler("onClientPlayerWasted",localPlayer,function()
	destroyPizzaShit()
end)