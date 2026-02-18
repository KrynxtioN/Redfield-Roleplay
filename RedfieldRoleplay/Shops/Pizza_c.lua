local pizza = {button = {},window = {},label = {}}

function pizzaWindow()
	if(getElementData(localPlayer,'redfieldClick') == false)then
		if(not(isElement(pizza.window[1])))then
			showCursor(true)
			setElementData(localPlayer,'redfieldClick',true)
			
			pizza.window[1] = guiCreateStaticImage(0.40, 0.38, 0.21, 0.27, 'Images/Background.png', true)
			
			pizza.label[1] = guiCreateLabel(0.04, 0.11, 0.93, 0.15, 'Was darf es sein?', true, pizza.window[1])
			guiSetFont(pizza.label[1], 'default-bold-small')
			guiLabelSetHorizontalAlign(pizza.label[1], 'center', true)
			guiLabelSetVerticalAlign(pizza.label[1], 'center')

			pizza.button[1] = guiCreateButton(0.13, 0.31, 0.74, 0.12, 'Kleine Pizza (10$)', true, pizza.window[1])
			guiSetProperty(pizza.button[1], 'NormalTextColour', 'FFAAAAAA')
			pizza.button[2] = guiCreateButton(0.13, 0.47, 0.74, 0.12, 'Mittlere Pizza (25$)', true, pizza.window[1])
			guiSetProperty(pizza.button[2], 'NormalTextColour', 'FFAAAAAA')
			pizza.button[3] = guiCreateButton(0.13, 0.64, 0.74, 0.12, 'Große Pizza (50$)', true, pizza.window[1])
			guiSetProperty(pizza.button[3], 'NormalTextColour', 'FFAAAAAA')
			pizza.button[4] = guiCreateButton(0.13, 0.80, 0.74, 0.12, 'Schließen', true, pizza.window[1])
			guiSetProperty(pizza.button[4], 'NormalTextColour', 'FFAAAAAA')
			
			if(getElementData(localPlayer,'Language') == 1)then
				guiSetText(pizza.button[1],'Small Pizza (10$)')
				guiSetText(pizza.button[2],'Middle Pizza (25$)')
				guiSetText(pizza.button[3],'Big Pizza (50$)')
				guiSetText(pizza.button[4],'Close')
				guiSetText(pizza.label[1],'What do you want?')
			end

			addEventHandler('onClientGUIClick',pizza.button[1],function()
				triggerServerEvent('buyPizza',localPlayer,'klein')
			end,false)
			addEventHandler('onClientGUIClick',pizza.button[2],function()
				triggerServerEvent('buyPizza',localPlayer,'mittel')
			end,false)
			addEventHandler('onClientGUIClick',pizza.button[3],function()
				triggerServerEvent('buyPizza',localPlayer,'groß')
			end,false)
			addEventHandler('onClientGUIClick',pizza.button[4],function()
				destroyElement(pizza.window[1])
				showCursor(false)
				setElementData(localPlayer,'redfieldClick',false)
			end,false)
		end
	end
end
addEvent('openPizzaWindow',true)
addEventHandler('openPizzaWindow',root,pizzaWindow)