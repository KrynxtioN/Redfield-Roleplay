function bonusshopserverbuy(item,level)
	if(item == 'leben')then
		if(getElementData(source,"Level")>=level)then
			if(isErfahrungspunkte(source,25))then
				setElementHealth(source,100)
				takeErfahrungspunkte(source,25)
			else
				getChatBox(source,26)
			end
		else
			getChatBox(source,169)
		end
	elseif(item == 'weste')then
		if(getElementData(source,"Level")>=level)then
			if(isErfahrungspunkte(source,25))then
				setPedArmor(source,100)
				takeErfahrungspunkte(source,25)
			else
				getChatBox(source,26)
			end
		else
			getChatBox(source,169)
		end
	end
	getChatBox(source,25)
end
addEvent('bonusshopserverbuy',true)
addEventHandler('bonusshopserverbuy',root,bonusshopserverbuy)