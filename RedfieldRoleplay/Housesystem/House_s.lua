local houses = {}
local housesblips = {}
local house = 0
local allowHouseEnter = {}

local houseDatenbank = dbPoll(dbQuery(dbConnection,"SELECT * FROM houses"),-1)

function createHouses()
	local IDS = #dbPoll(dbQuery(dbConnection,"SELECT ID FROM houses"),-1)
	outputDebugString(IDS..' house(s) load')
end
createHouses()

function getInterior(int)
	local int = tonumber(int)
	return houseInteriors['int'][int],houseInteriors['x'][int],
	houseInteriors['y'][int],houseInteriors['z'][int]
end
  
function leaveHouse(player)
	if(getElementData(player,'isPlayerInHouse') == true)then
		if(getElementData(player,'Firstinhouse') == true)then
			local x,y,z = getElementData(player,'outHouseX'),getElementData(player,'outHouseY'),getElementData(player,'outHouseZ')
			setElementPosition(player,x,y,z)
		else
			local house = getElementData(player,'setHouse')
			local x,y,z = getElementData(house,'outHouseX'),getElementData(house,'outHouseY'),getElementData(house,'outHouseZ')
			setElementPosition(player,x,y,z)
		end
		setElementInterior(player,0)
		setElementDimension(player,0)
		setElementData(player,'isPlayerInHouse',false)
	end
end
addCommandHandler('out',leaveHouse)

function onHousePickupHit(player)
	if(getElementData(source,'Besitzer') == 'none')then
		local Preis = getElementData(source,'Preis')
		if(isGerman(player))then
			infobox_func(player,'Tippe /buyhouse, um dieses Haus zu kaufen.\nPreis: '..Preis,0,255,0)
		end
		if(isEnglish(player))then
			infobox_func(player,'Use /buyhouse, to buy this House for '..Preis..'$.',0,255,0)
		end
	else
		if(getElementData(source,'Besitzer') == getPlayerName(player))then
			getChatBox(player,37)
		end
	end
	setElementData(player,'setHouse',source)
end

function enterHouse(player)
	allowHouseEnter[player] = false
	local haus = getElementData(player,'setHouse')
	if(getElementData(haus,'Locked') == '0')then
		if(getElementData(haus,'Besitzer') == getPlayerName(player))then
			allowHouseEnter[player] = true
		else allowHouseEnter[player] = false end
	else allowHouseEnter[player] = true end
	
	if(allowHouseEnter[player] == false)then return end
	
	local x,y,z = getElementPosition(player)
	local x1,y1,z1 = getElementPosition(getElementData(player,'setHouse'))
	
	if(getDistanceBetweenPoints3D(x,y,z,x1,y1,z1)>3)then return end
	
	local x,y,z,int,dim = getElementData(haus,'HouseX'),getElementData(haus,'HouseY'),
	getElementData(haus,'HouseZ'),getElementData(haus,'HouseInt'),getElementData(haus,'ID')
	setElementInterior(player,int,x,y,z)
	setElementPosition(player,x,y,z)
	setElementDimension(player,dim)
	
	setElementData(player,'isPlayerInHouse',true)
	setElementData(player,'isPlayerInHouseID',haus)
end
addCommandHandler('in',enterHouse)

for k,v in ipairs(houseDatenbank)do
	house = house+1
	
	if(v['Besitzer'] == 'none')then ID = 1273 r,g,b = 0,255,0 end
	if(v['Besitzer'] ~= 'none')then ID = 1272 r,g,b = 255,0,0 end
	
	houses[house] = createPickup(v['x'],v['y'],v['z'],3,ID,50)
	housesblips[house] = createBlip(v['x'],v['y'],v['z'],0,1,r,g,b,255,0,200,root)
	
	setElementData(houses[house],'house',true)
	setElementData(houses[house],'HouseInt',v['Interior'])
	setElementData(houses[house],'HouseX',v['INTX'])
	setElementData(houses[house],'HouseY',v['INTY'])
	setElementData(houses[house],'HouseZ',v['INTZ'])
	setElementData(houses[house],'outHouseX',v['x'])
	setElementData(houses[house],'outHouseY',v['y'])
	setElementData(houses[house],'outHouseZ',v['z'])
	setElementData(houses[house],'Besitzer',v['Besitzer'])
	setElementData(houses[house],'Preis',v['Preis'])
	setElementData(houses[house],'ID',tonumber(v['ID']))
	setElementData(houses[house],'Locked',v['Locked'])
	addEventHandler('onPickupHit',houses[house],onHousePickupHit)
end

