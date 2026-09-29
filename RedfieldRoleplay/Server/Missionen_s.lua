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
local missionpickup = nil
local missionblip = nil
local spawnMissionTimer = nil

function spawnMission()
	if aktiveMission then return end

	aktiveMission = true

	local spawn = missionsSpawns[math.random(1,#missionsSpawns)]
	missionpickup = createPickup(spawn[1],spawn[2],spawn[3],3,1210,50)
	missionblip = createBlip(spawn[1],spawn[2],spawn[3],19,0,0,0,0,0,0,200,root)

	for _,player in ipairs(getElementsByType("player")) do
		outputChatBox(getText(player,"MiniMission1"),player,255,255,255,true)
	end

	addEventHandler("onPickupHit",missionpickup,function(hitElement)
		if getElementType(hitElement) ~= "player" then return end
		if not aktiveMission then return end

		local player = hitElement
		aktiveMission = false

		if isElement(missionpickup) then
			destroyElement(missionpickup)
			missionpickup = nil
		end

		if isElement(missionblip) then
			destroyElement(missionblip)
			missionblip = nil
		end

		local missionArt = math.random(1,3)

		if missionArt == 1 then
			local mats = math.random(300,600)
			local currentMats = tonumber(getElementData(player,"Mats")) or 0

			setElementData(player,"Mats",currentMats+mats)
			infobox_func(player,getText(player,"MiniMission2"):format(mats),0,255,0)

		elseif missionArt == 2 then
			local drugs = math.random(300,600)
			local currentDrugs = tonumber(getElementData(player,"Drogen")) or 0

			setElementData(player,"Drogen",currentDrugs+drugs)
			infobox_func(player,getText(player,"MiniMission3"):format(drugs),0,255,0)

		elseif missionArt == 3 then
			local money = math.random(2000,2500)

			setElementData(player,"Money",getElementData(player,"Money")+money)
			infobox_func(player,getText(player,"MiniMission4"):format(money),0,255,0)
		end

		if tonumber(getElementData(player,"AchMiniMission")) == 0 then
			setElementData(player,"AchMiniMission",1)
			achievementInfo(player)
		end

		for _,target in ipairs(getElementsByType("player")) do
			outputChatBox(getText(target,"MiniMission5"):format(getPlayerName(player)),target,255,255,255,true)
		end
	end)
end

spawnMissionTimer = setTimer(spawnMission,1800000,0)