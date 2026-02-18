local versicherung = {button = {},window = {},label = {}}

function versicherungWindow()
	if(not(isElement(versicherung.window[1])))then
		if(getElementData(localPlayer,"redfieldClick")==false)then
			setElementData(localPlayer,"redfieldClick",true)
			showCursor(true)
		
			versicherung.window[1] = guiCreateStaticImage(0.39, 0.40, 0.22, 0.19, "Images/Background.png", true)

			versicherung.label[1] = guiCreateLabel(0.03, 0.15, 0.94, 0.31, "Hier können Sie eine Lebensversicherung abschließen, die pro Payday 750$ kostet. Die Versicherung deckt alle medizinischen Kosten, wenn Sie sterben.", true, versicherung.window[1])
			guiSetFont(versicherung.label[1], "default-bold-small")
			guiLabelSetHorizontalAlign(versicherung.label[1], "left", true)
			versicherung.button[1] = guiCreateButton(0.19, 0.52, 0.62, 0.18, "Lebensversicherung abschließen", true, versicherung.window[1])
			guiSetProperty(versicherung.button[1], "NormalTextColour", "FFAAAAAA")
			versicherung.button[2] = guiCreateButton(0.19, 0.76, 0.62, 0.18, "Schließen", true, versicherung.window[1])
			guiSetProperty(versicherung.button[2], "NormalTextColour", "FFAAAAAA")
			
			if(getElementData(localPlayer,"Language")==0)then
				if(getElementData(localPlayer,"Versicherung")==1)then
					guiSetText(versicherung.button[1],"Lebensversicherung kündigen")
				end
			else
				guiSetText(versicherung.label[1],"Here you can take out a life insurance policy, which per Payday $ 750 costs. The insurance covers all medical expenses when you die.")
				if(getElementData(localPlayer,"Versicherung")==0)then
					guiSetText(versicherung.button[1],"Complete Life Insurance")
				else
					guiSetText(versicherung.button[1],"Terminate life insurance")
				end
				guiSetText(versicherung.button[2],"Close")
			end
			
			addEventHandler("onClientGUIClick",versicherung.button[1],function()
				if(getElementData(localPlayer,"Versicherung")==0)then
					triggerServerEvent("versicherung",localPlayer,localPlayer)
					if(getElementData(localPlayer,"Language")==0)then
						guiSetText(versicherung.button[1],"Lebensversicherung kündigen")
					else
						guiSetText(versicherung.button[1],"Terminate life insurance")
					end
				else
					triggerServerEvent("versicherungStop",localPlayer,localPlayer)
					if(getElementData(localPlayer,"Language")==0)then
						guiSetText(versicherung.button[1],"Lebensversicherung abschließen")
					else
						guiSetText(versicherung.button[1],"Complete Life Insurance")
					end
				end
			end,false)
			
			addEventHandler("onClientGUIClick",versicherung.button[2],function()
				setElementData(localPlayer,"redfieldClick",false)
				showCursor(false)
				destroyElement(versicherung.window[1])
			end,false)
		end
    end
end
addEvent("versicherungWindow",true)
addEventHandler("versicherungWindow",root,versicherungWindow)