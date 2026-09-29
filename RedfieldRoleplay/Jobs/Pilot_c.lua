local flugplatzSauberMarker = {
	{-1491.1293945313,-221.15892028809,13.557952880859},
	{-1555.1639404297,-244.6473236084,13.559743881226},
	{-1637.3319091797,-238.22178649902,13.560585975647},
	{-1683.5029296875,-301.07312011719,13.557741165161},
	{-1705.1813964844,-430.07208251953,13.560558319092},
	{-1525.6856689453,-137.07530212402,13.558176994324},
	{-1437.9652099609,-91.385696411133,13.55957698822},
	{-1320.8251953125,-2.3044383525848,13.559787750244},
	{-1242.8430175781,-87.484077453613,13.560363769531},
	{-1145.7778320313,-131.91790771484,13.556604385376},
	{-1127.0167236328,-215.68975830078,13.558168411255},
	{-1146.3059082031,-329.31591796875,13.560150146484},
	{-1187.0684814453,-447.8098449707,13.560238838196},
	{-1258.84765625,-377.52697753906,13.560171127319},
	{-1316.6643066406,-470.6213684082,13.557686805725},
	{-1291.9415283203,-619.67913818359,13.556175231934},
	{-1330.638671875,-567.09423828125,13.560284614563},
	{-1405.2573242188,-557.14880371094,13.560079574585},
	{-1423.9660644531,-636.02209472656,13.560165405273},
	{-1537.0017089844,-617.48815917969,13.560934066772},
	{-1577.8197021484,-662.00183105469,13.558123588562},
	{-1617.8640136719,-606.83514404297,13.558015823364},
	{-1576.6229248047,-595.05181884766,13.56067276001},
	{-1503.7856445313,-567.00677490234,13.555177688599},
	{-1434.3331298828,-564.27386474609,13.559641838074},
	{-1323.46484375,-511.42138671875,13.55920791626},
	{-1290.8989257813,-418.89004516602,13.559827804565},
	{-1315.7467041016,-274.62594604492,13.560626983643},
	{-1414.7044677734,-174.61383056641,13.560144424438},
}

local landebahnVorbereiten = {
	{-1662.3355712891,-154.80267333984,14.119033813477},
	{-1565.2664794922,-58.635864257813,14.119012832642},
	{-1448.2554931641,55.879875183105,14.119013786316},
	{-1354.2351074219,152.01777648926,14.119022369385},
	{-1244.5471191406,262.61349487305,14.119017601013},
	{-1113.3146972656,391.01541137695,14.119247436523},
	{-1177.7540283203,303.32537841797,14.119029998779},
	{-1292.9724121094,189.14904785156,14.119024276733},
	{-1405.171875,78.024932861328,14.111454963684},
	{-1513.5699462891,-31.623069763184,14.11902141571},
	{-1627.9964599609,-149.04156494141,14.114906311035},
}

local duengerSpruehen = {
	{-245.45790100098,162.22663879395,191.7109375},
	{19.971717834473,46.362907409668,139.85939025879},
	{-177.25787353516,-17.686307907104,40.414638519287},
	{-201.72590637207,187.7310333252,27.868333816528},
	{25.002155303955,-121.80913543701,19.431457519531},
	{-19.08371925354,46.242828369141,51.267459869385},
}

local flughafenMarker = {
	{1740,-2493.8999023438,15.39999961853},
	{1430.0999755859,1462.9000244141,12.300000190735},
	{387.70001220703,2502.5,17.89999961853},
}

local pilotabgabemarker = nil
local pilotabgabeblip = nil
local currentPilotMission = nil

local function destroyPilotMarker()
	if isElement(pilotabgabemarker) then
		destroyElement(pilotabgabemarker)
	end

	if isElement(pilotabgabeblip) then
		destroyElement(pilotabgabeblip)
	end

	pilotabgabemarker = nil
	pilotabgabeblip = nil
end

local function createPilotMarker(markerTable,markerType,size,blipR,blipG,blipB)
	destroyPilotMarker()

	local position = markerTable[math.random(1,#markerTable)]

	pilotabgabemarker = createMarker(
		position[1],
		position[2],
		position[3],
		markerType,
		size,
		255,0,0
	)

	pilotabgabeblip = createBlip(
		position[1],
		position[2],
		position[3],
		0,
		2,
		blipR,
		blipG,
		blipB
	)

	triggerServerEvent(
		"pilotSetTarget",
		localPlayer,
		position[1],
		position[2],
		position[3]
	)

	addEventHandler("onClientMarkerHit",pilotabgabemarker,function(hit)
		if hit ~= localPlayer then return end

		local vehicle = getPedOccupiedVehicle(localPlayer)

		if not vehicle then return end
		if getPedOccupiedVehicleSeat(localPlayer) ~= 0 then return end

		destroyPilotMarker()

		triggerServerEvent("pilotMarkerReached",localPlayer)
	end)
end

function flugplatzsaubermachen_func()
	currentPilotMission = 1
	createPilotMarker(flugplatzSauberMarker,"checkpoint",2,255,0,0)
end
addEvent("flugplatzsaubermachen_func",true)
addEventHandler("flugplatzsaubermachen_func",root,flugplatzsaubermachen_func)

function landebahnvorbereiten_func()
	currentPilotMission = 2
	createPilotMarker(landebahnVorbereiten,"checkpoint",2,255,0,0)
end
addEvent("landebahnvorbereiten_func",true)
addEventHandler("landebahnvorbereiten_func",root,landebahnvorbereiten_func)

function flugbahnkontrollieren_func()
	currentPilotMission = 3
	createPilotMarker(landebahnVorbereiten,"checkpoint",2,255,0,0)
end
addEvent("flugbahnkontrollieren_func",true)
addEventHandler("flugbahnkontrollieren_func",root,flugbahnkontrollieren_func)

function duengerspruehen_func()
	currentPilotMission = 4
	createPilotMarker(duengerSpruehen,"ring",5,255,0,0)
end
addEvent("duengerspruehen_func",true)
addEventHandler("duengerspruehen_func",root,duengerspruehen_func)

function flughafenmarker_func()
	currentPilotMission = 5

	local flughafen = math.random(1,#flughafenMarker)
	local position = flughafenMarker[flughafen]

	if flughafen == 1 then
		infobox(getText("Pilot8"),0,255,0)
	elseif flughafen == 2 then
		infobox(getText("Pilot9"),0,255,0)
	else
		infobox(getText("Pilot10"),0,255,0)
	end

	createPilotMarker({position},"ring",8,255,255,0)
end
addEvent("flughafenmarker_func",true)
addEventHandler("flughafenmarker_func",root,flughafenmarker_func)

addEvent("pilotCreateNextMarker",true)
addEventHandler("pilotCreateNextMarker",root,function(mission)
	mission = tonumber(mission)

	if mission == 1 then
		flugplatzsaubermachen_func()
	elseif mission == 2 then
		landebahnvorbereiten_func()
	elseif mission == 3 then
		flugbahnkontrollieren_func()
	elseif mission == 4 then
		duengerspruehen_func()
	end
end)

function stopPilotJob()
	destroyPilotMarker()
	currentPilotMission = nil
end
addEvent("stopPilotJob",true)
addEventHandler("stopPilotJob",root,stopPilotJob)

addEventHandler("onClientPlayerWasted",localPlayer,function()
	stopPilotJob()
end)