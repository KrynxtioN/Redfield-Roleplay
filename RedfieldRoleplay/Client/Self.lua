local self = {button = {},window = {},label = {},gridlist={}}

local fraktionNames = {
[0] = 'Zivilist',
[1] = 'Police',
[2] = 'Yakuza',
[3] = 'Biker',
[4] = 'Reporter',
[5] = 'Ballas',
[6] = 'Surenos',
}

function self_func()
	if(getElementData(localPlayer,'redfieldClick') == false and not inTutorial == true)then
		if(not(isElement(self.window[1])))then
			showCursor(true)
			setElementData(localPlayer,'redfieldClick',true)
		
			self.window[1] = guiCreateStaticImage(0.31, 0.32, 0.40, 0.37, 'Images/Background.png', true)

			self.button[1] = guiCreateButton(0.02, 0.08, 0.38, 0.10, 'Spieler Informationen', true, self.window[1])
			guiSetProperty(self.button[1], 'NormalTextColour', 'FFAAAAAA')
			self.button[2] = guiCreateButton(0.02, 0.21, 0.38, 0.10, 'Fraktion Informationen', true, self.window[1])
			guiSetProperty(self.button[2], 'NormalTextColour', 'FFAAAAAA')
			self.button[3] = guiCreateButton(0.42, 0.08, 0.38, 0.10, 'Lizenzen', true, self.window[1])
			guiSetProperty(self.button[3], 'NormalTextColour', 'FFAAAAAA')
			self.button[4] = guiCreateButton(0.42, 0.21, 0.38, 0.10, 'Achievments', true, self.window[1])
			guiSetProperty(self.button[4], 'NormalTextColour', 'FFAAAAAA')
			self.button[5] = guiCreateButton(0.83, 0.21, 0.12, 0.10, 'Schließen', true, self.window[1])
			guiSetProperty(self.button[5], 'NormalTextColour', 'FFAAAAAA')
			self.label[1] = guiCreateLabel(0.02, 0.34, 0.38, 0.61, 'Klicke auf den gewünschten Button, um dir Informationen anzeigen zu lassen.', true, self.window[1])
			guiSetFont(self.label[1], 'default-bold-small')
			guiLabelSetHorizontalAlign(self.label[1], 'center', true)
			self.label[2] = guiCreateLabel(0.42, 0.34, 0.57, 0.61, '', true, self.window[1])
			guiSetFont(self.label[2], 'default-bold-small')
			guiLabelSetHorizontalAlign(self.label[2], 'center', true)

			self.window[2] = guiCreateStaticImage(0.17, 0.32, 0.14, 0.37, 'images/background.png', true)

			self.gridlist[1] = guiCreateGridList(0.05, 0.08, 0.90, 0.77, true, self.window[2])
			guiGridListAddColumn(self.gridlist[1], 'Spawn', 0.9)
			for i = 1, 7 do
				guiGridListAddRow(self.gridlist[1])
			end
			guiGridListSetItemText(self.gridlist[1], 0, 1, 'Noobspawn', false, false)
			if(getElementData(localPlayer,'Housekey') == 1)then
				if(getElementData(localPlayer,'Language') == 0)then
					guiGridListSetItemText(self.gridlist[1], 1, 1, 'Haus', false, false)
				else
					guiGridListSetItemText(self.gridlist[1], 1, 1, 'House', false, false)
				end
			end
			if(getElementData(localPlayer,'Fraktion') == 1)then
				guiGridListSetItemText(self.gridlist[1],2,1,'Police Department',false,false)
			end
			if(getElementData(localPlayer,'Fraktion') == 2)then
				guiGridListSetItemText(self.gridlist[1],3,1,'Yakuza Base',false,false)
			end
			if(getElementData(localPlayer,'Fraktion') == 3)then
				guiGridListSetItemText(self.gridlist[1],3,1,'Biker Base',false,false)
			end
			if(getElementData(localPlayer,'Fraktion') == 4)then
				guiGridListSetItemText(self.gridlist[1],4,1,'Reporter Base',false,false)
			end
			if(getElementData(localPlayer,'Fraktion') == 5)then
				guiGridListSetItemText(self.gridlist[1],5,1,'Ballas Base',false,false)
			end
			if(getElementData(localPlayer,'Fraktion') == 6)then
				guiGridListSetItemText(self.gridlist[1],6,1,'Surenos Base',false,false)
			end
			
			self.button[6] = guiCreateButton(0.05, 0.87, 0.90, 0.10, 'Spawn setzen', true, self.window[2])
			guiSetProperty(self.button[6], 'NormalTextColour', 'FFAAAAAA')
			
			if(getElementData(localPlayer,'Language') == 1)then
				guiSetText(self.label[1],'Click on the desired button to display the information.')
				guiSetText(self.button[1],'Player Information')
				guiSetText(self.button[2],'Faction Information')
				guiSetText(self.button[3],'Licenses')
				guiSetText(self.button[5],'Close')
				guiSetText(self.button[6],'Change Spawn')
			end
			
			addEventHandler('onClientGUIClick',self.button[6],function()
				selectedText=guiGridListGetItemText(self.gridlist[1],guiGridListGetSelectedItem(self.gridlist[1]),1)
				
				if(selectedText == 'Noobspawn')then
					triggerServerEvent('changeSpawn',localPlayer,-204.96250915527,1212.2875976563,19.7421875,0)
				elseif(selectedText == 'Haus' or selectedText == 'House')then
					triggerServerEvent('SpawnImHaus',localPlayer,localPlayer)
				elseif(selectedText == 'Police Department')then
					triggerServerEvent('changeSpawn',localPlayer,251.93380737305,70.434516906738,1003.640625,6)
				elseif(selectedText == 'Yakuza Base')then
					triggerServerEvent('changeSpawn',localPlayer,-2160.41796875,638.86529541016,1057.5860595703,1)
				elseif(selectedText == 'Biker Base')then
					triggerServerEvent('changeSpawn',localPlayer,-226.13352966309,1410.9614257813,27.7734375,18)
				elseif(selectedText == 'Reporter Base')then
					triggerServerEvent('changeSpawn',localPlayer,-2022.2545166016,-114.60018157959,1035.171875,3)
				elseif(selectedText == 'Ballas Base')then
					triggerServerEvent('changeSpawn',localPlayer,963.08654785156,2102.0639648438,1011.02734375,1)
				elseif(selectedText == 'Surenos Base')then
					triggerServerEvent('changeSpawn',localPlayer,325.65753173828,1124.7043457031,1083.8828125,5)
				end
			end,false)
			
			addEventHandler('onClientGUIClick',self.button[1],function()
				local name = getPlayerName(localPlayer)
				local playtime = getElementData(localPlayer,'Spielzeit')
				local playtimehours = math.floor(playtime/60)
				local playtimeminutes = playtime - playtimehours*60
				if(playtimeminutes < 10)then
					playtimeminutes = '0'..playtimeminutes
				end
				local playtime = playtimehours..':'..playtimeminutes
				local telenr = getElementData(localPlayer,'Telefonnummer')
				if(telenr == 0)then
					if(getElementData(localPlayer,'Language') == 0)then
						telenr = 'Kein Handy'
					else
						telenr = 'No phone'
					end
				end
				local money = getPlayerMoney(localPlayer)
				local bankmoney = getElementData(localPlayer,'Bankmoney')
				local fraki = getElementData(localPlayer,'Fraktion')
				
				local fraki = fraktionNames[fraki]

				local rang = getElementData(localPlayer,'Fraktionrang')
				local adminlvl = getElementData(localPlayer,'Adminrang')
				local kills = getElementData(localPlayer,'Kills')
				local tode = getElementData(localPlayer,'Tode')
			
				if(getElementData(localPlayer,'Language') == 0)then
					guiSetText(self.label[1],'Name: '..name..'\n\nSpielzeit: '..playtime..'\n\nTelefonnummer: '..telenr..'\n\nGeld auf der Hand: '..money..'$\n\nGeld auf der Bank: '..bankmoney..'$\n\nFraktion: '..fraki..'\n\nRang: '..rang..'\n\nAdminlevel: '..adminlvl)
					guiSetText(self.label[2],'Kills: '..kills..'\n\nTode: '..tode)
				else
					guiSetText(self.label[1],'Name: '..name..'\n\nPlaytime: '..playtime..'\n\nPhone number: '..telenr..'\n\nMoney: '..money..'$\n\nBankmoney: '..bankmoney..'$\n\nFaction: '..fraki..'\n\nRang: '..rang..'\n\nAdminlevel: '..adminlvl)
					guiSetText(self.label[2],'Kills: '..kills..'\n\nDeaths: '..tode)
				end
			end,false)
			
			addEventHandler('onClientGUIClick',self.button[2],function()
				local matstrucks = getElementData(localPlayer,'Matstransporter')
				local drogentrucks = getElementData(localPlayer,'Drogentransporter')
				local gangwars = getElementData(localPlayer,'Gwsgestartet')
				local geldtrucks=getElementData(localPlayer,"Geldtransporter")
				
				if(getElementData(localPlayer,'Language') == 0)then
					guiSetText(self.label[1],'Matstransporter abgegeben: '..matstrucks..'\n\nDrogentransporter abgegeben: '..drogentrucks..'\n\nGangwars gestartet: '..gangwars..'\n\nGeldtransporter abgegeben: '..geldtrucks)
					guiSetText(self.label[2],'')
				else
					guiSetText(self.label[1],'Finish Matstransporter: '..matstrucks..'\n\nFinish Drugtransporter: '..drogentrucks..'\n\nStart Gangwars: '..gangwars..'\n\nFinish Moneytrucks: '..geldtrucks)
					guiSetText(self.label[2],'')
				end
			end,false)
			
			addEventHandler('onClientGUIClick',self.button[3],function()
				local carlicense = getElementData(localPlayer,'Autoschein')
				local bikelicense = getElementData(localPlayer,'Motorradschein')
				local lkwlicense = getElementData(localPlayer,'Lkwschein')
				local helischein = getElementData(localPlayer,'Helischein')
				local flugschein = getElementData(localPlayer,'Flugschein')
				local bootschein = getElementData(localPlayer,'Bootschein')
				local perso = getElementData(localPlayer,'Personalausweis')
				local arbeitsgenehmigung = getElementData(localPlayer,'Arbeitsgenehmigung')
				local gunlicense = getElementData(localPlayer,'Waffenschein')
				
				if(carlicense == 0)then carlicense = '[_]' else carlicense = '[X]' end
				if(bikelicense == 0)then bikelicense = '[_]' else bikelicense = '[X]' end
				if(lkwlicense == 0)then lkwlicense = '[_]' else lkwlicense = '[X]' end
				if(helischein == 0)then helischein = '[_]' else helischein = '[X]' end
				if(flugschein == 0)then flugschein = '[_]' else flugschein = '[X]' end
				if(bootschein == 0)then bootschein = '[_]' else bootschein = '[X]' end
				if(perso == 0)then perso='[_]' else perso = '[X]' end
				if(arbeitsgenehmigung == 0)then arbeitsgenehmigung = '[_]' else arbeitsgenehmigung = '[X]' end
				if(gunlicense == 0)then gunlicense = '[_]' else gunlicense = '[X]' end
				
				if(getElementData(localPlayer,'Language')==0)then
					guiSetText(self.label[1],'Führerschein: '..carlicense..'\n\nMotorradschein: '..bikelicense..'\n\nLkwschein: '..lkwlicense..'\n\nHelischein: '..helischein..'\n\nFlugschein: '..flugschein..'\n\nBootschein: '..bootschein..'\n\nPersonalausweis: '..perso..'\n\nArbeitsgenehmigung: '..arbeitsgenehmigung)
					guiSetText(self.label[2],'Waffenschein: '..gunlicense)
				else
					guiSetText(self.label[1],'Driver´s License: '..carlicense..'\n\nBike-License: '..bikelicense..'\n\nTruck-License: '..lkwlicense..'\n\nHelicopter-License: '..helischein..'\n\nAirplane-License: '..flugschein..'\n\nBoat-License: '..bootschein..'\n\nIdentity-Card: '..perso..'\n\nWork-License: '..arbeitsgenehmigung)
					guiSetText(self.label[2],'Gunlicense: '..gunlicense)
				end
			end,false)
			
			addEventHandler('onClientGUIClick',self.button[4],function()
				local AchUmgezogen = getElementData(localPlayer,'AchUmgezogen')
				local AchFahrzeug = getElementData(localPlayer,'AchFahrzeug')
				local Ach1Million = getElementData(localPlayer,'Ach1Million')
				local AchKonto = getElementData(localPlayer,'AchKonto')
				local AchGestorben = getElementData(localPlayer,'AchGestorben')
				local AchCarlicence = getElementData(localPlayer,'AchCarlicence')
				local AchFraktion = getElementData(localPlayer,'AchFraktion')
				local AchLevel5 = getElementData(localPlayer,'AchLevel5')
				local AchBonusshopbuy = getElementData(localPlayer,'AchBonusshopbuy')
				local Ach25TausendEXP = getElementData(localPlayer,'Ach25TausendEXP')
				local AchMiniMission = getElementData(localPlayer,'AchMiniMission')
				local AchPayday = getElementData(localPlayer,'AchPayday')
				local Ach50Hours = getElementData(localPlayer,'Ach5Hours')
				local AchHouse = getElementData(localPlayer,'AchHouse')
				local AchSpawn = getElementData(localPlayer,'AchSpawn')
				local AchHolz = getElementData(localPlayer,'AchHolz')
				
				if(AchUmgezogen == 0)then ach1 = '[_]' else ach1 = '[X]' end
				if(AchFahrzeug == 0)then ach2 = '[_]' else ach2 = '[X]' end
				if(Ach1Million == 0)then ach3 = '[_]' else ach3 = '[X]' end
				if(AchKonto == 0)then ach4 = '[_]' else ach4 = '[X]' end
				if(AchGestorben == 0)then ach5 = '[_]' else ach5 = '[X]' end
				if(AchCarlicence == 0)then ach6 = '[_]' else ach6 = '[X]' end
				if(AchFraktion == 0)then ach7 = '[_]' else ach7 = '[X]' end
				if(AchLevel5 == 0)then ach8 = '[_]' else ach8 = '[X]' end
				if(AchBonusshopbuy == 0)then ach9 = '[_]' else ach9 = '[X]' end
				if(Ach25TausendEXP == 0)then ach10 = '[_]' else ach10 ='[X]' end
				if(AchMiniMission == 0)then ach11 = '[_]' else ach11 = '[X]' end
				if(AchPayday == 0)then ach12 = '[_]' else ach12 = '[X]' end
				if(Ach50Hours == 0)then ach13 = '[_]' else ach13 = '[X]' end
				if(AchHouse == 0)then ach14 = '[_]' else ach14 = '[X]' end
				if(AchSpawn == 0)then ach15 = '[_]' else ach15 = '[X]' end
				if(AchHolz == 0)then ach16 = '[_]' else ach16 = '[X]' end
				
				if(getElementData(localPlayer,'Language')==0)then
					guiSetText(self.label[1],'Neue Klamotten: '..ach1..'\n\nDas erste Fahrzeug: '..ach2..'\n\nDie erste Million: '..ach3..'\n\nEin Konto erstellt: '..ach4..'\n\nGestorben: '..ach5..'\n\nFührerschein erhalten: '..ach6..'\n\nEiner Fraktion beigetreten: '..ach7..'\n\nLevel 5 erreicht: '..ach8)
					guiSetText(self.label[2],'Den Bonusshop benutzt: '..ach9..'\n\n25.000 EXP auf einmal: '..ach10..'\n\nEine Mini-Mission erledigt: '..ach11..'\n\nErster Payday: '..ach12..'\n\n50 Spielstunden erreicht: '..ach13..'\n\nErstes Eigenheim: '..ach14..'\n\nSpawnpunkt geändert: '..ach15..'\n\nHolz verkauft: '..ach16)
				else
					guiSetText(self.label[1],'New Clothes: '..ach1..'\n\nFirst Vehicle: '..ach2..'\n\nFirst Million $$: '..ach3..'\n\nCreate a Bank-Account: '..ach4..'\n\nDie: '..ach5..'\n\nGet a Carlicense: '..ach6..'\n\nJoin a faction: '..ach7..'\n\nReach level 5: '..ach8)
					guiSetText(self.label[2],'Use the Bonusshop: '..ach9..'\n\nCollect 25.000 EXP: '..ach10..'\n\nFinish a Mini Mission: '..ach11..'\n\nFirst Payday: '..ach12..'\n\nReach 50 hours: '..ach13..'\n\nBuy a house: '..ach14..'\n\nChange your spawn: '..ach15..'\n\nSell wood: '..ach16)
				end
			end,false)
			
			addEventHandler('onClientGUIClick',self.button[5],function()
				showCursor(false)
				destroyElement(self.window[1])
				destroyElement(self.window[2])
				setElementData(localPlayer,'redfieldClick',false)
			end,false)
		end
	end
end
addCommandHandler('self',self_func)