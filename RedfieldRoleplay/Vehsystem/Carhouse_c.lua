local OttosCarsBuyMarker = createMarker(-1649.3000488281,1209.1999511719,6.4000000953674,'cylinder',1,0,0,200)
local WangCarsBuyPickup = createPickup(-1958.6409912109,304.90640258789,35.46875,3,1239,50)
local FortCarsonPickup = createPickup(-262.55642700195,1211.1387939453,19.895177841187,3,1239,50)
local FlughafenPickup = createPickup(1956.7330322266,-2183.6652832031,13.546875,3,1239,50)
local BoothausPickup = createPickup(-2245.2004394531,2381.7453613281,5.0761528015137,3,1239,50)

function HitCarhousePickups(player)
	if(player==localPlayer)then
		if(getElementData(localPlayer,"Language")==0)then
			outputChatBox("Klick auf ein Fahrzeug, um es zu kaufen.",0,200,0)
		else
			outputChatBox("Click on a Vehicle, to buy it.",0,200,0)
		end
	end
end
addEventHandler("onClientMarkerHit",OttosCarsBuyMarker,HitCarhousePickups)
addEventHandler("onClientPickupHit",WangCarsBuyPickup,HitCarhousePickups)
addEventHandler("onClientPickupHit",FortCarsonPickup,HitCarhousePickups)
addEventHandler("onClientPickupHit",FlughafenPickup,HitCarhousePickups)
addEventHandler("onClientPickupHit",BoothausPickup,HitCarhousePickups)

local fahrzeuge={
 ["Infernus"]={55000,-1638.5999755859,1211.4000244141,7,224,"Autoschein"},
 ["Bullet"]={45000,-1638.5999755859,1211.4000244141,7,224,"Autoschein"},
 ["Cheetah"]={30000,-1638.5999755859,1211.4000244141,7,224,"Autoschein"},
 ["Banshee"]={27500,-1638.5999755859,1211.4000244141,7,224,"Autoschein"},
 ["Comet"]={40000,-1638.5999755859,1211.4000244141,7,224,"Autoschein"},
 ["ZR-350"]={130000,-1638.5999755859,1211.4000244141,7,224,"Autoschein"},
 ["Stratum"]={17500,-1936.3000488281,271.89999389648,41,180,"Autoschein"},
 ["Perennial"]={5000,-1936.3000488281,271.89999389648,41,180,"Autoschein"},
 ["Solair"]={22000,-1936.3000488281,271.89999389648,41,180,"Autoschein"},
 ["Regina"]={11000,-1936.3000488281,271.89999389648,41,180,"Autoschein"},
 ["Club"]={13500,-1936.3000488281,271.89999389648,41,180,"Autoschein"},
 ["NRG-500"]={26000,-1936.3000488281,271.89999389648,41,180,"Motorradschein"},
 ["FCR-900"]={9000,-1936.3000488281,271.89999389648,41,180,"Motorradschein"},
 ["Tampa"]={1000,-232.19999694824,1203.4000244141,19.700000762939,270,"Autoschein"},
 ["Clover"]={1200,-232.19999694824,1203.4000244141,19.700000762939,270,"Autoschein"},
 ["Cadrona"]={4000,-232.19999694824,1203.4000244141,19.700000762939,270,"Autoschein"},
 ["Buccaneer"]={5000,-232.19999694824,1203.4000244141,19.700000762939,270,"Autoschein"},
 ["Sentinel"]={4500,-232.19999694824,1203.4000244141,19.700000762939,270,"Autoschein"},
 ["Premier"]={6000,-232.19999694824,1203.4000244141,19.700000762939,270,"Autoschein"},
 ["Nebula"]={3000,-232.19999694824,1203.4000244141,19.700000762939,270,"Autoschein"},
 ["Willard"]={4000,-232.19999694824,1203.4000244141,19.700000762939,270,"Autoschein"},
 ["Merit"]={7000,-232.19999694824,1203.4000244141,19.700000762939,270,"Autoschein"},
 ["Emperor"]={8000,-232.19999694824,1203.4000244141,19.700000762939,270,"Autoschein"},
 ["Cropduster"]={180000,2052.8000488281,-2493.5,14.5,90,"Flugschein"},
 ["Shamal"]={250000,2052.8000488281,-2493.5,14.5,90,"Flugschein"},
 ["Dodo"]={150000,2052.8000488281,-2493.5,14.5,90,"Flugschein"},
 ["Stuntplane"]={125000,2052.8000488281,-2493.5,14.5,90,"Flugschein"},
 ["Sparrow"]={40000,2052.8000488281,-2493.5,14.5,90,"Helikopterschein"},
 ["Maverick"]={80000,2052.8000488281,-2493.5,14.5,90,"Helikopterschein"},
 ["Marquis"]={200000,-2174.3999023438,2425.6000976563,-0,46,"Bootschein"},
 ["Jetmax"]={100000,-2174.3999023438,2425.6000976563,-0,46,"Bootschein"},
 ["Speeder"]={80000,-2174.3999023438,2425.6000976563,-0,46,"Bootschein"},
 ["Squalo"]={120000,-2174.3999023438,2425.6000976563,-0,46,"Bootschein"},
 ["Tropic"]={250000,-2174.3999023438,2425.6000976563,-0,46,"Bootschein"},
 ["Reefer"]={70000,-2174.3999023438,2425.6000976563,-0,46,"Bootschein"},
 ["Dinghy"]={30000,-2174.3999023438,2425.6000976563,-0,46,"Bootschein"},
 ["Coastguard"]={50000,-2174.3999023438,2425.6000976563,-0,46,"Bootschein"},
}

