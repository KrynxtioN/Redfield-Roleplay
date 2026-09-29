local openBankverwaltungWindowPickup = createPickup(362.37442016602,173.54965209961,1008.3828125,3,1239,50)
setElementInterior(openBankverwaltungWindowPickup,3)
setElementDimension(openBankverwaltungWindowPickup,1)

addEventHandler("onPickupHit",openBankverwaltungWindowPickup,function(player)
	if getElementType(player) ~= "player" then return end
	if not isPlayerAtBankverwaltung(player) then return end

	triggerClientEvent(player,"bankverwaltungWindow",player)
end)

addEvent("createBankAccount",true)
addEventHandler("createBankAccount",root,function()
	local player = client

	local bankpin = tonumber(getElementData(player,"Bankpin")) or 0

	if bankpin ~= 0 then
		infobox_func(player,getText(player,"Bankverwaltung6"),255,0,0)
		return
	end

	local createPin = math.random(1000,9999)

	setElementData(player,"Bankpin",createPin)
	infobox_func(player,getText(player,"Bankverwaltung5"):format(createPin),0,255,0)

	if tonumber(getElementData(player,"AchKonto")) == 0 then
		setElementData(player,"AchKonto",1)
		achievementInfo(player)
	end
end)

addEvent("requestBankPin",true)
addEventHandler("requestBankPin",root,function()
	local player = client
	if not player or not isElement(player) then return end

	local bankpin = tonumber(getElementData(player,"Bankpin")) or 0

	if bankpin == 0 then
		infobox_func(player,getText(player,"Bankverwaltung7"),255,0,0)
		return
	end

	infobox_func(player,getText(player,"Bankverwaltung5"):format(bankpin),0,255,0)
end)