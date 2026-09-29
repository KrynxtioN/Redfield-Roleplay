local houses = {}
local housesblips = {}
local allowHouseEnter = {}

local function isValidHouse(house)
	return isElement(house) and getElementData(house,"house") == true
end

local function isPlayerNearHouse(player,house,distance)
	if not isElement(player) or not isValidHouse(house) then return false end
	if getElementInterior(player) ~= 0 or getElementDimension(player) ~= 0 then return false end
	local x,y,z = getElementPosition(player)
	local hx,hy,hz = getElementPosition(house)
	return getDistanceBetweenPoints3D(x,y,z,hx,hy,hz) <= (distance or 3)
end

local function updateHousePickup(house)
	if not isValidHouse(house) then return end
	local owner = getElementData(house,"Besitzer")
	if owner == "none" then
		setPickupType(house,3,1273,50)
	else
		setPickupType(house,3,1272,50)
	end
end

function getInterior(int)
	int = tonumber(int)
	if not int or not houseInteriors or not houseInteriors["int"] then return nil end
	return houseInteriors["int"][int],houseInteriors["x"][int],houseInteriors["y"][int],houseInteriors["z"][int]
end

function createHouses()
	local houseDatenbank = dbPoll(dbQuery(dbConnection,"SELECT * FROM houses"),-1)
	if not houseDatenbank then
		return
	end
	for _,v in ipairs(houseDatenbank) do
		local id = tonumber(v["ID"])
		local x,y,z = tonumber(v["x"]),tonumber(v["y"]),tonumber(v["z"])
		local intX,intY,intZ = tonumber(v["INTX"]),tonumber(v["INTY"]),tonumber(v["INTZ"])
		local interior = tonumber(v["Interior"])
		local preis = tonumber(v["Preis"]) or 0
		local owner = tostring(v["Besitzer"] or "none")
		local locked = tostring(v["Locked"] or "0")
		if id and x and y and z and intX and intY and intZ and interior then
			local pickupID = owner == "none" and 1273 or 1272
			local r,g,b = 255,0,0
			if owner == "none" then r,g,b = 0,255,0 end
			local pickup = createPickup(x,y,z,3,pickupID,50)
			houses[id] = pickup
			housesblips[id] = blip
			setElementData(pickup,"house",true)
			setElementData(pickup,"HouseInt",interior)
			setElementData(pickup,"HouseX",intX)
			setElementData(pickup,"HouseY",intY)
			setElementData(pickup,"HouseZ",intZ)
			setElementData(pickup,"outHouseX",x)
			setElementData(pickup,"outHouseY",y)
			setElementData(pickup,"outHouseZ",z)
			setElementData(pickup,"Besitzer",owner)
			setElementData(pickup,"Preis",preis)
			setElementData(pickup,"ID",id)
			setElementData(pickup,"Locked",locked)
			
			addEventHandler("onPickupHit",pickup,function(player)
				if(getElementDimension(player) == getElementDimension(source))then
					setElementData(player,"setHouse",source)
					local owner = getElementData(source,"Besitzer")
					if owner == "none" then
						infobox_func(player,getText(player,"House6"):format(tonumber(getElementData(source,"Preis")) or 0),0,255,0)
					elseif owner == getPlayerName(player) then
						infobox_func(player,getText(player,"House7"),0,255,0)
					end
				end
			end)
		end
	end
end

function enterHouse(player)
	if getElementData(player,"loggedin") ~= 1 then return end
	local haus = getElementData(player,"setHouse")
	if not isPlayerNearHouse(player,haus,3) then return end
	local owner = getElementData(haus,"Besitzer")
	local locked = tostring(getElementData(haus,"Locked") or "0")
	if locked == "1" and owner ~= getPlayerName(player) then
		infobox_func(player,getText(player,"House8"),255,0,0)
		return
	end
	local x = tonumber(getElementData(haus,"HouseX"))
	local y = tonumber(getElementData(haus,"HouseY"))
	local z = tonumber(getElementData(haus,"HouseZ"))
	local int = tonumber(getElementData(haus,"HouseInt"))
	local dim = tonumber(getElementData(haus,"ID"))
	if not x or not y or not z or not int or not dim then return end
	local outX,outY,outZ = getElementPosition(haus)
	setElementData(player,"outHouseX",outX)
	setElementData(player,"outHouseY",outY)
	setElementData(player,"outHouseZ",outZ)
	setElementData(player,"isPlayerInHouse",true)
	setElementData(player,"isPlayerInHouseID",haus)
	setElementInterior(player,int,x,y,z)
	setElementDimension(player,dim)
	setElementPosition(player,x,y,z)
end
addCommandHandler("in",enterHouse)

