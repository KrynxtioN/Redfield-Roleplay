local chicken = {button = {},window = {},label = {}}

function chickenWindow()
	if(getElementData(localPlayer,'redfieldClick') == false)then
		if(not(isElement(chicken.window[1])))then
			showCursor(true)
			setElementData(localPlayer,'redfieldClick',true)
			
			chicken.window[1] = guiCreateStaticImage(0.40, 0.38, 0.21, 0.27, 'Images/Background.png', true)
			
			chicken.label[1] = guiCreateLabel(0.04, 0.11, 0.93, 0.15, 'Was darf es sein?', true, chicken.window[1])
			guiSetFont(chicken.label[1], 'default-bold-small')
			guiLabelSetHorizontalAlign(chicken.label[1], 'center', true)
			guiLabelSetVerticalAlign(chicken.label[1], 'center')

			chicken.button[1] = guiCreateButton(0.13, 0.31, 0.74, 0.12, 'Halbes Hähnchen (10$)', true, chicken.window[1])
			guiSetProperty(chicken.button[1], 'NormalTextColour', 'FFAAAAAA')
			chicken.button[2] = guiCreateButton(0.13, 0.47, 0.74, 0.12, 'Ganzes Hähnchen (25$)', true, chicken.window[1])
			guiSetProperty(chicken.button[2], 'NormalTextColour', 'FFAAAAAA')
			chicken.button[3] = guiCreateButton(0.13, 0.64, 0.74, 0.12, '2 ganze Hähnchen (50$)', true, chicken.window[1])
			guiSetProperty(chicken.button[3], 'NormalTextColour', 'FFAAAAAA')
			chicken.button[4] = guiCreateButton(0.13, 0.80, 0.74, 0.12, 'Schließen', true, chicken.window[1])
			guiSetProperty(chicken.button[4], 'NormalTextColour', 'FFAAAAAA')
			
			if(getElementData(localPlayer,'Language') == 1)then
				guiSetText(chicken.button[1],'Small Chicken (10$)')
				guiSetText(chicken.button[2],'Middle Chicken (25$)')
				guiSetText(chicken.button[3],'Big Chicken (50$)')
				guiSetText(chicken.button[4],'Close')
				guiSetText(chicken.label[1],'What do you want?')
			end

			addEventHandler('onClientGUIClick',chicken.button[1],function()
				triggerServerEvent('buyChicken',localPlayer,'klein')
			end,false)
			addEventHandler('onClientGUIClick',chicken.button[2],function()
				triggerServerEvent('buyChicken',localPlayer,'mittel')
			end,false)
			addEventHandler('onClientGUIClick',chicken.button[3],function()
				triggerServerEvent('buyChicken',localPlayer,'groß')
			end,false)
			addEventHandler('onClientGUIClick',chicken.button[4],function()
				destroyElement(chicken.window[1])
				showCursor(false)
				setElementData(localPlayer,'redfieldClick',false)
			end,false)
		end
	end
end
addEvent('openChickenWindow',true)
addEventHandler('openChickenWindow',root,chickenWindow)