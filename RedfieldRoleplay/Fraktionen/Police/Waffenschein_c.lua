local waffenschein = {button = {},window = {},label = {}}

function openWaffenschein()
	if(getElementData(localPlayer,'redfieldClick') == false)then
		if(not(isElement(waffenschein.window[1])))then
			showCursor(true)
			setElementData(localPlayer,'redfieldClick',true)
		
			waffenschein.window[1] = guiCreateStaticImage(0.37, 0.41, 0.27, 0.13, 'Images/Background.png', true)

			waffenschein.button[1] = guiCreateButton(0.03, 0.62, 0.44, 0.23, 'Kaufen (7500$)', true, waffenschein.window[1])
			guiSetProperty(waffenschein.button[1], 'NormalTextColour', 'FFAAAAAA')
			waffenschein.button[2] = guiCreateButton(0.54, 0.62, 0.44, 0.23, 'Schließen', true, waffenschein.window[1])
			guiSetProperty(waffenschein.button[2], 'NormalTextColour', 'FFAAAAAA')  
			
			waffenschein.label[1] = guiCreateLabel(0.03, 0.24, 0.95, 0.30, 'Hier können Sie einen Waffenschein erwerben, welcher Ihnen das Kaufen von Waffen ermöglicht.', true, waffenschein.window[1])
			guiSetFont(waffenschein.label[1], 'default-bold-small')
			guiLabelSetHorizontalAlign(waffenschein.label[1], 'center', true)
			guiLabelSetVerticalAlign(waffenschein.label[1], 'center')
			
			if(getElementData(localPlayer,'Language') == 1)then
				guiSetText(waffenschein.button[1],'Buy (7500$)')
				guiSetText(waffenschein.button[2],'Close')
				guiSetText(waffenschein.label[1],'Here, you can buy a gun license, which allows you to buy weapons.')
			end

			addEventHandler('onClientGUIClick',waffenschein.button[1],function()
				triggerServerEvent('buyWaffenschein',localPlayer,localPlayer)
			end,false)
			addEventHandler('onClientGUIClick',waffenschein.button[2],function()
				destroyElement(waffenschein.window[1])
				showCursor(false)
				setElementData(localPlayer,'redfieldClick',false)
			end,false)
		end
	end
end
addEvent('openWaffenschein',true)
addEventHandler('openWaffenschein',root,openWaffenschein)