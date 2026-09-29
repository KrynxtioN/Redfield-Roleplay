function playerChatting(message,type)
	local player = source

	if getElementData(player,"Mute") ~= 0 then
		cancelEvent()
		infobox_func(player,getText(player,"Chat4"),255,0,0)
		return
	end

	if type == 0 then
		cancelEvent()

		if getElementData(player,"isLive") == true then
			outputChatBox(getText(player,"Chat1"):format(getPlayerName(player),message),root,250,100,0)
			return
		end

		local x,y,z = getElementPosition(player)
		local colSphere = createColSphere(x,y,z,25)
		local players = getElementsWithinColShape(colSphere,"player")

		for _,target in ipairs(players) do
			outputChatBox(getText(target,"Chat2"):format(getPlayerName(player),message),target,255,255,255)
		end

		destroyElement(colSphere)

	elseif type == 1 then
		cancelEvent()

	elseif type == 2 then
		cancelEvent()
		executeCommandHandler("tchat",player,message)
	end
end
addEventHandler("onPlayerChat",root,playerChatting)

function frakChat(player,cmd,...)
	local fraktion = tonumber(getElementData(player,"Fraktion")) or 0
	if fraktion <= 0 then return end

	local text = table.concat({...}," ")
	if text == "" then return end

	for _,target in ipairs(getElementsByType("player")) do
		if tonumber(getElementData(target,"Fraktion")) == fraktion then
			outputChatBox(getText(target,"Chat3"):format(getPlayerName(player),text),target,255,255,0)
		end
	end
end
addCommandHandler("tchat",frakChat)