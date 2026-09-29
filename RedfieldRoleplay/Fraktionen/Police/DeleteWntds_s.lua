local securityCarKeycardWanteds = createVehicle(428,89.900001525879,-301.70001220703,1.7999999523163,0,0,0)
setElementFrozen(securityCarKeycardWanteds,true)
setVehicleLocked(securityCarKeycardWanteds,true)
setVehicleDamageProof(securityCarKeycardWanteds,true)
setVehicleColor(securityCarKeycardWanteds,0,0,0)

local deleteWantedsCard = createPickup(89.894546508789,-305.93283081055,1.578125,3,1581,50)
local wantedCardTimer = {}

function deleteWantedsCardHit(player)
	if getElementType(player) ~= "player" then return end
	if getElementData(player,"loggedin") ~= 1 then return end
	if getElementData(player,"wantedCard") == true then
		infobox_func(player,getText(player,"WantedCard1"),255,0,0)
		return
	end
	if isTimer(wantedCardTimer[player]) then
		infobox_func(player,getText(player,"WantedCard2"),255,0,0)
		return
	end
	setElementData(player,"wantedCard",true)
	giveErfahrungspunkte(player,25)
	infobox_func(player,getText(player,"WantedCard3"),0,255,0)
	wantedCardTimer[player] = setTimer(function(target)
		wantedCardTimer[target] = nil
		if not isElement(target) then return end
		setElementData(target,"wantedCard",false)
		infobox_func(target,getText(target,"WantedCard4"),255,0,0)
	end,1200000,1,player)
end
addEventHandler("onPickupHit",deleteWantedsCard,deleteWantedsCardHit)

addEventHandler("onPlayerQuit",root,function()
	if isTimer(wantedCardTimer[source]) then killTimer(wantedCardTimer[source]) end
	wantedCardTimer[source] = nil
end)