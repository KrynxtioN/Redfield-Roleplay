local Bankverwaltung = {button = {},window = {},label = {}}

local openBankverwaltungWindowPickup = createPickup(362.37442016602,173.54965209961,1008.3828125,3,1239,50)
setElementInterior(openBankverwaltungWindowPickup,3)
setElementDimension(openBankverwaltungWindowPickup,1)

function bankverwaltungWindow(hitPlayer)
	if(getElementData(localPlayer,'redfieldClick') == false)then
		if(getElementDimension(localPlayer) == 1)then
			--if(hitPlayer == localPlayer)then
				if(not(isElement(Bankverwaltung.window[1])))then
					showCursor(true)
					setElementData(localPlayer,'redfieldClick',true)
				
					Bankverwaltung.window[1] = guiCreateStaticImage(0.40, 0.39, 0.21, 0.21, 'Images/Background.png', true)
					
					Bankverwaltung.button[1] = guiCreateButton(0.03, 0.58, 0.43, 0.14, 'Konto eröffnen', true, Bankverwaltung.window[1])
					guiSetProperty(Bankverwaltung.button[1], 'NormalTextColour', 'FFAAAAAA')
					Bankverwaltung.button[2] = guiCreateButton(0.54, 0.58, 0.43, 0.14, 'Pin nachfragen', true, Bankverwaltung.window[1])
					guiSetProperty(Bankverwaltung.button[2], 'NormalTextColour', 'FFAAAAAA')
					Bankverwaltung.button[3] = guiCreateButton(0.29, 0.81, 0.43, 0.14, 'Schließen', true, Bankverwaltung.window[1])
					guiSetProperty(Bankverwaltung.button[3], 'NormalTextColour', 'FFAAAAAA')
					
					Bankverwaltung.label[1] = guiCreateLabel(0.03, 0.15, 0.93, 0.34, 'Um dein Geld besser verwalten zu können, benötigst du ein Konto, welches du hier erstellen lassen kannst.', true, Bankverwaltung.window[1])
					guiSetFont(Bankverwaltung.label[1], 'default-bold-small')
					guiLabelSetHorizontalAlign(Bankverwaltung.label[1], 'center', true)
					guiLabelSetVerticalAlign(Bankverwaltung.label[1], 'center')
					
					if(getElementData(localPlayer,'Language') == 1)then
						guiSetText(Bankverwaltung.button[1],'Create a bank account')
						guiSetText(Bankverwaltung.button[2],'Ask for your pin')
						guiSetText(Bankverwaltung.button[3],'Close')
						guiSetText(Bankverwaltung.label[1],'Create a Bank-Account, to manage your money better.')
					end
					
					addEventHandler('onClientGUIClick',Bankverwaltung.button[1],function()
						local bankpin = getElementData(localPlayer,'Bankpin')
						
						if(bankpin == 0)then
							local createPin = math.random(1000,9999)
							
							setElementData(localPlayer,'Bankpin',createPin)
							if(getElementData(localPlayer,'Language') == 0)then
								infobox('Dein Pin lautet: '..createPin,0,255,0)
							else
								infobox('Your pin: '..createPin,0,255,0)
							end
							
							if(getElementData(localPlayer,'AchKonto') == 0)then
								setElementData(localPlayer,'AchKonto',1)
								triggerServerEvent('achievmentInfo',localPlayer,localPlayer)
							end
						else
							if(getElementData(localPlayer,'Language') == 0)then
								infobox('Du hast bereits ein Konto!',255,0,0)
							else
								infobox('You already have a account!',255,0,0)
							end
						end
					end,false)
					
					addEventHandler('onClientGUIClick',Bankverwaltung.button[2],function()
						local bankpin=getElementData(localPlayer,'Bankpin')
						
						if(not(bankpin == 0))then
							if(getElementData(localPlayer,'Language') == 0)then
								infobox('Dein Pin lautet: '..bankpin,0,255,0)
							else
								infobox('Your pin: '..bankpin,0,255,0)
							end
						else
							if(getElementData(localPlayer,'Language') == 0)then
								infobox('Du hast kein Konto!',255,0,0)
							else
								infobox('You have no account!',255,0,0)
							end
						end
					end,false)
					
					addEventHandler('onClientGUIClick',Bankverwaltung.button[3],function()
						showCursor(false)
						destroyElement(Bankverwaltung.window[1])
						setElementData(localPlayer,'redfieldClick',false)
					end,false)
				end
			--end
		end
	end
end
addEvent("bankverwaltungWindow",true)
addEventHandler("bankverwaltungWindow",root,bankverwaltungWindow)