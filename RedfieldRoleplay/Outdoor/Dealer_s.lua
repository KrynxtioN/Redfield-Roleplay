local serverPriceDrugs = 6
local serverPriceMats = 4

local drugsDealerMarker = createMarker(2323.5,-1223.3000488281,21.799999237061,'cylinder',1,0,0,200)
setElementAlpha(drugsDealerMarker,100)

function drugsDealerMarkerHit(player)
	if(isGerman(player))then
		outputChatBox('Dealer: Jo, Brudi! Ich gebe dir 4$ pro Material und 6$ pro 1g Weed.. tippe /sell..',player,255,255,255)
	elseif(isEnglish(player))then
		outputChatBox('Dealer: Jo, Bro! I´ll give you $ 4 per material and $ 6 per 1g Weed.. type / sell..',player,255,255,255)
	end
end
addEventHandler('onMarkerHit',drugsDealerMarker,drugsDealerMarkerHit)

function sellItemsToServer(player,cmd,item,menge)
	if(getElementData(player,'loggedin') == 1)then
		if(getDistanceBetweenPoints3D(2322.8000488281,-1223.4000244141,22.60000038147,getElementPosition(player))<7)then
			if(item and menge)then
				local menge = tonumber(menge)
				
				if(item == 'mats')then
					if(getElementData(player,'Mats') >= menge)then
						local money = menge*4
						givePlayerMoney(player,money)
						setElementData(player,'Mats',getElementData(player,'Mats') - menge)
						if(isGerman(player))then
							infobox_func('Du hast '..menge..' Materialien für '..money..'$ verkauft.',0,255,0)
						elseif(isEnglish(player))then
							infobox_func(player,'You have sell '..menge..' mats for '..money..'$.',0,255,0)
						end
					else 
						getChatBox(player,31)
					end
				elseif(item == 'drugs')then
					if(getElementData(player,'Drogen') >= menge)then
						local money = menge*6
						givePlayerMoney(player,money)
						setElementData(player,'Drogen',getElementData(player,'Drogen')-menge)
						
						if(isGerman(player))then
							infobox_func('Du hast '..menge..'g Weed für '..money..'$ verkauft.',0,255,0)
						elseif(isEnglish(player))then
							infobox_func(player,'You have sell '..menge..'g Weed for '..money..'$.',0,255,0)
						end
					else 
						getChatBox(player,30)
					end
				end
			else
				getChatBox(player,79)
			end
		end
	end
end
addCommandHandler('sell',sellItemsToServer)