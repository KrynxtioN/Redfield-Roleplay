local objectPrices = {
	[1704] = 500, [1705] = 500, [1708] = 600, [1711] = 650, [1720] = 700, [1723] = 800, [1726] = 900,
	[1727] = 400, [1728] = 900, [1729] = 500, [1739] = 200, [1825] = 1000, [1896] = 1200, [1998] = 800,
	[2096] = 500, [2205] = 800, [2313] = 750, [1518] = 1400, [1752] = 1600, [1786] = 1800, [16377] = 900,
	[2526] = 3000, [2514] = 1200, [2527] = 2000, [2524] = 1000, [638] = 600, [970] = 700, [17037] = 2000
}

local outdoorObjects = {
	[638] = true,
	[970] = true,
	[17037] = true
}

function createAllObjects()
	local result = dbPoll(dbQuery(dbConnection, "SELECT * FROM objekte"), -1)
	if not result then
		return
	end

	for _, object in ipairs(result) do
		local model = tonumber(object["Model"])
		local x = tonumber(object["Positionx"])
		local y = tonumber(object["Positiony"])
		local z = tonumber(object["Positionz"])
		local rotation = tonumber(object["Rotation"]) or 0
		local interior = tonumber(object["Interior"]) or 0
		local dimension = tonumber(object["Dimension"]) or 0

		if objectPrices[model] and x and y and z then
			local element = createObject(model, x, y, z, 0, 0, rotation)
			if isElement(element) then
				setElementInterior(element, interior)
				setElementDimension(element, dimension)
			end
		end
	end
end

addEvent("createNewObjectPlace", true)
addEventHandler("createNewObjectPlace", root, function(id, x, y, z, rx, ry, rz, interior, dimension)
	local player = client
	if not player or not isElement(player) then return end
	if getElementData(player, "loggedin") ~= 1 then return end

	id = tonumber(id)
	x, y, z = tonumber(x), tonumber(y), tonumber(z)
	rx, ry, rz = tonumber(rx), tonumber(ry), tonumber(rz)
	interior, dimension = tonumber(interior), tonumber(dimension)

	if not id or not objectPrices[id] or not x or not y or not z or not rx or not ry or not rz or not interior or not dimension then return end

	local takeObject = "Objekt" .. id
	local amount = tonumber(getElementData(player, takeObject)) or 0

	if amount < 1 then
		infobox_func(player, getText(player, "Furniture1"), 255, 0, 0)
		return
	end

	if interior ~= getElementInterior(player) or dimension ~= getElementDimension(player) then return end

	local px, py, pz = getElementPosition(player)
	if getDistanceBetweenPoints3D(px, py, pz, x, y, z) > 25 then
		infobox_func(player, getText(player, "Furniture2"), 255, 0, 0)
		return
	end

	if outdoorObjects[id] then
		if interior ~= 0 then
			infobox_func(player, getText(player, "Furniture3"), 255, 0, 0)
			return
		end
	else
		if getElementData(player, "isPlayerInHouse") ~= true then
			infobox_func(player, getText(player, "Furniture4"), 255, 0, 0)
			return
		end

		local house = getElementData(player, "isPlayerInHouseID")
		if not isElement(house) or dimension ~= tonumber(getElementData(house, "ID")) then return end
	end

	local newObject = createObject(id, x, y, z, rx, ry, rz)
	if not isElement(newObject) then return end

	setElementInterior(newObject, interior)
	setElementDimension(newObject, dimension)

	if not dbExec(dbConnection, "INSERT INTO objekte (Model,Positionx,Positiony,Positionz,Rotation,Besitzer,Interior,Dimension) VALUES (?,?,?,?,?,?,?,?)", id, x, y, z, rz, getPlayerName(player), interior, dimension) then
		destroyElement(newObject)
		return
	end

	setElementData(player, takeObject, amount - 1)
	infobox_func(player, getText(player, "Furniture5"), 0, 255, 0)
end)

addEvent("buyObject", true)
addEventHandler("buyObject", root, function(object)
	local player = client
	if not player or not isElement(player) then return end
	if getElementData(player, "loggedin") ~= 1 then return end

	object = tonumber(object)
	local price = objectPrices[object]
	if not price then return end

	local money = tonumber(getElementData(player, "Money")) or 0
	if money < price then
		infobox_func(player, getText(player, "Furniture6"):format(price - money), 255, 0, 0)
		return
	end

	local buyObject = "Objekt" .. object
	local amount = tonumber(getElementData(player, buyObject)) or 0

	setElementData(player, "Money", money - price)
	setElementData(player, buyObject, amount + 1)
	updateEventkasse("einzahlen", price)
	infobox_func(player, getText(player, "Furniture7"):format(price), 0, 255, 0)
end)

addEvent("createnewobject", true)
addEventHandler("createnewobject", root, function(id)
	local player = client
	if not player or not isElement(player) then return end
	if getElementData(player, "loggedin") ~= 1 then return end

	id = tonumber(id)
	if not id or not objectPrices[id] then return end

	if (tonumber(getElementData(player, "Objekt" .. id)) or 0) < 1 then
		infobox_func(player, getText(player, "Furniture1"), 255, 0, 0)
		return
	end

	if outdoorObjects[id] then
		if getElementInterior(player) ~= 0 then
			infobox_func(player, getText(player, "Furniture3"), 255, 0, 0)
			return
		end
	else
		if getElementData(player, "isPlayerInHouse") ~= true then
			infobox_func(player, getText(player, "Furniture4"), 255, 0, 0)
			return
		end
	end

	triggerClientEvent(player, "createobject", player, id)
end)

createAllObjects()