local bankautomaten = {}
local bankSessions = {}
local bankPinVerified = {}

local atm1 = createObject(2942,-180.69999694824,1180,19.39999961853,0,0,270)
table.insert(bankautomaten,atm1)

local atm2 = createObject(2942,-207.89999389648,1116.8000488281,19.39999961853,0,0,90)
table.insert(bankautomaten,atm2)

function atmWindowShow(button,state,player)
	if button ~= "left" or state ~= "down" then return end
	if not isElement(player) or getElementType(player) ~= "player" then return end
	if getElementData(player,"loggedin") ~= 1 then return end

	for _,atm in ipairs(bankautomaten) do
		if atm == source then
			local px,py,pz = getElementPosition(player)
			local ax,ay,az = getElementPosition(atm)

			if getDistanceBetweenPoints3D(px,py,pz,ax,ay,az) > 5 then return end
			if getElementInterior(player) ~= getElementInterior(atm) then return end
			if getElementDimension(player) ~= getElementDimension(atm) then return end

			bankSessions[player] = atm
			bankPinVerified[player] = false

			triggerClientEvent(player,"bankpinWindow",player)
			return
		end
	end
end
addEventHandler("onElementClicked",root,atmWindowShow)

function isValidBankSession(player)
	if not isElement(player) or getElementType(player) ~= "player" then return false end
	if getElementData(player,"loggedin") ~= 1 then return false end

	local atm = bankSessions[player]

	if not isElement(atm) then
		bankSessions[player] = nil
		bankPinVerified[player] = nil
		return false
	end

	if getElementInterior(player) ~= getElementInterior(atm) then
		bankSessions[player] = nil
		bankPinVerified[player] = nil
		return false
	end

	if getElementDimension(player) ~= getElementDimension(atm) then
		bankSessions[player] = nil
		bankPinVerified[player] = nil
		return false
	end

	local px,py,pz = getElementPosition(player)
	local ax,ay,az = getElementPosition(atm)

	if getDistanceBetweenPoints3D(px,py,pz,ax,ay,az) > 7 then
		bankSessions[player] = nil
		bankPinVerified[player] = nil
		return false
	end

	return true
end

addEvent("checkBankPin",true)
addEventHandler("checkBankPin",root,function(pin)
	local player = client
	if not player or not isElement(player) then return end
	if not isValidBankSession(player) then return end
	if bankPinVerified[player] == true then return end

	local enteredPin = tonumber(pin)
	local realPin = tonumber(getElementData(player,"Bankpin")) or 0

	if not enteredPin or realPin <= 0 or enteredPin ~= realPin then
		triggerClientEvent(player,"bankPinWrong",player)
		return
	end

	bankPinVerified[player] = true

	triggerClientEvent(player,"bankPinCorrect",player)
end)

function auszahlenServer(auszahlenSumme)
	local player = client
	if not player or not isElement(player) then return end
	if not isValidBankSession(player) then return end
	if bankPinVerified[player] ~= true then return end

	local amount = tonumber(auszahlenSumme)

	if not amount or amount <= 0 or amount ~= math.floor(amount) then
		infobox_func(player,getText(player,"Bank11"),255,0,0)
		return
	end

	local bankmoney = tonumber(getElementData(player,"Bankmoney")) or 0
	local money = tonumber(getElementData(player,"Money")) or 0

	if bankmoney < amount then
		infobox_func(player,getText(player,"Bank12"),255,0,0)
		return
	end

	setElementData(player,"Bankmoney",bankmoney-amount)
	setElementData(player,"Money",money+amount)

	infobox_func(player,getText(player,"Bank13"):format(amount),0,255,0)

	triggerClientEvent(player,"updateMoneyLabel",player)
end
addEvent("auszahlenServer",true)
addEventHandler("auszahlenServer",root,auszahlenServer)

function einzahlenServer(einzahlenSumme)
	local player = client
	if not player or not isElement(player) then return end
	if not isValidBankSession(player) then return end
	if bankPinVerified[player] ~= true then return end

	local amount = tonumber(einzahlenSumme)

	if not amount or amount <= 0 or amount ~= math.floor(amount) then
		infobox_func(player,getText(player,"Bank11"),255,0,0)
		return
	end

	local money = tonumber(getElementData(player,"Money")) or 0
	local bankmoney = tonumber(getElementData(player,"Bankmoney")) or 0

	if money < amount then
		infobox_func(player,getText(player,"Bank14"),255,0,0)
		return
	end

	setElementData(player,"Money",money-amount)
	setElementData(player,"Bankmoney",bankmoney+amount)

	infobox_func(player,getText(player,"Bank15"):format(amount),0,255,0)

	triggerClientEvent(player,"updateMoneyLabel",player)
end
addEvent("einzahlenServer",true)
addEventHandler("einzahlenServer",root,einzahlenServer)

addEvent("closeBankSession",true)
addEventHandler("closeBankSession",root,function()
	local player = client
	if not player or not isElement(player) then return end

	bankSessions[player] = nil
	bankPinVerified[player] = nil
end)

addEventHandler("onPlayerQuit",root,function()
	bankSessions[source] = nil
	bankPinVerified[source] = nil
end)

addEventHandler("onPlayerWasted",root,function()
	bankSessions[source] = nil
	bankPinVerified[source] = nil
end)