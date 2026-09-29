local weedgeraucht={}

addCommandHandler("smokeweed",function(player)
	if(getElementData(player,"loggedin") == 1)then
		if(tonumber(getElementData(player,"Drogen")) >= 4)then
			if(weedgeraucht[player] == false)then
				setPedArmor(player,100)
				weedgeraucht[player] = true
				setTimer(function()
					weedgeraucht[player] = false
				end,15000,1)
			else
				infobox_func(player,getText(player,"Weed2"),255,0,0)
			end
		else
			infobox_func(player,getText(player,"Weed1"),255,0,0)
		end
	end
end)