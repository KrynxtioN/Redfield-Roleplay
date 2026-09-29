local drogentransporterAbgabe = nil
local drogentransporterAbgabeBlip = nil

function destroyDrogentransporterMarker()
	if isElement(drogentransporterAbgabe) then
		destroyElement(drogentransporterAbgabe)
	end
	if isElement(drogentransporterAbgabeBlip) then
		destroyElement(drogentransporterAbgabeBlip)
	end
	drogentransporterAbgabe = nil
	drogentransporterAbgabeBlip = nil
end
addEvent("destroyDrogentransporterMarker",true)
addEventHandler("destroyDrogentransporterMarker",root,destroyDrogentransporterMarker)

function drogentransporterMarker()
	destroyDrogentransporterMarker()
	drogentransporterAbgabe = createMarker(578.59997558594,1220.3000488281,11.699999809265,"checkpoint",3,0,0,200)
	drogentransporterAbgabeBlip = createBlip(578.59997558594,1220.3000488281,11.699999809265,0,3,255,255,0)
	addEventHandler("onClientMarkerHit",drogentransporterAbgabe,function(hitElement)
		if hitElement ~= localPlayer then return end
		if not isPedInVehicle(localPlayer) then return end
		triggerServerEvent("drogentruckAbgabe",localPlayer)
	end)
end
addEvent("drogentransporterMarker",true)
addEventHandler("drogentransporterMarker",root,drogentransporterMarker)

addEventHandler("onClientResourceStop",resourceRoot,function()
	destroyDrogentransporterMarker()
end)