function leaveHouse(player)
	if getElementData(player,"isPlayerInHouse") ~= true then return end
	local haus = getElementData(player,"isPlayerInHouseID")
	local x,y,z
	if isValidHouse(haus) then
		x = tonumber(getElementData(haus,"outHouseX"))
		y = tonumber(getElementData(haus,"outHouseY"))
		z = tonumber(getElementData(haus,"outHouseZ"))
	else
		x = tonumber(getElementData(player,"outHouseX"))
		y = tonumber(getElementData(player,"outHouseY"))
		z = tonumber(getElementData(player,"outHouseZ"))
	end
	if not x or not y or not z then return end
	setElementInterior(player,0)
	setElementDimension(player,0)
	setElementPosition(player,x,y,z)
	setElementData(player,"isPlayerInHouse",false)
	setElementData(player,"isPlayerInHouseID",false)
end
addCommandHandler("out",leaveHouse)

function sellHouse(player)
	if getElementData(player,"loggedin") ~= 1 then return end
	if tonumber(getElementData(player,"Housekey")) ~= 1 then
		infobox_func(player,getText(player,"House9"),255,0,0)
		return
	end
	local haus = getElementData(player,"setHouse")
	if not isPlayerNearHouse(player,haus,3) then return end
	if getElementData(haus,"Besitzer") ~= getPlayerName(player) then
		infobox_func(player,getText(player,"House10"),255,0,0)
		return
	end
	local money = tonumber(getElementData(haus,"Preis")) or 0
	local currentMoney = tonumber(getElementData(player,"Money")) or 0
	local id = tonumber(getElementData(haus,"ID"))
	if not id then return end
	if not dbExec(dbConnection,"UPDATE houses SET Besitzer = ?, Locked = ? WHERE ID = ?","none","0",id) then return end
	setElementData(haus,"Besitzer","none")
	setElementData(haus,"Locked","0")
	setElementData(player,"Housekey",0)
	setElementData(player,"Money",currentMoney+money)
	updateHousePickup(haus)
	infobox_func(player,getText(player,"House11"):format(money),0,255,0)
end
addCommandHandler("sellhouse",sellHouse)

function lockHouse(player)
	if getElementData(player,"loggedin") ~= 1 then return end
	local haus = getElementData(player,"setHouse")
	if not isPlayerNearHouse(player,haus,3) then return end
	if getElementData(haus,"Besitzer") ~= getPlayerName(player) then
		infobox_func(player,getText(player,"House10"),255,0,0)
		return
	end
	local id = tonumber(getElementData(haus,"ID"))
	if not id then return end
	local status = tostring(getElementData(haus,"Locked") or "0")
	if status == "1" then
		if dbExec(dbConnection,"UPDATE houses SET Locked = ? WHERE ID = ?","0",id) then
			setElementData(haus,"Locked","0")
			infobox_func(player,getText(player,"House12"),0,255,0)
		end
	else
		if dbExec(dbConnection,"UPDATE houses SET Locked = ? WHERE ID = ?","1",id) then
			setElementData(haus,"Locked","1")
			infobox_func(player,getText(player,"House13"),0,255,0)
		end
	end
end
addCommandHandler("hlock",lockHouse)

function buyHouse(player)
	if getElementData(player,"loggedin") ~= 1 then return end
	local haus = getElementData(player,"setHouse")
	if not isPlayerNearHouse(player,haus,3) then return end
	if getElementData(haus,"Besitzer") ~= "none" then
		infobox_func(player,getText(player,"House14"),255,0,0)
		return
	end
	if tonumber(getElementData(player,"Housekey")) == 1 then
		infobox_func(player,getText(player,"House15"),255,0,0)
		return
	end
	local preis = tonumber(getElementData(haus,"Preis")) or 0
	local money = tonumber(getElementData(player,"Money")) or 0
	if preis <= 0 then return end
	if money < preis then
		infobox_func(player,getText(player,"House16"):format(preis-money),255,0,0)
		return
	end
	local id = tonumber(getElementData(haus,"ID"))
	if not id then return end
	local playerName = getPlayerName(player)
	if not dbExec(dbConnection,"UPDATE houses SET Besitzer = ?, Locked = ? WHERE ID = ?",playerName,"1",id) then return end
	setElementData(player,"Money",money-preis)
	setElementData(player,"Housekey",1)
	setElementData(haus,"Besitzer",playerName)
	setElementData(haus,"Locked","1")
	if tonumber(getElementData(player,"AchHouse")) == 0 then
		setElementData(player,"AchHouse",1)
		achievementInfo(player)
	end
	updateHousePickup(haus)
	updateEventkasse("einzahlen",preis)
	infobox_func(player,getText(player,"House17"):format(preis),0,255,0)
end
addCommandHandler("buyhouse",buyHouse)

