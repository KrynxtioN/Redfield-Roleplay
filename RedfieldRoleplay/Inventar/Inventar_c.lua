local inventar = {gridlist = {},window = {}}

local notalloweditemsclick = {
['Eichenholz'] = true,
['Birkenholz'] = true,
['Drogen'] = true,
['Materialien'] = true,
['Oak wood'] = true,
['Birch wood'] = true,
['Drugs'] = true,
['Mats'] = true,
}

local outdoorobjects = {
['638'] = true,
['970'] = true,
['17037'] = true,
}

function inventarWindow()
	if(getElementData(localPlayer,'loggedin')==1)and not inTutorial == true then
		if(not(isElement(inventar.window[1])))then
			if(getElementData(localPlayer,'redfieldClick')==false)then
				if(getElementData(localPlayer,"Knastzeit")==0)and(getElementData(localPlayer,"Prisontime")==0)then
					showCursor(true)
					setElementData(localPlayer,'redfieldClick',true)
				
					inventar.window[1] = guiCreateStaticImage(0.40, 0.32, 0.21, 0.36, 'Images/Background.png', true)

					inventar.gridlist[1] = guiCreateGridList(0.03, 0.09, 0.93, 0.88, true, inventar.window[1])
					
					if(getElementData(localPlayer,'Language')==0)then
						guiGridListAddColumn(inventar.gridlist[1], 'Item', 0.5)
						guiGridListAddColumn(inventar.gridlist[1], 'Anzahl', 0.5)
					else
						guiGridListAddColumn(inventar.gridlist[1], 'Item', 0.5)
						guiGridListAddColumn(inventar.gridlist[1], 'Number', 0.5)
					end
					
					for i = 1, 32 do
						guiGridListAddRow(inventar.gridlist[1])
					end
					
					if(getElementData(localPlayer,'Language') == 0)then
						outputChatBox('Klick 2x auf "Anzahl", um die Liste zu ordnen.',0,200,0)
					else
						outputChatBox('Click 2x on "Number" to assign the list.',0,200,0)
					end

					if(getElementData(localPlayer,'Language') == 0)then
						guiGridListSetItemText(inventar.gridlist[1], 0, 1, 'Eichenholz', false, false)
						guiGridListSetItemText(inventar.gridlist[1], 0, 2, getElementData(localPlayer,'Eichenholz'), false, false)

						guiGridListSetItemText(inventar.gridlist[1], 1, 1, 'Birkenholz', false, false)
						guiGridListSetItemText(inventar.gridlist[1], 1, 2, getElementData(localPlayer,'Birkenholz'), false, false)

						guiGridListSetItemText(inventar.gridlist[1], 2, 1, 'Drogen', false, false)
						guiGridListSetItemText(inventar.gridlist[1], 2, 2, getElementData(localPlayer,'Drogen'), false, false)

						guiGridListSetItemText(inventar.gridlist[1], 3, 1, 'Materialien', false, false)
						guiGridListSetItemText(inventar.gridlist[1], 3, 2, getElementData(localPlayer,'Mats'), false, false)
					else
						guiGridListSetItemText(inventar.gridlist[1], 0, 1, 'Oak wood', false, false)
						guiGridListSetItemText(inventar.gridlist[1], 0, 2, getElementData(localPlayer,'Eichenholz'), false, false)

						guiGridListSetItemText(inventar.gridlist[1], 1, 1, 'Birch wood', false, false)
						guiGridListSetItemText(inventar.gridlist[1], 1, 2, getElementData(localPlayer,'Birkenholz'), false, false)

						guiGridListSetItemText(inventar.gridlist[1], 2, 1, 'Drugs', false, false)
						guiGridListSetItemText(inventar.gridlist[1], 2, 2, getElementData(localPlayer,'Drogen'), false, false)

						guiGridListSetItemText(inventar.gridlist[1], 3, 1, 'Mats', false, false)
						guiGridListSetItemText(inventar.gridlist[1], 3, 2, getElementData(localPlayer,'Mats'), false, false)
					end

					guiGridListSetItemText(inventar.gridlist[1], 4, 1, '1704', false, false)
					guiGridListSetItemText(inventar.gridlist[1], 4, 2, getElementData(localPlayer,'Objekt1704'), false, false)

					guiGridListSetItemText(inventar.gridlist[1], 5, 1, '1705', false, false)
					guiGridListSetItemText(inventar.gridlist[1], 5, 2, getElementData(localPlayer,'Objekt1705'), false, false)

					guiGridListSetItemText(inventar.gridlist[1], 6, 1, '1708', false, false)
					guiGridListSetItemText(inventar.gridlist[1], 6, 2, getElementData(localPlayer,'Objekt1708'), false, false)

					guiGridListSetItemText(inventar.gridlist[1], 7, 1, '1711', false, false)
					guiGridListSetItemText(inventar.gridlist[1], 7, 2, getElementData(localPlayer,'Objekt1711'), false, false)

					guiGridListSetItemText(inventar.gridlist[1], 8, 1, '1720', false, false)
					guiGridListSetItemText(inventar.gridlist[1], 8, 2, getElementData(localPlayer,'Objekt1720'), false, false)

					guiGridListSetItemText(inventar.gridlist[1], 9, 1, '1723', false, false)
					guiGridListSetItemText(inventar.gridlist[1], 9, 2, getElementData(localPlayer,'Objekt1723'), false, false)

					guiGridListSetItemText(inventar.gridlist[1], 10, 1, '1726', false, false)
					guiGridListSetItemText(inventar.gridlist[1], 10, 2, getElementData(localPlayer,'Objekt1726'), false, false)

					guiGridListSetItemText(inventar.gridlist[1], 11, 1, '1727', false, false)
					guiGridListSetItemText(inventar.gridlist[1], 11, 2, getElementData(localPlayer,'Objekt1727'), false, false)

					guiGridListSetItemText(inventar.gridlist[1], 12, 1, '1728', false, false)
					guiGridListSetItemText(inventar.gridlist[1], 12, 2, getElementData(localPlayer,'Objekt1728'), false, false)

					guiGridListSetItemText(inventar.gridlist[1], 13, 1, '1729', false, false)
					guiGridListSetItemText(inventar.gridlist[1], 13, 2, getElementData(localPlayer,'Objekt1729'), false, false)

					guiGridListSetItemText(inventar.gridlist[1], 14, 1, '1739', false, false)
					guiGridListSetItemText(inventar.gridlist[1], 14, 2, getElementData(localPlayer,'Objekt1739'), false, false)

					guiGridListSetItemText(inventar.gridlist[1], 15, 1, '1825', false, false)
					guiGridListSetItemText(inventar.gridlist[1], 15, 2, getElementData(localPlayer,'Objekt1825'), false, false)

					guiGridListSetItemText(inventar.gridlist[1], 16, 1, '1896', false, false)
					guiGridListSetItemText(inventar.gridlist[1], 16, 2, getElementData(localPlayer,'Objekt1896'), false, false)

					guiGridListSetItemText(inventar.gridlist[1], 17, 1, '1998', false, false)
					guiGridListSetItemText(inventar.gridlist[1], 17, 2, getElementData(localPlayer,'Objekt1998'), false, false)

					guiGridListSetItemText(inventar.gridlist[1], 18, 1, '2096', false, false)
					guiGridListSetItemText(inventar.gridlist[1], 18, 2, getElementData(localPlayer,'Objekt2096'), false, false)

					guiGridListSetItemText(inventar.gridlist[1], 19, 1, '2205', false, false)
					guiGridListSetItemText(inventar.gridlist[1], 19, 2, getElementData(localPlayer,'Objekt2205'), false, false)

					guiGridListSetItemText(inventar.gridlist[1], 20, 1, '2313', false, false)
					guiGridListSetItemText(inventar.gridlist[1], 20, 2, getElementData(localPlayer,'Objekt2313'), false, false)

					guiGridListSetItemText(inventar.gridlist[1], 21, 1, '1518', false, false)
					guiGridListSetItemText(inventar.gridlist[1], 21, 2, getElementData(localPlayer,'Objekt1518'), false, false)

					guiGridListSetItemText(inventar.gridlist[1], 22, 1, '1752', false, false)
					guiGridListSetItemText(inventar.gridlist[1], 22, 2, getElementData(localPlayer,'Objekt1752'), false, false)

					guiGridListSetItemText(inventar.gridlist[1], 23, 1, '1786', false, false)
					guiGridListSetItemText(inventar.gridlist[1], 23, 2, getElementData(localPlayer,'Objekt1786'), false, false)

					guiGridListSetItemText(inventar.gridlist[1], 24, 1, '16377', false, false)
					guiGridListSetItemText(inventar.gridlist[1], 24, 2, getElementData(localPlayer,'Objekt16377'), false, false)

					guiGridListSetItemText(inventar.gridlist[1], 25, 1, '638', false, false)
					guiGridListSetItemText(inventar.gridlist[1], 25, 2, getElementData(localPlayer,'Objekt638'), false, false)

					guiGridListSetItemText(inventar.gridlist[1], 26, 1, '970', false, false)
					guiGridListSetItemText(inventar.gridlist[1], 26, 2, getElementData(localPlayer,'Objekt970'), false, false)

					guiGridListSetItemText(inventar.gridlist[1], 27, 1, '17037', false, false)
					guiGridListSetItemText(inventar.gridlist[1], 27, 2, getElementData(localPlayer,'Objekt17037'), false, false)
					
					guiGridListSetItemText(inventar.gridlist[1], 28, 1, '2526', false, false)
					guiGridListSetItemText(inventar.gridlist[1], 28, 2, getElementData(localPlayer,'Objekt2526'), false, false)
					
					guiGridListSetItemText(inventar.gridlist[1], 29, 1, '2514', false, false)
					guiGridListSetItemText(inventar.gridlist[1], 29, 2, getElementData(localPlayer,'Objekt2514'), false, false)
					
					guiGridListSetItemText(inventar.gridlist[1], 30, 1, '2527', false, false)
					guiGridListSetItemText(inventar.gridlist[1], 30, 2, getElementData(localPlayer,'Objekt2527'), false, false)
					
					guiGridListSetItemText(inventar.gridlist[1], 31, 1, '2524', false, false)
					guiGridListSetItemText(inventar.gridlist[1], 31, 2, getElementData(localPlayer,'Objekt2524'), false, false)
					
					addEventHandler('onClientGUIClick',inventar.gridlist[1],function()
						local auswahl = guiGridListGetItemText(inventar.gridlist[1],guiGridListGetSelectedItem(inventar.gridlist[1]),1)
						local erlaubteObjects = notalloweditemsclick[auswahl]
						local dim = getElementDimension(localPlayer)
						
						if(not(erlaubteObjects == true))then
							if(getElementInterior(localPlayer) == 0)then
								removeEventHandler('onClientRender',root,rotateshowInvObject)
								local x,y,z = getElementPosition(localPlayer)
								if(isElement(showInvObject))then
									destroyElement(showInvObject)
								end
								showInvObject=createObject(auswahl,x,y-4,z+2)
								setElementDimension(showInvObject,dim)
								setObjectScale(showInvObject,0.5)
								setElementCollisionsEnabled(showInvObject,false)
								addEventHandler('onClientRender',root,rotateshowInvObject)
							end
						end
					end,false)
					
					addEventHandler('onClientGUIDoubleClick',inventar.gridlist[1],function()
						local auswahl = guiGridListGetItemText(inventar.gridlist[1],guiGridListGetSelectedItem(inventar.gridlist[1]),1)
						local erlaubteObjects = notalloweditemsclick[auswahl]
						local outdoorobject = outdoorobjects[auswahl]
						
						if(not(erlaubteObjects == true))then
							if(outdoorobject == true)then
								if(getElementInterior(localPlayer) == 0)then
									triggerServerEvent("createnewobject",localPlayer,auswahl)
									destroyElement(inventar.window[1])
									setElementData(localPlayer,'redfieldClick',false)
									if(isElement(showInvObject))then
										destroyElement(showInvObject)
									end
									removeEventHandler('onClientRender',root,rotateshowInvObject)
								else
									if(getElementData(localPlayer,'Language')==0)then
									infobox('Dieses Objekt kann nicht im Interior platziert werden!',255,0,0)else
									infobox('This object can not be placed in the interior!',255,0,0)end
								end
							else
								if(getElementData(localPlayer,'isPlayerInHouse')==true)then
									triggerServerEvent("createnewobject",localPlayer,auswahl)
									destroyElement(inventar.window[1])
									setElementData(localPlayer,'redfieldClick',false)
									if(isElement(showInvObject))then
										destroyElement(showInvObject)
									end
									removeEventHandler('onClientRender',root,rotateshowInvObject)
								else
									if(getElementData(localPlayer,'Language') == 0)then
									infobox('Dieses Objekt kann nicht außerhalb platziert werden!',255,255,255)else
									infobox('This object can not be placed outside!',255,255,255)end
								end
							end
						end
					end,false)
				else
					if(getElementData(localPlayer,"Language")==0)then
					outputChatBox("Du erhälst dein Inventar nach der Haft wieder!",200,0,0)else
					outdoorobject("You get your inventory after imprisonment back!",200,0,0)end
				end
			end
		else
			showCursor(false)
			destroyElement(inventar.window[1])
			setElementData(localPlayer,'redfieldClick',false)
			if(isElement(showInvObject))then
				destroyElement(showInvObject)
			end
			removeEventHandler('onClientRender',root,rotateshowInvObject)
		end
	end
end
bindKey('i','down',inventarWindow)

function rotateshowInvObject()
	local rx,ry,rz=getElementRotation(showInvObject)
	setElementRotation(showInvObject,rx,ry,rz+1)
end