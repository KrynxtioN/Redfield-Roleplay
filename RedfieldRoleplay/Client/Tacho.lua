local x,y = guiGetScreenSize()

function render_tacho()
	if(isPedInVehicle(localPlayer))then
		local veh = getPedOccupiedVehicle(localPlayer)
		local sx, sy, sz = getElementVelocity (getPedOccupiedVehicle(getLocalPlayer()))
		local kmh_s = math.floor(((sx^2 + sy^2 + sz^2)^(0.5))*180)
		local str = string.format('%03d',kmh_s)
		local benzin = getElementData(veh,'Benzin')
		
		dxDrawRectangle(1656*(x/1920), 930*(y/1080), 254*(x/1920), 74*(y/1080), tocolor(1, 0, 0, 207), false)
		dxDrawText('Km/h', 1763*(x/1920), 964*(y/1080), 1825*(x/1920), 995*(y/1080), tocolor(255, 255, 255, 255), 1.50*(y/1080), 'default-bold', 'center', 'bottom', false, false, false, false, false)
		dxDrawRectangle(1666*(x/1920), 940*(y/1080), 97*(x/1920), 54*(y/1080), tocolor(1, 0, 0, 207), false)
		dxDrawText(str, 1666*(x/1920), 940*(y/1080), 1763*(x/1920), 994*(y/1080), tocolor(255, 255, 255, 255), 1.50*(y/1080), 'default-bold', 'center', 'center', false, false, false, false, false)
		dxDrawImage(1768*(x/1920), 945*(y/1080), 21*(x/1920), 20*(y/1080), 'Images/Tank.png', 0, 0, 0, tocolor(255, 255, 255, 255), false)
		dxDrawText(benzin..' Liter', 1794*(x/1920), 890*(y/1080), 1822*(x/1920), 1020*(y/1080), tocolor(255, 255, 255, 255), 1.00*(y/1080), 'default-bold', 'left', 'center', false, false, false, false,false)
		
		if getVehicleEngineState(veh) == true then
			dxDrawImage(1875*(x/1920), 934*(y/1080), 33*(x/1920), 33*(y/1080), 'Images/Kreis.png', 0, 0, 0, tocolor(0,200,0, 254), false)
		else
			dxDrawImage(1875*(x/1920), 934*(y/1080), 33*(x/1920), 33*(y/1080), 'Images/Kreis.png', 0, 0, 0, tocolor(200,0,0, 254), false)
		end
	end
end

addEventHandler('onClientVehicleEnter',root,function(player)
	if(player == localPlayer)then
		addEventHandler('onClientRender',root,render_tacho)
	end
end)

addEventHandler('onClientVehicleExit',root,function(player)
	if(player == localPlayer)then
		removeEventHandler('onClientRender',root,render_tacho)
	end
end)