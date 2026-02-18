local Adminnames = {

[1] = 'Ticketbeauftragter',
[2] = 'Supporter',
[3] = 'Moderator',
[4] = 'Projektleiter'

}

local Adminrangs = {

['Ticketbeauftragter'] = 1,
['Supporter'] = 2,
['Moderator'] = 3,
['Projektleiter'] = 4

}

local Factionnames = {

[1] = 'Police',
[2] = 'Yakuza',
[3] = 'Biker',
[4] = 'Reporter',
[5] = 'Ballas',
[6] = 'Surenos'

}

function isAdminlevel(player,adminlevel)
	local level = getElementData(player,'Adminrang')
	
	if(adminlevel == nil)then
		adminlevel = 1
	end

	if(level >= adminlevel)then
		return true
	else
		return false
	end
end

function adminlist_func(player)
	if(getElementData(player,'loggedin') == 1)then
		outputChatBox('Moment online:',player,35,207,95)
		
		for k,v in ipairs(getElementsByType('player'))do
			if(isAdminlevel(v))then
				outputChatBox(getPlayerName(v)..', '..Adminnames[getElementData(v,'Adminrang')])
			end
		end
	end
end
addCommandHandler('admins',adminlist_func)

function makeleader_func(player,cmd,target,faction)
	if(getElementData(player,'loggedin') == 1)then
		if(isAdminlevel(player,Adminrangs['Moderator']))then
			if(target and faction)then
				local tplayer = getPlayerFromName(target)
				local faction = tonumber(faction)
				
				if(isElement(tplayer))then
					setElementData(tplayer,'Fraktionrang',5)
					setElementData(tplayer,'Fraktion',faction)
							
					if(isGerman(player))then
						infobox_func(player,'Du hast '..getPlayerName(tplayer)..' zum '..Factionnames[faction]..' Leader ernannt.',255,255,255)
					elseif(isEnglish(player))then
						infobox_func(player,'You have set '..getPlayerName(tplayer)..' '..Factionnames[faction]..' Leader.',255,255,255)
					end
							
					if(isGerman(tplayer))then
						infobox_func(tplayer,'Du wurdest von '..getPlayerName(player)..' zum '..Factionnames[faction]..' Leader ernannt.',255,255,255)
					elseif(isEnglish(tplayer))then
						infobox_func(tplayer,getPlayerName(player)..' has set you '..Factionnames[faction]..' Leader.',255,255,255)
					end
				else
					getChatBox(player,11)
				end
			else
				getChatBox(player,1)
			end
		else
			getChatBox(player,2)
		end
	end
end
addCommandHandler('makeleader',makeleader_func)

function giverank_func(player,cmd,target,rank)
	if(getElementData(player,'loggedin') == 1)then
		if(isAdminlevel(player,Adminrangs['Moderator']))then
			if(target and rank)then
				local tplayer = getPlayerFromName(target)
				
				if(isElement(tplayer))then
					if(getElementData(tplayer,'Fraktion') > 0)then
						local rank = tonumber(rank)
						
						getChatBox(player,5)
						getChatBox(tplayer,6)
						setElementData(tplayer,'Fraktionrang',rank)
					else
						getChatBox(player,4)
					end
				else
					getChatBox(player,11)
				end
			else
				getChatBox(player,3)
			end
		else
			getChatBox(player,2)
		end
	end
end
addCommandHandler('setrank',giverank_func)

function adminChatRoot_func(player,cmd,...)
	if(getElementData(player,'loggedin') == 1)then
		if(isAdminlevel(player,Adminrangs['Ticketbeauftragter']))then
			local parametersTable = {...}
			local stringWithAllParameters = table.concat(parametersTable,' ')
			
			if(stringWithAllParameters == '')then
				getChatBox(player,7)
			else
				local name = getPlayerName(player)
				local rank = Adminnames[getElementData(player,'Adminrang')]
				
				outputChatBox('(('..rank..' '..name..': '..stringWithAllParameters..'))',root,255,255,255)
			end
		else
			getChatBox(player,8)
		end
	end
