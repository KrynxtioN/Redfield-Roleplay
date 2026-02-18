function matstransporterMarker()
	matstransporterAbgabe = createMarker(578.59997558594,1220.3000488281,11.699999809265,'checkpoint',3,0,0,200)
	matstransporterAbgabeBlip = createBlip(578.59997558594,1220.3000488281,11.699999809265,0,3,255,255,0)
	
	addEventHandler('onClientMarkerHit',matstransporterAbgabe,function(hitClient)
		if(hitClient == localPlayer)then
			triggerServerEvent('matstruckAbgabe',localPlayer,localPlayer)
		end
	end)
end
addEvent('matstransporterMarker',true)
addEventHandler('matstransporterMarker',root,matstransporterMarker)

function destroymatstransporterMarker()
	if(isElement(matstransporterAbgabe))then
		destroyElement(matstransporterAbgabe)
	end
	if(isElement(matstransporterAbgabeBlip))then
		destroyElement(matstransporterAbgabeBlip)
	end
end
addEvent('destroymatstransporterMarker',true)
addEventHandler('destroymatstransporterMarker',root,destroymatstransporterMarker)