local Bankpin = {button = {},window = {},edit = {},label = {}}

function bankpinWindow()
	if(not(isElement(Bankpin.window[1])))then
		if(getElementData(localPlayer,'redfieldClick') == false)then
			showCursor(true)
			setElementData(localPlayer,'redfieldClick',true)
		
			Bankpin.window[1] = guiCreateStaticImage(0.40, 0.40, 0.21, 0.18, 'Images/Background.png', true)

			Bankpin.label[1] = guiCreateLabel(0.03, 0.16, 0.93, 0.14, 'Trage deinen Pin ein:', true, Bankpin.window[1])
			guiSetFont(Bankpin.label[1], 'default-bold-small')
			guiLabelSetHorizontalAlign(Bankpin.label[1], 'center', true)
			guiLabelSetVerticalAlign(Bankpin.label[1], 'center')
			Bankpin.edit[1] = guiCreateEdit(0.23, 0.29, 0.53, 0.15, '', true, Bankpin.window[1])
			Bankpin.button[1] = guiCreateButton(0.15, 0.61, 0.71, 0.14, 'Einloggen', true, Bankpin.window[1])
			guiSetProperty(Bankpin.button[1], 'NormalTextColour', 'FFAAAAAA')
			Bankpin.button[2] = guiCreateButton(0.15, 0.80, 0.71, 0.14, 'Schließen', true, Bankpin.window[1])
			guiSetProperty(Bankpin.button[2], 'NormalTextColour', 'FFAAAAAA')
			
			if(getElementData(localPlayer,'Language') == 1)then
				guiSetText(Bankpin.label[1],'Your pin carrying a:')
				guiSetText(Bankpin.button[1],'Login')
				guiSetText(Bankpin.button[2],'Close')
			end
			
			addEventHandler('onClientGUIClick',Bankpin.button[1],function()
				local bankpin = getElementData(localPlayer,'Bankpin')
				local bankpin2 = tonumber(guiGetText(Bankpin.edit[1]))
				
				if(bankpin == bankpin2)then
					destroyElement(Bankpin.window[1])
					atmWindow()
				else
					if(getElementData(localPlayer,'Language')==0)then
						infobox('Der Bankpin ist nicht korrekt!',255,0,0)
					else
						infobox('The pin is not correct!',255,0,0)
					end
				end
			end,false)
			
			addEventHandler('onClientGUIClick',Bankpin.button[2],function()
				destroyElement(Bankpin.window[1])
				showCursor(false)
				setElementData(localPlayer,'redfieldClick',false)
			end,false)
		end
    end
end
addEvent('bankpinWindow',true)
addEventHandler('bankpinWindow',root,bankpinWindow)

local Atm = {button = {},window = {},edit = {},label = {}}

function atmWindow()
	if(not(isElement(Atm.window[1])))then
        Atm.window[1] = guiCreateStaticImage(0.40, 0.40, 0.21, 0.22, 'images/background.png', true)

        Atm.label[1] = guiCreateLabel(0.04, 0.13, 0.93, 0.11, 'Kontostand: '..getElementData(localPlayer,'Bankmoney')..'$', true, Atm.window[1])
        guiSetFont(Atm.label[1], 'default-bold-small')
        guiLabelSetHorizontalAlign(Atm.label[1], 'center', true)
        guiLabelSetVerticalAlign(Atm.label[1], 'center')
        Atm.edit[1] = guiCreateEdit(0.23, 0.29, 0.53, 0.15, '', true, Atm.window[1])
        Atm.button[1] = guiCreateButton(0.15, 0.65, 0.71, 0.12, 'Auszahlen', true, Atm.window[1])
        guiSetProperty(Atm.button[1], 'NormalTextColour', 'FFAAAAAA')
        Atm.button[2] = guiCreateButton(0.15, 0.49, 0.71, 0.12, 'Einzahlen', true, Atm.window[1])
        guiSetProperty(Atm.button[2], 'NormalTextColour', 'FFAAAAAA')
        Atm.button[3] = guiCreateButton(0.15, 0.82, 0.71, 0.12, 'Schließen', true, Atm.window[1])
        guiSetProperty(Atm.button[3], 'NormalTextColour', 'FFAAAAAA')
		
		if(getElementData(localPlayer,'Language') == 1)then
			guiSetText(Atm.label[1],'Your account balance '..getElementData(localPlayer,'Bankmoney')..'$')
			guiSetText(Atm.button[1],'Pay out')
			guiSetText(Atm.button[2],'Pay in')
			guiSetText(Atm.button[3],'Close')
		end
		
		addEventHandler('onClientGUIClick',Atm.button[1],function()
			local auszahlenSumme = guiGetText(Atm.edit[1])
			local bankmoney = getElementData(localPlayer,'Bankmoney')
			
			if(auszahlenSumme == '')then
				if(getElementData(localPlayer,'Language')==0)then
					infobox('Trag eine Summe ein!',255,0,0)
				else
					infobox('Please provide a sum!',255,0,0)
				end
			else
				if(bankmoney >= tonumber(auszahlenSumme))then
					triggerServerEvent('auszahlenServer',localPlayer,auszahlenSumme)
				else
					if(getElementData(localPlayer,'Language') == 0)then
						infobox('So viel Geld befindet sich nicht auf deinem Konto!',255,0,0)
					else
						infobox('You have not enough money on your account!',255,0,0)
					end
				end
			end
		end,false)
		
		addEventHandler('onClientGUIClick',Atm.button[2],function()
			local einzahlenSumme = guiGetText(Atm.edit[1])
			local money = getPlayerMoney(localPlayer)
			
			if(einzahlenSumme == '')then
				if(getElementData(localPlayer,'Language') == 0)then
					infobox('Trage eine Summe ein!',255,0,0)
				else
					infobox('Please provide a sum!',255,0,0)
				end
			else
				if(money >= tonumber(einzahlenSumme))then
					triggerServerEvent('einzahlenServer',localPlayer,einzahlenSumme)
				else 
					if(getElementData(localPlayer,'Language') == 0)then
						infobox('So viel Geld hast du nicht dabei!',255,0,0)
					else
						infobox('You have not enough money!',255,0,0)
					end
				end
			end
		end,false)
		
		addEventHandler('onClientGUIClick',Atm.button[3],function()
			destroyElement(Atm.window[1])
			showCursor(false)
			setElementData(localPlayer,'redfieldClick',false)
		end,false)
    end
end

function updateMoneyLabel()
	if(getElementData(localPlayer,'Language') == 0)then
		guiSetText(Atm.label[1],'Dein Kontostand: '..getElementData(localPlayer,'Bankmoney')..'$')
	else
		guiSetText(Atm.label[1],'Your account balance '..getElementData(localPlayer,'Bankmoney')..'$')
	end
end
addEvent('updateMoneyLabel',true)
addEventHandler('updateMoneyLabel',root,updateMoneyLabel)