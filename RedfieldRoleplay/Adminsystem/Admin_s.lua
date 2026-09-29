local Adminnames = {
	[1] = {[0]="Ticketbeauftragter",[1] = "Ticket Manager"},
	[2] = {[0]="Supporter",[1] = "Supporter"},
	[3] = {[0]="Moderator",[1] = "Moderator"},
	[4] = {[0]="Projektleiter",[1] = "Project Manager"}
}

local Adminrangs = {
	["Ticketbeauftragter"] = 1,
	["Supporter"] = 2,
	["Moderator"] = 3,
	["Projektleiter"] = 4
}

local Factionnames = {
	[1] = {[0] = "Polizei",[1] = "Police"},
	[2] = {[0] = "Yakuza",[1] = "Yakuza"},
	[3] = {[0] = "Biker",[1] = "Biker"},
	[4] = {[0] = "Reporter",[1] = "Reporter"},
	[5] = {[0] = "Ballas",[1] = "Ballas"},
	[6] = {[0] = "Surenos",[1] = "Surenos"}
}

local function getPlayerLanguage(player)
	local language = tonumber(getElementData(player,"Language")) or 0
	if language ~= 0 and language ~= 1 then language = 0 end
	return language
end

local function getAdminName(player,rank)
	rank = tonumber(rank)
	if not rank or not Adminnames[rank] then return getText(player,"AdminUnknown") end
	local language = getPlayerLanguage(player)
	return Adminnames[rank][language] or Adminnames[rank][0]
end

local function getFactionName(player,faction)
	faction = tonumber(faction)
	if not faction or not Factionnames[faction] then return getText(player,"AdminUnknown") end
	local language = getPlayerLanguage(player)
	return Factionnames[faction][language] or Factionnames[faction][0]
end

local function findAdminPlayer(name)
	if not name or name == "" then return nil end
	local search = name:lower()
	local found = nil
	for _,target in ipairs(getElementsByType("player")) do
		local playerName = getPlayerName(target):gsub("#%x%x%x%x%x%x","")
		local cleanName = playerName:lower()
		if cleanName == search then return target end
		if cleanName:find(search,1,true) then
			if found then return nil end
			found = target
		end
	end
	return found
end

function isAdminlevel(player,adminlevel)
	if not isElement(player) then return false end
	adminlevel = tonumber(adminlevel) or 1
	local level = tonumber(getElementData(player,"Adminrang")) or 0
	return level >= adminlevel
end

function adminlist_func(player)
	if getElementData(player,"loggedin") ~= 1 then return end
	outputChatBox(getText(player,"Admin1"),player,35,207,95)
	local found = false
	for _,admin in ipairs(getElementsByType("player")) do
		if isAdminlevel(admin) then
			found = true
			outputChatBox(getPlayerName(admin)..", "..getAdminName(player,getElementData(admin,"Adminrang")),player,255,255,255)
		end
	end
	if not found then outputChatBox(getText(player,"Admin2"),player,255,255,255) end
end
addCommandHandler("admins",adminlist_func)

function makeleader_func(player,cmd,target,faction)
	if getElementData(player,"loggedin") ~= 1 then return end
	if not isAdminlevel(player,Adminrangs["Moderator"]) then
		infobox_func(player,getText(player,"Admin3"),255,0,0)
		return
	end
	if not target or not faction then
		infobox_func(player,getText(player,"Admin4"),255,255,255)
		return
	end
	local tplayer = findAdminPlayer(target)
	faction = tonumber(faction)
	if not isElement(tplayer) then
		infobox_func(player,getText(player,"Admin5"),255,0,0)
		return
	end
	if not faction or not Factionnames[faction] then
		infobox_func(player,getText(player,"Admin6"),255,0,0)
		return
	end
	setElementData(tplayer,"Fraktionrang",5)
	setElementData(tplayer,"Fraktion",faction)
	infobox_func(player,getText(player,"Admin7"):format(getPlayerName(tplayer),getFactionName(player,faction)),255,255,255)
	infobox_func(tplayer,getText(tplayer,"Admin8"):format(getPlayerName(player),getFactionName(tplayer,faction)),255,255,255)
