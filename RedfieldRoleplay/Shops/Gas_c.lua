local tanke = {button = {},window = {},edit = {},label = {}}

function tankeWindow()
	if(getElementData(localPlayer,'redfieldClick') == false)then
		if(not(isElement(tanke.window[1])))then
			local veh = getPedOccupiedVehicle(localPlayer)
			
			if(veh)then
				showCursor(true)
				setElementData(localPlayer,'redfieldClick',true)
			
				tanke.window[1] = guiCreateStaticImage(0.39, 0.41, 0.21, 0.17, 'Images/Background.png', true)

				tanke.button[1] = guiCreateButton(0.03, 0.17, 0.42, 0.17, 'Volltanken', true, tanke.window[1])
				guiSetProperty(tanke.button[1], 'NormalTextColour', 'FFAAAAAA')
				tanke.button[2] = guiCreateButton(0.03, 0.40, 0.42, 0.17, 'Liter Tanken', true, tanke.window[1])
				guiSetProperty(tanke.button[2], 'NormalTextColour', 'FFAAAAAA')
				tanke.button[3] = guiCreateButton(0.03, 0.77, 0.42, 0.17, 'Schließen', true, tanke.window[1])
				guiSetProperty(tanke.button[3], 'NormalTextColour', 'FFAAAAAA')
				tanke.label[1] = guiCreateLabel(0.48, 0.17, 0.48, 0.17, 'Liter:', true, tanke.window[1])
				guiSetFont(tanke.label[1], 'default-bold-small')
				guiLabelSetHorizontalAlign(tanke.label[1], 'center', true)
				guiLabelSetVerticalAlign(tanke.label[1], 'center')
				tanke.edit[1] = guiCreateEdit(0.47, 0.40, 0.49, 0.17, '', true, tanke.window[1])
				
				if(getElementData(localPlayer,'Language') == 1)then
					guiSetText(tanke.button[1],'Tank up')
					guisetText(tank.button[2],'Refuel liter')
					guiSetText(tanke.button[3],'Close')
				end
				
				addEventHandler('onClientGUIClick',tanke.button[1],function()
					triggerServerEvent('fulltanken',localPlayer,localPlayer)
				end,false)
				addEventHandler('onClientGUIClick',tanke.button[2],function()
					local liter = tonumber(guiGetText(tanke.edit[1]))
					
					if(liter)then
						if(liter > 0 and liter < 101)then
							triggerServerEvent('litertanken',localPlayer,localPlayer,liter)
						else
							if(getElementData(localPlayer,'Language') == 0)then
								infobox('Trag eine Zahl zwischen 0 - 101 ein!',255,0,0)
							else
								infobox('Write a number (1 - 100)',255,0,0)
							end
						end
					else
						if(getElementData(localPlayer,'Language') == 0)then
							infobox('Trag eine Zahl ein!',255,0,0)
						else
							infobox('Write a number!',255,0,0)
						end
					end
				end,false)
				addEventHandler('onClientGUIClick',tanke.button[3],function()
					destroyElement(tanke.window[1])
					showCursor(false)
					setElementData(localPlayer,'redfieldClick',false)
				end,false)
			else
				if(getElementData(localPlayer,'Language') == 0)then
					infobox('Du benötigst ein Fahrzeug!',255,0,0)
				else
					infobox('You need a vehicle!',255,0,0)
				end
			end
		end
	end
end
addEvent('tankeWindow',true)
addEventHandler('tankeWindow',root,tankeWindow)