local sx, sy = guiGetScreenSize()
local scale = math.min(sx / 1920, sy / 1080)

local skinid = 1
local skinpreise = 1
local minskin, maxskin = 1, 50
local show_ped = nil
local skinshopOpen = false

local skins = {
	[0] = 0,
	[1] = 299,
	[2] = 181,
	[3] = 1,
	[4] = 7,
	[5] = 12,
	[6] = 17,
	[7] = 18,
	[8] = 19,
	[9] = 20,
	[10] = 22,
	[11] = 23,
	[12] = 45,
	[13] = 44,
	[14] = 46,
	[15] = 47,
	[16] = 48,
	[17] = 55,
	[18] = 67,
	[19] = 69,
	[20] = 75,
	[21] = 78,
	[22] = 79,
	[23] = 85,
	[24] = 87,
	[25] = 88,
	[26] = 96,
	[27] = 97,
	[28] = 98,
	[29] = 101,
	[30] = 128,
	[31] = 134,
	[32] = 136,
	[33] = 137,
	[34] = 147,
	[35] = 148,
	[36] = 150,
	[37] = 156,
	[38] = 157,
	[39] = 158,
	[40] = 159,
	[41] = 160,
	[42] = 176,
	[43] = 177,
	[44] = 180,
	[45] = 191,
	[46] = 192,
	[47] = 249,
	[48] = 250,
	[49] = 298,
	[50] = 299
}

local skinpreis = {
	[0] = 500,
	[1] = 500,
	[2] = 1000,
	[3] = 500,
	[4] = 500,
	[5] = 600,
	[6] = 500,
	[7] = 500,
	[8] = 500,
	[9] = 500,
	[10] = 500,
	[11] = 500,
	[12] = 500,
	[13] = 500,
	[14] = 500,
	[15] = 500,
	[16] = 500,
	[17] = 500,
	[18] = 500,
	[19] = 500,
	[20] = 500,
	[21] = 200,
	[22] = 200,
	[23] = 500,
	[24] = 500,
	[25] = 88,
	[26] = 500,
	[27] = 500,
	[28] = 500,
	[29] = 500,
	[30] = 500,
	[31] = 200,
	[32] = 200,
	[33] = 200,
	[34] = 500,
	[35] = 500,
	[36] = 500,
	[37] = 500,
	[38] = 500,
	[39] = 200,
	[40] = 200,
	[41] = 200,
	[42] = 500,
	[43] = 500,
	[44] = 500,
	[45] = 500,
	[46] = 500,
	[47] = 1000,
	[48] = 600,
	[49] = 500,
	[50] = 500
}

local function isCursorOnElement(x, y, w, h)
	if not isCursorShowing() then return false end
	local cx, cy = getCursorPosition()
	if not cx or not cy then return false end
	cx, cy = cx * sx, cy * sy
	return cx >= x and cx <= x + w and cy >= y and cy <= y + h
end

local function getSkinshopLayout()
	local panelW, panelH = 330 * scale, 170 * scale
	local panelX, panelY = sx - panelW - 25 * scale, 25 * scale
	local padding = 15 * scale
	local buttonH = 42 * scale
	return panelX, panelY, panelW, panelH, padding, buttonH
end

local function getNavigationLayout()
	local buttonW, buttonH = 90 * scale, 55 * scale
	local gap = 20 * scale
	local totalW = buttonW * 2 + gap
	local startX = (sx - totalW) / 2
	local buttonY = sy - 90 * scale
	return startX, buttonY, buttonW, buttonH, gap
end

local function drawButton(text, x, y, w, h)
	local hover = isCursorOnElement(x, y, w, h)
	dxDrawRectangle(x, y, w, h, hover and tocolor(0, 100, 200, 255) or tocolor(0, 0, 0, 220), false)
	dxDrawRectangle(x, y + h - 3 * scale, w, 3 * scale, tocolor(0, 100, 200, 255), false)
	dxDrawText(text, x + 5 * scale, y, x + w - 5 * scale, y + h, tocolor(255, 255, 255, 255), 1.2 * scale, "default-bold", "center", "center", true)
end

local function renderRotatePed()
	if isElement(show_ped) then
		local rot = getPedRotation(show_ped)
		setPedRotation(show_ped, rot + 1)
	end
end

