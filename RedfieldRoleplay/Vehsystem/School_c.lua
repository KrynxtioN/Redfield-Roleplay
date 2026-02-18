local fahrpruefungMarker = {

['x'] = {
[1] = -198.01217651367,
[2] = -250.33056640625,
[3] = -50.418704986572,
[4] = 212.21748352051,
[5] = 186.0555267334,
[6] = -58.385551452637,
[7] = -120.08601379395,
[8] = -193.21726989746,
[9] = -198.33740234375},

['y'] = {
[1] = 1040.6884765625,
[2] = 838.54522705078,
[3] = 855.70318603516,
[4] = 960.47393798828,
[5] = 1139.2517089844,
[6] = 1264.7175292969,
[7] = 1153.3526611328,
[8] = 1196.2297363281,
[9] = 1109.3471679688},

['z'] = {
[1] = 19.590286254883,
[2] = 13.064254760742,
[3] = 17.738880157471,
[4] = 28.189987182617,
[5] = 14.710836410522,
[6] = 10.569092750549,
[7] = 19.59375,
[8] = 19.583673477173,
[9] = 19.591083526611},

}

function clientPraxisCarMarker()
	if(isElement(praxisMarker))then
		destroyElement(praxisMarker)
	end
	if(isElement(praxisBlip))then
		destroyElement(praxisBlip)
	end
	praxisMarkerPoints = praxisMarkerPoints + 1
	
	if(praxisMarkerPoints > 9)then
		triggerServerEvent('giveCarlicense',localPlayer,localPlayer)
	else
		praxisMarker = createMarker(fahrpruefungMarker['x'][praxisMarkerPoints],fahrpruefungMarker['y'][praxisMarkerPoints],fahrpruefungMarker['z'][praxisMarkerPoints],'checkpoint',1,200,0,0)
		praxisBlip = createBlip(fahrpruefungMarker['x'][praxisMarkerPoints],fahrpruefungMarker['y'][praxisMarkerPoints],fahrpruefungMarker['z'][praxisMarkerPoints],0,2,255,0,0)
		
		addEventHandler('onClientMarkerHit',praxisMarker,function(hitPlayer)
			if(hitPlayer == localPlayer)then
				clientPraxisCarMarker()
			end
		end)
	end
end
addEvent('clientPraxisCarlicense',true)
addEventHandler('clientPraxisCarlicense',root,clientPraxisCarMarker)

local Lizenzen = {button = {},window = {}}