local buyVehicle = {button = {},window = {},label = {}}

function buyVehicleWindow(id)
	if(not(isElement(buyVehicle.window[1])))then
		if(not(getElementData(localPlayer,"redfieldClick"))==true)then
			showCursor(true)
			setElementData(localPlayer,"redfieldClick",true)
		
			buyVehicle.window[1] = guiCreateStaticImage(0.40, 0.42, 0.21, 0.17, "Images/Background.png", true)

			buyVehicle.label[1] = guiCreateLabel(0.03, 0.19, 0.93, 0.18,getVehicleNameFromModel(id)..": "..fahrzeuge[getVehicleNameFromModel(id)][1].."$", true, buyVehicle.window[1])
			guiSetFont(buyVehicle.label[1], "default-bold-small")
			guiLabelSetHorizontalAlign(buyVehicle.label[1], "center", true)
			guiLabelSetVerticalAlign(buyVehicle.label[1], "center")
			buyVehicle.button[1] = guiCreateButton(0.24, 0.49, 0.52, 0.19, "Kaufen", true, buyVehicle.window[1])
			guiSetProperty(buyVehicle.button[1], "NormalTextColour", "FFAAAAAA")
			buyVehicle.button[2] = guiCreateButton(0.24, 0.75, 0.52, 0.19, "Schließen", true, buyVehicle.window[1])
			guiSetProperty(buyVehicle.button[2], "NormalTextColour", "FFAAAAAA")
			
			addEventHandler("onClientGUIClick",buyVehicle.button[1],function()
				if(getPlayerMoney(localPlayer)>=fahrzeuge[getVehicleNameFromModel(id)][1])then
					if(getElementData(localPlayer,fahrzeuge[getVehicleNameFromModel(id)][6])==1)then
						triggerServerEvent("buyVehicle",localPlayer,id,fahrzeuge[getVehicleNameFromModel(id)][1],fahrzeuge[getVehicleNameFromModel(id)][2],fahrzeuge[getVehicleNameFromModel(id)][3],fahrzeuge[getVehicleNameFromModel(id)][4],fahrzeuge[getVehicleNameFromModel(id)][5])
						showCursor(false)
						setElementData(localPlayer,"redfieldClick",false)
						destroyElement(buyVehicle.window[1])
					else
						if(getElementData(localPlayer,"Language")==0)then
							infobox("Du besitzt nicht den nötigen Schein!",255,255,255)
						else
							infobox("You do not have the necessary license!",255,255,255)
						end
					end
				else
					notEnoughMoneyCarshop()
				end
			end,false)
			
			addEventHandler("onClientGUIClick",buyVehicle.button[2],function()
				showCursor(false)
				setElementData(localPlayer,"redfieldClick",false)
				destroyElement(buyVehicle.window[1])
			end,false)
			
			if(getElementData(localPlayer,"Language")==1)then
				guiSetText(buyVehicle.label[1],"Buy")
				guiSetText(buyVehicle.label[2],"Close")
			end
		end
    end
end
addEvent("buyVehicleWindow",true)
addEventHandler("buyVehicleWindow",root,buyVehicleWindow)

function notEnoughMoneyCarshop()
	if(getElementData(localPlayer,'Language') == 0)then
		infobox('Du hast nicht genug Geld!',255,0,0)
	else
		infobox('You have not enough money!',255,0,0)
	end
end