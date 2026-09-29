addEvent("versicherung",true)
addEventHandler("versicherung",root,function()
	if(getElementData(client,"Versicherung") == 0)then
		setElementData(client,"Versicherung",1)
		infobox_func(client,getText(client,"Versicherung6"),0,255,0)
	else
		infobox_func(client,getText(client,"Versicherung7"),255,0,0)
	end
end)

addEvent("versicherungStop",true)
addEventHandler("versicherungStop",root,function()
	if(getElementData(client,"Versicherung") == 1)then
		infobox_func(client,getText(client,"Versicherung9"),0,255,0)
		setElementData(client,"Versicherung",0)
	else
		infobox_func(client,getText(client,"Versicherung8"),255,0,0)
	end
end)