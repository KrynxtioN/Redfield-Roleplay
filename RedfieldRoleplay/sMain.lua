local realtime = getRealTime()
setTime(realtime.hour,realtime.minute)
setMinuteDuration(60000)

addEventHandler("onPlayerChangeNick",root,function()
	infobox_func(source,getText(source,"Nickchange1"),255,0,0)
	cancelEvent()
end)