local farmerCowPoints = {}

function farmerjob_func(player)
	if getElementData(player,"loggedin") ~= 1 then return end
	if getElementData(player,"Job") ~= "Farmer" then return end
	local x,y,z = getElementPosition(player)
	if getDistanceBetweenPoints3D(-1061.4000244141,-1195.5999755859,129.80000305176,x,y,z) >= 5 then return end
	if getElementData(player,"FarmerAktiv") == true then
		infobox_func(player,getText(player,"Farmer1"),255,0,0)
		return
	end
	setElementData(player,"FarmerAktiv",true)
	farmerCowPoints[player] = 0
	infobox_func(player,getText(player,"Farmer3"),0,255,0)
	triggerClientEvent(player,"milkCowMarker",player)
end
addCommandHandler("farmjob",farmerjob_func)

addEvent("farmerCowMilked",true)
addEventHandler("farmerCowMilked",root,function()
	local player = client
	if not player or not isElement(player) then return end
	if getElementData(player,"loggedin") ~= 1 then return end
	if getElementData(player,"Job") ~= "Farmer" then return end
	if getElementData(player,"FarmerAktiv") ~= true then return end
	local points = tonumber(farmerCowPoints[player]) or 0
	if points >= 14 then return end
	farmerCowPoints[player] = points+1
end)

addEvent("farmerMilkFinished",true)
addEventHandler("farmerMilkFinished",root,function()
	local player = client
	if not player or not isElement(player) then return end
	if getElementData(player,"loggedin") ~= 1 then return end
	if getElementData(player,"Job") ~= "Farmer" then return end
	if getElementData(player,"FarmerAktiv") ~= true then return end
	if (tonumber(farmerCowPoints[player]) or 0) < 14 then return end
	local x,y,z = getElementPosition(player)
	if getDistanceBetweenPoints3D(-1081.4000244141,-1195.5999755859,128.19999694824,x,y,z) > 5 then return end
	giveJobMoney(player,2400,0)
	infobox_func(player,getText(player,"Farmer4"):format(2400),0,255,0)
	farmerCowPoints[player] = 0
	triggerClientEvent(player,"milkCowMarker",player)
end)

addEventHandler("onPlayerWasted",root,function()
	if getElementData(source,"FarmerAktiv") == true then
		farmerCowPoints[source] = nil
		setElementData(source,"FarmerAktiv",false)
		triggerClientEvent(source,"destroyFarmerShit",source)
	end
end)

addEventHandler("onPlayerQuit",root,function()
	farmerCowPoints[source] = nil
end)