end
addCommandHandler('o',adminChatRoot_func)

function kickplayer_func(player,cmd,target,...)
	if(getElementData(player,'loggedin') == 1)then
		if(isAdminlevel(player,Adminrangs['Supporter']))then
			if(target)then
				local reason = {...}
				reason = table.concat(reason,' ')
				local tplayer = getPlayerFromName(target)
				
				if(isElement(tplayer))then
					if(reason == '')then reason = 'Keine Angabe' end
					
					kickPlayer(tplayer,player,tostring(reason))
					outputChatBox(getPlayerName(tplayer)..' wurde von '..getPlayerName(player)..' gekickt! Grund: '..tostring(reason),root,150,0,0)
				else
					getChatBox(player,11)
				end
			else
				getChatBox(player,10)
			end
		else
			getChatBox(player,9)
		end
	end
end
addCommandHandler('rkick',kickplayer_func)

function permaban_func(player,cmd,target,...)
	if(getElementData(player,'loggedin') == 1)then
		if(isAdminlevel(player,Adminrangs['Projektleiter']))then
			if(target)then
				local reason = {...}
				reason = table.concat(reason,' ')
				local tplayer = getPlayerFromName(target)
				
				if(isElement(tplayer))then
					if(reason == '')then reason = 'Keine Angabe' end
					
					kickPlayer(tplayer,player,tostring(reason))
					dbExec(dbConnection,"INSERT INTO bans (Username,Grund) VALUES ('"..getPlayerName(target).."','"..reason.."')")
					outputChatBox(getPlayerName(target)..' wurde von '..getPlayerName(player)..' permanent gebannt! Grund: '..reason,root,150,0,0)
				else
					getChatBox(player,11)
				end
			else
				getChatBox(player,10)
			end
		else
			getChatBox(player,12)
		end
	end
end
addCommandHandler('rban',permaban_func)

function prison_func(player,cmd,target,reason,time)
	if(getElementData(player,'loggedin') == 1)then
		if(isAdminlevel(player,Adminrangs['Supporter']))then
			if(target and reason and time)then
				local tplayer = getPlayerFromName(target)
				
				if(isElement(tplayer))then
					inDenKnast(tplayer)
					setElementData(tplayer,'Prisontime',getElementData(tplayer,'Prisontime')+time)
					outputChatBox(getPlayerName(tplayer)..' wurde für '..time..' Minuten ins Prison gesperrt! Grund: '..reason,root,150,0,0)
				else
					getChatBox(player,11)
				end
			else
				getChatBox(player,13)
			end
		else
			getChatBox(player,9)
		end
	end
end
addCommandHandler('prison',prison_func)

function mute_func(player,cmd,target)
	if(getElementData(player,'loggedin') == 1)then
		if(isAdminlevel(player,Adminrangs['Supporter']))then
			if(target)then
				local tplayer = getPlayerFromName(target)
				
				if(isElement(tplayer))then
					if(getElementData(tplayer,'Mute') == 0)then
						getChatBox(player,14)
						getChatBox(tplayer,15)
						setElementData(tplayer,'Mute',1)
					else
						getChatBox(player,16)
					end
				else
					getChatBox(player,11)
				end
			else
				getChatBox(player,10)
			end
		else
			getChatBox(player,9)
		end
	end
end

function adminintern_func(player,cmd,...)
	if(getElementData(player,'loggedin') == 1)then
		local chat = {...}
		local text = table.concat(chat,' ')
		
		if(isAdminlevel(player,Adminrangs['Ticketbeauftragter']))then
			if(not(text == ''))then
				local players = getElementsByType('player')
				
				for k,v in ipairs(players)do
					if(isAdminlevel(v,Adminrangs['Ticketbeauftragter']))then
						local name = getPlayerName(player)
						local rank = Adminnames[getElementData(player,'Adminrang')]
						outputChatBox('(('..rank..' '..name..': '..text..'))',v,0,150,0)
					end
				end
			else
				getChatBox(player,7)
			end
		else
			getChatBox(player,8)
		end
	end
