local jobcenter = {gridlist = {},window = {},button = {}}

local JobInfos = {
[1] = {'Pilot',-1421.4528808594,-287.35494995117,14.1484375},
[2] = {'Pizzalieferant',2122.1867675781,-1823.1586914063,13.557378768921},
[3] = {'Holzfaeller',-538.60534667969,-78.070526123047,62.8671875},
[4] = {'Tankwart',639.02117919922,1683.3165283203,7.1875},
[5] = {"Busfahrer",12.60000038147,1225.5,19.299999237061},
[6] = {"Farmer",-1061.4000244141,-1195.5999755859,129.80000305176},
}

function jobcenterWindow(hitplayer)
	if(getElementData(localPlayer,'redfieldClick') == false)then
		if(not(isElement(jobcenter.window[1])))then
			--if(hitplayer == localPlayer)then
				showCursor(true)
				setElementData(localPlayer,'redfieldClick',true)
			
				jobcenter.window[1] = guiCreateStaticImage(0.40, 0.31, 0.21, 0.35, 'Images/Background.png', true)

				jobcenter.gridlist[1] = guiCreateGridList(0.04, 0.09, 0.92, 0.72, true, jobcenter.window[1])
				guiGridListAddColumn(jobcenter.gridlist[1], 'Job', 1)
				for i = 1, 6 do
					guiGridListAddRow(jobcenter.gridlist[1])
				end
				if(getElementData(localPlayer,'Language') == 0)then
					guiGridListSetItemText(jobcenter.gridlist[1], 0, 1, 'Pilot', false, false)
					guiGridListSetItemText(jobcenter.gridlist[1], 1, 1, 'Pizzalieferant', false, false)
					guiGridListSetItemText(jobcenter.gridlist[1], 2, 1, 'Holzfäller', false, false)
					guiGridListSetItemText(jobcenter.gridlist[1], 3, 1, 'Tankwart', false, false)
					guiGridListSetItemText(jobcenter.gridlist[1], 4, 1, 'Busfahrer', false, false)
				else
					guiGridListSetItemText(jobcenter.gridlist[1], 0, 1, 'Pilot', false, false)
					guiGridListSetItemText(jobcenter.gridlist[1], 1, 1, 'Pizzaman', false, false)
					guiGridListSetItemText(jobcenter.gridlist[1], 2, 1, 'Lumberjack', false, false)
					guiGridListSetItemText(jobcenter.gridlist[1], 3, 1, 'Gas station attendant', false, false)
					guiGridListSetItemText(jobcenter.gridlist[1], 4, 1, 'Busdriver', false, false)
				end
				guiGridListSetItemText(jobcenter.gridlist[1], 5, 1, 'Farmer', false, false)
				
				jobcenter.button[1] = guiCreateButton(0.04, 0.83, 0.41, 0.09, 'Annehmen', true, jobcenter.window[1])
				guiSetProperty(jobcenter.button[1], 'NormalTextColour', 'FFAAAAAA')
				jobcenter.button[2] = guiCreateButton(0.54, 0.83, 0.41, 0.09, 'Schließen', true, jobcenter.window[1])
				guiSetProperty(jobcenter.button[2], 'NormalTextColour', 'FFAAAAAA')
				
				if(getElementData(localPlayer,'Language') == 1)then
					guiSetText(jobcenter.button[1],'Accept')
					guiSetText(jobcenter.button[2],'Close')
				end
				
				addEventHandler('onClientGUIClick',jobcenter.button[1],function()
					if(getElementData(localPlayer,'Arbeitsgenehmigung') == 1)then
						selectedText=guiGridListGetItemText(jobcenter.gridlist[1],guiGridListGetSelectedItem(jobcenter.gridlist[1]),1)
						
						if(selectedText)then
							if(selectedText == 'Pilot')then
								Job = 1
							elseif(selectedText == 'Pizzalieferant' or selectedText == 'Pizzaman')then
								Job = 2
							elseif(selectedText == 'Holzfäller' or selectedText == 'Lumberjack')then
								Job = 3
							elseif(selectedText == 'Tankwart' or selectedText == 'Gas station attendant')then
								Job = 4
							elseif(selectedText == "Busfahrer" or selectedText == "Busdriver")then
								Job = 5
							elseif(selectedText == "Farmer")then
								Job = 6
							end
							jobInfos_func()
						end
					else
						if(getElementData(localPlayer,"Language") == 0)then
							infobox('Du benötigst eine Arbeitsgenehmigung!',255,255,255)
						else
							infobox('You need a Work-License!',255,255,255)
						end
					end
				end,false)
				
				addEventHandler('onClientGUIClick',jobcenter.button[2],function()
					showCursor(false)
					destroyElement(jobcenter.window[1])
					setElementData(localPlayer,'redfieldClick',false)
				end,false)
			--end
		end
	end
end
addEvent("jobcenterWindow",true)
addEventHandler("jobcenterWindow",root,jobcenterWindow)

function jobInfos_func()
	if(isElement(jobBlip))then
		destroyElement(jobBlip)
	end
	
	if(isTimer(jobBlipTimer))then
		killTimer(jobBlipTimer)
	end
	
	jobBlip = createBlip(JobInfos[Job][2],JobInfos[Job][3],JobInfos[Job][4],0,2,255,255,0)
	jobBlipTimer = setTimer(function()
		destroyElement(jobBlip)
	end,120000,1)
	
	if(getElementData(localPlayer,'Language') == 0)then
		outputChatBox('Der Job wurde mit einem gelben Blip auf der Karte markiert.',0,200,0)
	else
		outputChatBox('The Job is marked with a yellow Blip on the Map.',0,200,0)
	end
end