local bar = {gridlist = {},window = {},button = {}}

function barWindow()
	if(getElementData(localPlayer,'redfieldClick') == false)then
		if(not(isElement(bar.window[1])))then
			showCursor(true)
			setElementData(localPlayer,'redfieldClick',true)
		
			bar.window[1] = guiCreateStaticImage(0.40, 0.31, 0.21, 0.35, 'Images/Background.png', true)

			bar.gridlist[1] = guiCreateGridList(0.04, 0.09, 0.92, 0.72, true, bar.window[1])
			if(getElementData(localPlayer,'Language') == 0)then
			guiGridListAddColumn(bar.gridlist[1], 'Artikel', 0.5)
			guiGridListAddColumn(bar.gridlist[1], 'Preis', 0.5)
			else
			guiGridListAddColumn(bar.gridlist[1], 'Article', 0.5)
			guiGridListAddColumn(bar.gridlist[1], 'Price', 0.5)
			end
			for i = 1, 3 do
				guiGridListAddRow(bar.gridlist[1])
			end
			guiGridListSetItemText(bar.gridlist[1], 0, 2, '8$', false, false)
			guiGridListSetItemText(bar.gridlist[1], 1, 2, '6$', false, false)
			guiGridListSetItemText(bar.gridlist[1], 2, 2, '12$', false, false)
			
			guiGridListSetItemText(bar.gridlist[1], 0, 1, 'Whiskey', false, false)
			guiGridListSetItemText(bar.gridlist[1], 1, 1, 'Scotch', false, false)
			guiGridListSetItemText(bar.gridlist[1], 2, 1, 'Wodka', false, false)
			
			bar.button[1] = guiCreateButton(0.04, 0.83, 0.41, 0.09, 'Kaufen', true, bar.window[1])
			guiSetProperty(bar.button[1], 'NormalTextColour', 'FFAAAAAA')
			bar.button[2] = guiCreateButton(0.54, 0.83, 0.41, 0.09, 'Schließen', true, bar.window[1])
			guiSetProperty(bar.button[2], 'NormalTextColour', 'FFAAAAAA')
			
			if(getElementData(localPlayer,'Language') == 1)then
				guiSetText(bar.button[1],'Buy')
				guiSetText(bar.button[2],'Close')
			end
			
			addEventHandler('onClientGUIClick',bar.button[1],function()
				selectedText=guiGridListGetItemText(bar.gridlist[1],guiGridListGetSelectedItem(bar.gridlist[1]),1)
				
				if(selectedText == 'Whiskey')then
					if(getPlayerMoney(localPlayer) >= 8)then
						if(getElementData(localPlayer,'Language')==0)then
							infobox('Du hast dir das Getränk gekauft.',0,255,0)
						else
							infobox('You have bought the drink.',0,255,0)
						end
						triggerServerEvent('BuyAlcohol',localPlayer,localPlayer)
						triggerServerEvent('takemoneyshop',localPlayer,8)
					else
						if(getElementData(localPlayer,'Language')==0)then
							infobox('Du hast nicht genug Geld!',255,0,0)
						else
							infobox('You have not enough money!',255,0,0)
						end
					end
				elseif(selectedText == 'Scotch')then
					if(getPlayerMoney(localPlayer) >= 6)then
						if(getElementData(localPlayer,'Language')==0)then
							infobox('Du hast dir das Getränk gekauft.',0,255,0)
						else
							infobox('You have bought the drink.',0,255,0)
						end
						triggerServerEvent('BuyAlcohol',localPlayer,localPlayer)
						triggerServerEvent('takemoneyshop',localPlayer,3)
					else
						if(getElementData(localPlayer,'Language')==0)then
							infobox('Du hast nicht genug Geld!',255,0,0)
						else
							infobox('You have not enough money!',255,0,0)
						end
					end
				elseif(selectedText == 'Los' or selectedText == 'Wodka')then
					if(getPlayerMoney(localPlayer) >= 12)then
						if(getElementData(localPlayer,'Language')==0)then
							infobox('Du hast dir das Getränk gekauft.',0,255,0)
						else
							infobox('You have bought the drink.',0,255,0)
						end
						triggerServerEvent('BuyAlcohol',localPlayer,localPlayer)
						triggerServerEvent('takemoneyshop',localPlayer,12)
					else
						if(getElementData(localPlayer,'Language')==0)then
							infobox('Du hast nicht genug Geld!',255,0,0)
						else
							infobox('You have not enough money!',255,0,0)
						end
					end
				end
			end,false)
			
			addEventHandler('onClientGUIClick',bar.button[2],function()
				destroyElement(bar.window[1])
				showCursor(false)
				setElementData(localPlayer,'redfieldClick',false)
			end,false)
		end
	end
end
addEvent('openBarWindow',true)
addEventHandler('openBarWindow',root,barWindow)