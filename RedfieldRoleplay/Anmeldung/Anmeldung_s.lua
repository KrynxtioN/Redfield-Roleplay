local startgeld = 5000
local spawnx = -187.65440368652
local spawny = 1210.7149658203
local spawnz = 19.705902099609

function selfmadeRegistrieren(name,passwort,language)
	local player = client
	language = tonumber(language) or 1
	setElementData(player,"Language",language)

	local datenbank = dbQuery(dbConnection,"SELECT * FROM userdata WHERE Username = ?",name)
	local result,num_rows = dbPoll(datenbank,-1)

	if(num_rows == 0)then
		local serial = dbQuery(dbConnection,"SELECT * FROM userdata WHERE Serial = ?",getPlayerSerial(player))
		local result,num_rows = dbPoll(serial,-1)

		if(num_rows == 0)then
			passwordHash(passwort,"bcrypt",{},function(verschluesseln)
				if(not(isElement(player)))then return end

				local pname = getPlayerName(player)
				
				dbExec(dbConnection,"INSERT INTO userdata (Username,Passwort,Money,Autoschein,Motorradschein,Lkwschein,Helikopterschein,Flugschein,Bootschein,Personalausweis,Arbeitsgenehmigung,Bankpin,Bankmoney,Level,Erfahrungspunkte,Spielzeit,Hunger,Adminrang,Fraktion,Fraktionrang,Mats,Drogen,Matstransporter,Drogentransporter,Jobgehalt,Wanteds,Stvo,Job,Flugjobskills,Knastzeit,Prisontime,Skin,Waffenschein,Motel,Mute,Handy,Telefonnummer,Infobox,Pizzajobskills,Status,SpawnX,SpawnY,SpawnZ,Holzjobskillpunkte,Eichenholz,Birkenholz,Interior,AchUmgezogen,AchFahrzeug,Ach1Million,AchKonto,AchGestorben,AchCarlicence,AchFraktion,AchLevel5,AchBonusshopbuy,Ach25TausendEXP,AchMiniMission,AchPayday,Ach5Hours,AchHouse,Kills,Tode,Gwsgestartet,Intro,Tankwartjobskills,Language,Objekt1704,Objekt1705,Objekt1708,Objekt1711,Objekt1720,Objekt1723,Objekt1726,Objekt1727,Objekt1728,Objekt1729,Objekt1739,Objekt1825,Objekt1896,Objekt1998,Objekt2096,Objekt2205,Objekt2313,Objekt1518,Objekt1752,Objekt1786,Objekt16377,Objekt638,Objekt970,Objekt17037,Dimension,Serial,Objekt2526,Objekt2514,Objekt2527,Objekt2524,Geldtransporter,Versicherung) VALUES ('"..getPlayerName(player).."','"..verschluesseln.."','"..startgeld.."','0','0','0','0','0','0','0','0','0','0','0','0','0','100','0','0','0','0','0','0','0','0','0','0','0','0','0','0','26','0','0','0','0','0','0','0','Redfield User','"..spawnx.."','"..spawny.."','"..spawnz.."','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','"..language.."','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','"..getPlayerSerial(player).."','0','0','0','0','0','0')")
				
				infobox_func(player,getText(player,"Anmeldung1"),0,255,0)
			end)
		else
			infobox_func(player,getText(player,"Anmeldung2"):format(result[1]["Username"]),255,0,0)
		end
	else
		infobox_func(player,getText(player,"Anmeldung3"),255,0,0)
	end
end
addEvent('redfieldRegistrieren',true)
addEventHandler('redfieldRegistrieren',root,selfmadeRegistrieren)

function selfmadeEinloggen(name,passwort)
	local player = client
	local query = dbQuery(dbConnection,'SELECT * FROM bans WHERE Username = ?',name)
	local result,num_rows = dbPoll(query,-1)

	if(num_rows == 0)then
		local datenbank = dbQuery(dbConnection,'SELECT * FROM userdata WHERE Username = ?',name)
		local result,num_rows = dbPoll(datenbank,-1)

		if(num_rows == 1)then
			passwordVerify(passwort,result[1]['Passwort'],{},function(passwortKorrekt)
				if(not(isElement(player)))then return end

				if(passwortKorrekt)then
					local pname = getPlayerName(player)
					
					for _,v in pairs(Player_Data)do
						setElementData(player,v,tonumber(result[1][v]))
					end
					
					setElementData(player,"Language",tonumber(result[1]["Language"]) or 1)

					for i = 69,79 do setPedStat(player,i,1000) end

					if(getElementData(player,"Fraktion")==1)then
						copxyz(player)
					end

					if(getElementData(player,'Intro')==0)then
						setElementModel(player,26)
						triggerClientEvent(player,'startintro_func',player)
					else
						local x = getElementData(player,'SpawnX')
						local y = getElementData(player,'SpawnY')
						local z = getElementData(player,'SpawnZ')
						local interior = getElementData(player,'Interior')
						local dimension = getElementData(player,'Dimension')

						spawnPlayer(player,x,y,z)
						setElementInterior(player,interior)
						setElementDimension(player,dimension)
						setElementFrozen(player,false)
						setElementModel(player,getElementData(player,'Skin'))

						if(getElementData(player,'Prisontime')>0)or(getElementData(player,'Knastzeit')>0)then
							inDenKnast(player)
						else
							if(getElementData(player,'Motel') == 1)then
								motelSpawn(player)
								setElementDimension(player,0)
							elseif(getElementData(player,'ImHaus') == 1)then
								local HOUSE = dbQuery(dbConnection,"SELECT * FROM houses WHERE Besitzer = ?",getPlayerName(player))
								local DATA = dbPoll(HOUSE,-1)

								setElementData(player,'outHouseX',DATA[1]['x'])
								setElementData(player,'outHouseY',DATA[1]['y'])
								setElementData(player,'outHouseZ',DATA[1]['z'])
								setElementData(player,'isPlayerInHouse',true)
								setElementData(player,'Firstinhouse',true)
								setElementData(player,'isPlayerInHouseID',DATA[1]['ID'])

								infobox_func(player,getText(player,"Haus25"),0,255,0)
							end
						end
					end

					setElementData(player,'loggedin',1)
					setTimer(spielerTimer,60000,1,player)
					setElementData(player,'handystate','on')
					triggerClientEvent(player,'destroyAnmeldung',player)

					bindKey(player,"enter","down",function(player)
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
					infobox_func(player,getText(player,"Anmeldung4"),255,0,0)
				end
			end)
		else
			infobox_func(player,getText(player,"Anmeldung4"),255,0,0)
		end
	else
		infobox_func(player,getText(player,"Anmeldung5"),255,0,0)
	end
end
addEvent('redfieldEinloggen',true)
addEventHandler('redfieldEinloggen',root,selfmadeEinloggen)