end
addCommandHandler("makeleader",makeleader_func)

function giverank_func(player,cmd,target,rank)
	if getElementData(player,"loggedin") ~= 1 then return end
	if not isAdminlevel(player,Adminrangs["Moderator"]) then
		infobox_func(player,getText(player,"Admin3"),255,0,0)
		return
	end
	if not target or not rank then
		infobox_func(player,getText(player,"Admin9"),255,255,255)
		return
	end
	local tplayer = findAdminPlayer(target)
	rank = tonumber(rank)
	if not isElement(tplayer) then
		infobox_func(player,getText(player,"Admin5"),255,0,0)
		return
	end
	if (tonumber(getElementData(tplayer,"Fraktion")) or 0) <= 0 then
		infobox_func(player,getText(player,"Admin10"),255,0,0)
		return
	end
	if not rank or rank < 0 or rank > 5 or rank ~= math.floor(rank) then
		infobox_func(player,getText(player,"Admin11"),255,0,0)
		return
	end
	setElementData(tplayer,"Fraktionrang",rank)
	infobox_func(player,getText(player,"Admin12"):format(getPlayerName(tplayer),rank),255,255,255)
	infobox_func(tplayer,getText(tplayer,"Admin13"):format(getPlayerName(player),rank),255,255,255)
end
addCommandHandler("setrank",giverank_func)

function adminChatRoot_func(player,cmd,...)
	if getElementData(player,"loggedin") ~= 1 then return end
	if not isAdminlevel(player,Adminrangs["Ticketbeauftragter"]) then
		infobox_func(player,getText(player,"Admin14"),255,0,0)
		return
	end
	local text = table.concat({...}," ")
	if text == "" then
		infobox_func(player,getText(player,"Admin15"),255,255,255)
		return
	end
	local name = getPlayerName(player)
	for _,target in ipairs(getElementsByType("player")) do
		local rank = getAdminName(target,getElementData(player,"Adminrang"))
		outputChatBox("(("..rank.." "..name..": "..text.."))",target,255,255,255)
	end
end
addCommandHandler("o",adminChatRoot_func)

function kickplayer_func(player,cmd,target,...)
	if getElementData(player,"loggedin") ~= 1 then return end
	if not isAdminlevel(player,Adminrangs["Supporter"]) then
		infobox_func(player,getText(player,"Admin16"),255,0,0)
		return
	end
	if not target then
		infobox_func(player,getText(player,"Admin17"),255,255,255)
		return
	end
	local tplayer = findAdminPlayer(target)
	if not isElement(tplayer) then
		infobox_func(player,getText(player,"Admin5"),255,0,0)
		return
	end
	if tplayer == player then
		infobox_func(player,getText(player,"Admin18"),255,0,0)
		return
	end
	local adminRank = tonumber(getElementData(player,"Adminrang")) or 0
	local targetRank = tonumber(getElementData(tplayer,"Adminrang")) or 0
	if targetRank >= adminRank and targetRank > 0 then
		infobox_func(player,getText(player,"Admin19"),255,0,0)
		return
	end
	local reason = table.concat({...}," ")
	if reason == "" then reason = getText(player,"Admin20") end
	local targetName = getPlayerName(tplayer)
	local adminName = getPlayerName(player)
	for _,targetPlayer in ipairs(getElementsByType("player")) do
		outputChatBox(getText(targetPlayer,"Admin21"):format(targetName,adminName,reason),targetPlayer,150,0,0)
	end
	kickPlayer(tplayer,player,reason)
end
addCommandHandler("rkick",kickplayer_func)

