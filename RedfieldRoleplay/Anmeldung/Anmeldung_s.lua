local startgeld = 5000
local spawnx = -204.96250915527
local spawny = 1212.2875976563
local spawnz = 19.7421875

function selfmadeRegistrieren(name,passwort,language)
	local datenbank=dbQuery(dbConnection,"SELECT * FROM userdata WHERE Username = '"..name.."'")
	local result,num_rows=dbPoll(datenbank,-1)
	
	if(num_rows==0)then
		local serial=dbQuery(dbConnection,"SELECT * FROM userdata WHERE Serial = '"..getPlayerSerial(source).."'")
		local result,num_rows=dbPoll(serial,-1)
	
		if(num_rows==0)then
			local verschluesseln=md5(passwort)
			local pname=getPlayerName(source)
				
			dbExec(dbConnection,"INSERT INTO userdata (Username,Passwort,Money,Autoschein,Motorradschein,Lkwschein,Helikopterschein,Flugschein,Bootschein,Personalausweis,Arbeitsgenehmigung,Bankpin,Bankmoney,Level,Erfahrungspunkte,Spielzeit,Hunger,Adminrang,Fraktion,Fraktionrang,Mats,Drogen,Matstransporter,Drogentransporter,Jobgehalt,Wanteds,Stvo,Job,Flugjobskills,Knastzeit,Prisontime,Skin,Waffenschein,Motel,Mute,Handy,Telefonnummer,Infobox,Pizzajobskills,Status,SpawnX,SpawnY,SpawnZ,Holzjobskillpunkte,Eichenholz,Birkenholz,Interior,AchUmgezogen,AchFahrzeug,Ach1Million,AchKonto,AchGestorben,AchCarlicence,AchFraktion,AchLevel5,AchBonusshopbuy,Ach25TausendEXP,AchMiniMission,AchPayday,Ach5Hours,AchHouse,Kills,Tode,Gwsgestartet,Intro,Tankwartjobskills,Language,Objekt1704,Objekt1705,Objekt1708,Objekt1711,Objekt1720,Objekt1723,Objekt1726,Objekt1727,Objekt1728,Objekt1729,Objekt1739,Objekt1825,Objekt1896,Objekt1998,Objekt2096,Objekt2205,Objekt2313,Objekt1518,Objekt1752,Objekt1786,Objekt16377,Objekt638,Objekt970,Objekt17037,Dimension,Serial,Objekt2526,Objekt2514,Objekt2527,Objekt2524,Geldtransporter,Versicherung) VALUES ('"..getPlayerName(source).."','"..verschluesseln.."','"..startgeld.."','0','0','0','0','0','0','0','0','0','0','0','0','0','100','0','0','0','0','0','0','0','0','0','0','0','0','0','0','26','0','0','0','0','0','0','0','Dorfbewohner','"..spawnx.."','"..spawny.."','"..spawnz.."','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','"..language.."','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','"..getPlayerSerial(source).."','0','0','0','0','0','0')")

			if(language=='0')then infobox_func(source,'Du hast dich registriert, logge dich nun ein.',0,255,0)end
			if(language=='1')then infobox_func(source,'You´ve registered. Now you can log in.',0,255,0)end
		else
			if(language=='0')then infobox_func(source,'Multi Accounts sind nicht erlaubt!',255,0,0)end
			if(language=='1')then infobox_func(source,'Multi Accounts are not allowed!',255,0,0)end
		end
	else
		if(language=='0')then infobox_func(source,'Dieser Name ist bereits vergeben!',255,0,0)end
		if(language=='1')then infobox_func(source,'This name is already taken!',255,0,0)end
	end
end
addEvent('redfieldRegistrieren',true)
addEventHandler('redfieldRegistrieren',root,selfmadeRegistrieren)