function createNewHouse(player,cmd,int,preis)
	if getElementData(player,"loggedin") ~= 1 then return end
	if (tonumber(getElementData(player,"Adminrang")) or 0) < 4 then
		infobox_func(player,getText(player,"House18"),255,0,0)
		return
	end
	int = tonumber(int)
	preis = tonumber(preis)
	if not int or int < 1 or int > 32 or not preis or preis <= 0 then
		infobox_func(player,getText(player,"House19"),255,0,0)
		return
	end
	preis = math.floor(preis)
	local interior,x,y,z = getInterior(int)
	if not interior or not x or not y or not z then
		infobox_func(player,getText(player,"House19"),255,0,0)
		return
	end
	local result = dbPoll(dbQuery(dbConnection,"SELECT MAX(ID) AS maxID FROM houses"),-1)
	local id = ((result and result[1] and tonumber(result[1].maxID)) or 0)+1
	local x1,y1,z1 = getElementPosition(player)
	if not dbExec(dbConnection,"INSERT INTO houses (ID,Preis,Besitzer,Interior,Locked,x,y,z,INTX,INTY,INTZ) VALUES (?,?,?,?,?,?,?,?,?,?,?)",id,preis,"none",interior,"0",x1,y1,z1,x,y,z) then
		return
	end
	local pickup = createPickup(x1,y1,z1,3,1273,50)
	houses[id] = pickup
	housesblips[id] = blip
	setElementData(pickup,"house",true)
	setElementData(pickup,"HouseInt",interior)
	setElementData(pickup,"HouseX",x)
	setElementData(pickup,"HouseY",y)
	setElementData(pickup,"HouseZ",z)
	setElementData(pickup,"outHouseX",x1)
	setElementData(pickup,"outHouseY",y1)
	setElementData(pickup,"outHouseZ",z1)
	setElementData(pickup,"Besitzer","none")
	setElementData(pickup,"Preis",preis)
	setElementData(pickup,"ID",id)
	setElementData(pickup,"Locked","0")
	addEventHandler("onPickupHit",pickup,onHousePickupHit)
	infobox_func(player,getText(player,"House20"):format(id),0,255,0)
end
addCommandHandler("createhouse",createNewHouse)

function SpawnImHaus()
	local player = client
	if not player or not isElement(player) then return end
	if getElementData(player,"loggedin") ~= 1 then return end
	local data = dbPoll(dbQuery(dbConnection,"SELECT ID, Interior, INTX, INTY, INTZ FROM houses WHERE Besitzer = ? LIMIT 1",getPlayerName(player)),-1)
	if not data or not data[1] then
		infobox_func(player,getText(player,"House21"),255,0,0)
		return
	end
	setElementData(player,"SpawnX",tonumber(data[1]["INTX"]))
	setElementData(player,"SpawnY",tonumber(data[1]["INTY"]))
	setElementData(player,"SpawnZ",tonumber(data[1]["INTZ"]))
	setElementData(player,"Interior",tonumber(data[1]["Interior"]))
	setElementData(player,"Dimension",tonumber(data[1]["ID"]))
	setElementData(player,"ImHaus",1)
	infobox_func(player,getText(player,"House22"),0,255,0)
	if tonumber(getElementData(player,"AchSpawn")) == 0 then
		setElementData(player,"AchSpawn",1)
		achievementInfo(player)
	end
end
addEvent("SpawnImHaus",true)
addEventHandler("SpawnImHaus",root,SpawnImHaus)

function house_heilen()
	local player = client
	if not player or not isElement(player) then return end
	if getElementData(player,"loggedin") ~= 1 then return end
	if getElementData(player,"isPlayerInHouse") ~= true then return end
	local haus = getElementData(player,"isPlayerInHouseID")
	if not isValidHouse(haus) or getElementDimension(player) ~= tonumber(getElementData(haus,"ID")) then return end
	setElementHealth(player,100)
	infobox_func(player,getText(player,"House23"),0,255,0)
end
addEvent("house_heilen",true)
addEventHandler("house_heilen",root,house_heilen)

function house_eat()
	local player = client
	if not player or not isElement(player) then return end
	if getElementData(player,"loggedin") ~= 1 then return end
	if getElementData(player,"isPlayerInHouse") ~= true then return end
	local haus = getElementData(player,"isPlayerInHouseID")
	if not isValidHouse(haus) or getElementDimension(player) ~= tonumber(getElementData(haus,"ID")) then return end
	setElementData(player,"Hunger",100)
	infobox_func(player,getText(player,"House24"),0,255,0)
end
addEvent("house_eat",true)
addEventHandler("house_eat",root,house_eat)

addEventHandler("onPlayerQuit",root,function()
	allowHouseEnter[source] = nil
end)

createHouses()