function dxdraw_skinshop()
	if not skinshopOpen then return end

	local panelX, panelY, panelW, panelH, padding, buttonH = getSkinshopLayout()
	local navX, navY, navW, navH, navGap = getNavigationLayout()
	local contentW = panelW - padding * 2
	local price = skinpreis[skinpreise] or 0
	local text = string.format(getText("Skinshop3"), price)
	local actionGap = 10 * scale
	local actionW = (contentW - actionGap) / 2
	local actionY = panelY + panelH - padding - buttonH

	dxDrawRectangle(panelX, panelY, panelW, panelH, tocolor(0, 0, 0, 240), false)
	dxDrawRectangle(panelX, panelY, panelW, 3 * scale, tocolor(0, 100, 200, 255), false)

	dxDrawText(getText("Skinshop2"), panelX + padding, panelY + 10 * scale, panelX + panelW - padding, panelY + 42 * scale, tocolor(255, 255, 255, 255), 1.1 * scale, "default-bold", "center", "center", true)

	dxDrawRectangle(panelX + padding, panelY + 50 * scale, contentW, 48 * scale, tocolor(20, 20, 20, 255), false)
	dxDrawRectangle(panelX + padding, panelY + 50 * scale, 3 * scale, 48 * scale, tocolor(0, 100, 200, 255), false)
	dxDrawText(text, panelX + padding + 12 * scale, panelY + 50 * scale, panelX + panelW - padding - 12 * scale, panelY + 98 * scale, tocolor(255, 255, 255, 255), 1 * scale, "default-bold", "center", "center", true)

	drawButton("✓", panelX + padding, actionY, actionW, buttonH)
	drawButton("X", panelX + padding + actionW + actionGap, actionY, actionW, buttonH)

	drawButton("<", navX, navY, navW, navH)
	drawButton(">", navX + navW + navGap, navY, navW, navH)
end

local function closeSkinshop()
	if not skinshopOpen then return end

	skinshopOpen = false
	showCursor(false)
	setElementData(localPlayer, "redfieldClick", false)
	setElementFrozen(localPlayer, false)

	removeEventHandler("onClientRender", root, dxdraw_skinshop)
	removeEventHandler("onClientRender", root, renderRotatePed)
	removeEventHandler("onClientClick", root, skinshopClick)

	if isElement(show_ped) then destroyElement(show_ped) end
	show_ped = nil
end

function skin_rechts()
	skinid = skinid - 1
	skinpreise = skinpreise - 1

	if skinid < minskin then
		skinid = maxskin
		skinpreise = maxskin
	end

	if isElement(show_ped) then
		setElementModel(show_ped, skins[skinid])
	end
end

function skin_links()
	skinid = skinid + 1
	skinpreise = skinpreise + 1

	if skinid > maxskin then
		skinid = minskin
		skinpreise = minskin
	end

	if isElement(show_ped) then
		setElementModel(show_ped, skins[skinid])
	end
end

function skinshopClick(button, state)
	if not skinshopOpen or button ~= "left" or state ~= "down" then return end

	local panelX, panelY, panelW, panelH, padding, buttonH = getSkinshopLayout()
	local navX, navY, navW, navH, navGap = getNavigationLayout()
	local contentW = panelW - padding * 2
	local actionGap = 10 * scale
	local actionW = (contentW - actionGap) / 2
	local actionY = panelY + panelH - padding - buttonH

	if isCursorOnElement(panelX + padding, actionY, actionW, buttonH) then
		local selectedSkin = skins[skinid]
		local selectedIndex = skinpreise
		closeSkinshop()
		triggerServerEvent("skinchange", localPlayer, selectedSkin, selectedIndex)
		return
	end

	if isCursorOnElement(panelX + padding + actionW + actionGap, actionY, actionW, buttonH) then
		closeSkinshop()
		triggerServerEvent("dont_skinbuy", localPlayer)
		return
	end

	if isCursorOnElement(navX, navY, navW, navH) then
		skin_links()
		return
	end

	if isCursorOnElement(navX + navW + navGap, navY, navW, navH) then
		skin_rechts()
	end
end

function skinshop_buttons()
	if skinshopOpen then return end
	if getElementData(localPlayer, "redfieldClick") == true then return end

	skinid = 1
	skinpreise = 1
	skinshopOpen = true

	showCursor(true)
	setElementData(localPlayer, "redfieldClick", true)

	local dim = getElementDimension(localPlayer)

	setCameraMatrix(208.70359802246, -12.220499992371, 1002.629699707, 207.73143005371, -12.205281257629, 1002.395874023)

	show_ped = createPed(skins[skinid], 202.400390625, -12.2509765625, 1001.2109375, 271)
	setElementInterior(show_ped, 5)
	setElementDimension(show_ped, dim)
	setElementFrozen(localPlayer, true)

	addEventHandler("onClientRender", root, dxdraw_skinshop)
	addEventHandler("onClientRender", root, renderRotatePed)
	addEventHandler("onClientClick", root, skinshopClick)
end

function open_skinshop()
	skinshop_buttons()
end
addEvent("open_skinshop", true)
addEventHandler("open_skinshop", root, open_skinshop)

addEvent("close_skin", true)
addEventHandler("close_skin", root, function()
	if skinshopOpen then
		closeSkinshop()
		triggerServerEvent("dont_skinbuy", localPlayer)
	end
end)

addEventHandler("onClientPlayerWasted", localPlayer, function()
	if skinshopOpen then
		closeSkinshop()
		triggerServerEvent("dont_skinbuy", localPlayer)
	end
end)