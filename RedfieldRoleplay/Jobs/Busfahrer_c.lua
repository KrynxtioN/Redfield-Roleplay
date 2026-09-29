local busfahrerMarker = {
	{-29.832874298096,1201.1043701172,19.21614074707,false},
	{-145.9149017334,1201.0035400391,19.600311279297,false},
	{-210.1748046875,1201.5344238281,19.596260070801,true},
	{-273.29379272461,1197.9653320313,19.599969863892,false},
	{-277.41171264648,1110.9799804688,19.594045639038,false},
	{-314.68103027344,1101.0450439453,19.595317840576,false},
	{-319.04330444336,1081.3393554688,19.593879699707,true},
	{-289.05770874023,1060.9708251953,19.596710205078,false},
	{-274.65396118164,1020.4541625977,19.596899032593,false},
	{-205.89993286133,1015.41015625,19.589206695557,false},
	{-187.5,1084.7998046875,19.60000038147,false},
	{-79.400390625,1095.7001953125,19.60000038147,false},
	{-9.8000001907349,1096.1999511719,19.60000038147,false},
	{31.799999237061,1119.9000244141,19.60000038147,true},
	{16.723217010498,1150.7191162109,19.59375,false},
	{-62.89391708374,1174.2985839844,19.581422805786,false},
	{12.507538795471,1195.9011230469,19.189804077148,false},
	{107.31144714355,1195.1121826172,18.220653533936,false},
	{175.99220275879,1143.2995605469,14.231485366821,false},
	{297.02093505859,1253.6958007813,14.832268714905,false},
	{411.03948974609,1589.5395507813,17.820465087891,false},
	{626.40679931641,1738.4890136719,5.4139337539673,false},
	{656.19427490234,1828.5078125,5.46875,true},
	{660.33343505859,1860.3422851563,5.46875,false},
	{803.23596191406,1812.4262695313,3.9152269363403,false},
	{848.96398925781,1645.2437744141,8.5847854614258,false},
	{774.23455810547,1456.9074707031,20.24641418457,false},
	{823.75543212891,1239.7489013672,26.71692276001,false},
	{650.71783447266,1090.625,28.335670471191,false},
	{533.07818603516,1058.7810058594,28.333106994629,true},
	{241.16339111328,980.18579101563,28.194452285767,false},
	{94.439300537109,890.42535400391,22.759346008301,false},
	{-130.38558959961,824.37438964844,20.952310562134,true},
	{-246.51998901367,790.83428955078,17.547149658203,false},
	{-278.94030761719,798.66857910156,15.204532623291,true},
	{-234.87748718262,842.9404296875,12.279434204102,false},
	{-190.3243560791,966.65600585938,18.156667709351,false},
	{-188.01657104492,1195.8626708984,19.543041229248,false},
	{-0.60268729925156,1211.8502197266,19.352746963501,false},
}

local buspoints = 0
local busmarker = nil
local busblip = nil
local bustime = 0
local busTimer = nil
local x,y = guiGetScreenSize()

function renderBus()
	dxDrawText(getText("Busjob5"):format(bustime),449*(x/1440),385*(y/900),959*(x/1440),508*(y/900),tocolor(254,0,0,255),3.00,"default-bold","center","center",false,false,false,false,false)
end

function showBusTimer()
	if isTimer(busTimer) then killTimer(busTimer) end
	removeEventHandler("onClientRender",root,renderBus)
	bustime = 7
	addEventHandler("onClientRender",root,renderBus)
	busTimer = setTimer(function()
		bustime = bustime-1
		if bustime <= 0 then
			bustime = 0
			removeEventHandler("onClientRender",root,renderBus)
		end
	end,1000,7)
end

function startBusfahrer()
	if isElement(busmarker) then destroyElement(busmarker) end
	if isElement(busblip) then destroyElement(busblip) end
	busmarker = nil
	busblip = nil
	buspoints = buspoints+1
	if buspoints > #busfahrerMarker then
		triggerServerEvent("busJobFinished",localPlayer)
		return
	end
	local point = buspoints
	local data = busfahrerMarker[point]
	busmarker = createMarker(data[1],data[2],data[3],"checkpoint",2,200,0,0)
	busblip = createBlip(data[1],data[2],data[3],0,2,255,0,0)
	addEventHandler("onClientMarkerHit",busmarker,function(player)
		if player ~= localPlayer then return end
		local vehicle = getPedOccupiedVehicle(localPlayer)
		if not vehicle or getPedOccupiedVehicleSeat(localPlayer) ~= 0 then return end
		if isElement(busmarker) then destroyElement(busmarker) end
		if isElement(busblip) then destroyElement(busblip) end
		busmarker = nil
		busblip = nil
		triggerServerEvent("busMarkerReached",localPlayer,point)
		if data[4] == true then
			triggerServerEvent("frozePlayer",localPlayer,point)
			showBusTimer()
		end
		startBusfahrer()
	end)
end

addEvent("startBusfahrerMarker",true)
addEventHandler("startBusfahrerMarker",root,function()
	buspoints = 0
	startBusfahrer()
end)

function destroyBusShit()
	if isElement(busmarker) then destroyElement(busmarker) end
	if isElement(busblip) then destroyElement(busblip) end
	if isTimer(busTimer) then killTimer(busTimer) end
	busmarker = nil
	busblip = nil
	buspoints = 0
	bustime = 0
	removeEventHandler("onClientRender",root,renderBus)
end
addEvent("destroyBusShit",true)
addEventHandler("destroyBusShit",root,destroyBusShit)

addEventHandler("onClientPlayerWasted",localPlayer,function()
	destroyBusShit()
end)