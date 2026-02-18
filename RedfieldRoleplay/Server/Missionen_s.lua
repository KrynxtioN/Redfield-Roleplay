local missionsSpawns = {

{-78.170738220215,1234.474609375,19.7421875},
{-1.2284731864929,1394.7355957031,9.171875},
{490.08111572266,1531.3870849609,1},
{1053.5642089844,1485.1931152344,5.8203125},
{1001.2124633789,1067.5281982422,10.8203125},
{1464.2365722656,1025.7395019531,10.8203125},
{1825.6213378906,1277.1676025391,9.2134265899658},
{1853.8709716797,1809.7229003906,12.557171821594},
{1612.15234375,1978.1217041016,10.8203125},
{1345.47265625,1900.0837402344,10.8203125},
{930.44903564453,2177.9020996094,10.8203125},

}

local aktiveMission = false

function spawnMission()
	if(aktiveMission == false)then
		aktiveMission = true
		local spawnmarker = math.random(1,table.getn(missionsSpawns))
		missionpickup = createPickup(missionsSpawns[spawnmarker][1],missionsSpawns[spawnmarker][2],missionsSpawns[spawnmarker][3],3,1210,50)
		missionblip = createBlip(missionsSpawns[spawnmarker][1],missionsSpawns[spawnmarker][2],missionsSpawns[spawnmarker][3],19,0,0,0,0,0,0,200,root)
		
		local players = getElementsByType('player')
		for theKey,thePlayer in pairs(players)do
			if(isGerman(thePlayer))then
				outputChatBox('#808000INFO: #ffffff Eine Person in Schwarz hat einen Koffer fallen lassen (Rote Flagge auf der Karte)!',thePlayer,255,255,255,true)
			elseif(isEnglish(thePlayer))then
				outputChatBox('#808000INFO: #ffffff A man in black lost a suitcase (Red flag on the Map)!',thePlayer,255,255,255,true)
			end
		end
		
		addEventHandler('onPickupHit',missionpickup,function(player)
			local missionArt = math.random(1,3)
			
			if(missionArt == 1)then
				local mats = math.random(300,600)
				setElementData(player,'Mats',getElementData(player,'Mats')+mats)
				if(isGerman(player))then
					infobox_func(player,'Du hast '..mats..' Materialien gefunden.',0,255,0)
				end
				if(isEnglish(player))then
					infobox_func(player,'You find '..mats..' mats.',0,255,0)
				end
			elseif(missionArt == 2)then
				local drugs = math.random(300,600)
				setElementData(player,'Drogen',getElementData(player,'Drogen')+drugs)
				if(isGerman(player))then infobox_func(player,'Du hast '..drugs..'g Drogen gefunden.',0,255,0)end
				if(isEnglish(player))then infobox_func(player,'You find '..drugs..'g weed.',0,255,0)end
			elseif(missionArt == 3)then
				local money = math.random(2000,2500)
				givePlayerMoney(player,money)
				if(isGerman(player))then
					infobox_func(player,'Du hast '..money..'$ gefunden.',0,255,0)
				end
				if(isEnglish(player))then
					infobox_func(player,'You find '..money..'$.',0,255,0)
				end
			end
			if(getElementData(player,'AchMiniMission') == 0)then
				setElementData(player,'AchMiniMission',1)
				achievmentInfo(player)
			end
			destroyElement(missionpickup)
			destroyElement(missionblip)
			for theKey,thePlayer in pairs(players)do
				if(isGerman(thePlayer))then
					outputChatBox('#808000INFO: #ffffff '..getPlayerName(player)..' hat den Koffer eingesammelt!',thePlayer,255,255,255,true)
				elseif(isEnglish(thePlayer))then
					outputChatBox('#808000INFO: #ffffff '..getPlayerName(player)..' collect the suitcase!',thePlayer,255,255,255,true)
				end
			end
			aktiveMission = false
		end)
	end
	
	if(not(isTimer(spawnMissionTimer)))then
		spawnMissionTimer = setTimer(spawnMission,1800000,0)
	end
end
setTimer(spawnMission,1800000,1)