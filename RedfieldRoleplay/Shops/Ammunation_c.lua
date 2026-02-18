local ammunationTabelle = {
-- Id, Price, Ammo
[1] = {24,250,14},
[2] = {29,900,90},
[3] = {31,1500,200},
[4] = {33,1200,30},
[5] = {25,300,20},
[6] = {28,1000,300},
[7] = {30,1800,150}
}

local ammunation = {button = {},window = {}}

function ammuWindow()
	if(getElementData(localPlayer,'redfieldClick')==false)then
		if(not(isElement(ammunation.window[1])))then
			showCursor(true)
			setElementData(localPlayer,'redfieldClick',true)

			ammunation.window[1] = guiCreateStaticImage(0.36, 0.36, 0.27, 0.26, 'Images/Background.png', true)

			ammunation.button[1] = guiCreateButton(0.03, 0.13, 0.46, 0.14, 'Deagle | 14 Schuss | 250$', true, ammunation.window[1])
			guiSetProperty(ammunation.button[1], 'NormalTextColour', 'FFAAAAAA')
			ammunation.button[2] = guiCreateButton(0.51, 0.13, 0.46, 0.14, 'Mp5 | 90 Schuss | 900$', true, ammunation.window[1])
			guiSetProperty(ammunation.button[2], 'NormalTextColour', 'FFAAAAAA')
			ammunation.button[3] = guiCreateButton(0.51, 0.30, 0.46, 0.14, 'M4 | 200 Schuss | 1500$', true, ammunation.window[1])
			guiSetProperty(ammunation.button[3], 'NormalTextColour', 'FFAAAAAA')
			ammunation.button[4] = guiCreateButton(0.03, 0.30, 0.46, 0.14, 'Rifle | 30 Schuss | 1200$', true, ammunation.window[1])
			guiSetProperty(ammunation.button[4], 'NormalTextColour', 'FFAAAAAA')
			ammunation.button[5] = guiCreateButton(0.03, 0.48, 0.46, 0.14, 'Shotgun | 20 Schuss | 300$', true, ammunation.window[1])
			guiSetProperty(ammunation.button[5], 'NormalTextColour', 'FFAAAAAA')
			ammunation.button[6] = guiCreateButton(0.03, 0.66, 0.46, 0.14, 'Uzi | 300 Schuss | 1000$', true, ammunation.window[1])
			guiSetProperty(ammunation.button[6], 'NormalTextColour', 'FFAAAAAA')
			ammunation.button[7] = guiCreateButton(0.51, 0.48, 0.46, 0.14, 'AK47 | 150 Schuss | 1800$', true, ammunation.window[1])
			guiSetProperty(ammunation.button[7], 'NormalTextColour', 'FFAAAAAA')
			ammunation.button[8] = guiCreateButton(0.51, 0.66, 0.46, 0.14, 'Weste | 30$', true, ammunation.window[1])
			guiSetProperty(ammunation.button[8], 'NormalTextColour', 'FFAAAAAA')
			ammunation.button[9] = guiCreateButton(0.27, 0.82, 0.46, 0.14, 'Schließen', true, ammunation.window[1])
			guiSetProperty(ammunation.button[9], 'NormalTextColour', 'FFAAAAAA')
			
			if(getElementData(localPlayer,'Language')==1)then
				guiSetText(ammunation.button[1],'Deagle | 14 Ammo | 250$')
				guiSetText(ammunation.button[2],'Mp5 | 90 Ammo | 900$')
				guiSetText(ammunation.button[3],'M4 | 200 Ammo | 1500$')
				guiSetText(ammunation.button[4],'Rifle | 30 Ammo | 1200$')
				guiSetText(ammunation.button[5],'Shotgun | 20 Ammo | 300$')
				guiSetText(ammunation.button[6],'Uzi | 300 Ammo | 1000$')
				guiSetText(ammunation.button[7],'AK47 | 150 Ammo | 1800$')
				guiSetText(ammunation.button[8],'Armor | 30$')
				guiSetText(ammunation.button[9],'Close')
			end

			addEventHandler('onClientGUIClick',ammunation.button[1],function()
				triggerServerEvent('buyAmmunation',localPlayer,ammunationTabelle[1][1],ammunationTabelle[1][2],ammunationTabelle[1][3])
			end,false)
			addEventHandler('onClientGUIClick',ammunation.button[2],function()
				triggerServerEvent('buyAmmunation',localPlayer,ammunationTabelle[2][1],ammunationTabelle[2][2],ammunationTabelle[2][3])
			end,false)
			addEventHandler('onClientGUIClick',ammunation.button[3],function()
				triggerServerEvent('buyAmmunation',localPlayer,ammunationTabelle[3][1],ammunationTabelle[3][2],ammunationTabelle[3][3])
			end,false)
			addEventHandler('onClientGUIClick',ammunation.button[4],function()
				triggerServerEvent('buyAmmunation',localPlayer,ammunationTabelle[4][1],ammunationTabelle[4][2],ammunationTabelle[4][3])
			end,false)
			addEventHandler('onClientGUIClick',ammunation.button[5],function()
				triggerServerEvent('buyAmmunation',localPlayer,ammunationTabelle[5][1],ammunationTabelle[5][2],ammunationTabelle[5][3])
			end,false)
			addEventHandler('onClientGUIClick',ammunation.button[6],function()
				triggerServerEvent('buyAmmunation',localPlayer,ammunationTabelle[6][1],ammunationTabelle[6][2],ammunationTabelle[6][3])
			end,false)
			addEventHandler('onClientGUIClick',ammunation.button[7],function()
				triggerServerEvent('buyAmmunation',localPlayer,ammunationTabelle[7][1],ammunationTabelle[7][2],ammunationTabelle[7][3])
			end,false)
			addEventHandler('onClientGUIClick',ammunation.button[8],function()
				triggerServerEvent('weste',localPlayer,localPlayer)
			end,false)
			addEventHandler('onClientGUIClick',ammunation.button[9],function()
				destroyElement(ammunation.window[1])
				showCursor(false)
				setElementData(localPlayer,'redfieldClick',false)
			end,false)
		end
	end
end
addEvent('ammuWindow',true)
addEventHandler('ammuWindow',root,ammuWindow)