local pedFence = createObject(970,2216.3000488281,-1145.1999511719,1025,90,0,0)
setElementInterior(pedFence,15)

function zimmerMieten(player)
	if(getElementData(player,'Motel')==0)then
		setElementData(player,'Motel',1)
		if(isGerman(player))then
			outputChatBox('Sarah: Hier ist ihr Zimmerschlüssel.',player,255,255,255)
			infobox_func(player,'Nach dem Einloggen wirst du nun im Motel spawnen.',0,255,0)
		elseif(isEnglish(player))then
			outputChatBox('Sarah: Here´s your room key.',player,255,255,255)
			infobox_func(player,'You spawn now in the motel after you logging in.',0,255,0)
		end
	else
		getChatBox(player,81)
	end
end
addEvent('zimmerMieten',true)
addEventHandler('zimmerMieten',root,zimmerMieten)

function ausmietenMotel(player)
	if(getElementData(player,'Motel')==1)then
		setElementData(player,'Motel',0)
		if(isGerman(player))then
			outputChatBox('Sarah: Wir würden uns freuen, sie bald wieder zu sehen.',player,255,255,255)
			infobox_func(player,'Du spawnst nun wieder am Noobspawn.',0,255,0)
		elseif(isEnglish(player))then
			outputChatBox('Sarah: We would be pleased to see them again soon.',player,255,255,255)
			infobox_func(player,'Now you spawn at the noobspawn after you logging in.',0,255,0)
		end
	else
		getChatBox(player,82)
	end
end
addEvent('ausmietenMotel',true)
addEventHandler('ausmietenMotel',root,ausmietenMotel)

local zimmerSpawnMotel={

{2234.8371582031,-1157.4515380859,1029.796875},
{2247.3686523438,-1161.9423828125,1029.796875},
{2235.0639648438,-1169.1770019531,1029.8043212891},
{2227.068359375,-1183.3489990234,1029.8043212891},
{2208.3737792969,-1194.3394775391,1029.796875},
{2199.2189941406,-1174.6075439453,1029.8043212891},
{2187.1337890625,-1155.4892578125,1029.796875},
{2198.2377929688,-1157.76953125,1029.796875},

}

function motelSpawn(player)
	local zimmerspawn = math.random(1,table.getn(zimmerSpawnMotel))
	setElementPosition(player,zimmerSpawnMotel[zimmerspawn][1],zimmerSpawnMotel[zimmerspawn][2],zimmerSpawnMotel[zimmerspawn][3])
	setElementInterior(player,15)
end