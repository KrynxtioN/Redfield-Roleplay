local navi = {gridlist = {},window = {},button = {}}

local naviziele={
["Fort Carson Police Department"]={-217.80000305176,979.20001220703,19.60000038147},
["Fort Carson Motel"]={-176.39999389648,1112,19.799999237061},
["Fort Carson Bank"]={-179.39999389648,1177.5,20},
["Fort Carson Stadthalle / Cityhall"]={-207.69999694824,1119.1999511719,20.49999961853},
["Dealer"]={2323.5,-1223.3000488281,21.799999237061},
["Möbelhaus / Furniture Shop"]={1419.1676025391,-1623.7145996094,13.546875},
["Waffentruck / Weapontruck"]={219.03958129883,2.9537336826324,2.578125},
["Yakuza Base"]={693.70013427734,1967.6844482422,5.5390625},
["Biker Base"]={-11.165034294128,1379.3729248047,9.3635883331299},
["Ballas Base"]={2524.4104003906,-1998.3729248047,14.113082885742},
["Surenos Base"]={-376.91302490234,2242.3215332031,42.618461608887},
["Reporter Base"]={13.987555503845,1187.8225097656,19.47974395752},
}

function navi_func()
	if(not(isElement(navi.window[1])))then
		if(not(getElementData(localPlayer,"redfieldClick"))==true)then
			setElementData(localPlayer,"redfieldClick",true)
			showCursor(true)
		
			navi.window[1] = guiCreateStaticImage(0.38, 0.27, 0.25, 0.42, "Images/Background.png", true)

			navi.gridlist[1] = guiCreateGridList(0.03, 0.08, 0.94, 0.79, true, navi.window[1])
			ziele=guiGridListAddColumn(navi.gridlist[1], "Ziel", 0.9)
			
			local row
			for key, index in pairs ( naviziele ) do
				row = guiGridListAddRow ( navi.gridlist[1] )
				guiGridListSetItemText ( navi.gridlist[1], row, ziele, key, false, false )
			end
			
			navi.button[1] = guiCreateButton(0.03, 0.89, 0.44, 0.08, "Anzeigen", true, navi.window[1])
			guiSetProperty(navi.button[1], "NormalTextColour", "FFAAAAAA")
			navi.button[2] = guiCreateButton(0.52, 0.89, 0.44, 0.08, "Schließen", true, navi.window[1])
			guiSetProperty(navi.button[2], "NormalTextColour", "FFAAAAAA")
			
			addEventHandler("onClientGUIClick",navi.button[1],function()
				local rowindex, columnindex = guiGridListGetSelectedItem ( navi.gridlist[1] )
				local text = guiGridListGetItemText ( navi.gridlist[1], rowindex, ziele )

				if(isElement(naviBlip))then
					destroyElement(naviBlip)
				end
				if(isTimer(naviTimer))then
					killTimer(naviTimer)
				end
				naviBlip=createBlip(naviziele[text][1],naviziele[text][2],naviziele[text][3],41,0,0,0,0,0,0,9999)
				naviTimer=setTimer(function()
					destroyElement(naviBlip)
				end,300000,1)
				
				if(getElementData(localPlayer,"Language")==0)then
					infobox("Der Ort wird wir nun auf der Karte angezeigt.",255,255,255)
				else
					infobox("The Place will shown on the Map.",255,255,255)
				end
			end,false)
			addEventHandler("onClientGUIClick",navi.button[2],function()
				destroyElement(navi.window[1])
				setElementData(localPlayer,"redfieldClick",false)
				showCursor(false)
			end,false)
		end
    end
end
addCommandHandler("navi",navi_func)