function selfmadeEinloggen(name,passwort)
	local query=dbQuery(dbConnection,'SELECT * FROM bans WHERE Username = ?',name)
	local result,num_rows=dbPoll(query,-1)
	
	if(num_rows==0)then
		local verschluesseln=md5(passwort)
		local datenbank=dbQuery(dbConnection,"SELECT * FROM userdata WHERE Username = '"..name.."' AND Passwort = '"..verschluesseln.."'")
		local result,num_rows=dbPoll(datenbank,-1)
		
		if(num_rows==1)then
			local pname=getPlayerName(source)
		
			setElementData(source,'Money',tonumber(result[1]['Money']))
			setElementData(source,'Autoschein',tonumber(result[1]['Autoschein']))
			setElementData(source,'Motorradschein',tonumber(result[1]['Motorradschein']))
			setElementData(source,'Lkwschein',tonumber(result[1]['Lkwschein']))
			setElementData(source,'Helikopterschein',tonumber(result[1]['Helikopterschein']))
			setElementData(source,'Flugschein',tonumber(result[1]['Flugschein']))
			setElementData(source,'Bootschein',tonumber(result[1]['Bootschein']))
			setElementData(source,'Personalausweis',tonumber(result[1]['Personalausweis']))
			setElementData(source,'Arbeitsgenehmigung',tonumber(result[1]['Arbeitsgenehmigung']))
			setElementData(source,'Bankpin',tonumber(result[1]['Bankpin']))
			setElementData(source,'Bankmoney',tonumber(result[1]['Bankmoney']))
			setElementData(source,'Level',tonumber(result[1]['Level']))
			setElementData(source,'Erfahrungspunkte',tonumber(result[1]['Erfahrungspunkte']))
			setElementData(source,'Spielzeit',tonumber(result[1]['Spielzeit']))
			setElementData(source,'Hunger',tonumber(result[1]['Hunger']))
			setElementData(source,'Adminrang',tonumber(result[1]['Adminrang']))
			setElementData(source,'Fraktion',tonumber(result[1]['Fraktion']))
			setElementData(source,'Fraktionrang',tonumber(result[1]['Fraktionrang']))
			setElementData(source,'Mats',tonumber(result[1]['Mats']))
			setElementData(source,'Drogen',tonumber(result[1]['Drogen']))
			setElementData(source,'Matstransporter',tonumber(result[1]['Matstransporter']))
			setElementData(source,'Drogentransporter',tonumber(result[1]['Drogentransporter']))
			setElementData(source,'Jobgehalt',tonumber(result[1]['Jobgehalt']))
			setElementData(source,'Wanteds',tonumber(result[1]['Wanteds']))
			setElementData(source,'Stvo',tonumber(result[1]['Stvo']))
			setElementData(source,'Job',result[1]['Job'])
			setElementData(source,'Flugjobskills',tonumber(result[1]['Flugjobskills']))
			setElementData(source,'Prisontime',tonumber(result[1]['Prisontime']))
			setElementData(source,'Knastzeit',tonumber(result[1]['Knastzeit']))
			setElementData(source,'Skin',tonumber(result[1]['Skin']))
			setElementData(source,'Waffenschein',tonumber(result[1]['Waffenschein']))
			setElementData(source,'Motel',tonumber(result[1]['Motel']))
			setElementData(source,'Mute',tonumber(result[1]['Mute']))
			setElementData(source,'Handy',tonumber(result[1]['Handy']))
			setElementData(source,'Telefonnummer',tonumber(result[1]['Telefonnummer']))
			setElementData(source,'Infobox',tonumber(result[1]['Infobox']))
			setElementData(source,'Pizzajobskills',tonumber(result[1]['Pizzajobskills']))
			setElementData(source,'Status',result[1]['Status'])
			setElementData(source,'SpawnX',tonumber(result[1]['SpawnX']))
			setElementData(source,'SpawnY',tonumber(result[1]['SpawnY']))
			setElementData(source,'SpawnZ',tonumber(result[1]['SpawnZ']))
			setElementData(source,'Housekey',tonumber(result[1]['Housekey']))
			setElementData(source,'Holzjobskillpunkte',tonumber(result[1]['Holzjobskillpunkte']))
			setElementData(source,'Eichenholz',tonumber(result[1]['Eichenholz']))
			setElementData(source,'Birkenholz',tonumber(result[1]['Birkenholz']))
			setElementData(source,'Interior',tonumber(result[1]['Interior']))
			setElementData(source,'AchUmgezogen',tonumber(result[1]['AchUmgezogen']))
			setElementData(source,'AchFahrzeug',tonumber(result[1]['AchFahrzeug']))
			setElementData(source,'Ach1Million',tonumber(result[1]['Ach1Million']))
			setElementData(source,'AchKonto',tonumber(result[1]['AchKonto']))
			setElementData(source,'AchGestorben',tonumber(result[1]['AchGestorben']))
			setElementData(source,'AchCarlicence',tonumber(result[1]['AchCarlicence']))	
			setElementData(source,'AchFraktion',tonumber(result[1]['AchFraktion']))
			setElementData(source,'AchLevel5',tonumber(result[1]['AchLevel5']))
			setElementData(source,'AchBonusshopbuy',tonumber(result[1]['AchBonusshopbuy']))
			setElementData(source,'Ach25TausendEXP',tonumber(result[1]['Ach25TausendEXP']))
			setElementData(source,'AchMiniMission',tonumber(result[1]['AchMiniMission']))
			setElementData(source,'AchPayday',tonumber(result[1]['AchPayday']))
			setElementData(source,'Ach5Hours',tonumber(result[1]['Ach5Hours']))
			setElementData(source,'AchHouse',tonumber(result[1]['AchHouse']))
			setElementData(source,'AchSpawn',tonumber(result[1]['AchSpawn']))
			setElementData(source,'AchHolz',tonumber(result[1]['AchHolz']))
			setElementData(source,'ImHaus',tonumber(result[1]['ImHaus']))
			setElementData(source,'Kills',tonumber(result[1]['Kills']))
			setElementData(source,'Tode',tonumber(result[1]['Tode']))
			setElementData(source,'Gwsgestartet',tonumber(result[1]['Gwsgestartet']))
			setElementData(source,'Intro',tonumber(result[1]['Intro']))
			setElementData(source,'Tankwartjobskills',tonumber(result[1]['Tankwartjobskills']))
			setElementData(source,'Language',tonumber(result[1]['Language']))
			setElementData(source,'Objekt1704',tonumber(result[1]['Objekt1704'])) 
			setElementData(source,'Objekt1705',tonumber(result[1]['Objekt1705']))
			setElementData(source,'Objekt1708',tonumber(result[1]['Objekt1708']))
			setElementData(source,'Objekt1711',tonumber(result[1]['Objekt1711']))
			setElementData(source,'Objekt1720',tonumber(result[1]['Objekt1720']))
			setElementData(source,'Objekt1723',tonumber(result[1]['Objekt1723']))
			setElementData(source,'Objekt1726',tonumber(result[1]['Objekt1726']))
			setElementData(source,'Objekt1727',tonumber(result[1]['Objekt1727']))
			setElementData(source,'Objekt1728',tonumber(result[1]['Objekt1728']))
			setElementData(source,'Objekt1729',tonumber(result[1]['Objekt1729']))
			setElementData(source,'Objekt1739',tonumber(result[1]['Objekt1739']))
			setElementData(source,'Objekt1825',tonumber(result[1]['Objekt1825']))
			setElementData(source,'Objekt1896',tonumber(result[1]['Objekt1896']))
			setElementData(source,'Objekt1998',tonumber(result[1]['Objekt1998']))
			setElementData(source,'Objekt2096',tonumber(result[1]['Objekt2096']))
			setElementData(source,'Objekt2205',tonumber(result[1]['Objekt2205']))
			setElementData(source,'Objekt2313',tonumber(result[1]['Objekt2313']))
			setElementData(source,'Objekt1518',tonumber(result[1]['Objekt1518']))
			setElementData(source,'Objekt1752',tonumber(result[1]['Objekt1752']))
			setElementData(source,'Objekt1786',tonumber(result[1]['Objekt1786']))
			setElementData(source,'Objekt16377',tonumber(result[1]['Objekt16377']))
			setElementData(source,'Objekt638',tonumber(result[1]['Objekt638']))
			setElementData(source,'Objekt970',tonumber(result[1]['Objekt970']))
			setElementData(source,'Objekt17037',tonumber(result[1]['Objekt17037']))
			setElementData(source,'Dimension',tonumber(result[1]['Dimension']))
			setElementData(source,'Objekt2526',tonumber(result[1]['Objekt2526']))
			setElementData(source,'Objekt2514',tonumber(result[1]['Objekt2514']))
			setElementData(source,'Objekt2527',tonumber(result[1]['Objekt2527']))
			setElementData(source,'Objekt2524',tonumber(result[1]['Objekt2524']))
			setElementData(source,'Geldtransporter',tonumber(result[1]['Geldtransporter']))
			setElementData(source,'Versicherung',tonumber(result[1]['Versicherung']))
			
			setPedStat(source,69,1000)
			setPedStat(source,70,1000)
			setPedStat(source,71,1000)
			setPedStat(source,72,1000)
			setPedStat(source,73,1000)
			setPedStat(source,74,1000)
			setPedStat(source,75,1000)
			setPedStat(source,76,1000)
			setPedStat(source,77,1000)
			setPedStat(source,78,1000)
			setPedStat(source,79,1000)
			
			if(getElementData(source,"Fraktion")==1)then
				copxyz(player)
			end
			
			if(getElementData(source,'Intro')==0)then
				setElementModel(source,26)
				triggerClientEvent(source,'startintro_func',source)
			else
				local x=getElementData(source,'SpawnX')
				local y=getElementData(source,'SpawnY')
				local z=getElementData(source,'SpawnZ')
				local interior=getElementData(source,'Interior')
				local dimension=getElementData(source,'Dimension')
				
				spawnPlayer(source,x,y,z)
				setElementInterior(source,interior)
				setElementDimension(source,dimension)
				setElementFrozen(source,false)
				setPlayerWantedLevel(source,getElementData(source,'Wanteds'))
				setElementModel(source,getElementData(source,'Skin'))
				setPlayerMoney(source,getElementData(source,'Money'))
				
				if(getElementData(source,'Prisontime')>0)or(getElementData(source,'Knastzeit')>0)then
					inDenKnast(source)
				else
					if(getElementData(source,'Motel')==1)then
						motelSpawn(source)
						setElementDimension(source,0)
					elseif(getElementData(source,'ImHaus')==1)then
						local HOUSE=dbQuery(dbConnection,"SELECT * FROM houses WHERE Besitzer = '"..getPlayerName(source).."'")
						local DATA=dbPoll(HOUSE,-1)
			
						setElementData(source,'outHouseX',DATA[1]['x'])
						setElementData(source,'outHouseY',DATA[1]['y'])
						setElementData(source,'outHouseZ',DATA[1]['z'])
						setElementData(source,'isPlayerInHouse',true)
						setElementData(source,'Firstinhouse',true)
						setElementData(source,'isPlayerInHouseID',DATA[1]['ID'])
						
						getChatBox(player,17)
					end
				end
			end
			setElementData(source,'loggedin',1)
			setTimer(spielerTimer,60000,1,source)
			setElementData(source,'handystate','on')
			triggerClientEvent(source,'destroyAnmeldung',source)
			
			bindKey(source,"enter","down",function(player)
				if(getDistanceBetweenPoints3D(-174.19999694824,1134.3000488281,5.5,getElementPosition(player))<3.5)then
					triggerClientEvent(player,"bankverwaltungWindow",player)
				elseif(getDistanceBetweenPoints3D(2217.3000488281,-1145.3000488281,1026,getElementPosition(player))<3.5)then
					triggerClientEvent(player,"motelWindow",player)
				elseif(getDistanceBetweenPoints3D(251.19999694824,68.5,1003.5999755859,getElementPosition(player))<3.5)then
					triggerClientEvent(player,"openWaffenschein",player)
				elseif(getDistanceBetweenPoints3D(-212.60000610352,1119.3000488281,6,getElementPosition(player))<3.5)then
					triggerClientEvent(player,"openLizenzenWindow",player)
				elseif(getDistanceBetweenPoints3D(2123,-1823.0999755859,13.60000038147,getElementPosition(player))<3.5)then
					triggerClientEvent(player,"openJobWindow",player,"pizza")
				elseif(getDistanceBetweenPoints3D(638.90002441406,1683.5,7.1999998092651,getElementPosition(player))<3.5)then
					triggerClientEvent(player,"openJobWindow",player,"tankwart")
				elseif(getDistanceBetweenPoints3D(-1421.0999755859,-287,14.10000038147,getElementPosition(player))<3.5)then
					triggerClientEvent(player,"openJobWindow",player,"pilot")
				elseif(getDistanceBetweenPoints3D(-538.29998779297,-78.199996948242,62.900001525879,getElementPosition(player))<3.5)then
					triggerClientEvent(player,"openJobWindow",player,"holzfaeller")
				elseif(getDistanceBetweenPoints3D(-2015.5,-2395.6999511719,30.60000038147,getElementPosition(player))<3.5)then
					triggerClientEvent(player,"holzWindow",player)
				elseif(getDistanceBetweenPoints3D(-207.63023376465,1114.8167724609,5.1393160820007,getElementPosition(player))<3.5)then
					triggerClientEvent(player,"jobcenterWindow",player)
				elseif(getDistanceBetweenPoints3D(12.60000038147,1225.5,19.299999237061,getElementPosition(player))<3.5)then
					triggerClientEvent(player,"openJobWindow",player,"busfahrer")
				elseif(getDistanceBetweenPoints3D(-1061.4000244141,-1195.5999755859,129.80000305176,getElementPosition(player))<3.5)then
					triggerClientEvent(player,"openJobWindow",player,"farmer")
				elseif(getDistanceBetweenPoints3D(2010.1999511719,-1915,-88.599998474121,getElementPosition(player))<3.5)then
					triggerClientEvent(player,"versicherungWindow",player)
				end
			end)
		else
			if(getElementData(source,'german') == true)then
				infobox_func(source,'Das Passwort ist nicht korrekt!',255,0,0)
			else
				infobox_func(source,'Your password is not correct!',255,0,0)
			end
		end
	else
		if(getElementData(source,'german') == true)then
			infobox_func(source,'Du bist gebannt!',255,0,0)
		else
			infobox_func(source,'You are banned!',255,0,0)
		end
	end
end
addEvent('redfieldEinloggen',true)
addEventHandler('redfieldEinloggen',root,selfmadeEinloggen)

setFPSLimit(60)