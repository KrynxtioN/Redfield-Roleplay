local supermarkt = {gridlist = {},window = {},button = {}}

function supermarktWindow()
	if(getElementData(localPlayer,'redfieldClick') == false)then
		if(not(isElement(supermarkt.window[1])))then
			showCursor(true)
			setElementData(localPlayer,'redfieldClick',true)
		
			supermarkt.window[1] = guiCreateStaticImage(0.40, 0.31, 0.21, 0.35, 'Images/Background.png', true)

			supermarkt.gridlist[1] = guiCreateGridList(0.04, 0.09, 0.92, 0.72, true, supermarkt.window[1])
			if(getElementData(localPlayer,'Language')==0)then
			guiGridListAddColumn(supermarkt.gridlist[1], 'Artikel', 0.5)
			guiGridListAddColumn(supermarkt.gridlist[1], 'Preis', 0.5)
			else
			guiGridListAddColumn(supermarkt.gridlist[1], 'Article', 0.5)
			guiGridListAddColumn(supermarkt.gridlist[1], 'Price', 0.5)
			end
			for i = 1, 3 do
				guiGridListAddRow(supermarkt.gridlist[1])
			end
			guiGridListSetItemText(supermarkt.gridlist[1], 0, 2, '350$', false, false)
			guiGridListSetItemText(supermarkt.gridlist[1], 1, 2, '3$', false, false)
			if(getElementData(localPlayer,'Language')==0)then
				guiGridListSetItemText(supermarkt.gridlist[1], 0, 1, 'Handy', false, false)
				guiGridListSetItemText(supermarkt.gridlist[1], 1, 1, 'Snack', false, false)
				guiGridListSetItemText(supermarkt.gridlist[1], 2, 1, 'Los', false, false)
			else
				guiGridListSetItemText(supermarkt.gridlist[1], 0, 1, 'Phone', false, false)
				guiGridListSetItemText(supermarkt.gridlist[1], 1, 1, 'Snack', false, false)
				guiGridListSetItemText(supermarkt.gridlist[1], 2, 1, 'Scratch card', false, false)
			end
			guiGridListSetItemText(supermarkt.gridlist[1], 2, 2, '25$', false, false)
			supermarkt.button[1] = guiCreateButton(0.04, 0.83, 0.41, 0.09, 'Kaufen', true, supermarkt.window[1])
			guiSetProperty(supermarkt.button[1], 'NormalTextColour', 'FFAAAAAA')
			supermarkt.button[2] = guiCreateButton(0.54, 0.83, 0.41, 0.09, 'Schließen', true, supermarkt.window[1])
			guiSetProperty(supermarkt.button[2], 'NormalTextColour', 'FFAAAAAA')
			
			if(getElementData(localPlayer,'Language')==1)then guiSetText(supermarkt.button[1],'Buy')
			guiSetText(supermarkt.button[2],'Close')end
			
			addEventHandler('onClientGUIClick',supermarkt.button[1],function()
				selectedText=guiGridListGetItemText(supermarkt.gridlist[1],guiGridListGetSelectedItem(supermarkt.gridlist[1]),1)
				
				if(selectedText == 'Handy' or selectedText == 'Phone')then
					if(getPlayerMoney(localPlayer) >= 350)then
						if(getElementData(localPlayer,'Telefonnummer') == 0)then
							newNR = math.random(1000000,9999999)
							triggerServerEvent('takemoneyshop',localPlayer,350)
							setElementData(localPlayer,'Telefonnummer',newNR)
							markertBuyItem()
							if(getElementData(localPlayer,'Language') == 0)then
								outputChatBox('Deine Telefonnummer ist: '..newNR,0,150,0)
							else
								outputChatBox('Your phone number: '..newNR,0,150,0)
							end
						else
							if(getElementData(localPlayer,'Language') == 0)then
								infobox('Du hast bereits ein Handy!',255,0,0)
							else
								infobox('You already have a phone!',255,0,0)
							end
						end
					else
						markerNotEnoughMoney_func()
					end
				elseif(selectedText == 'Snack')then
					if(getPlayerMoney(localPlayer) >= 3)then
						markertBuyItem()
						setElementData(localPlayer,'Hunger',getElementData(localPlayer,'Hunger') + 10)
						if(getElementData(localPlayer,'Hunger') > 100)then
							setElementData(localPlayer,'Hunger',100)
						end
						triggerServerEvent('takemoneyshop',localPlayer,3)
					else
						markerNotEnoughMoney_func()
					end
				elseif(selectedText == 'Los' or selectedText == 'Scratch card')then
					if(getPlayerMoney(localPlayer) >= 25)then
						triggerServerEvent('los',localPlayer,localPlayer)
						triggerServerEvent('takemoneyshop',localPlayer,25)
					else
						markerNotEnoughMoney_func()
					end
				end
			end,false)
			
			addEventHandler('onClientGUIClick',supermarkt.button[2],function()
				destroyElement(supermarkt.window[1])
				showCursor(false)
				setElementData(localPlayer,'redfieldClick',false)
			end,false)
		end
	end
end
addEvent('opensupermarktWindow',true)
addEventHandler('opensupermarktWindow',root,supermarktWindow)

function markerNotEnoughMoney_func()
	if(getElementData(localPlayer,'Language') == 0)then
		infobox('Du hast nicht genug Geld!',255,0,0)
	else
		infobox('You have not enough money!',255,0,0)
	end
end

function markertBuyItem()
	if(getElementData(localPlayer,'Language') == 0)then
		infobox('Du hast den Artikel gekauft.',0,255,0)
	else
		infobox('You´ve bought the item.',0,255,0)
	end
end