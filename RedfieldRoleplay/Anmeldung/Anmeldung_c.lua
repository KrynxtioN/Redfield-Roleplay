local Ameldung = {tab = {},tabpanel = {},edit = {},button = {},window = {},label = {},staticimage = {}}
local x,y = guiGetScreenSize()
local german = true
local english = false

function blackBalken()
    dxDrawRectangle(0*(x/1440), 0*(y/900), 1440*(x/1440), 49*(y/900), tocolor(0, 0, 0, 255), false)
    dxDrawRectangle(0*(x/1440), 851*(y/900), 1440*(x/1440), 49*(y/900), tocolor(0, 0, 0, 255), false)
end

addEventHandler('onClientResourceStart', resourceRoot,function()
	if(not(isElement(Ameldung.window[1])))then
		showChat(false)
		fadeCamera(true)
		showCursor(true)
		setElementData(localPlayer,'german',true)
		setPlayerHudComponentVisible('radar',false)
		setElementData(localPlayer,'redfieldClick',true)
		addEventHandler('onClientRender',root,blackBalken)
		setCameraMatrix(-181.89030456543,1188.7331542969,75.061599731445,-181.4167175293,1188.0411376953,74.516807556152,0,70)
	
        Ameldung.window[1] = guiCreateStaticImage(0.01, 0.00, 0.99, 1.00,'Images/Login.png',true)
		
        Ameldung.tabpanel[1] = guiCreateTabPanel(0.31, 0.47, 0.40, 0.20, true, Ameldung.window[1])
        Ameldung.tab[1] = guiCreateTab('Einloggen', Ameldung.tabpanel[1])
        Ameldung.button[1] = guiCreateButton(0.02, 0.69, 0.96, 0.24, 'Einloggen', true, Ameldung.tab[1])
        Ameldung.label[1] = guiCreateLabel(0.02, 0.03, 0.31, 0.14, 'Username', true, Ameldung.tab[1])
        guiSetFont(Ameldung.label[1], 'default-bold-small')
        guiLabelSetHorizontalAlign(Ameldung.label[1], 'center', false)
        guiLabelSetVerticalAlign(Ameldung.label[1], 'center')
        Ameldung.edit[1] = guiCreateEdit(0.02, 0.24, 0.31, 0.16, getPlayerName(localPlayer), true, Ameldung.tab[1])
        Ameldung.label[2] = guiCreateLabel(0.34, 0.03, 0.31, 0.14, 'Passwort', true, Ameldung.tab[1])
        guiSetFont(Ameldung.label[2], 'default-bold-small')
        guiLabelSetHorizontalAlign(Ameldung.label[2], 'center', false)
        guiLabelSetVerticalAlign(Ameldung.label[2], 'center')
        Ameldung.edit[2] = guiCreateEdit(0.34, 0.24, 0.31, 0.16, '', true, Ameldung.tab[1])

        Ameldung.tab[2] = guiCreateTab('Registrieren', Ameldung.tabpanel[1])
        Ameldung.button[2] = guiCreateButton(0.02, 0.69, 0.96, 0.24, 'Registrieren', true, Ameldung.tab[2])
        Ameldung.label[4] = guiCreateLabel(0.02, 0.03, 0.31, 0.14, 'Username', true, Ameldung.tab[2])
        guiSetFont(Ameldung.label[4], 'default-bold-small')
        guiLabelSetHorizontalAlign(Ameldung.label[4], 'center', false)
        guiLabelSetVerticalAlign(Ameldung.label[4], 'center')
        Ameldung.edit[3] = guiCreateEdit(0.02, 0.24, 0.31, 0.16, getPlayerName(localPlayer), true, Ameldung.tab[2])
        Ameldung.label[5] = guiCreateLabel(0.34, 0.03, 0.31, 0.14, 'Passwort', true, Ameldung.tab[2])
        guiSetFont(Ameldung.label[5], 'default-bold-small')
        guiLabelSetHorizontalAlign(Ameldung.label[5], 'center', false)
        guiLabelSetVerticalAlign(Ameldung.label[5], 'center')
        Ameldung.edit[4] = guiCreateEdit(0.34, 0.24, 0.31, 0.16, '', true, Ameldung.tab[2])
		
        Ameldung.button[3] = guiCreateButton(0.41, 0.70, 0.05, 0.06, 'English', true, Ameldung.window[1])
        Ameldung.button[4] = guiCreateButton(0.55, 0.70, 0.05, 0.06, 'German', true, Ameldung.window[1]) 
		guiSetAlpha(Ameldung.button[3],0)
		guiSetAlpha(Ameldung.button[4],0)
		
		addEventHandler('onClientGUIClick',Ameldung.button[3],function()
			guiSetText(Ameldung.button[1],'Login')
			guiSetText(Ameldung.button[2],'Register')
			guiSetText(Ameldung.label[5],'Password')
			guiSetText(Ameldung.label[2],'Password')
			guiSetText(Ameldung.tab[1],'Login')
			guiSetText(Ameldung.tab[2],'Register')
			setElementData(localPlayer,'german',false)
			english = true
			german = false
		end,false)
		addEventHandler('onClientGUIClick',Ameldung.button[4],function()
			guiSetText(Ameldung.button[1],'Einloggen')
			guiSetText(Ameldung.button[2],'Registrieren')
			guiSetText(Ameldung.label[5],'Passwort')
			guiSetText(Ameldung.label[2],'Passwort')
			guiSetText(Ameldung.tab[1],'Einloggen')
			guiSetText(Ameldung.tab[2],'Registrieren')
			setElementData(localPlayer,'german',true)
			english = false
			german = true
		end,false)
		
		addEventHandler('onClientGUIClick',Ameldung.button[1],function()
			local name = getPlayerName(localPlayer)
			local passwort = guiGetText(Ameldung.edit[2])
			
			if(passwort == '')then
				if(german == true)then
					infobox('Es wurde kein Passwort angegeben!',255,0,0)
				elseif(english == true)then
					infobox('Please provide a Passwort!',255,0,0)
				end
			else
				if(passwort:len() >= 4)then
					triggerServerEvent('redfieldEinloggen',localPlayer,name,passwort)
				else
					if(german == true)then
						infobox('Das Passwort muss mindestens 4 Zeichen lang sein!',255,0,0)
					elseif(english == true)then
						infobox('The password must be at least 4 characters!',255,0,0)
					end
				end
			end
		end,false)
		
		addEventHandler('onClientGUIClick',Ameldung.button[2],function()
			local name = getPlayerName(localPlayer)
			local passwort = guiGetText(Ameldung.edit[4])
			
			if(passwort == '')then
				if(german == true)then
					infobox('Es wurde kein Passwort angegeben!',255,0,0)
				elseif(english == true)then
					infobox('Please provide a Passwort!',255,0,0)
				end
			else
				if(passwort:len() >= 4)then
					if(german == true)then
						triggerServerEvent('redfieldRegistrieren',localPlayer,name,passwort,'0')
					elseif(english == true)then
						triggerServerEvent('redfieldRegistrieren',localPlayer,name,passwort,'1')
					end
				else
					if(german == true)then
						infobox('Das Passwort muss mindestens 4 Zeichen lang sein!',255,255,255)
					elseif(english == true)then
						infobox('The password must be at least 4 characters!',255,255,255)
					end
				end
			end
		end,false)
	end
end)

function destroyAnmeldung()
	showChat(true)
	showCursor(false)
	setCameraTarget(localPlayer)
	destroyElement(Ameldung.window[1])
	setPlayerHudComponentVisible('radar',true)
	setElementData(localPlayer,'redfieldClick',false)
	removeEventHandler('onClientRender',root,blackBalken)
end
addEvent('destroyAnmeldung',true)
addEventHandler('destroyAnmeldung',root,destroyAnmeldung)