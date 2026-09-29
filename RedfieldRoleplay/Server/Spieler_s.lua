function spielerTimer(player)
	if not isElement(player) then return end

	if getElementData(player,"loggedin") == 1 then
		local spielzeit = (tonumber(getElementData(player,"Spielzeit")) or 0)+1
		local hunger = tonumber(getElementData(player,"Hunger")) or 0

		setElementData(player,"Spielzeit",spielzeit)

		if hunger > 0 then
			hunger = hunger-1
			setElementData(player,"Hunger",hunger)
		end

		if hunger > 0 and hunger < 5 then
			infobox_func(player,getText(player,"Spieler1"),255,0,0)
		end

		if hunger <= 0 and not isPedDead(player) then
			setElementData(player,"Hunger",0)
			infobox_func(player,getText(player,"Spieler2"),255,0,0)
			killPed(player)
		end

		local prisontime = tonumber(getElementData(player,"Prisontime")) or 0
		if prisontime > 0 then
			prisontime = prisontime-1
			setElementData(player,"Prisontime",prisontime)

			if prisontime == 0 then
				ausDemKnast(player)
			end
		end

		local knastzeit = tonumber(getElementData(player,"Knastzeit")) or 0
		if knastzeit > 0 then
			knastzeit = knastzeit-1
			setElementData(player,"Knastzeit",knastzeit)

			if knastzeit == 0 then
				ausDemKnast(player)
			end
		end

		if spielzeit%60 == 0 then
			if tonumber(getElementData(player,"Ach25TausendEXP")) == 0 then
				setElementData(player,"Ach25TausendEXP",1)
				achievementInfo(player)
			end

			if tonumber(getElementData(player,"AchPayday")) == 0 then
				setElementData(player,"AchPayday",1)
				achievementInfo(player)
			end

			if spielzeit >= 3000 and tonumber(getElementData(player,"Ach5Hours")) == 0 then
				setElementData(player,"Ach5Hours",1)
				achievementInfo(player)
			end

			local bankmoney = tonumber(getElementData(player,"Bankmoney")) or 0

			if tonumber(getElementData(player,"Ach1Million")) == 0 and bankmoney >= 1000000 then
				setElementData(player,"Ach1Million",1)
				achievementInfo(player)
			end

			local jobgehalt = tonumber(getElementData(player,"Jobgehalt")) or 0
			local plusCash = jobgehalt
			local minusCash = 0

			if tonumber(getElementData(player,"Motel")) == 1 then
				minusCash = minusCash+630
			end

			if tonumber(getElementData(player,"Versicherung")) == 1 then
				minusCash = minusCash+750
			end

			setElementData(player,"paydayPlusCash",plusCash)
			setElementData(player,"paydayMinusCash",minusCash)

			outputChatBox("..:: Payday ::..",player,255,255,255)
			outputChatBox("______________________________",player,255,255,255)
			outputChatBox(getText(player,"Spieler3"):format(jobgehalt),player,0,150,0)

			if tonumber(getElementData(player,"Motel")) == 1 then
				outputChatBox(getText(player,"Spieler4"),player,150,0,0)
			end

			if tonumber(getElementData(player,"Versicherung")) == 1 then
				outputChatBox(getText(player,"Spieler5"),player,150,0,0)
			end

			outputChatBox("______________________________",player,255,255,255)
			outputChatBox("+ "..plusCash.."$ / - "..minusCash.."$",player,150,150,0)
			outputChatBox(getText(player,"Spieler6"),player,0,150,0)

			setElementData(player,"Bankmoney",bankmoney+plusCash-minusCash)
		end
	end

	if isElement(player) then
		setTimer(spielerTimer,60000,1,player)
	end
end

function adFunktion(player,cmd,...)
	if getElementData(player,"loggedin") ~= 1 then return end

	local text = table.concat({...}," ")
	if text == "" then
		infobox_func(player,getText(player,"Spieler9"),255,0,0)
		return
	end

	if #text > 70 then
		infobox_func(player,getText(player,"Spieler7"),255,0,0)
		return
	end

	local costs = #text*2

	if tonumber(getElementData(player,"Money")) < costs then
		infobox_func(player,getText(player,"Spieler8"):format(costs),255,0,0)
		return
	end

	takePlayerMoney(player,costs)

	for _,target in ipairs(getElementsByType("player")) do
		outputChatBox(getText(target,"Spieler10"):format(getPlayerName(player),text),target,0,150,0)
	end
end
addCommandHandler("ad",adFunktion)
addCommandHandler("werbung",adFunktion)

function krankenhausServer(ammo,killer,weapon,part)
	local player = source

	if tonumber(getElementData(player,"AchGestorben")) == 0 then
		setElementData(player,"AchGestorben",1)
		achievementInfo(player)
	end

	if getElementData(player,"PilotJobAktiv") == true then
		local veh = getPedOccupiedVehicle(player)

		if isElement(veh) then
			destroyElement(veh)
		end

		triggerClientEvent(player,"stopPilotJob",player)
		setElementData(player,"PilotJobAktiv",nil)
	end

	if getElementData(player,"inholzjob") == true then
		setElementData(player,"inholzjob",false)
		triggerClientEvent(player,"destroyHolz",player)
	end

	if getElementData(player,"TankwartAktiv") == true then
		setElementData(player,"TankwartAktiv",false)
		triggerClientEvent(player,"destroyTankShit",player)
	end

	if isElement(killer) and getElementType(killer) == "player" and killer ~= player then
		local kills = tonumber(getElementData(killer,"Kills")) or 0
		setElementData(killer,"Kills",kills+1)
	end

	if part == 9 then
		setPedHeadless(player,true)
	end

	local tode = tonumber(getElementData(player,"Tode")) or 0
	setElementData(player,"Tode",tode+1)

	local bankmoney = tonumber(getElementData(player,"Bankmoney")) or 0

	if tonumber(getElementData(player,"Versicherung")) ~= 1 then
		infobox_func(player,getText(player,"Spieler11"),255,0,0)
		setElementData(player,"Bankmoney",bankmoney-2300)
	else
		infobox_func(player,getText(player,"Spieler12"),0,255,0)
	end

	if isElement(killer) and getElementType(killer) == "player" and killer ~= player then
		if isCop(killer) and getElementData(killer,"copDuty") == true then
			local wanted = getPlayerWantedLevel(player)

			if wanted > 0 then
				giveErfahrungspunkte(killer,50)
				setElementData(player,"Knastzeit",wanted*4)
				inDenKnast(player)
			end
		end
	end

	triggerClientEvent(player,"hospitalWindow",player)
end
addEventHandler("onPlayerWasted",root,krankenhausServer)

function afterHospitalSpawn()
	local player = client
	if not player or not isElement(player) then return end

	spawnPlayer(player,-316.16384887695,1056.6286621094,19.7421875)
	setElementDimension(player,0)
	setElementInterior(player,0)
	setCameraTarget(player,player)

	if (tonumber(getElementData(player,"Hunger")) or 0) <= 0 then
		setElementData(player,"Hunger",5)
	end

	local skin = tonumber(getElementData(player,"Skin"))
	if skin then
		setElementModel(player,skin)
	end

	setPedHeadless(player,false)
end
addEvent("afterHospitalSpawn",true)
addEventHandler("afterHospitalSpawn",root,afterHospitalSpawn)

function infobox_func(player,text,r,g,b)
	if not isElement(player) then return end
	triggerClientEvent(player,"infobox",player,text,r,g,b)
end