function createGeldtruckSachen()
	geldtruckmarker = createMarker(-196.61231994629,986.69573974609,19.305110931396,'checkpoint',2,255,0,0)
	geldtruckblip = createBlip(-196.61231994629,986.69573974609,19.305110931396,0,2,255,255,0)
	infobox('Bring den Transporter zum gelben Blip.',0,255,0)
	
	addEventHandler('onClientMarkerHit',geldtruckmarker,function(hitPlayer)
		if(hitPlayer == localPlayer)then
			triggerServerEvent('geldtruckMoney',localPlayer,localPlayer)
		end
	end)
end
addEvent('createGeldtruckSachen',true)
addEventHandler('createGeldtruckSachen',root,createGeldtruckSachen)

function destroyGeldtruckShit()
	if(isElement(geldtruckmarker))then
		destroyElement(geldtruckmarker)
	end
	if(isElement(geldtruckblip))then
		destroyElement(geldtruckblip)
	end
end
addEvent('destroyGeldtruckShit',true)
addEventHandler('destroyGeldtruckShit',root,destroyGeldtruckShit)