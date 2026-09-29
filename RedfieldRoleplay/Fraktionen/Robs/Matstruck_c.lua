local matstransporterAbgabe = nil
local matstransporterAbgabeBlip = nil

function destroymatstransporterMarker()
	if isElement(matstransporterAbgabe) then destroyElement(matstransporterAbgabe) end
	if isElement(matstransporterAbgabeBlip) then destroyElement(matstransporterAbgabeBlip) end
	matstransporterAbgabe = nil
	matstransporterAbgabeBlip = nil
end
addEvent("destroymatstransporterMarker",true)
addEventHandler("destroymatstransporterMarker",root,destroymatstransporterMarker)

function matstransporterMarker()
	destroymatstransporterMarker()
	matstransporterAbgabe = createMarker(578.59997558594,1220.3000488281,11.699999809265,"checkpoint",3,0,0,200)
	matstransporterAbgabeBlip = createBlip(578.59997558594,1220.3000488281,11.699999809265,0,3,255,255,0)
	infobox(getText("MatsTruck17"),0,255,0)
	addEventHandler("onClientMarkerHit",matstransporterAbgabe,function(hitElement)
		if hitElement ~= localPlayer then return end
		if not isPedInVehicle(localPlayer) or getPedOccupiedVehicleSeat(localPlayer) ~= 0 then return end
		triggerServerEvent("matstruckAbgabe",localPlayer)
	end)
end
addEvent("matstransporterMarker",true)
addEventHandler("matstransporterMarker",root,matstransporterMarker)

addEventHandler("onClientResourceStop",resourceRoot,function()
	destroymatstransporterMarker()
end)