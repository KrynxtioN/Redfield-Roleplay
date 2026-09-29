Player_Data = {"Money","Autoschein","Motorradschein","Lkwschein","Helikopterschein","Flugschein","Bootschein","Personalausweis","Arbeitsgenehmigung","Bankpin","Bankmoney","Level","Erfahrungspunkte","Spielzeit","Hunger","Adminrang","Fraktion","Fraktionrang","Mats","Drogen","Matstransporter","Drogentransporter","Jobgehalt","Wanteds","Stvo","Job","Flugjobskills","Knastzeit","Prisontime","Skin","Waffenschein","Motel","Mute","Handy","Telefonnummer","Infobox","Pizzajobskills","Status","SpawnX","SpawnY","SpawnZ","Housekey","Holzjobskillpunkte","Eichenholz","Birkenholz","Interior","AchUmgezogen","AchFahrzeug","Ach1Million","AchKonto","AchGestorben","AchCarlicence","AchFraktion","AchLevel5","AchBonusshopbuy","Ach25TausendEXP","AchMiniMission","AchPayday","Ach5Hours","AchHouse","AchSpawn","AchHolz","ImHaus","Kills","Tode","Gwsgestartet","Intro","Tankwartjobskills","Language","Objekt1704","Objekt1705","Objekt1708","Objekt1711","Objekt1720","Objekt1723","Objekt1726","Objekt1727","Objekt1728","Objekt1729","Objekt1739","Objekt1825","Objekt1896","Objekt1998","Objekt2096","Objekt2205","Objekt2313","Objekt1518","Objekt1752","Objekt1786","Objekt16377","Objekt638","Objekt970","Objekt17037","Dimension","Objekt2526","Objekt2514","Objekt2527","Objekt2524","Geldtransporter","Versicherung"}

dbConnection = dbConnect('mysql','dbname=redfieldroleplay;host=localhost','user','password')
if(dbConnection)then outputDebugString('DB-Connection: ✔') else outputDebugString('DB-Connection: ✘') end

function redfieldSaveData(player)
	if(getElementData(player,"loggedin") == 1)then
		for _,v in pairs(Player_Data)do
			dbExec(dbConnection,"UPDATE userdata SET '"..v.."' WHERE Username = ?;",getElementData(player,v),getPlayerName(player))
		end
	end
end
	
addEventHandler("onPlayerQuit",root,function() redfieldSaveData(source) end)