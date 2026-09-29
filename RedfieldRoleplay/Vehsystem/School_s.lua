Fahrschule = {p_vehicle = {}}

local Lizenz_Price = {
	["Motorradschein"] = 3000,
	["Lkwschein"] = 8000,
	["Helikopterschein"] = 20000,
	["Flugschein"] = 40000,
	["Bootschein"] = 9000,
	["Personalausweis"] = 50,
	["Arbeitsgenehmigung"] = 50,
}

function givePlayerLicense(lizenz)
	if(getElementData(client,lizenz) == 0)then
		local preis = Lizenz_Price[lizenz]
		if(tonumber(getElementData(client,"Money")) >= preis)then
			setElementData(client,"Money",tonumber(getElementData(client,"Money"))-preis)
			giveErfahrungspunkte(client,math.floor(preis/100*2.5))
			updateEventkasse("einzahlen",preis)
			infobox_func(client,getText(client,"Fahrschule3"),0,255,0)
		else
			infobox_func(client,getText(client,"Fahrschule2"),255,0,0)
		end
	else
		infobox_func(client,getText(client,"Fahrschule1"),255,0,0)
	end
end
addEvent('givePlayerLicense',true)
addEventHandler('givePlayerLicense',root,givePlayerLicense)

function startPraxisCarlicense()
	if(getElementData(client,"Autoschein") == 0)then
		if(tonumber(getElementData(client,"Money")) >= 1400)then
			setElementData(client,"Money",tonumber(getElementData(client,"Money"))-1400)
			giveErfahrungspunkte(client,math.floor(1400/100*2.5))
			updateEventkasse("einzahlen",1400)
			triggerClientEvent(client,"clientPraxisCarlicense",client)
			Fahrschule.p_vehicle[client] = createVehicle(405,-220.19999694824,1094.8000488281,19.60000038147,0,0,270)
			setElementData(Fahrschule.p_vehicle[client],"Benzin",100)
			setElementData(Fahrschule.p_vehicle[client],"Besitzer","System")
			setElementInterior(client,0)
			setElementDimension(client,0)
			warpPedIntoVehicle(client,Fahrschule.p_vehicle[client])
			infobox_func(client,getText(client,"Fahrschule4"),0,255,0)
			
			addEventHandler("onVehicleStartExit",Fahrschule.p_vehicle[client],function(player)
				infobox_func(player,getText(player,"Fahrschule4"),0,255,0)
				cancelEvent()
			end)
		else
			infobox_func(client,getText(client,"Fahrschule2"),255,0,0)
		end
	else
		infobox_func(client,getText(client,"Fahrschule1"),255,0,0)
	end
end
addEvent('startPraxisCarlicense',true)
addEventHandler('startPraxisCarlicense',root,startPraxisCarlicense)

function giveCarlicense()
	if(isElement(Fahrschule.p_vehicle[client]))then
		destroyElement(Fahrschule.p_vehicle[client])
	end
	giveErfahrungspunkte(client,300)
	setElementData(client,"Autoschein",1)
	infobox_func(client,getText(client,"Fahrschule5"),0,255,0)
	if(getElementData(client,"AchCarlicense") == 0)then
		setElementData(client,"AchCarlicense",1)
		achievementInfo(player)
	end
end
addEvent('giveCarlicense',true)
addEventHandler('giveCarlicense',root,giveCarlicense)