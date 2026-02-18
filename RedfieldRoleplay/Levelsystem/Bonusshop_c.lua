local bonusshop = {gridlist = {},window = {},button = {}}

function bonusshopWindow(hitplayer)
	if(getElementData(localPlayer,'redfieldClick') == false)then
		if(not(isElement(bonusshop.window[1])))then
			showCursor(true)
			setElementData(localPlayer,'redfieldClick',true)
		
			bonusshop.window[1] = guiCreateStaticImage(0.40, 0.31, 0.21, 0.35, 'Images/Background.png', true)

			bonusshop.gridlist[1] = guiCreateGridList(0.04, 0.09, 0.92, 0.72, true, bonusshop.window[1])
			guiGridListAddColumn(bonusshop.gridlist[1], 'Artikel', 0.5)
			guiGridListAddColumn(bonusshop.gridlist[1], 'Preis', 0.5)
			for i = 1, 2 do
				guiGridListAddRow(bonusshop.gridlist[1])
			end
			if(getElementData(localPlayer,'Language')==0)then
				guiGridListSetItemText(bonusshop.gridlist[1], 0, 1, '100% Leben', false, false)
				guiGridListSetItemText(bonusshop.gridlist[1], 1, 1, '100% Weste', false, false)
			else
				guiGridListSetItemText(bonusshop.gridlist[1], 0, 1, '100% Health', false, false)
				guiGridListSetItemText(bonusshop.gridlist[1], 1, 1, '100% Armor', false, false)
			end
			guiGridListSetItemText(bonusshop.gridlist[1], 0, 2, '25 EXP', false, false)
			guiGridListSetItemText(bonusshop.gridlist[1], 1, 2, '25 EXP', false, false)
			bonusshop.button[1] = guiCreateButton(0.04, 0.83, 0.41, 0.09, 'Kaufen', true, bonusshop.window[1])
			guiSetProperty(bonusshop.button[1], 'NormalTextColour', 'FFAAAAAA')
			bonusshop.button[2] = guiCreateButton(0.54, 0.83, 0.41, 0.09, 'Schließen', true, bonusshop.window[1])
			guiSetProperty(bonusshop.button[2], 'NormalTextColour', 'FFAAAAAA')
			
			if(getElementData(localPlayer,'Language')==1)then guiSetText(bonusshop.button[1],'Buy')
			guiSetText(bonusshop.button[2],'Close')end
			
			addEventHandler('onClientGUIClick',bonusshop.button[1],function()
				selectedText=guiGridListGetItemText(bonusshop.gridlist[1],guiGridListGetSelectedItem(bonusshop.gridlist[1]),1)
				
				if(selectedText == '100% Leben' or selectedText == '100% Health')then
					triggerServerEvent('bonusshopserverbuy',localPlayer,'leben',0)
				elseif(selectedText == '100% Weste' or selectedText == '100% Armor')then
					triggerServerEvent('bonusshopserverbuy',localPlayer,'weste',0)
				end
			end,false)
			
			addEventHandler('onClientGUIClick',bonusshop.button[2],function()
				destroyElement(bonusshop.window[1])
				showCursor(false)
				setElementData(localPlayer,'redfieldClick',false)
			end,false)
		end
	end
end
addCommandHandler('bonusshop',bonusshopWindow)