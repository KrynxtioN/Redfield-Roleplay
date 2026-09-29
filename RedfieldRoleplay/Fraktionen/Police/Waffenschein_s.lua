local waffenscheinPreis = 7500

function buyWaffenschein()
	local player = client
	if not isElement(player) or getElementType(player) ~= "player" then return end
	if getElementData(player,"loggedin") ~= 1 then return end
	if (tonumber(getElementData(player,"Waffenschein")) or 0) >= 1 then
		infobox_func(player,getText(player,"GunLicense6"),255,0,0)
		return
	end
	local money = tonumber(getElementData(player,"Money")) or 0
	if money < waffenscheinPreis then
		infobox_func(player,getText(player,"GunLicense5"):format(waffenscheinPreis-money),255,0,0)
		return
	end
	setElementData(player,"Money",money-waffenscheinPreis)
	setElementData(player,"Waffenschein",1)
	giveErfahrungspunkte(player,250)
	infobox_func(player,getText(player,"GunLicense4"):format(waffenscheinPreis),0,255,0)
	triggerClientEvent(player,"closeWaffenschein",player)
end
addEvent("buyWaffenschein",true)
addEventHandler("buyWaffenschein",root,buyWaffenschein)