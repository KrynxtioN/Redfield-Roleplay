function playerChatting(message,type)
	local player = source
	
	if(getElementData(source,'Mute') == 0)then
		if(type == 0)then
			cancelEvent()
			local x,y,z = getElementPosition(player)
			local colsphare = createColSphere(x,y,z,25)
			local colsphare2 = getElementsWithinColShape(colsphare,'player')
			for index,spieler in ipairs(colsphare2)do
				if(getElementData(player,'isLive') == true)then
					outputChatBox('Gast '..getPlayerName(player)..': '..message,root,250,100,0)
				else
					if(isGerman(spieler))then
						outputChatBox(getPlayerName(player)..' sagt: '..message,spieler,255,255,255)
					elseif(isEnglish(spieler))then
						outputChatBox(getPlayerName(player)..' say: '..message,spieler,255,255,255)
					end
				end
			end
		elseif(type == 1)then
			cancelEvent()
		elseif(type == 2)then
			cancelEvent()
			executeCommandHandler('tchat',source,message)
		end
	else
		getChatBox(player,77)
	end
end
addEventHandler('onPlayerChat',root,playerChatting)

function frakChat(player,cmd,...)
	local chat = {...}
	local text = table.concat(chat,' ')
	local fraki = getElementData(player,'Fraktion')
	
	if(fraki > 0)then
		local players = getElementsByType('player')
		for k,fplayer in ipairs(players)do
			if(getElementData(fplayer,'Fraktion'))then
				if(getElementData(fplayer,'Fraktion') == fraki)then
					if(isGerman(fplayer))then
						outputChatBox('Fraktiosnchat '..getPlayerName(player)..': '..text,fplayer,255,255,0)
					elseif(isEnglish(fplayer))then
						outputChatBox('Factionchat '..getPlayerName(player)..': '..text,fplayer,255,255,0)
					end
				end
			end
		end
	end
end
addCommandHandler('tchat',frakChat)