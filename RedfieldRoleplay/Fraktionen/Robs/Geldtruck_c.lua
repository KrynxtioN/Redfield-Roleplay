local geldtruckmarker = nil
local geldtruckblip = nil

function destroyGeldtruckShit()
	if isElement(geldtruckmarker) then destroyElement(geldtruckmarker) end
	if isElement(geldtruckblip) then destroyElement(geldtruckblip) end
	geldtruckmarker = nil
	geldtruckblip = nil
end
addEvent("destroyGeldtruckShit",true)
addEventHandler("destroyGeldtruckShit",root,destroyGeldtruckShit)

function createGeldtruckSachen()
	destroyGeldtruckShit()
	geldtruckmarker = createMarker(-196.61231994629,986.69573974609,19.305110931396,"checkpoint",2,255,0,0)
	geldtruckblip = createBlip(-196.61231994629,986.69573974609,19.305110931396,0,2,255,255,0)
	infobox(getText("MoneyTruck6"),0,255,0)
	addEventHandler("onClientMarkerHit",geldtruckmarker,function(hitElement,matchingDimension)
		if hitElement ~= localPlayer or not matchingDimension then return end
		if not isPedInVehicle(localPlayer) then return end
		if getPedOccupiedVehicleSeat(localPlayer) ~= 0 then return end
		triggerServerEvent("geldtruckMoney",localPlayer)
	end)
end
addEvent("createGeldtruckSachen",true)
addEventHandler("createGeldtruckSachen",root,createGeldtruckSachen)

addEventHandler("onClientResourceStop",resourceRoot,function()
	destroyGeldtruckShit()
end)