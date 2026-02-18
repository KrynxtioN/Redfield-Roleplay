function nickchange()
	cancelEvent()
	getChatBox(source,24)
end
addEventHandler('onPlayerChangeNick',root,nickchange)