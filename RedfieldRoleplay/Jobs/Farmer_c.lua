local cows = {
	{-1116.3000488281,-1258.5,128.30000305176},
	{-1116.0999755859,-1267.4000244141,128.30000305176},
	{-1117.1999511719,-1280.5,128.30000305176},
	{-1100.4000244141,-1258.4000244141,128.30000305176},
	{-1104.5,-1266.5999755859,128.30000305176},
	{-1105,-1285.0999755859,128.30000305176},
	{-1095.5999755859,-1286.0999755859,128.30000305176},
	{-1096.3000488281,-1276.6999511719,128.30000305176},
	{-1087.6999511719,-1271.3000488281,128.30000305176},
	{-1082,-1284.0999755859,128.30000305176},
	{-1075.6999511719,-1259.3000488281,128.30000305176},
	{-1072,-1268.4000244141,128.30000305176},
	{-1070.5,-1276.1999511719,128.30000305176},
	{-1069.8000488281,-1285.6999511719,128.30000305176},
}

local cowmarker = nil
local cowblip = nil
local milkmarker = nil
local milkblip = nil
local cowpoints = 0
local farmerBusy = false

local function destroyFarmerMarker()
	if isElement(cowmarker) then destroyElement(cowmarker) end
	if isElement(cowblip) then destroyElement(cowblip) end
	if isElement(milkmarker) then destroyElement(milkmarker) end
	if isElement(milkblip) then destroyElement(milkblip) end
	cowmarker = nil
	cowblip = nil
	milkmarker = nil
	milkblip = nil
end

function milkMarker()
	destroyFarmerMarker()
	milkmarker = createMarker(-1081.4000244141,-1195.5999755859,128.19999694824,"cylinder",3,200,0,0)
	milkblip = createBlip(-1081.4000244141,-1195.5999755859,128.19999694824,0,2,255,0,0)
	infobox(getText("Farmer2"),0,255,0)
	addEventHandler("onClientMarkerHit",milkmarker,function(player)
		if player ~= localPlayer or farmerBusy then return end
		farmerBusy = true
		destroyFarmerMarker()
		triggerServerEvent("farmerMilkFinished",localPlayer)
	end)
end

function milkCowMarker()
	destroyFarmerMarker()
	farmerBusy = false
	local cow = cows[math.random(1,#cows)]
	cowmarker = createMarker(cow[1],cow[2],cow[3],"cylinder",1,200,0,0)
	cowblip = createBlip(cow[1],cow[2],cow[3],0,2,255,0,0)
	addEventHandler("onClientMarkerHit",cowmarker,function(player)
		if player ~= localPlayer or farmerBusy then return end
		farmerBusy = true
		destroyFarmerMarker()
		setElementFrozen(localPlayer,true)
		setTimer(function()
			if not isElement(localPlayer) then return end
			setElementFrozen(localPlayer,false)
			cowpoints = cowpoints+1
			triggerServerEvent("farmerCowMilked",localPlayer)
			if cowpoints >= 14 then
				milkMarker()
			else
				milkCowMarker()
			end
		end,2000,1)
	end)
end
addEvent("milkCowMarker",true)
addEventHandler("milkCowMarker",root,function()
	cowpoints = 0
	farmerBusy = false
	milkCowMarker()
end)

addEvent("destroyFarmerShit",true)
addEventHandler("destroyFarmerShit",root,function()
	destroyFarmerMarker()
	cowpoints = 0
	farmerBusy = false
	setElementFrozen(localPlayer,false)
end)

addEventHandler("onClientPlayerWasted",localPlayer,function()
	destroyFarmerMarker()
	cowpoints = 0
	farmerBusy = false
	setElementFrozen(localPlayer,false)
end)