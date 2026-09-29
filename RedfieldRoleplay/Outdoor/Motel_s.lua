local pedFence = createObject(970,2216.3000488281,-1145.1999511719,1025,90,0,0)
setElementInterior(pedFence,15)
setElementDimension(pedFence,0)

local motelPlayers = {}

function isPlayerAtMotel(player)
	if not isElement(player) or getElementType(player) ~= "player" then return false end
	if getElementData(player,"loggedin") ~= 1 then return false end
	if getElementInterior(player) ~= 15 then return false end
	if getElementDimension(player) ~= 0 then return false end

	local px,py,pz = getElementPosition(player)
	local mx,my,mz = getElementPosition(motelPickup)

	if getDistanceBetweenPoints3D(px,py,pz,mx,my,mz) > 5 then
		return false
	end

	return true
end

addEvent("openMotelSession",true)
addEventHandler("openMotelSession",root,function()
	if not client or not isElement(client) then return end
	if getElementData(client,"loggedin") ~= 1 then return end

	motelPlayers[client] = true
end)

function zimmerMieten()
	local player = client
	if not player or not isElement(player) then return end
	if not motelPlayers[player] then return end

	local motel = tonumber(getElementData(player,"Motel")) or 0

	if motel ~= 0 then
		infobox_func(player,getText(player,"Motel9"),255,0,0)
		return
	end

	setElementData(player,"Motel",1)

	outputChatBox(getText(player,"Motel1"),player,255,255,255)
	infobox_func(player,getText(player,"Motel2"),0,255,0)
end
addEvent("zimmerMieten",true)
addEventHandler("zimmerMieten",root,zimmerMieten)

function ausmietenMotel()
	local player = client
	if not player or not isElement(player) then return end
	if not motelPlayers[player] then return end

	local motel = tonumber(getElementData(player,"Motel")) or 0

	if motel ~= 1 then
		infobox_func(player,getText(player,"Motel9"),255,0,0)
		return
	end

	setElementData(player,"Motel",0)

	outputChatBox(getText(player,"Motel3"),player,255,255,255)
	infobox_func(player,getText(player,"Motel4"),0,255,0)
end
addEvent("ausmietenMotel",true)
addEventHandler("ausmietenMotel",root,ausmietenMotel)

addEvent("closeMotelSession",true)
addEventHandler("closeMotelSession",root,function()
	if not client then return end
	motelPlayers[client] = nil
end)

addEventHandler("onPlayerQuit",root,function()
	motelPlayers[source] = nil
end)

addEventHandler("onPlayerWasted",root,function()
	motelPlayers[source] = nil
end)

local zimmerSpawnMotel = {
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
	if not isElement(player) or getElementType(player) ~= "player" then return end

	local spawn = zimmerSpawnMotel[math.random(1,#zimmerSpawnMotel)]

	setElementInterior(player,15)
	setElementDimension(player,0)
	setElementPosition(player,spawn[1],spawn[2],spawn[3])
end