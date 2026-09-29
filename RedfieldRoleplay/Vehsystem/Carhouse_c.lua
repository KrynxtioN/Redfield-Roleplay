local sx, sy = guiGetScreenSize()
local scale = math.min(sx / 1920, sy / 1080)

local OttosCarsBuyPickup = createPickup(-1649.3000488281, 1209.1999511719, 6.4000000953674, 3, 1239, 50)
local WangCarsBuyPickup = createPickup(-1958.6409912109, 304.90640258789, 35.46875, 3, 1239, 50)
local FortCarsonPickup = createPickup(-262.55642700195, 1211.1387939453, 19.895177841187, 3, 1239, 50)
local FlughafenPickup = createPickup(1956.7330322266, -2183.6652832031, 13.546875, 3, 1239, 50)
local BoothausPickup = createPickup(-2245.2004394531, 2381.7453613281, 5.0761528015137, 3, 1239, 50)

function HitCarhousePickups(player)
	if player == localPlayer then
		infobox(getText("Autohaus4"), 0, 255, 0)
	end
end
addEventHandler("onClientPickupHit", OttosCarsBuyPickup, HitCarhousePickups)
addEventHandler("onClientPickupHit", WangCarsBuyPickup, HitCarhousePickups)
addEventHandler("onClientPickupHit", FortCarsonPickup, HitCarhousePickups)
addEventHandler("onClientPickupHit", FlughafenPickup, HitCarhousePickups)
addEventHandler("onClientPickupHit", BoothausPickup, HitCarhousePickups)

local fahrzeuge = {
	["Infernus"] = {55000, -1638.5999755859, 1211.4000244141, 7, 224, "Autoschein"},
	["Bullet"] = {45000, -1638.5999755859, 1211.4000244141, 7, 224, "Autoschein"},
	["Cheetah"] = {30000, -1638.5999755859, 1211.4000244141, 7, 224, "Autoschein"},
	["Banshee"] = {27500, -1638.5999755859, 1211.4000244141, 7, 224, "Autoschein"},
	["Comet"] = {40000, -1638.5999755859, 1211.4000244141, 7, 224, "Autoschein"},
	["ZR-350"] = {130000, -1638.5999755859, 1211.4000244141, 7, 224, "Autoschein"},
	["Stratum"] = {17500, -1936.3000488281, 271.89999389648, 41, 180, "Autoschein"},
	["Perennial"] = {5000, -1936.3000488281, 271.89999389648, 41, 180, "Autoschein"},
	["Solair"] = {22000, -1936.3000488281, 271.89999389648, 41, 180, "Autoschein"},
	["Regina"] = {11000, -1936.3000488281, 271.89999389648, 41, 180, "Autoschein"},
	["Club"] = {13500, -1936.3000488281, 271.89999389648, 41, 180, "Autoschein"},
	["NRG-500"] = {26000, -1936.3000488281, 271.89999389648, 41, 180, "Motorradschein"},
	["FCR-900"] = {9000, -1936.3000488281, 271.89999389648, 41, 180, "Motorradschein"},
	["Tampa"] = {1000, -232.19999694824, 1203.4000244141, 19.700000762939, 270, "Autoschein"},
	["Clover"] = {1200, -232.19999694824, 1203.4000244141, 19.700000762939, 270, "Autoschein"},
	["Cadrona"] = {4000, -232.19999694824, 1203.4000244141, 19.700000762939, 270, "Autoschein"},
	["Buccaneer"] = {5000, -232.19999694824, 1203.4000244141, 19.700000762939, 270, "Autoschein"},
	["Sentinel"] = {4500, -232.19999694824, 1203.4000244141, 19.700000762939, 270, "Autoschein"},
	["Premier"] = {6000, -232.19999694824, 1203.4000244141, 19.700000762939, 270, "Autoschein"},
	["Nebula"] = {3000, -232.19999694824, 1203.4000244141, 19.700000762939, 270, "Autoschein"},
	["Willard"] = {4000, -232.19999694824, 1203.4000244141, 19.700000762939, 270, "Autoschein"},
	["Merit"] = {7000, -232.19999694824, 1203.4000244141, 19.700000762939, 270, "Autoschein"},
	["Emperor"] = {8000, -232.19999694824, 1203.4000244141, 19.700000762939, 270, "Autoschein"},
	["Cropduster"] = {180000, 2052.8000488281, -2493.5, 14.5, 90, "Flugschein"},
	["Shamal"] = {250000, 2052.8000488281, -2493.5, 14.5, 90, "Flugschein"},
	["Dodo"] = {150000, 2052.8000488281, -2493.5, 14.5, 90, "Flugschein"},
	["Stuntplane"] = {125000, 2052.8000488281, -2493.5, 14.5, 90, "Flugschein"},
	["Sparrow"] = {40000, 2052.8000488281, -2493.5, 14.5, 90, "Helikopterschein"},
	["Maverick"] = {80000, 2052.8000488281, -2493.5, 14.5, 90, "Helikopterschein"},
	["Marquis"] = {200000, -2174.3999023438, 2425.6000976563, 0, 46, "Bootschein"},
	["Jetmax"] = {100000, -2174.3999023438, 2425.6000976563, 0, 46, "Bootschein"},
	["Speeder"] = {80000, -2174.3999023438, 2425.6000976563, 0, 46, "Bootschein"},
	["Squalo"] = {120000, -2174.3999023438, 2425.6000976563, 0, 46, "Bootschein"},
	["Tropic"] = {250000, -2174.3999023438, 2425.6000976563, 0, 46, "Bootschein"},
	["Reefer"] = {70000, -2174.3999023438, 2425.6000976563, 0, 46, "Bootschein"},
	["Dinghy"] = {30000, -2174.3999023438, 2425.6000976563, 0, 46, "Bootschein"},
	["Coastguard"] = {50000, -2174.3999023438, 2425.6000976563, 0, 46, "Bootschein"}
}

