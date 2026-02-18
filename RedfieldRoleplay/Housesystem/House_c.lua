local housemenue = {button = {},window = {},label = {}}

function houseWindow()
	if(not(isElement(housemenue.window[1])))then
		if(not(getElementData(localPlayer,"redfieldClick"))==true)then
			if(getElementData(localPlayer,"isPlayerInHouse")==true)then
				showCursor(true)
				setElementData(localPlayer,"redfieldClick",true)
		
				housemenue.window[1] = guiCreateStaticImage(0.39, 0.42, 0.25, 0.19, "Images/Background.png", true)

				housemenue.label[1] = guiCreateLabel(0.03, 0.15, 0.94, 0.36, "Dies ist das Hausmenü, hier kannst du dich jederzeit kostenlos heilen und Essen.", true, housemenue.window[1])
				guiSetFont(housemenue.label[1], "default-bold-small")
				guiLabelSetHorizontalAlign(housemenue.label[1], "center", true)
				guiLabelSetVerticalAlign(housemenue.label[1], "center")
				housemenue.button[1] = guiCreateButton(0.03, 0.57, 0.46, 0.17, "Heilen", true, housemenue.window[1])
				guiSetProperty(housemenue.button[1], "NormalTextColour", "FFAAAAAA")
				housemenue.button[2] = guiCreateButton(0.51, 0.57, 0.46, 0.17, "Essen", true, housemenue.window[1])
				guiSetProperty(housemenue.button[2], "NormalTextColour", "FFAAAAAA")
				housemenue.button[3] = guiCreateButton(0.03, 0.78, 0.94, 0.16, "Schließen", true, housemenue.window[1])
				guiSetProperty(housemenue.button[3], "NormalTextColour", "FFAAAAAA")
				
				if(getElementData(localPlayer,"Language")==1)then
					guiSetText(housemenue.label[1],"This is the Housemenu. Here you can fill your hunger and Health.")
					guiSetText(housemenue.button[1],"100% Health")
					guisetText(housemenue.button[2],"100% Hunger")
					guiSetText(housemenue.button[3],"Close")
				end
				
				addEventHandler("onClientGUIClick",housemenue.button[1],function()
					triggerServerEvent("house_heilen",localPlayer,localPlayer)
				end)
				
				addEventHandler("onClientGUIClick",housemenue.button[2],function()
					triggerServerEvent("house_eat",localPlayer,localPlayer)
				end)
				
				addEventHandler("onClientGUIClick",housemenue.button[3],function()
					showCursor(false)
					setElementData(localPlayer,"redfieldClick",false)
					destroyElement(housemenue.window[1])
				end)
			end
		end
	end
end
bindKey("f2","down",houseWindow)