function handychange(player)
	if(getElementData(player,'loggedin')==1)then
		if(getElementData(player,'handystate')=='on')then
			setElementData(player,'handystate','off')
			getChatBox(player,75)
		else
			setElementData(player,'handystate','on')
			getChatBox(player,76)
		end
	end
end
addCommandHandler('handychange',handychange)

function cmdSMS(player,cmd,number,...)
	if(getElementData(player,'loggedin')==1)then
		if(number)then
			local parametersTable = {...}
			local text=  table.concat(parametersTable,' ')
			if(text)then
				smsFunc(player,tonumber(number),text)
			else
				getChatBox(player,7)
			end
		else 
			getChatBox(player,74)
		end
	end
end
addCommandHandler('sms',cmdSMS)

function smsFunc(player,nr,text)
	if(getElementData(player,'handystate') == 'on')then
		local players = getElementsByType('player')
		for i=1,#players do
			local playeritem = players[i]
			if(getElementData(playeritem,'Telefonnummer'))then
				if(getElementData(playeritem,'Telefonnummer') == nr)then
					if(getElementData(playeritem,'handystate') == 'on')then
						getChatBox(player,73)
						if(isGerman(playeritem))then
							outputChatBox('SMS von '..getPlayerName(player)..' ('..getElementData(player,'Telefonnummer')..'): '..text,playeritem,0,150,0)
						elseif(isEnglish(playeritem))then
							outputChatBox('SMS from '..getPlayerName(player)..' ('..getElementData(player,'Telefonnummer')..'): '..text,playeritem,0,150,0)
						end
					end
				end
			end
		end
	else
		getChatBox(player,72)
	end
end