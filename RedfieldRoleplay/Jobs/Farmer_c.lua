local cows={
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

function milkMarker()
	milkmarker=createMarker(-1081.4000244141,-1195.5999755859,128.19999694824,"cylinder",3,200,0,0)
	milkblip=createBlip(-1081.4000244141,-1195.5999755859,128.19999694824,0,2,255,0,0)
	
	addEventHandler("onClientMarkerHit",milkmarker,function(player)
		if(player==localPlayer)then
			if(isElement(milkmarker))then
				destroyElement(milkmarker)
			end
			if(isElement(milkblip))then
				destroyElement(milkblip)
			end
			triggerServerEvent("giveJobMoney",localPlayer,2400,0)
			cowpoints=nil
			milkCowMarker()
		end
	end)
end

function milkCowMarker()
	local cowmarkernumber=math.random(1,table.getn(cows))
	cowmarker=createMarker(cows[cowmarkernumber][1],cows[cowmarkernumber][2],cows[cowmarkernumber][3],"cylinder",1,200,0,0)
	cowblip=createBlip(cows[cowmarkernumber][1],cows[cowmarkernumber][2],cows[cowmarkernumber][3],0,2,255,0,0)
	
	addEventHandler("onClientMarkerHit",cowmarker,function(player)
		if(player==localPlayer)then
			setElementFrozen(localPlayer,true)
			setTimer(function()
				setElementFrozen(localPlayer,false)
			end,2000,1)
			if(isElement(cowmarker))then
				destroyElement(cowmarker)
			end
			if(isElement(cowblip))then
				destroyElement(cowblip)
			end
			 
			if(cowpoints==nil)then
				cowpoints=1
			else
				cowpoints=cowpoints+1
			end
			
			if(cowpoints==14)then
				milkMarker()
			else
				milkCowMarker()
			end
		end
	end)
end
addEvent("milkCowMarker",true)
addEventHandler("milkCowMarker",root,milkCowMarker)

addEvent("destroyFarmerShit",true)
addEventHandler("destroyFarmerShit",root,function()
	setElementData(localPlayer,"FarmerAktiv",false)
	if(isElement(cowmarker))then
		destroyElement(cowmarker)
	end
	if(isElement(cowblip))then
		destroyElement(cowblip)
	end
	cowpoints=nil
end)