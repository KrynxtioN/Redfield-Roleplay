local serverPriceDrugs = 6
local serverPriceMats = 4

local drugsDealerMarker = createMarker(2323.5,-1223.3000488281,21.799999237061,"cylinder",1,0,0,200)
setElementAlpha(drugsDealerMarker,100)

function drugsDealerMarkerHit(player)
	if not isElement(player) or getElementType(player) ~= "player" then return end
	if getElementData(player,"loggedin") ~= 1 then return end

	outputChatBox(getText(player,"Dealer1"):format(serverPriceMats,serverPriceDrugs),player,255,255,255)
end
addEventHandler("onMarkerHit",drugsDealerMarker,drugsDealerMarkerHit)

function sellItemsToServer(player,cmd,item,menge)
	if not isElement(player) or getElementType(player) ~= "player" then return end
	if getElementData(player,"loggedin") ~= 1 then return end

	local x,y,z = getElementPosition(player)

	if getDistanceBetweenPoints3D(2322.8000488281,-1223.4000244141,22.60000038147,x,y,z) >= 7 then
		return
	end

	if not item or not menge then
		infobox_func(player,getText(player,"Dealer5"),255,0,0)
		return
	end

	menge = tonumber(menge)

	if not menge or menge <= 0 or menge ~= math.floor(menge) then
		infobox_func(player,getText(player,"Dealer2"),255,0,0)
		return
	end

	item = string.lower(item)

	if item == "mats" then
		local mats = tonumber(getElementData(player,"Mats")) or 0

		if mats < menge then
			infobox_func(player,getText(player,"Dealer6"),255,0,0)
			return
		end

		local money = menge*serverPriceMats
		local playerMoney = tonumber(getElementData(player,"Money")) or 0

		setElementData(player,"Mats",mats-menge)
		setElementData(player,"Money",playerMoney+money)

		infobox_func(player,getText(player,"Dealer3"):format(menge,money),0,255,0)

	elseif item == "drugs" then
		local drugs = tonumber(getElementData(player,"Drogen")) or 0

		if drugs < menge then
			infobox_func(player,getText(player,"Dealer7"),255,0,0)
			return
		end

		local money = menge*serverPriceDrugs
		local playerMoney = tonumber(getElementData(player,"Money")) or 0

		setElementData(player,"Drogen",drugs-menge)
		setElementData(player,"Money",playerMoney+money)

		infobox_func(player,getText(player,"Dealer4"):format(menge,money),0,255,0)
	else
		infobox_func(player,getText(player,"Dealer5"),255,0,0)
	end
end
addCommandHandler("sell",sellItemsToServer)