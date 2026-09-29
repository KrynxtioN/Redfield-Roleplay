local tankwartTankstellen = {
	{-1697.0087890625,405.01791381836,7.1796875},
	{-2408.8757324219,957.34521484375,45.301616668701},
	{-1346.6795654297,2678.4011230469,50.135066986084},
	{-739.54998779297,2731.6789550781,46.70006942749},
	{2163.8188476563,2749.224609375,10.8203125},
	{2200.775390625,2455.2509765625,10.671875},
	{2629.8090820313,1082.7493896484,10.8203125},
	{2125.3349609375,944.38836669922,10.8203125},
	{1582.0573730469,2198.515625,10.8203125},
	{990.40093994141,-920.96051025391,42.1796875},
	{1904.6497802734,-1778.0961914063,13.546875},
	{-83.688751220703,-1154.3907470703,1.75},
}

local tankjobMarker = nil
local tankjobBlip = nil

function destroyTankShit()
	if isElement(tankjobMarker) then
		destroyElement(tankjobMarker)
	end

	if isElement(tankjobBlip) then
		destroyElement(tankjobBlip)
	end

	tankjobMarker = nil
	tankjobBlip = nil
end
addEvent("destroyTankShit",true)
addEventHandler("destroyTankShit",root,destroyTankShit)

function createTankMarker()
	destroyTankShit()

	local tankstelle = tankwartTankstellen[math.random(1,#tankwartTankstellen)]

	tankjobMarker = createMarker(
		tankstelle[1],
		tankstelle[2],
		tankstelle[3],
		"checkpoint",
		3,
		255,
		0,
		0,
		150
	)

	tankjobBlip = createBlip(
		tankstelle[1],
		tankstelle[2],
		tankstelle[3],
		0,
		2,
		255,
		255,
		0
	)

	infobox(getText("Tankwart1"),0,255,0)

	addEventHandler("onClientMarkerHit",tankjobMarker,function(element)
		if element ~= localPlayer then return end

		local vehicle = getPedOccupiedVehicle(localPlayer)
		if not vehicle then return end
		if getPedOccupiedVehicleSeat(localPlayer) ~= 0 then return end

		triggerServerEvent("AnhaengerCheckTankWart",localPlayer)
	end)
end
addEvent("createTankMarker",true)
addEventHandler("createTankMarker",root,createTankMarker)

addEventHandler("onClientPlayerWasted",localPlayer,function()
	destroyTankShit()
end)