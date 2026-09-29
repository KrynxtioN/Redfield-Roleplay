function achievementInfo()
	giveErfahrungspunkte(client,50)
	infobox_func(client,getText(client,"Achievements1"),0,255,0)
end
addEvent('achievementInfo',true)
addEventHandler('achievementInfo',root,achievementInfo)