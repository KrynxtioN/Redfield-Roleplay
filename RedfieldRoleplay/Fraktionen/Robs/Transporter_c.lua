local copstealblip = nil
local copstealmarker = nil
local copstealblip2 = nil

local function destroyTransporterFirstMarker()
	if isElement(copstealblip) then destroyElement(copstealblip) end
	copstealblip = nil
end

local function destroyTransporterSecondMarker()
	if isElement(copstealmarker) then destroyElement(copstealmarker) end
	if isElement(copstealblip2) then destroyElement(copstealblip2) end
	copstealmarker = nil
	copstealblip2 = nil
end

addEvent("transporterFirstMarker",true)
addEventHandler("transporterFirstMarker",root,function()
	destroyTransporterFirstMarker()
	copstealblip = createBlip(1702,681,10.699999809265,0,2,255,255,0)
	infobox(getText("CopSteal1"),0,255,0)
end)

addEvent("transporterSecondMarker",true)
addEventHandler("transporterSecondMarker",root,function()
	destroyTransporterFirstMarker()
	destroyTransporterSecondMarker()
	copstealmarker = createMarker(-1422.6063232422,2598.7263183594,55.6875,"checkpoint",2,0,255,0)
	copstealblip2 = createBlip(-1422.6063232422,2598.7263183594,55.6875,0,2,255,255,0)
	infobox(getText("CopSteal2"),0,255,0)
	addEventHandler("onClientMarkerHit",copstealmarker,function(element)
		if element ~= localPlayer then return end
		if not isPedInVehicle(localPlayer) or getPedOccupiedVehicleSeat(localPlayer) ~= 0 then return end
		triggerServerEvent("finisCopTransporter",localPlayer)
	end)
end)

addEvent("destroyTransporterFirstMarker",true)
addEventHandler("destroyTransporterFirstMarker",root,destroyTransporterFirstMarker)

addEvent("destroyTransporterSecondMarker",true)
addEventHandler("destroyTransporterSecondMarker",root,destroyTransporterSecondMarker)

addEventHandler("onClientResourceStop",resourceRoot,function()
	destroyTransporterFirstMarker()
	destroyTransporterSecondMarker()
end)