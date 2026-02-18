function buyWaffenschein(player)
	if(getElementData(player,"Waffenschein") == 0)then
		if(getPlayerMoney(player)>=7500)then
			takePlayerMoney(player,7500)
			giveErfahrungspunkte(player,250)
			getChatBox(player,91)
			setElementData(player,"Waffenschein",1)
		else 
			getChatBox(player,33)
		end
	else
		getChatBox(player,92)
	end
end
addEvent("buyWaffenschein",true)
addEventHandler("buyWaffenschein",root,buyWaffenschein)