local motel = {button = {},window = {}, label = {}}

function motelWindow()
	if(getElementData(localPlayer,'redfieldClick') == false)then
		if(not(isElement(motel.window[1])))then
			showCursor(true)
			setElementData(localPlayer,'redfieldClick',true)
			
			motel.window[1] = guiCreateStaticImage(0.40, 0.39, 0.21, 0.19, 'Images/Background.png', true)

			motel.button[1] = guiCreateButton(0.03, 0.17, 0.44, 0.17, 'Zimmer mieten', true, motel.window[1])
			guiSetProperty(motel.button[1], 'NormalTextColour', 'FFAAAAAA')
			motel.button[2] = guiCreateButton(0.03, 0.39, 0.44, 0.17, 'Ausmieten', true, motel.window[1])
			guiSetProperty(motel.button[2], 'NormalTextColour', 'FFAAAAAA')
			motel.button[3] = guiCreateButton(0.03, 0.77, 0.44, 0.17, 'Schließen', true, motel.window[1])
			guiSetProperty(motel.button[3], 'NormalTextColour', 'FFAAAAAA')
			
			motel.label[1] = guiCreateLabel(0.51, 0.17, 0.46, 0.77, 'Willkommen im Redfield Roleplay Motel. Für 630$ pro Payday kannst du dir hier ein Zimmer mieten.', true, motel.window[1])
			guiSetFont(motel.label[1], 'default-bold-small')
			guiLabelSetHorizontalAlign(motel.label[1], 'left', true)
			
			if(getElementData(localPlayer,'Language') == 1)then
				guiSetText(motel.button[1],'Rent a room')
				guiSetText(motel.button[2],'Move out')
				guiSetText(motel.button[3],'Close')
				guiSetText(motel.label[1],'Welcome to the Redfield Roleplay Motel. For $ 630 per Payday can you rent a room here.')
			end

			addEventHandler('onClientGUIClick',motel.button[1],function()
				triggerServerEvent('zimmerMieten',localPlayer,localPlayer)
			end,false)
			addEventHandler('onClientGUIClick',motel.button[2],function()
				triggerServerEvent('ausmietenMotel',localPlayer,localPlayer)
			end,false)
			addEventHandler('onClientGUIClick',motel.button[3],function()
				destroyElement(motel.window[1])
				showCursor(false)
				setElementData(localPlayer,'redfieldClick',false)
			end,false)
		end
	end
end
addEvent('motelWindow',true)
addEventHandler('motelWindow',root,motelWindow)