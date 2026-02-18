function farmerjob_func(player)
	if(getDistanceBetweenPoints3D(-1061.4000244141,-1195.5999755859,129.80000305176,getElementPosition(player))<5)then
		if(getElementData(player,"Job")=="Farmer")then
			if(not(getElementData(player,"FarmerAktiv"))==true)then
				setElementData(player,"FarmerAktiv",true)
				triggerClientEvent(player,"milkCowMarker",player)
				if(isGerman(player))then
					outputChatBox("Farmer: Die Kühe müssen wieder gemolken werden.",player,255,255,255)
				elseif(isEnglish(player))then
					outputChatBox("Farmer: The cows must be milked again.",player,255,255,255)
				end
			end
		end
	end
end
addCommandHandler("farmjob",farmerjob_func)