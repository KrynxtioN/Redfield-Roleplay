local fkasse = {button = {},window = {},radiobutton = {},edit = {}}

function factionWindow()
	if(not(isElement(fkasse.window[1])))then
		if(not(getElementData(localPlayer,"redfieldClick"))==true)then
			if(getElementData(localPlayer,"Fraktion")>0)then
				triggerServerEvent("fstate",localPlayer,localPlayer)
				setElementData(localPlayer,"redfieldClick",true)
				showCursor(true)
			
				fkasse.window[1] = guiCreateStaticImage(0.44, 0.33, 0.12, 0.29, "Images/Background.png", true)

				fkasse.radiobutton[1] = guiCreateRadioButton(0.05, 0.09, 0.87, 0.06, "Geld", true, fkasse.window[1])
				guiSetFont(fkasse.radiobutton[1], "default-bold-small")
				guiRadioButtonSetSelected(fkasse.radiobutton[1], true)
				fkasse.radiobutton[2] = guiCreateRadioButton(0.05, 0.19, 0.87, 0.06, "Drogen", true, fkasse.window[1])
				guiSetFont(fkasse.radiobutton[2], "default-bold-small")
				fkasse.radiobutton[3] = guiCreateRadioButton(0.05, 0.29, 0.87, 0.06, "Materialien", true, fkasse.window[1])
				guiSetFont(fkasse.radiobutton[3], "default-bold-small")
				fkasse.button[1] = guiCreateButton(0.05, 0.52, 0.87, 0.10, "Einzahlen", true, fkasse.window[1])
				guiSetProperty(fkasse.button[1], "NormalTextColour", "FFAAAAAA")
				fkasse.edit[1] = guiCreateEdit(10, 100, 152, 27, "", false, fkasse.window[1])
				fkasse.button[2] = guiCreateButton(0.05, 0.67, 0.87, 0.10, "Auszahlen", true, fkasse.window[1])
				guiSetProperty(fkasse.button[2], "NormalTextColour", "FFAAAAAA")
				fkasse.button[3] = guiCreateButton(0.05, 0.86, 0.87, 0.10, "Schließen", true, fkasse.window[1])
				guiSetProperty(fkasse.button[3], "NormalTextColour", "FFAAAAAA")
				
				addEventHandler("onClientGUIClick",fkasse.button[2],function()
					local menge=tonumber(guiGetText(fkasse.edit[1]))
					
					if(menge)then
						if(guiRadioButtonGetSelected(fkasse.radiobutton[1]))then
							triggerServerEvent("updatefstate",localPlayer,"auszahlen","money",menge,getElementData(localPlayer,"Fraktion"))
						elseif(guiRadioButtonGetSelected(fkasse.radiobutton[2]))then
							triggerServerEvent("updatefstate",localPlayer,"auszahlen","drugs",menge,getElementData(localPlayer,"Fraktion"))
						elseif(guiRadioButtonGetSelected(fkasse.radiobutton[3]))then
							triggerServerEvent("updatefstate",localPlayer,"auszahlen","mats",menge,getElementData(localPlayer,"Fraktion"))
						end
					else
						if(getElementData(localPlayer,"Language")==0)then
							infobox("Gib eine Anzahl an!",255,255,255)
						else
							infobox("Provide a Number!",255,255,255)
						end
					end
				end,false)
				
				addEventHandler("onClientGUIClick",fkasse.button[1],function()
					local menge=tonumber(guiGetText(fkasse.edit[1]))
					
					if(menge)then
						if(guiRadioButtonGetSelected(fkasse.radiobutton[1]))then
							triggerServerEvent("updatefstate",localPlayer,"einzahlen","money",menge,getElementData(localPlayer,"Fraktion"))
						elseif(guiRadioButtonGetSelected(fkasse.radiobutton[2]))then
							triggerServerEvent("updatefstate",localPlayer,"einzahlen","drugs",menge,getElementData(localPlayer,"Fraktion"))
						elseif(guiRadioButtonGetSelected(fkasse.radiobutton[3]))then
							triggerServerEvent("updatefstate",localPlayer,"einzahlen","mats",menge,getElementData(localPlayer,"Fraktion"))
						end
					else
						if(getElementData(localPlayer,"Language")==0)then
							infobox("Gib eine Anzahl an!",255,255,255)
						else
							infobox("Provide a Number!",255,255,255)
						end
					end
				end,false)
				
				addEventHandler("onClientGUIClick",fkasse.button[3],function()
					destroyElement(fkasse.window[1])
					showCursor(false)
					setElementData(localPlayer,"redfieldClick",false)
				end,false)
			end
		end
    end
end
bindKey("f5","down",factionWindow)