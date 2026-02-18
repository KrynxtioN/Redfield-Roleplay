local Job = {button = {},window = {},label = {}}

function openJobWindow(typ)
	if(not(isElement(Job.window[1])))then
		if(not(getElementData(localPlayer,"redfieldClick"))==true)then
			showCursor(true)
			setElementData(localPlayer,"redfieldClick",true)
		
			Job.window[1] = guiCreateStaticImage(0.40, 0.42, 0.21, 0.17, "Images/Background.png", true)

			Job.label[1] = guiCreateLabel(0.04, 0.19, 0.93, 0.21, "Job-Text", true, Job.window[1])
			guiSetFont(Job.label[1], "default-bold-small")
			guiLabelSetHorizontalAlign(Job.label[1], "center", true)
			guiLabelSetVerticalAlign(Job.label[1], "center")
			Job.button[1] = guiCreateButton(0.03, 0.49, 0.93, 0.17, "Job annehmen", true, Job.window[1])
			guiSetProperty(Job.button[1], "NormalTextColour", "FFAAAAAA")
			Job.button[2] = guiCreateButton(0.03, 0.73, 0.93, 0.17, "Schließen", true, Job.window[1])
			guiSetProperty(Job.button[2], "NormalTextColour", "FFAAAAAA")
			
			if(getElementData(localPlayer,"Language")==1)then
				guiSetText(Job.button[2],"Close")
				guiSetText(Job.button[1],"Accept Job")
			end
			
			addEventHandler("onClientGUIClick",Job.button[2],function()
				destroyElement(Job.window[1])
				showCursor(false)
				setElementData(localPlayer,"redfieldClick",false)
			end,false)
			
			addEventHandler("onClientGUIClick",Job.button[1],function()
				if(getElementData(localPlayer,"Arbeitsgenehmigung")==1)then
					if(typ=="pizza")then
						setElementData(localPlayer,"Job","Pizzalieferant")
					elseif(typ=="tankwart")then
						setElementData(localPlayer,"Job","Tankwart")
						if(getElementData(localPlayer,"Language")==0)then
							outputChatBox("Tippe nun '/tankjob', um den Job zu starten.",0,200,0)
						else
							outputChatBox("Now use '/tankjob', to start the Job.",0,200,0)
						end
					elseif(typ=="pilot")then
						setElementData(localPlayer,"Job","Pilot")
						if(getElementData(localPlayer,"Language")==0)then
							outputChatBox("Tippe nun '/flugjob [1-5]', um den Job zu starten.",0,200,0)
						else
							outputChatBox("Now use '/flugjob [1-5]', to start the Job.",0,200,0)
						end
					elseif(typ=="holzfaeller")then
						setElementData(localPlayer,"Job","Holzfaeller")
						if(getElementData(localPlayer,"Language")==0)then
							outputChatBox("Tippe nun '/holzjob', um den Job zu starten.",0,200,0)
						else
							outputChatBox("Now use '/holzjob', to start the Job.",0,200,0)
						end
					elseif(typ=="busfahrer")then
						setElementData(localPlayer,"Job","Busfahrer")
						if(getElementData(localPlayer,"Language")==0)then
							outputChatBox("Tippe nun '/busjob', um den Job zu starten.",0,200,0)
						else
							outputChatBox("Now use '/busjob', to start the Job.",0,200,0)
						end
					elseif(typ=="farmer")then
						setElementData(localPlayer,"Job","Farmer")
						if(getElementData(localPlayer,"Language")==0)then
							outputChatBox("Tippe nun '/farmjob', um den Job zu starten.",0,200,0)
						else
							outputChatBox("Now use '/farmjob', to start the Job.",0,200,0)
						end
					end
					if(getElementData(localPlayer,"Language") == 0)then
						infobox('Du hast den Job angenommen.',255,255,255)
					else
						infobox('You have accept the Job.',255,255,255)
					end
				else
					if(getElementData(localPlayer,"Language") == 0)then
						infobox('Du benötigst eine Arbeitsgenehmigung!',255,255,255)
					else
						infobox('You need a Work-License!',255,255,255)
					end
				end
			end,false)
			
			if(typ=="pizza")then
				if(getElementData(localPlayer,"Language")==0)then
					guiSetText(Job.label[1],"Möchtest du Pizzalieferant werden? Dann bist du bei mir genau richtig!")
				else
					guiSetText(Job.label[1],"Would you like to be a Pizza Man? Then you are exactly right with me!")
				end
			elseif(typ=="tankwart")then
				if(getElementData(localPlayer,"Language")==0)then
					guiSetText(Job.label[1],"Möchtest du Tankwart werden? Dann bist du bei mir genau richtig!")
				else
					guiSetText(Job.label[1],"Would you like to be a Gas station attendant? Then you are exactly right with me!")
				end
			elseif(typ=="pilot")then
				if(getElementData(localPlayer,"Language")==0)then
					guiSetText(Job.label[1],"Möchtest du Pilot werden? Dann bist du bei mir genau richtig!")
				else	
					guiSetText(Job.label[1],"Would you like to be a Pilot? Then you are exactly right with me!")
				end
			elseif(typ=="holzfaeller")then
				if(getElementData(localPlayer,"Language")==0)then
					guiSetText(Job.label[1],"Möchtest du Holzfäller werden? Dann bist du bei mir genau richtig!")
				else
					guiSetText(Job.label[1],"Would you like to be a Lumberjack? Then you are exactly right with me!")
				end
			elseif(typ=="busfahrer")then
				if(getElementData(localPlayer,"Language")==0)then
					guiSetText(Job.label[1],"Möchtest du Busfahrer werden? Dann bist du bei mir genau richtig!")
				else
					guiSetText(Job.label[1],"Would you like to be a Busdriver? Then you are exactly right with me!")
				end
			elseif(typ=="farmer")then
				if(getElementData(localPlayer,"Language")==0)then
					guiSetText(Job.label[1],"Möchtest du Farmer werden? Dann bist du bei mir genau richtig!")
				else
					guiSetText(Job.label[1],"Would you like to be a Farmer? Then you are exactly right with me!")
				end
			end
		end
	end
end
addEvent("openJobWindow",true)
addEventHandler("openJobWindow",root,openJobWindow)