function openLizenzenWindow()
	if(getElementData(localPlayer,'redfieldClick') == false)then
		--if(hitPlayer == localPlayer)then
			if(not(isElement(Lizenzen.window[1])))then
				showCursor(true)
				setElementData(localPlayer,'redfieldClick',true)
			
				Lizenzen.window[1] = guiCreateStaticImage(0.36, 0.36, 0.27, 0.26, 'Images/Background.png', true)

				Lizenzen.button[1] = guiCreateButton(0.03, 0.13, 0.46, 0.14, 'Führerschein (1400$)', true, Lizenzen.window[1])
				guiSetProperty(Lizenzen.button[1], 'NormalTextColour', 'FFAAAAAA')
				Lizenzen.button[2] = guiCreateButton(0.51, 0.13, 0.46, 0.14, 'Motorradschein (3000$)', true, Lizenzen.window[1])
				guiSetProperty(Lizenzen.button[2], 'NormalTextColour', 'FFAAAAAA')
				Lizenzen.button[3] = guiCreateButton(0.51, 0.30, 0.46, 0.14, 'Lkwschein (8000$)', true, Lizenzen.window[1])
				guiSetProperty(Lizenzen.button[3], 'NormalTextColour', 'FFAAAAAA')
				Lizenzen.button[4] = guiCreateButton(0.03, 0.30, 0.46, 0.14, 'Helikopterschein (20.000$)', true, Lizenzen.window[1])
				guiSetProperty(Lizenzen.button[4], 'NormalTextColour', 'FFAAAAAA')
				Lizenzen.button[5] = guiCreateButton(0.03, 0.48, 0.46, 0.14, 'Flugschein (40.000$)', true, Lizenzen.window[1])
				guiSetProperty(Lizenzen.button[5], 'NormalTextColour', 'FFAAAAAA')
				Lizenzen.button[6] = guiCreateButton(0.03, 0.66, 0.46, 0.14, 'Bootschein (9000$)', true, Lizenzen.window[1])
				guiSetProperty(Lizenzen.button[6], 'NormalTextColour', 'FFAAAAAA')
				Lizenzen.button[7] = guiCreateButton(0.51, 0.48, 0.46, 0.14, 'Personalausweis (50$)', true, Lizenzen.window[1])
				guiSetProperty(Lizenzen.button[7], 'NormalTextColour', 'FFAAAAAA')
				Lizenzen.button[8] = guiCreateButton(0.51, 0.66, 0.46, 0.14, 'Arbeitsgenehmigung (50$)', true, Lizenzen.window[1])
				guiSetProperty(Lizenzen.button[8], 'NormalTextColour', 'FFAAAAAA')
				Lizenzen.button[9] = guiCreateButton(0.27, 0.82, 0.46, 0.14, 'Schließen', true, Lizenzen.window[1])
				guiSetProperty(Lizenzen.button[9], 'NormalTextColour', 'FFAAAAAA')
				
				if(getElementData(localPlayer,'Language') == 1)then
					guiSetText(Lizenzen.button[1],'Driver´s License (1400$)')
					guiSetText(Lizenzen.button[2],'Bike-License (3000$)')
					guiSetText(Lizenzen.button[3],'Truck-License (8000$)')
					guiSetText(Lizenzen.button[4],'Helicopter-License (20.000$)')
					guiSetText(Lizenzen.button[5],'Airplane-License (40.000$)')
					guiSetText(Lizenzen.button[7],'Identity-Card (50$)')
					guiSetText(Lizenzen.button[6],'Boat-License (9000$)')
					guiSetText(Lizenzen.button[8],'Work-License (50$)')
					guiSetText(Lizenzen.button[9],'Close')
				end
				
				addEventHandler('onClientGUIClick',Lizenzen.button[1],function()
					praxisMarkerPoints = 0
					triggerServerEvent('startPraxisCarlicense',localPlayer,localPlayer)
					destroyElement(Lizenzen.window[1])
					showCursor(false)
					setElementData(localPlayer,'redfieldClick',false)
				end,false)
				
				addEventHandler('onClientGUIClick',Lizenzen.button[2],function()
					triggerServerEvent('givePlayerLicense',localPlayer,'Motorradschein')
				end,false)
				
				addEventHandler('onClientGUIClick',Lizenzen.button[3],function()
					triggerServerEvent('givePlayerLicense',localPlayer,'Lkwschein')
				end,false)
				
				addEventHandler('onClientGUIClick',Lizenzen.button[4],function()
					triggerServerEvent('givePlayerLicense',localPlayer,'Helikopterschein')
				end,false)

				addEventHandler('onClientGUIClick',Lizenzen.button[5],function()
					triggerServerEvent('givePlayerLicense',localPlayer,'Flugschein')
				end,false)
				
				addEventHandler('onClientGUIClick',Lizenzen.button[6],function()
					triggerServerEvent('givePlayerLicense',localPlayer,'Bootschein')
				end,false)
				
				addEventHandler('onClientGUIClick',Lizenzen.button[7],function()
					triggerServerEvent('givePlayerLicense',localPlayer,'Personalausweis')
				end,false)
				
				addEventHandler('onClientGUIClick',Lizenzen.button[8],function()
					triggerServerEvent('givePlayerLicense',localPlayer,'Arbeitsgenehmigung')
				end,false)
				
				addEventHandler('onClientGUIClick',Lizenzen.button[9],function()
					destroyElement(Lizenzen.window[1])
					showCursor(false)
					setElementData(localPlayer,'redfieldClick',false)
				end,false)
			end
		--end
	end
end
addEvent("openLizenzenWindow",true)
addEventHandler("openLizenzenWindow",root,openLizenzenWindow)