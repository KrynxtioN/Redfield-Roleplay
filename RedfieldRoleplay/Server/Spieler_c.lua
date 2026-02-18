function showCursorClient()
	if(not(getElementData(localPlayer,'redfieldClick') == true))then
		showCursor(not(isCursorShowing()))
	end
end
bindKey('m','down',showCursorClient)

local Hospital = {label = {},window = {}}

function hospitalWindow()
	if(not(isElement(Hospital.window[1])))then
		local krankenhaustime = 30
		setElementData(localPlayer,'redfieldClick',true)
		if(isPedInVehicle(localPlayer))then
			removeEventHandler('onClientRender',root,render_tacho)
		end
		
		setCameraMatrix(-309.30661010742,1072.3266601563,35.636001586914,-309.77633666992,1071.5665283203,35.186965942383,0,70)
		setCameraInterior(0)
		
        Hospital.window[1] = guiCreateStaticImage(0.40, 0.42, 0.20, 0.13, 'Images/Background.png', true)

        Hospital.label[1] = guiCreateLabel(0.04, 0.25, 0.93, 0.57, 'Du bist noch '..krankenhaustime..' Sekunden im Krankenhaus', true, Hospital.window[1])
        guiSetFont(Hospital.label[1], 'default-bold-small')
        guiLabelSetHorizontalAlign(Hospital.label[1], 'center', true)
        guiLabelSetVerticalAlign(Hospital.label[1], 'center')
		
		if(getElementData(localPlayer,'Language') == 1)then
			guiSetText(Hospital.label[1],'You are '..krankenhaustime..' seconds in hospital')
		end
		
		setTimer(function()
			krankenhaustime=krankenhaustime - 1
			if(getElementData(localPlayer,'Language') == 0)then
				guiSetText(Hospital.label[1],'Du bist noch '..krankenhaustime..' Sekunden im Krankenhaus')
			else
				guiSetText(Hospital.label[1],'You are '..krankenhaustime..' seconds in hospital')
			end
		end,1000,29)
		setTimer(function()
			destroyElement(Hospital.window[1])
			triggerServerEvent('afterHospitalSpawn',localPlayer,localPlayer)
			setElementData(localPlayer,'redfieldClick',false)
		end,30000,1)
	end
end
addEvent('hospitalWindow',true)
addEventHandler('hospitalWindow',root,hospitalWindow)

function noDamage()
	if(getElementData(localPlayer,'imKnast') == true)then
		cancelEvent()
	end
end
addEventHandler('onClientPlayerDamage',localPlayer,noDamage)