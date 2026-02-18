function achievmentInfo(player)
	giveErfahrungspunkte(player,50)
	
	if(isGerman(player))then
		outputChatBox('Du hast ein Achievment erreicht, wofür du 50 EXP bekommst.',player,0,200,0)
	elseif(isEnglish(player))then
		outputChatBox('You reached an achievement for which you get 50 EXP.',player,0,200,0)
	end
end
addEvent('achievmentInfo',true)
addEventHandler('achievmentInfo',root,achievmentInfo)