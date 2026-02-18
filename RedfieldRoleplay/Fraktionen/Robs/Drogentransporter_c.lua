function drogentransporterMarker()
	drogentransporterAbgabe = createMarker(578.59997558594,1220.3000488281,11.699999809265,'checkpoint',3,0,0,200)
	drogentransporterAbgabeBlip = createBlip(578.59997558594,1220.3000488281,11.699999809265,0,3,255,255,0)
	
	addEventHandler('onClientMarkerHit',drogentransporterAbgabe,function(hitClient)
		if(hitClient == localPlayer)then
			triggerServerEvent('drogentruckAbgabe',localPlayer,localPlayer)
		end
	end)
end
addEvent('drogentransporterMarker',true)
addEventHandler('drogentransporterMarker',root,drogentransporterMarker)

function destroyDrogentransporterMarker()
	if(isElement(drogentransporterAbgabe))then
		destroyElement(drogentransporterAbgabe)
	elseif(isElement(drogentransporterAbgabeBlip))then
		destroyElement(drogentransporterAbgabeBlip)
	end
end
addEvent('destroyDrogentransporterMarker',true)
addEventHandler('destroyDrogentransporterMarker',root,destroyDrogentransporterMarker)