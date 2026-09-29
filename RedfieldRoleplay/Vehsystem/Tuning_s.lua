setGarageOpen(7,true)
setGarageOpen(10,true)
setGarageOpen(15,true)
setGarageOpen(18,true)
setGarageOpen(33,true)

local tuning1 = createMarker(2644.9609375,-2045.8447265625,12.640233039856,"cylinder",3,0,0,200)
local tuning2 = createMarker(1041.7705078125,-1012.9990234375,31.080799102783,"cylinder",3,0,0,200)
local tuning3 = createMarker(2386.48828125,1051.6982421875,8.9280261993408,"cylinder",3,0,0,200)
local tuning4 = createMarker(-2725.255859375,217.642578125,2.484375,"cylinder",3,0,0,200)
local tuning5 = createMarker(-1935.8095703125,246.93359375,33.4609375,"cylinder",3,0,0,200)

function createTuningWindow(hitElement)
	if getElementType(hitElement) ~= "player" then return end
	if not isPedInVehicle(hitElement) then return end
	if getPedOccupiedVehicleSeat(hitElement) ~= 0 then return end

	local veh = getPedOccupiedVehicle(hitElement)
	if not isElement(veh) then return end

	local besitzer = getElementData(veh,"Besitzer")
	local slot = getElementData(veh,"Slot")

	if not besitzer or not slot then
		infobox_func(hitElement,getText(hitElement,"Tuning1"),255,0,0)
		return
	end
	if besitzer ~= getPlayerName(hitElement) then
		infobox_func(hitElement,getText(hitElement,"Tuning1"),255,0,0)
		return
	end

	triggerClientEvent(hitElement,"openTuningWindow",hitElement)
end
addEventHandler("onMarkerHit",tuning1,createTuningWindow)
addEventHandler("onMarkerHit",tuning2,createTuningWindow)
addEventHandler("onMarkerHit",tuning3,createTuningWindow)
addEventHandler("onMarkerHit",tuning4,createTuningWindow)
addEventHandler("onMarkerHit",tuning5,createTuningWindow)

addEvent("changeColor",true)
addEventHandler("changeColor",root,function(r,g,b)
	if not client or not isElement(client) then return end
	if not isPedInVehicle(client) then return end
	if getPedOccupiedVehicleSeat(client) ~= 0 then return end

	local veh = getPedOccupiedVehicle(client)
	if not isElement(veh) then return end

	local besitzer = getElementData(veh,"Besitzer")
	local slot = getElementData(veh,"Slot")

	if not besitzer or not slot then return end
	if besitzer ~= getPlayerName(client) then return end

	r = tonumber(r)
	g = tonumber(g)
	b = tonumber(b)

	if not r or not g or not b then return end

	r = math.floor(math.max(0,math.min(255,r)))
	g = math.floor(math.max(0,math.min(255,g)))
	b = math.floor(math.max(0,math.min(255,b)))

	setVehicleColor(veh,r,g,b)

	setCarData(besitzer,slot,"R",r)
	setCarData(besitzer,slot,"G",g)
	setCarData(besitzer,slot,"B",b)
end)