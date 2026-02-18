local securityCarKeycardWanteds = createVehicle(428,89.900001525879,-301.70001220703,1.7999999523163,0,0,0)
setElementFrozen(securityCarKeycardWanteds,true)
setVehicleLocked(securityCarKeycardWanteds,true)
setVehicleDamageProof(securityCarKeycardWanteds,true)
setVehicleColor(securityCarKeycardWanteds,0,0,0)
local deleteWantedsCard = createPickup(89.894546508789,-305.93283081055,1.578125,3,1581,50)

function deleteWantedsCardHit(player)
	if(not(getElementData(player,'wantedCard') == true))then
		if(not(isTimer(wantedCardTimer)))then
			setElementData(player,'wantedCard',true)
			giveErfahrungspunkte(player,25)
			getChatBox(player,93)
			wantedCardTimer=setTimer(function(player)
				getChatBox(player,94)
				setElementData(player,'wantedCard',false)
			end,1200000,1,player)
		else 
			getChatBox(player,95)
		end
	else
		getChatBox(player,96)
	end
end
addEventHandler('onPickupHit',deleteWantedsCard,deleteWantedsCardHit)