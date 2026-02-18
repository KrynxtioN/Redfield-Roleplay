local Tuning = {button = {},window = {},edit = {},label = {}}

function createTankWindow()
	if(not(isElement(Tuning.window[1])))then
		if(not(getElementData(localPlayer,'redfieldClick')) == true)then
			showCursor(true)
			setElementData(localPlayer,'redfieldClick',true)
		
			Tuning.window[1] = guiCreateStaticImage(569, 374, 301, 148, 'Images/Background.png', false)

			Tuning.label[1] = guiCreateLabel(0.03, 0.17, 0.93, 0.21, 'Hier kannst du deine Fahrzeugfarbe ändern.\nTrage unten den gewünschten RGB Code ein.', true, Tuning.window[1])
			guiSetFont(Tuning.label[1], 'default-bold-small')
			guiLabelSetHorizontalAlign(Tuning.label[1], 'center', true)
			guiLabelSetVerticalAlign(Tuning.label[1], 'center')
			Tuning.button[1] = guiCreateButton(0.03, 0.74, 0.45, 0.20, 'Farbe ändern', true, Tuning.window[1])
			guiSetProperty(Tuning.button[1], 'NormalTextColour', 'FFAAAAAA')
			Tuning.button[2] = guiCreateButton(0.51, 0.74, 0.45, 0.20, 'Schließen', true, Tuning.window[1])
			guiSetProperty(Tuning.button[2], 'NormalTextColour', 'FFAAAAAA')
			Tuning.edit[1] = guiCreateEdit(0.08, 0.45, 0.26, 0.18, '', true, Tuning.window[1])
			Tuning.edit[2] = guiCreateEdit(0.37, 0.45, 0.26, 0.18, '', true, Tuning.window[1])
			Tuning.edit[3] = guiCreateEdit(0.66, 0.45, 0.26, 0.18, '', true, Tuning.window[1])    
			guiEditSetMaxLength(Tuning.edit[1],3)
			guiEditSetMaxLength(Tuning.edit[2],3)
			guiEditSetMaxLength(Tuning.edit[3],3)
			
			addEventHandler('onClientGUIClick',Tuning.button[1],function()
				local r=guiGetText(Tuning.edit[1])
				local g=guiGetText(Tuning.edit[2])
				local b=guiGetText(Tuning.edit[3])
				if(r == '' and g == '' and b == '')then
				r = math.random(1,255)
				g = math.random(1,255)
				b = math.random(1,255)end
				triggerServerEvent('changeColor',localPlayer,r,g,b)
			end,false)
			
			addEventHandler('onClientGUIClick',Tuning.button[2],function()
				destroyElement(Tuning.window[1])
				showCursor(false)
				setElementData(localPlayer,'redfieldClick',false)
			end,false)
		end
	end
end
addEvent('openTuningWindow',true)
addEventHandler('openTuningWindow',root,createTankWindow)