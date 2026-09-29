function newsbox()
	for _,player in ipairs(getElementsByType("player")) do
		outputChatBox("━━━━━━━━━━━━━━━| Redfield Roleplay |━━━━━━━━━━━━━━━",player,255,180,0)
		outputChatBox("» "..getText(player,"Newsbox1"),player,235,235,235)
		outputChatBox("» "..getText(player,"Newsbox2"),player,235,235,235)
		outputChatBox("» "..getText(player,"Newsbox3"),player,235,235,235)
		outputChatBox("» "..getText(player,"Newsbox4"),player,235,235,235)
		outputChatBox("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━",player,255,180,0)
	end
end
setTimer(newsbox,1800000,0)