function permaban_func(player,cmd,target,...)
	if getElementData(player,"loggedin") ~= 1 then return end
	if not isAdminlevel(player,Adminrangs["Projektleiter"]) then
		infobox_func(player,getText(player,"Admin22"),255,0,0)
		return
	end
	if not target then
		infobox_func(player,getText(player,"Admin23"),255,255,255)
		return
	end
	local tplayer = findAdminPlayer(target)
	if not isElement(tplayer) then
		infobox_func(player,getText(player,"Admin5"),255,0,0)
		return
	end
	if tplayer == player then
		infobox_func(player,getText(player,"Admin18"),255,0,0)
		return
	end
	local reason = table.concat({...}," ")
	if reason == "" then reason = getText(player,"Admin20") end
	local targetName = getPlayerName(tplayer)
	local adminName = getPlayerName(player)
	if not dbExec(dbConnection,"INSERT INTO bans (Username,Grund) VALUES (?,?)",targetName,reason) then return end
	for _,targetPlayer in ipairs(getElementsByType("player")) do
		outputChatBox(getText(targetPlayer,"Admin24"):format(targetName,adminName,reason),targetPlayer,150,0,0)
	end
	kickPlayer(tplayer,player,reason)
end
addCommandHandler("rban",permaban_func)

function prison_func(player,cmd,target,reason,time)
	if getElementData(player,"loggedin") ~= 1 then return end
	if not isAdminlevel(player,Adminrangs["Supporter"]) then
		infobox_func(player,getText(player,"Admin16"),255,0,0)
		return
	end
	if not target or not reason or not time then
		infobox_func(player,getText(player,"Admin25"),255,255,255)
		return
	end
	local tplayer = findAdminPlayer(target)
	time = tonumber(time)
	if not isElement(tplayer) then
		infobox_func(player,getText(player,"Admin5"),255,0,0)
		return
	end
	if not time or time <= 0 or time ~= math.floor(time) then
		infobox_func(player,getText(player,"Admin26"),255,0,0)
		return
	end
	inDenKnast(tplayer)
	setElementData(tplayer,"Prisontime",(tonumber(getElementData(tplayer,"Prisontime")) or 0)+time)
	for _,targetPlayer in ipairs(getElementsByType("player")) do
		outputChatBox(getText(targetPlayer,"Admin27"):format(getPlayerName(tplayer),time,reason),targetPlayer,150,0,0)
	end
end
addCommandHandler("prison",prison_func)

function mute_func(player,cmd,target)
	if getElementData(player,"loggedin") ~= 1 then return end
	if not isAdminlevel(player,Adminrangs["Supporter"]) then
		infobox_func(player,getText(player,"Admin16"),255,0,0)
		return
	end
	if not target then
		infobox_func(player,getText(player,"Admin17"),255,255,255)
		return
	end
	local tplayer = findAdminPlayer(target)
	if not isElement(tplayer) then
		infobox_func(player,getText(player,"Admin5"),255,0,0)
		return
	end
	if tonumber(getElementData(tplayer,"Mute")) == 1 then
		infobox_func(player,getText(player,"Admin28"),255,0,0)
		return
	end
	setElementData(tplayer,"Mute",1)
	infobox_func(player,getText(player,"Admin29"):format(getPlayerName(tplayer)),255,255,255)
	infobox_func(tplayer,getText(tplayer,"Admin30"):format(getPlayerName(player)),255,0,0)
end
addCommandHandler("mute",mute_func)

function adminintern_func(player,cmd,...)
	if getElementData(player,"loggedin") ~= 1 then return end
	if not isAdminlevel(player,Adminrangs["Ticketbeauftragter"]) then
		infobox_func(player,getText(player,"Admin14"),255,0,0)
		return
	end
	local text = table.concat({...}," ")
	if text == "" then
		infobox_func(player,getText(player,"Admin15"),255,255,255)
		return
	end
	local name = getPlayerName(player)
	for _,admin in ipairs(getElementsByType("player")) do
		if isAdminlevel(admin,Adminrangs["Ticketbeauftragter"]) then
			local rank = getAdminName(admin,getElementData(player,"Adminrang"))
			outputChatBox("(("..rank.." "..name..": "..text.."))",admin,0,150,0)
		end
	end
end
addCommandHandler("a",adminintern_func)

