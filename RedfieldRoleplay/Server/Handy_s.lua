function handychange(player)
	if(getElementData(player,'loggedin') == 1)then
		if(getElementData(player,'handystate') == 'on')then
			setElementData(player,'handystate','off')
			infobox_func(player,getText(player,"Handy1"),255,0,0)
		else
			setElementData(player,'handystate','on')
			infobox_func(player,getText(player,"Handy1"),0,255,0)
		end
	end
end
addCommandHandler('handychange',handychange)

function cmdSMS(player,cmd,number,...)
	if(getElementData(player,"loggedin") == 1)then
		if(number)then
			local parametersTable = {...}
			local text = table.concat(parametersTable," ")

			if(text ~= "")then
				local sent = smsFunc(player,tonumber(number),text)

				if(sent)then
					infobox_func(player,getText(player,"Handy6"),0,255,0)
				end
			else
				infobox_func(player,getText(player,"Handy4"),255,0,0)
			end
		else
			infobox_func(player,getText(player,"Handy3"),255,0,0)
		end
	end
end
addCommandHandler("sms",cmdSMS)

function smsFunc(player,nr,text)
	if(getElementData(player,"handystate") ~= "on")then
		infobox_func(player,getText(player,"Handy8"),255,0,0)
		return false
	end

	if not nr then
		infobox_func(player,getText(player,"Handy5"),255,0,0)
		return false
	end

	for _,playeritem in ipairs(getElementsByType("player"))do
		local telefonnummer = tonumber(getElementData(playeritem,"Telefonnummer"))

		if telefonnummer and telefonnummer == nr then
			if(getElementData(playeritem,"handystate") == "on")then
				outputChatBox(getText(playeritem,"Handy7"):format(getPlayerName(player),getElementData(player,"Telefonnummer"),text),playeritem,0,150,0)
				return true
			end

			infobox_func(player,getText(player,"Handy5"),255,0,0)
			return false
		end
	end

	infobox_func(player,getText(player,"Handy5"),255,0,0)
	return false
end