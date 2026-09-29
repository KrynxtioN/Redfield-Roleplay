local MAX_LEVEL = 100

local function getRequiredEXP(level)
	level = tonumber(level) or 1
	return math.floor(500+(level^1.6)*350)
end

local function getLevelReward(level)
	level = tonumber(level) or 1
	return math.floor(1000+(math.sqrt(level)*500))
end

function isErfahrungspunkte(player,punkte)
	if not isElement(player) then return false end

	local exp = tonumber(getElementData(player,"Erfahrungspunkte")) or 0
	punkte = tonumber(punkte) or 0

	return exp >= punkte
end

function takeErfahrungspunkte(player,punkte)
	if not isElement(player) then return end

	local exp = tonumber(getElementData(player,"Erfahrungspunkte")) or 0
	punkte = tonumber(punkte) or 0

	if punkte <= 0 then return end

	setElementData(player,"Erfahrungspunkte",math.max(0,exp-punkte))
end

function giveErfahrungspunkte(player,punkte)
	if not isElement(player) or getElementType(player) ~= "player" then return end

	punkte = tonumber(punkte) or 0
	if punkte <= 0 then return end

	punkte = math.floor(punkte)

	local exp = tonumber(getElementData(player,"Erfahrungspunkte")) or 0
	local level = tonumber(getElementData(player,"Level")) or 1
	local bankmoney = tonumber(getElementData(player,"Bankmoney")) or 0

	exp = exp + punkte
	infobox_func(player,getText(player,"Level1"):format(punkte),0,100,200)

	while level < MAX_LEVEL do
		local requiredEXP = getRequiredEXP(level)
		if exp < requiredEXP then break end

		exp = exp - requiredEXP
		level = level + 1

		local money = getLevelReward(level)
		bankmoney = bankmoney + money

		setElementData(player,"Level",level)
		setElementData(player,"Bankmoney",bankmoney)

		infobox_func(player,getText(player,"Level4"):format(level,requiredEXP,money),0,255,0)
	end

	setElementData(player,"Erfahrungspunkte",exp)
end

function buyLevel_func(player)
	if getElementData(player,"loggedin") ~= 1 then return end

	local level = tonumber(getElementData(player,"Level")) or 1
	local exp = tonumber(getElementData(player,"Erfahrungspunkte")) or 0

	if level >= MAX_LEVEL then
		infobox_func(player,getText(player,"Level2"),255,0,0)
		return
	end

	local requiredEXP = getRequiredEXP(level)

	if exp < requiredEXP then
		infobox_func(player,getText(player,"Level3"):format(requiredEXP-exp),255,0,0)
		return
	end

	local newLevel = level+1
	local money = getLevelReward(newLevel)
	local bankmoney = tonumber(getElementData(player,"Bankmoney")) or 0

	takeErfahrungspunkte(player,requiredEXP)

	setElementData(player,"Level",newLevel)
	setElementData(player,"Bankmoney",bankmoney+money)

	infobox_func(player,getText(player,"Level4"):format(newLevel,requiredEXP,money),0,255,0)
end
addCommandHandler("buylevel",buyLevel_func)

function myLevel_func(player)
	if getElementData(player,"loggedin") ~= 1 then return end

	local level = tonumber(getElementData(player,"Level")) or 1

	infobox_func(player,getText(player,"Level5"):format(level),255,255,255)
end
addCommandHandler("mylevel",myLevel_func)

function myEXP_func(player)
	if getElementData(player,"loggedin") ~= 1 then return end

	local level = tonumber(getElementData(player,"Level")) or 1
	local exp = tonumber(getElementData(player,"Erfahrungspunkte")) or 0

	if level >= MAX_LEVEL then
		infobox_func(player,getText(player,"Level6"):format(exp),255,255,255)
		return
	end

	local requiredEXP = getRequiredEXP(level)

	infobox_func(player,getText(player,"Level7"):format(exp,requiredEXP),255,255,255)
end
addCommandHandler("myexp",myEXP_func)