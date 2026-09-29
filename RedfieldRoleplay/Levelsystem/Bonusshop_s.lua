local BONUSSHOP_PRICE = 25

function bonusshopserverbuy(item)
	local player = client
	if not player or not isElement(player) then return end
	if getElementData(player,"loggedin") ~= 1 then return end

	if item ~= "leben" and item ~= "weste" then return end

	if not isErfahrungspunkte(player,BONUSSHOP_PRICE) then
		infobox_func(player,getText(player,"Bonusshop8"):format(BONUSSHOP_PRICE),255,0,0)
		return
	end

	if item == "leben" then
		setElementHealth(player,100)
	elseif item == "weste" then
		setPedArmor(player,100)
	end

	takeErfahrungspunkte(player,BONUSSHOP_PRICE)

	infobox_func(player,getText(player,"Bonusshop9"):format(BONUSSHOP_PRICE),0,255,0)
end
addEvent("bonusshopserverbuy",true)
addEventHandler("bonusshopserverbuy",root,bonusshopserverbuy)