function sellHouse(player)
	if(getElementData(player,'Housekey') == 1)then
		local house = getElementData(player,'setHouse')
		local x,y,z = getElementPosition(player)
		local x1,y1,z1 = getElementPosition(getElementData(player,'setHouse'))
		local money = getElementData(house,'Preis')
		
		if(getDistanceBetweenPoints3D(x,y,z,x1,y1,z1)>3)then return end
		
		if(getElementData(house,'Besitzer') == getPlayerName(player))then
			dbExec(dbConnection,"UPDATE `houses` SET Besitzer  =  'none' WHERE Besitzer  =  '"..getPlayerName(player).."'")
			setElementData(player,'Housekey',0)
			givePlayerMoney(player,money)
			getChatBox(player,38)
		end
	end
end
addCommandHandler('sellhouse',sellHouse)

function lockHouse(player)
	local house = getElementData(player,'setHouse')
	local x,y,z = getElementPosition(player)
	local x1,y1,z1 = getElementPosition(getElementData(player,'setHouse'))
	local status = getElementData(house,'Locked')
	
	if(getDistanceBetweenPoints3D(x,y,z,x1,y1,z1)>3)then return end
	
	if(getElementData(house,'Besitzer') == getPlayerName(player))then
		if(status == '0')then
			getChatBox(player,39)
			setElementData(house,'Locked','1')
			dbExec(dbConnection,"UPDATE `houses` SET Locked  =  '1' WHERE Besitzer  =  '"..getPlayerName(player).."'")
		else
			getChatBox(player,40)
			setElementData(house,'Locked','0')
			dbExec(dbConnection,"UPDATE `houses` SET Locked  =  '0' WHERE Besitzer  =  '"..getPlayerName(player).."'")
		end
	end
end
addCommandHandler('hlock',lockHouse)

function buyHouse(player)
	local house = getElementData(player,'setHouse')
	local x,y,z = getElementPosition(player)
	local x1,y1,z1 = getElementPosition(getElementData(player,'setHouse'))
	
	if(getDistanceBetweenPoints3D(x,y,z,x1,y1,z1)>3)then return end
	
	if(getElementData(house,'Besitzer') == 'none')then
		if(getPlayerMoney(player) >= tonumber(getElementData(house,'Preis')))then
			if(getElementData(player,'Housekey') == 0)then
				if(getElementData(player,'AchHouse') == 0)then
					setElementData(player,'AchHouse',1)
					achievmentInfo(player)
				end
				setElementData(house,'Besitzer',getPlayerName(player))
				takePlayerMoney(player,getElementData(house,'Preis'))
				getChatBox(player,41)
				dbExec(dbConnection,"UPDATE houses SET Besitzer = ? WHERE ID = ?",getPlayerName(player),getElementData(house,'ID'))
				setElementData(player,'Housekey',1)
				updateEventkasse("einzahlen",getElementData(house,"Preis"))
			else 
				getChatBox(player,42)
			end
		else
			getChatBox(player,33)
		end
	end
end
addCommandHandler('buyhouse',buyHouse)

function createNewHouse(player,cmd,int,Preis)
	if(getElementData(player,'loggedin') == 1)then
		if(getElementData(player,'Adminrang') >= 4)then
			if(int and Preis and tonumber(int) <= 32)then
				local int,x,y,z = getInterior(int)
				local ID = table.getn(dbPoll(dbQuery(dbConnection,"SELECT ID FROM houses"),-1))+1
				local x1,y1,z1 = getElementPosition(player)
				local result = dbPoll(dbQuery(dbConnection,"INSERT INTO houses VALUES(?,?,?,?,?,?,?,?,?,?,?)",ID,Preis,'none',int,false,x1,y1,z1,x,y,z),-1)
				getChatBox(player,44)
			else
				getChatBox(player,43)
			end
		else
			getChatBox(player,12)
		end
	end
end
addCommandHandler('createhouse',createNewHouse)

function SpawnImHaus(player)
	local HOUSE = dbQuery(dbConnection,"SELECT * FROM houses WHERE Besitzer  =  '"..getPlayerName(player).."'")
	local DATA = dbPoll(HOUSE,-1)
	
	setElementData(player,'SpawnX',DATA[1]['INTX'])
	setElementData(player,'SpawnY',DATA[1]['INTY'])
	setElementData(player,'SpawnZ',DATA[1]['INTZ'])
	setElementData(player,'Interior',DATA[1]['Interior'])
	setElementData(player,'Dimension',DATA[1]['ID'])
	setElementData(player,'ImHaus',1)
	getChatBox(player,45)
	
	if(getElementData(source,'AchSpawn') == 0)then
		setElementData(source,'AchSpawn',1)
		achievmentInfo(source)
	end
end
addEvent('SpawnImHaus',true)
addEventHandler('SpawnImHaus',root,SpawnImHaus)

function house_heilen(player)
	setElementHealth(player,100)
end
addEvent("house_heilen",true)
addEventHandler("house_heilen",root,house_heilen)

function house_eat(player)
	setElementData(player,"Hunger",100)
end
addEvent("house_eat",true)
addEventHandler("house_eat",root,house_eat)