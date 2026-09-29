local sx, sy = guiGetScreenSize()
local scale = math.min(sx / 1920, sy / 1080)

local fahrpruefungMarker = {
	["x"] = {
		[1] = -198.01217651367,
		[2] = -250.33056640625,
		[3] = -50.418704986572,
		[4] = 212.21748352051,
		[5] = 186.0555267334,
		[6] = -58.385551452637,
		[7] = -120.08601379395,
		[8] = -193.21726989746,
		[9] = -198.33740234375
	},
	["y"] = {
		[1] = 1040.6884765625,
		[2] = 838.54522705078,
		[3] = 855.70318603516,
		[4] = 960.47393798828,
		[5] = 1139.2517089844,
		[6] = 1264.7175292969,
		[7] = 1153.3526611328,
		[8] = 1196.2297363281,
		[9] = 1109.3471679688
	},
	["z"] = {
		[1] = 19.590286254883,
		[2] = 13.064254760742,
		[3] = 17.738880157471,
		[4] = 28.189987182617,
		[5] = 14.710836410522,
		[6] = 10.569092750549,
		[7] = 19.59375,
		[8] = 19.583673477173,
		[9] = 19.591083526611
	}
}

local lizenzenOpen = false
local praxisMarker = nil
local praxisBlip = nil
local praxisMarkerPoints = 0

local lizenzButtons = {
	{text = "Fahrschule6", type = "car"},
	{text = "Fahrschule7", type = "Motorradschein"},
	{text = "Fahrschule8", type = "Lkwschein"},
	{text = "Fahrschule9", type = "Helikopterschein"},
	{text = "Fahrschule10", type = "Flugschein"},
	{text = "Fahrschule11", type = "Bootschein"},
	{text = "Fahrschule12", type = "Personalausweis"},
	{text = "Fahrschule13", type = "Arbeitsgenehmigung"}
}

local function isCursorOnElement(x, y, w, h)
	if not isCursorShowing() then return false end
	local cx, cy = getCursorPosition()
	if not cx or not cy then return false end
	cx, cy = cx * sx, cy * sy
	return cx >= x and cx <= x + w and cy >= y and cy <= y + h
end

local function getLizenzenLayout()
	local w, h = 560 * scale, 370 * scale
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

local function renderLizenzen()
	if not lizenzenOpen then return end

	local x, y, w, h, padding = getLizenzenLayout()
	local contentW = w - padding * 2
	local gap = 10 * scale
	local buttonW = (contentW - gap) / 2
	local buttonH = 48 * scale
	local startY = y + 25 * scale
	local rowGap = 10 * scale

	dxDrawRectangle(x, y, w, h, tocolor(0, 0, 0, 240), false)
	dxDrawRectangle(x, y, w, 3 * scale, tocolor(0, 100, 200, 255), false)

	for i, data in ipairs(lizenzButtons) do
		local column = (i - 1) % 2
		local row = math.floor((i - 1) / 2)
		local buttonX = x + padding + column * (buttonW + gap)
		local buttonY = startY + row * (buttonH + rowGap)
		drawButton(getText(data.text), buttonX, buttonY, buttonW, buttonH)
	end

	local closeY = y + h - padding - buttonH
	drawButton(getText("Fahrschule14"), x + padding, closeY, contentW, buttonH)
end

local function closeLizenzenWindow()
	if not lizenzenOpen then return end
	lizenzenOpen = false
	removeEventHandler("onClientRender", root, renderLizenzen)
	removeEventHandler("onClientClick", root, lizenzenClick)
	showCursor(false)
	setElementData(localPlayer, "redfieldClick", false)
end

function clientPraxisCarMarker()
	if isElement(praxisMarker) then destroyElement(praxisMarker) end
	if isElement(praxisBlip) then destroyElement(praxisBlip) end

	praxisMarker = nil
	praxisBlip = nil
	praxisMarkerPoints = praxisMarkerPoints + 1

	if praxisMarkerPoints > 9 then
		triggerServerEvent("giveCarlicense", localPlayer)
		return
	end

	local markerX = fahrpruefungMarker["x"][praxisMarkerPoints]
	local markerY = fahrpruefungMarker["y"][praxisMarkerPoints]
	local markerZ = fahrpruefungMarker["z"][praxisMarkerPoints]

	praxisMarker = createMarker(markerX, markerY, markerZ, "checkpoint", 1, 200, 0, 0)
	praxisBlip = createBlip(markerX, markerY, markerZ, 0, 2, 255, 0, 0)

	addEventHandler("onClientMarkerHit", praxisMarker, function(hitPlayer)
		if hitPlayer == localPlayer then
			clientPraxisCarMarker()
		end
	end)
end
addEvent("clientPraxisCarlicense", true)
addEventHandler("clientPraxisCarlicense", root, clientPraxisCarMarker)

function lizenzenClick(button, state)
	if not lizenzenOpen or button ~= "left" or state ~= "down" then return end

	local x, y, w, h, padding = getLizenzenLayout()
	local contentW = w - padding * 2
	local gap = 10 * scale
	local buttonW = (contentW - gap) / 2
	local buttonH = 48 * scale
	local startY = y + 25 * scale
	local rowGap = 10 * scale

	for i, data in ipairs(lizenzButtons) do
		local column = (i - 1) % 2
		local row = math.floor((i - 1) / 2)
		local buttonX = x + padding + column * (buttonW + gap)
		local buttonY = startY + row * (buttonH + rowGap)

		if isCursorOnElement(buttonX, buttonY, buttonW, buttonH) then
			if data.type == "car" then
				praxisMarkerPoints = 0
				closeLizenzenWindow()
				triggerServerEvent("startPraxisCarlicense", localPlayer, localPlayer)
			else
				triggerServerEvent("givePlayerLicense", localPlayer, data.type)
			end
			return
		end
	end

	local closeY = y + h - padding - buttonH
	if isCursorOnElement(x + padding, closeY, contentW, buttonH) then
		closeLizenzenWindow()
	end
end

function openLizenzenWindow()
	if lizenzenOpen then return end
	if getElementData(localPlayer, "redfieldClick") == true then return end

	lizenzenOpen = true
	showCursor(true)
	setElementData(localPlayer, "redfieldClick", true)
	addEventHandler("onClientRender", root, renderLizenzen)
	addEventHandler("onClientClick", root, lizenzenClick)
end
addEvent("openLizenzenWindow", true)
addEventHandler("openLizenzenWindow", root, openLizenzenWindow)

addEventHandler("onClientPlayerWasted", localPlayer, function()
	closeLizenzenWindow()
end)