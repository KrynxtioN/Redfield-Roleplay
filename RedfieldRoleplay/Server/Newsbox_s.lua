function newsbox()
	local players = getElementsByType('player')
	
	for theKey,thePlayer in pairs(players)do
		if(isGerman(thePlayer))then
			outputChatBox('__________| Redfield Roleplay |__________',thePlayer,255,255,0)
			outputChatBox('In der Stadthalle kannst du Jobs annehmen.',thePlayer,255,255,0)
			outputChatBox('Du benötigst Hilfe? Tippe /report oder F1.',thePlayer,255,255,0)
			outputChatBox('Du hast Hunger? Besuche ein Restaurant.',thePlayer,255,255,0)
			outputChatBox('Ein Konto kannst du in der Bank eröffnen.',thePlayer,255,255,0)
			outputChatBox('__________| Redfield Roleplay |__________',thePlayer,255,255,0)
		elseif(isEnglish(thePlayer))then
			outputChatBox('__________| Redfield Roleplay |__________',thePlayer,255,255,0)
			outputChatBox('Accept jobs in our Cityhall.',thePlayer,255,255,0)
			outputChatBox('You need help? Use /report or F1.',thePlayer,255,255,0)
			outputChatBox('You are hungry? Visit a restaurant.',thePlayer,255,255,0)
			outputChatBox('Create a bank account in the bank.',thePlayer,255,255,0)
			outputChatBox('__________| Redfield Roleplay |__________',thePlayer,255,255,0)
		end
	end
end
setTimer(newsbox,1800000,0)