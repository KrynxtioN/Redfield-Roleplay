local burger = {button = {},window = {},label = {}}

function burgerWindow()
	if(getElementData(localPlayer,'redfieldClick') == false)then
		if(not(isElement(burger.window[1])))then
			showCursor(true)
			setElementData(localPlayer,'redfieldClick',true)
			
			burger.window[1] = guiCreateStaticImage(0.40, 0.38, 0.21, 0.27, 'Images/Background.png', true)
			
			burger.label[1] = guiCreateLabel(0.04, 0.11, 0.93, 0.15, 'Was darf es sein?', true, burger.window[1])
			guiSetFont(burger.label[1], 'default-bold-small')
			guiLabelSetHorizontalAlign(burger.label[1], 'center', true)
			guiLabelSetVerticalAlign(burger.label[1], 'center')

			burger.button[1] = guiCreateButton(0.13, 0.31, 0.74, 0.12, 'Kleines Burger Menü (10$)', true, burger.window[1])
			guiSetProperty(burger.button[1], 'NormalTextColour', 'FFAAAAAA')
			burger.button[2] = guiCreateButton(0.13, 0.47, 0.74, 0.12, 'Mittleres Burger Menü (25$)', true, burger.window[1])
			guiSetProperty(burger.button[2], 'NormalTextColour', 'FFAAAAAA')
			burger.button[3] = guiCreateButton(0.13, 0.64, 0.74, 0.12, 'Großes Burger Menü (50$)', true, burger.window[1])
			guiSetProperty(burger.button[3], 'NormalTextColour', 'FFAAAAAA')
			burger.button[4] = guiCreateButton(0.13, 0.80, 0.74, 0.12, 'Schließen', true, burger.window[1])
			guiSetProperty(burger.button[4], 'NormalTextColour', 'FFAAAAAA')
			
			if(getElementData(localPlayer,'Language') == 1)then
				guiSetText(burger.button[1],'Small Burger (10$)')
				guiSetText(burger.button[2],'Middle Burger (25$)')
				guiSetText(burger.button[3],'Big Burger (50$)')
				guiSetText(burger.button[4],'Close')
				guiSetText(burger.label[1],'What do you want?')
			end

			addEventHandler('onClientGUIClick',burger.button[1],function()
				triggerServerEvent('buyburger',localPlayer,'klein')
			end,false)
			addEventHandler('onClientGUIClick',burger.button[2],function()
				triggerServerEvent('buyburger',localPlayer,'mittel')
			end,false)
			addEventHandler('onClientGUIClick',burger.button[3],function()
				triggerServerEvent('buyburger',localPlayer,'groß')
			end,false)
			addEventHandler('onClientGUIClick',burger.button[4],function()
				destroyElement(burger.window[1])
				showCursor(false)
				setElementData(localPlayer,'redfieldClick',false)
			end,false)
		end
	end
end
addEvent('openBurgerWindow',true)
addEventHandler('openBurgerWindow',root,burgerWindow)