local buyVehicleOpen = false
local selectedVehicleID = nil

local function isCursorOnElement(x, y, w, h)
	if not isCursorShowing() then return false end
	local cx, cy = getCursorPosition()
	if not cx or not cy then return false end
	cx, cy = cx * sx, cy * sy
	return cx >= x and cx <= x + w and cy >= y and cy <= y + h
end

local function getBuyVehicleLayout()
	local w, h = 460 * scale, 260 * scale
	local x, y = (sx - w) / 2, (sy - h) / 2
	local padding = 15 * scale
	return x, y, w, h, padding
end

local function drawButton(text, x, y, w, h)
	local hover = isCursorOnElement(x, y, w, h)
	dxDrawRectangle(x, y, w, h, hover and tocolor(0, 100, 200, 255) or tocolor(30, 30, 30, 255), false)
	dxDrawRectangle(x, y + h - 2 * scale, w, 2 * scale, tocolor(0, 100, 200, 255), false)
	dxDrawText(text, x + 8 * scale, y, x + w - 8 * scale, y + h, tocolor(255, 255, 255, 255), 1 * scale, "default-bold", "center", "center", true)
end

local function renderBuyVehicle()
	if not buyVehicleOpen or not selectedVehicleID then return end

	local vehicleName = getVehicleNameFromModel(selectedVehicleID)
	local vehicleData = fahrzeuge[vehicleName]
	if not vehicleData then return end

	local x, y, w, h, padding = getBuyVehicleLayout()
	local contentW = w - padding * 2
	local infoY = y + 20 * scale
	local infoH = 80 * scale
	local buttonH = 44 * scale
	local buttonGap = 10 * scale
	local buttonW = (contentW - buttonGap) / 2
	local buttonY = y + h - padding - buttonH
	local priceText = vehicleName .. ": $" .. tostring(vehicleData[1])

	dxDrawRectangle(x, y, w, h, tocolor(0, 0, 0, 240), false)
	dxDrawRectangle(x, y, w, 3 * scale, tocolor(0, 100, 200, 255), false)
	dxDrawRectangle(x + padding, infoY, contentW, infoH, tocolor(20, 20, 20, 255), false)
	dxDrawRectangle(x + padding, infoY, 3 * scale, infoH, tocolor(0, 100, 200, 255), false)
	dxDrawText(priceText, x + padding + 15 * scale, infoY, x + w - padding - 15 * scale, infoY + infoH, tocolor(255, 255, 255, 255), 1.1 * scale, "default-bold", "center", "center", true)

	drawButton(getText("Autohaus5"), x + padding, buttonY, buttonW, buttonH)
	drawButton(getText("Autohaus6"), x + padding + buttonW + buttonGap, buttonY, buttonW, buttonH)
end

local function closeBuyVehicleWindow()
	if not buyVehicleOpen then return end
	buyVehicleOpen = false
	selectedVehicleID = nil
	removeEventHandler("onClientRender", root, renderBuyVehicle)
	removeEventHandler("onClientClick", root, buyVehicleClick)
	showCursor(false)
	setElementData(localPlayer, "redfieldClick", false)
end

function buyVehicleClick(button, state)
	if not buyVehicleOpen or button ~= "left" or state ~= "down" then return end

	local x, y, w, h, padding = getBuyVehicleLayout()
	local contentW = w - padding * 2
	local buttonH = 44 * scale
	local buttonGap = 10 * scale
	local buttonW = (contentW - buttonGap) / 2
	local buttonY = y + h - padding - buttonH

	if isCursorOnElement(x + padding, buttonY, buttonW, buttonH) then
		if not selectedVehicleID then return end

		local vehicleName = getVehicleNameFromModel(selectedVehicleID)
		local vehicleData = fahrzeuge[vehicleName]
		if not vehicleData then return end

		local id = selectedVehicleID
		local spawnX = vehicleData[2]
		local spawnY = vehicleData[3]
		local spawnZ = vehicleData[4]
		local spawnRot = vehicleData[5]

		closeBuyVehicleWindow()
		triggerServerEvent("buyVehicle", localPlayer, id, spawnX, spawnY, spawnZ, spawnRot)
		return
	end

	if isCursorOnElement(x + padding + buttonW + buttonGap, buttonY, buttonW, buttonH) then
		closeBuyVehicleWindow()
	end
end

function buyVehicleWindow(id)
	if buyVehicleOpen then return end
	if getElementData(localPlayer, "redfieldClick") == true then return end

	id = tonumber(id)
	if not id then return end

	local vehicleName = getVehicleNameFromModel(id)
	if not vehicleName or not fahrzeuge[vehicleName] then return end

	selectedVehicleID = id
	buyVehicleOpen = true
	showCursor(true)
	setElementData(localPlayer, "redfieldClick", true)
	addEventHandler("onClientRender", root, renderBuyVehicle)
	addEventHandler("onClientClick", root, buyVehicleClick)
end
addEvent("buyVehicleWindow", true)
addEventHandler("buyVehicleWindow", root, buyVehicleWindow)

addEventHandler("onClientPlayerWasted", localPlayer, function()
	closeBuyVehicleWindow()
end)