function goto_func(player,cmd,target)
	if getElementData(player,"loggedin") ~= 1 then return end
	if not isAdminlevel(player,Adminrangs["Supporter"]) then
		infobox_func(player,getText(player,"Admin16"),255,0,0)
		return
	end
	if not target then
		infobox_func(player,getText(player,"Admin17"),255,255,255)
		return
	end
	local tplayer = findAdminPlayer(target)
	if not isElement(tplayer) then
		infobox_func(player,getText(player,"Admin5"),255,0,0)
		return
	end
	local x,y,z = getElementPosition(tplayer)
	setElementInterior(player,getElementInterior(tplayer))
	setElementDimension(player,getElementDimension(tplayer))
	setElementPosition(player,x,y,z+1)
	infobox_func(player,getText(player,"Admin31"):format(getPlayerName(tplayer)),255,255,255)
end
addCommandHandler("goto",goto_func)

function gethere_func(player,cmd,target)
	if getElementData(player,"loggedin") ~= 1 then return end
	if not isAdminlevel(player,Adminrangs["Supporter"]) then
		infobox_func(player,getText(player,"Admin16"),255,0,0)
		return
	end
	if not target then
		infobox_func(player,getText(player,"Admin17"),255,255,255)
		return
	end
	local tplayer = findAdminPlayer(target)
	if not isElement(tplayer) then
		infobox_func(player,getText(player,"Admin5"),255,0,0)
		return
	end
	local x,y,z = getElementPosition(player)
	setElementInterior(tplayer,getElementInterior(player))
	setElementDimension(tplayer,getElementDimension(player))
	setElementPosition(tplayer,x,y,z+1)
	infobox_func(player,getText(player,"Admin32"):format(getPlayerName(tplayer)),255,255,255)
	infobox_func(tplayer,getText(tplayer,"Admin33"):format(getPlayerName(player)),255,255,255)
end
addCommandHandler("gethere",gethere_func)

function event_kasse(player,cmd,typ,money)
	if getElementData(player,"loggedin") ~= 1 then return end
	if not isAdminlevel(player,1) then
		infobox_func(player,getText(player,"Admin14"),255,0,0)
		return
	end
	local result = dbPoll(dbQuery(dbConnection,"SELECT Geld FROM kassen WHERE Besitzer = ? LIMIT 1","99"),-1)
	if not result or not result[1] then return end
	local eventMoney = tonumber(result[1]["Geld"]) or 0
	if not typ and not money then
		outputChatBox(getText(player,"Admin34"):format(eventMoney),player,0,100,200)
		outputChatBox(getText(player,"Admin35"),player,0,100,150)
		return
	end
	money = tonumber(money)
	if not money or money <= 0 or money ~= math.floor(money) then
		infobox_func(player,getText(player,"Admin36"),255,0,0)
		return
	end
	if typ == "take" then
		if eventMoney < money then
			infobox_func(player,getText(player,"Admin37"),255,0,0)
			return
		end
		local playerMoney = tonumber(getElementData(player,"Money")) or 0
		if updateEventkasse("auszahlen",money) then
			setElementData(player,"Money",playerMoney+money)
			infobox_func(player,getText(player,"Admin38"):format(money),0,255,0)
		end
	elseif typ == "give" then
		local playerMoney = tonumber(getElementData(player,"Money")) or 0
		if playerMoney < money then
			infobox_func(player,getText(player,"Admin39"),255,0,0)
			return
		end
		if updateEventkasse("einzahlen",money) then
			setElementData(player,"Money",playerMoney-money)
			infobox_func(player,getText(player,"Admin40"):format(money),0,255,0)
		end
	else
		infobox_func(player,getText(player,"Admin41"),255,255,255)
	end
end
addCommandHandler("eventkasse",event_kasse)

function updateEventkasse(typ,money)
	money = tonumber(money)
	if not money or money <= 0 then return false end
	local result = dbPoll(dbQuery(dbConnection,"SELECT Geld FROM kassen WHERE Besitzer = ? LIMIT 1","99"),-1)
	if not result or not result[1] then return false end
	local currentMoney = tonumber(result[1]["Geld"]) or 0
	if typ == "auszahlen" then
		if currentMoney < money then return false end
		return dbExec(dbConnection,"UPDATE kassen SET Geld = ? WHERE Besitzer = ?",currentMoney-money,"99")
	elseif typ == "einzahlen" then
		return dbExec(dbConnection,"UPDATE kassen SET Geld = ? WHERE Besitzer = ?",currentMoney+money,"99")
	end
	return false
end