addEvent('transporterFirstMarker',true)
addEventHandler('transporterFirstMarker',root,function()
	copstealblip=createBlip(1702,681,10.699999809265,0,2,255,255,0)
	if(getElementData(localPlayer,'Language')==0)then
		infobox('Fahr zum gelben Blip und klau das Polizei Fahrzeug.',0,255,0)
	else
		infobox('Drive to the Yellow-Blip and steal the Police Vehicle.',0,255,0)
	end
end)

addEvent('transporterSecondMarker',true)
addEventHandler('transporterSecondMarker',root,function()
	copstealmarker=createMarker(-1422.6063232422,2598.7263183594,55.6875,'checkpoint',2,0,255,0)
	copstealblip2=createBlip(-1422.6063232422,2598.7263183594,55.6875,0,2,255,255,0)
	addEventHandler('onClientMarkerHit',copstealmarker,function(element)
		if(element==localPlayer)then
			triggerServerEvent('finisCopTransporter',localPlayer,localPlayer)
		end
	end)
end)

addEvent('destroyTransporterFirstMarker',true)
addEventHandler('destroyTransporterFirstMarker',root,function()
	if(isElement(copstealblip))then
		destroyElement(copstealblip)
	end
end)

addEvent('destroyTransporterSecondMarker',true)
addEventHandler('destroyTransporterSecondMarker',root,function()
	if(isElement(copstealmarker))then
		destroyElement(copstealmarker)
	end
	if(isElement(copstealblip2))then
		destroyElement(copstealblip2)
	end
end)