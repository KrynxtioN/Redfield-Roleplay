local report = {}
local reportHelpCooldown = {}
local reportpickup = createPickup(1483.8206787109,-1789.1024169922,-93.831253051758,3,1239,50)

function inreporthalle_func(player)
	if getElementData(player,"loggedin") ~= 1 then return end
	if report[player] then
		infobox_func(player,getText(player,"Report1"),255,0,0)
		return
	end
	if getElementInterior(player) ~= 0 or getElementDimension(player) ~= 0 then
		infobox_func(player,getText(player,"Report2"),255,0,0)
		return
	end
	local x,y,z = getElementPosition(player)
	report[player] = {x=x,y=y,z=z,interior=getElementInterior(player),dimension=getElementDimension(player)}
	setElementData(player,"posx",x)
	setElementData(player,"posy",y)
	setElementData(player,"posz",z)
	setElementData(player,"inReport",true)
	if (tonumber(getElementData(player,"Adminrang")) or 0) > 0 then
		setElementPosition(player,1477.1514892578,-1781.9364013672,-93.831253051758)
	else
		setElementPosition(player,1482.5185546875,-1799.3825683594,-93.831253051758)
	end
	infobox_func(player,getText(player,"Report3"),0,200,0)
end
addCommandHandler("report",inreporthalle_func)

function outreport_func(player)
	if getElementData(player,"loggedin") ~= 1 then return end
	if not report[player] then
		infobox_func(player,getText(player,"Report4"),255,0,0)
		return
	end
	local data = report[player]
	setElementInterior(player,data.interior or 0)
	setElementDimension(player,data.dimension or 0)
	setElementPosition(player,data.x,data.y,data.z)
	report[player] = nil
	reportHelpCooldown[player] = nil
	setElementData(player,"inReport",false)
	infobox_func(player,getText(player,"Report5"),0,200,0)
end
addCommandHandler("leavereport",outreport_func)

function reportpickup_func(player)
	if getElementType(player) ~= "player" then return end
	if getElementData(player,"loggedin") ~= 1 or not report[player] then return end
	infobox_func(player,getText(player,"Report6"),0,200,0)
end
addEventHandler("onPickupHit",reportpickup,reportpickup_func)

function hilfe_func(player)
	if getElementData(player,"loggedin") ~= 1 then return end
	if not report[player] then
		infobox_func(player,getText(player,"Report7"),255,0,0)
		return
	end
	local x,y,z = getElementPosition(player)
	if getDistanceBetweenPoints3D(1483.8206787109,-1789.1024169922,-93.831253051758,x,y,z) > 5 then
		infobox_func(player,getText(player,"Report8"),255,0,0)
		return
	end
	local now = getTickCount()
	if reportHelpCooldown[player] and now-reportHelpCooldown[player] < 30000 then
		local seconds = math.ceil((30000-(now-reportHelpCooldown[player]))/1000)
		infobox_func(player,getText(player,"Report9"):format(seconds),255,0,0)
		return
	end
	reportHelpCooldown[player] = now
	local admins = 0
	for _,admin in ipairs(getElementsByType("player")) do
		if getElementData(admin,"loggedin") == 1 and (tonumber(getElementData(admin,"Adminrang")) or 0) > 0 then
			admins = admins+1
			infobox_func(admin,getText(admin,"Report10"):format(getPlayerName(player)),255,200,0)
		end
	end
	if admins > 0 then
		infobox_func(player,getText(player,"Report11"),0,200,0)
	else
		infobox_func(player,getText(player,"Report12"),255,0,0)
	end
end
addCommandHandler("hilfe",hilfe_func)
addCommandHandler("help",hilfe_func)

addEventHandler("onPlayerQuit",root,function()
	report[source] = nil
	reportHelpCooldown[source] = nil
end)