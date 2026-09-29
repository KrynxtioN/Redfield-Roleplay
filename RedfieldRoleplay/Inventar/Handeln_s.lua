local tradeItems = {
	["mats"] = {data="Mats",name={[0]="Materialien",[1]="Mats"}},
	["materialien"] = {data="Mats",name={[0]="Materialien",[1]="Mats"}},
	["materials"] = {data="Mats",name={[0]="Materialien",[1]="Mats"}},
	["drogen"] = {data="Drogen",name={[0]="Drogen",[1]="Drugs"}},
	["drugs"] = {data="Drogen",name={[0]="Drogen",[1]="Drugs"}},
	["eichenholz"] = {data="Eichenholz",name={[0]="Eichenholz",[1]="Oak wood"}},
	["oak"] = {data="Eichenholz",name={[0]="Eichenholz",[1]="Oak wood"}},
	["oakwood"] = {data="Eichenholz",name={[0]="Eichenholz",[1]="Oak wood"}},
	["birkenholz"] = {data="Birkenholz",name={[0]="Birkenholz",[1]="Birch wood"}},
	["birch"] = {data="Birkenholz",name={[0]="Birkenholz",[1]="Birch wood"}},
	["birchwood"] = {data="Birkenholz",name={[0]="Birkenholz",[1]="Birch wood"}}
}

local function getTradeItemName(player,item)
	local language = tonumber(getElementData(player,"Language")) or 0
	return item.name[language] or item.name[0]
end

local function findTradePlayer(name)
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

function handeln(player,cmd,target,item,anzahl)
	if getElementData(player,"loggedin") ~= 1 then return end
	if not target or not item or not anzahl then
		infobox_func(player,getText(player,"Trade1"),255,255,255)
		return
	end
	local tplayer = findTradePlayer(target)
	if not tplayer or not isElement(tplayer) or getElementData(tplayer,"loggedin") ~= 1 then
		infobox_func(player,getText(player,"Trade2"),255,0,0)
		return
	end
	if tplayer == player then
		infobox_func(player,getText(player,"Trade3"),255,0,0)
		return
	end
	local px,py,pz = getElementPosition(player)
	local tx,ty,tz = getElementPosition(tplayer)
	if getElementInterior(player) ~= getElementInterior(tplayer) or getElementDimension(player) ~= getElementDimension(tplayer) or getDistanceBetweenPoints3D(px,py,pz,tx,ty,tz) > 5 then
		infobox_func(player,getText(player,"Trade4"),255,0,0)
		return
	end
	local tradeItem = tradeItems[item:lower()]
	if not tradeItem then
		infobox_func(player,getText(player,"Trade5"),255,0,0)
		return
	end
	local menge = tonumber(anzahl)
	if not menge or menge <= 0 or menge ~= math.floor(menge) or menge > 1000000 then
		infobox_func(player,getText(player,"Trade6"),255,0,0)
		return
	end
	local playerAmount = tonumber(getElementData(player,tradeItem.data)) or 0
	local targetAmount = tonumber(getElementData(tplayer,tradeItem.data)) or 0
	if playerAmount < menge then
		infobox_func(player,getText(player,"Trade7"):format(getTradeItemName(player,tradeItem)),255,0,0)
		return
	end
	setElementData(player,tradeItem.data,playerAmount-menge)
	setElementData(tplayer,tradeItem.data,targetAmount+menge)
	infobox_func(player,getText(player,"Trade8"):format(getPlayerName(tplayer),menge,getTradeItemName(player,tradeItem)),255,255,255)
	infobox_func(tplayer,getText(tplayer,"Trade9"):format(getPlayerName(player),menge,getTradeItemName(tplayer,tradeItem)),255,255,255)
end
addCommandHandler("trade",handeln)