end
addCommandHandler('a',adminintern_func)

function goto_func(player,cmd,target)
	if(getElementData(player,'loggedin') == 1)then
		if(isAdminlevel(player,Adminrangs['Supporter']))then
			if(target)then
				local tplayer=getPlayerFromName(target)
				
				if(isElement(tplayer))then
					local x,y,z = getElementPosition(tplayer)
					local interior = getElementInterior(tplayer)
					local dimension = getElementDimension(tplayer)
					
					setElementPosition(player,x,y,z)
					setElementInterior(player,interior)
					setElementDimension(player,dimension)
				else
					getChatBox(player,11)
				end
			else
				getChatBox(player,10)
			end
		else
			getChatBox(player,9)
		end
	end
end
addCommandHandler('goto',goto_func)

function gethere_func(player,cmd,target)
	if(getElementData(player,'loggedin') == 1)then
		if(isAdminlevel(player,Adminrangs['Supporter']))then
			if(target)then
				local tplayer=getPlayerFromName(target)
				
				if(isElement(tplayer))then
					local x,y,z = getElementPosition(player)
					local interior = getElementInterior(player)
					local dimension = getElementDimension(player)
					
					setElementPosition(tplayer,x,y,z)
					setElementInterior(tplayer,interior)
					setElementDimension(tplayer,dimension)
				else
					getChatBox(player,11)
				end
			else
				getChatBox(player,10)
			end
		else
			getChatBox(player,9)
		end
	end
end
addCommandHandler('gethere',gethere_func)

function event_kasse(player,cmd,typ,money)
	if(getElementData(player,"Adminrang")>=1)then
		local query=dbQuery(dbConnection,"SELECT * FROM kassen WHERE Besitzer = '99'")
		local result,num_rows=dbPoll(query,-1)

		if(query)then
			if(not(typ) and not(money))then
				if(isGerman(player))then
					outputChatBox("Eventkasse: "..tonumber(result[1]['Inhalt']).."$",player,0,100,200)
					outputChatBox("Tippe /eventkasse [take/give] [Geld], um etwas ein/auszuzahlen.",player,0,100,150)
				elseif(isEnglish(player))then
					outputChatBox("Event-Money: "..tonumber(result[1]['Inhalt']).."$",player,0,100,200)
					outputChatBox("Use /eventkasse [take/give] [Money], to use the Eventmoney.",player,0,100,150)
				end
			else
				money=tonumber(money)
				if(typ=="take")then
					if(tonumber(result[1]["Geld"])>=money)then
						updateEventkasse("auszahlen",money)
						givePlayerMoney(player,money)
						getChatBox(player,151)
					else
						getChatBox(player,150)
					end
				elseif(typ=="give")then
					if(getPlayerMoney(player)>=money)then
						updateEventkasse("einzahlen",money)
						takePlayerMoney(player,money)
						getChatBox(player,152)
					else
						getChatBox(player,33)
					end
				end
			end
		end
	end
end
addCommandHandler("eventkasse",event_kasse)

function updateEventkasse(typ,money)
	local query=dbQuery(dbConnection,"SELECT * FROM kassen WHERE Besitzer = '99'")
	local result,num_rows=dbPoll(query,-1)
	
	if(query)then
		if(typ=="auszahlen")then
			getmoney=tonumber(result[1]["Geld"])
			newmoney=getmoney-money
			dbQuery(dbConnection,"UPDATE kassen SET Geld = '"..newmoney.."' WHERE Besitzer = '99'")
		elseif(typ=="einzahlen")then
			getmoney=tonumber(result[1]["Geld"])
			newmoney=getmoney+money
			dbQuery(dbConnection,"UPDATE kassen SET Geld = '"..newmoney.."' WHERE Besitzer = '99'")
		end
	end
end