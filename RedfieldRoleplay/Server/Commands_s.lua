local weedgeraucht={}

addCommandHandler("smokeweed",function(player)
	if(getElementData(player,"Drogen")>=4)then
		if(weedgeraucht[player]==false)then
			setPedArmor(player,100)
			getChatBox(player,164)
			weedgeraucht[player]=true
			setTimer(function()
				weedgeraucht[player]=false
			end,15000,1)
		else
			getChatBox(player,165)
		end
	else
		getChatBox(player,163)
	end
end)