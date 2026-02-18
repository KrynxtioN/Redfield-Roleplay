addEvent("versicherung",true)
addEventHandler("versicherung",root,function(player)
	if(getElementData(player,"Versicherung")==0)then
		getChatBox(player,166)
		setElementData(player,"Versicherung",1)
	else
		getChatBox(player,167)
	end
end)

addEvent("versicherungStop",true)
addEventHandler("versicherungStop",root,function(player)
	if(getElementData(player,"Versicherung")==1)then
		getChatBox(player,168)
		setElementData(player,"Versicherung",0)
	end
end)