local sx, sy = guiGetScreenSize()
local scale = math.min(sx / 1920, sy / 1080)
local scroll = 0
local visibleRows = 16
local scoreboardVisible = false

local factionNames = {
	[0] = {[0] = "Zivilist", [1] = "Civilian"},
	[1] = {[0] = "Police Department", [1] = "Police Department"},
	[2] = {[0] = "Yakuza", [1] = "Yakuza"},
	[3] = {[0] = "Biker", [1] = "Biker"},
	[4] = {[0] = "Reporter", [1] = "Reporter"},
	[5] = {[0] = "Ballas", [1] = "Ballas"},
	[6] = {[0] = "Surenos", [1] = "Surenos"}
}

local factionColors = {
	[-1] = {130, 130, 130},
	[0] = {255, 255, 255},
	[1] = {0, 200, 0},
	[2] = {0, 100, 255},
	[3] = {150, 100, 100},
	[4] = {250, 150, 0},
	[5] = {255, 0, 200},
	[6] = {220, 220, 0}
}

local function lang()
	return tonumber(getElementData(localPlayer, "Language")) == 1 and 1 or 0
end

local function factionName(id)
	return factionNames[id] and factionNames[id][lang()] or factionNames[0][lang()]
end

local function online(id)
	local amount = 0
	for _, player in ipairs(getElementsByType("player")) do
		if getElementData(player, "loggedin") == 1 and tonumber(getElementData(player, "Fraktion")) == id then amount = amount + 1 end
	end
	return amount
end

local function pingColor(ping)
	if ping <= 70 then return 0, 200, 0 end
	if ping <= 120 then return 255, 250, 0 end
	if ping <= 200 then return 255, 150, 0 end
	return 200, 0, 0
end

local function playtime(minutes)
	minutes = tonumber(minutes) or 0
	return string.format("%02d:%02d", math.floor(minutes / 60), minutes % 60)
end

local function players()
	local list = getElementsByType("player")
	table.sort(list, function(a, b)
		return getPlayerName(a):lower() < getPlayerName(b):lower()
	end)
	return list
end

function ScoreboardScrollingUp()
	scroll = math.max(0, scroll - 1)
end

function ScoreboardScrollingDown()
	scroll = math.min(math.max(0, #getElementsByType("player") - visibleRows), scroll + 1)
end

function ScoreboardDraw()
	local list = players()
	local maxScroll = math.max(0, #list - visibleRows)
	if scroll > maxScroll then scroll = maxScroll end

	local width, height = 940 * scale, 540 * scale
	local x, y = (sx - width) / 2, (sy - height) / 2
	local headerHeight = 48 * scale
	local rowHeight = 24 * scale
	local listY = y + headerHeight + 8 * scale
	local footerY = y + height - 74 * scale

	dxDrawRectangle(x, y, width, height, tocolor(0, 0, 0, 200), false)
	dxDrawRectangle(x, y, width, 3 * scale, tocolor(0, 100, 200, 255), false)
	dxDrawRectangle(x, y + 3 * scale, width, headerHeight - 3 * scale, tocolor(20, 20, 20, 255), false)

	local cols = {
		x + 25 * scale,
		x + 210 * scale,
		x + 365 * scale,
		x + 530 * scale,
		x + 680 * scale,
		x + 815 * scale
	}

	local headers = {
		getText("ScorePlayer"),
		getText("ScoreFaction"),
		getText("ScoreStatus"),
		getText("ScorePhone"),
		getText("ScorePlaytime"),
		getText("ScorePing")
	}

	for i = 1, 6 do
		local right = i < 6 and cols[i + 1] - 10 * scale or x + width - 20 * scale
		dxDrawText(headers[i], cols[i], y + 5 * scale, right, y + headerHeight, tocolor(255, 255, 255, 255), 1, "default-bold", "left", "center", true, false, false)
	end

	for row = 1, visibleRows do
		local player = list[scroll + row]
		if not player then break end
		local rowY = listY + (row - 1) * rowHeight
		local logged = getElementData(player, "loggedin") == 1
		local faction = logged and (tonumber(getElementData(player, "Fraktion")) or 0) or -1
		local factionColor = factionColors[faction] or factionColors[0]
		local name = getPlayerName(player)
		if (tonumber(getElementData(player, "Adminrang")) or 0) > 0 then name = "[BC] " .. name end
		local phone = logged and (getElementData(player, "Telefonnummer") or "-") or "-"
		if phone == 0 then phone = getText("ScoreNoPhone") end
		local status = logged and tostring(getElementData(player, "Status") or "-") or "-"
		local playerTime = logged and playtime(getElementData(player, "Spielzeit")) or "-"
		local ping = getPlayerPing(player)
		local pr, pg, pb = pingColor(ping)
		local values = {name, logged and factionName(faction) or "-", status, tostring(phone), playerTime, tostring(ping)}

		if row % 2 == 0 then dxDrawRectangle(x + 10 * scale, rowY, width - 20 * scale, rowHeight, tocolor(20, 20, 20, 210), false) end
		for i = 1, 6 do
			local right = i < 6 and cols[i + 1] - 10 * scale or x + width - 20 * scale
			local color = i == 6 and tocolor(pr, pg, pb, 255) or tocolor(factionColor[1], factionColor[2], factionColor[3], 255)
			dxDrawText(values[i], cols[i], rowY, right, rowY + rowHeight, color, 1, "default-bold", "left", "center", true, false, false)
		end
	end

	if #list > visibleRows then
		local barX = x + width - 7 * scale
		local barY = listY
		local barHeight = visibleRows * rowHeight
		local thumbHeight = barHeight * (visibleRows / #list)
		local thumbY = barY
		if maxScroll > 0 then thumbY = barY + (barHeight - thumbHeight) * (scroll / maxScroll) end
		dxDrawRectangle(barX, barY, 3 * scale, barHeight, tocolor(50, 50, 50, 255), false)
		dxDrawRectangle(barX, thumbY, 3 * scale, thumbHeight, tocolor(0, 100, 200, 255), false)
	end

	dxDrawRectangle(x, footerY, width, 2 * scale, tocolor(0, 100, 200, 255), false)
	dxDrawText(getText("ScoreOnline"):format(#list), x + 20 * scale, footerY + 8 * scale, x + 185 * scale, y + height - 10 * scale, tocolor(255, 255, 255, 255), 1, "default-bold", "left", "center")
	dxDrawText(getText("ScoreState") .. "\nPolice Department: " .. online(1), x + 200 * scale, footerY + 7 * scale, x + 400 * scale, y + height - 5 * scale, tocolor(255, 255, 255, 255), 1, "default-bold", "left", "top")
	dxDrawText(getText("ScoreGangs") .. "\nYakuza: " .. online(2) .. " | Biker: " .. online(3) .. " | Ballas: " .. online(5) .. " | Surenos: " .. online(6), x + 410 * scale, footerY + 7 * scale, x + 745 * scale, y + height - 5 * scale, tocolor(255, 255, 255, 255), 1, "default-bold", "left", "top", false, true)
	dxDrawText(getText("ScoreNeutral") .. "\nReporter: " .. online(4), x + 755 * scale, footerY + 7 * scale, x + width - 20 * scale, y + height - 5 * scale, tocolor(255, 255, 255, 255), 1, "default-bold", "left", "top")
end

local function showScoreboard()
	if scoreboardVisible or getElementData(localPlayer, "loggedin") ~= 1 or getElementData(localPlayer, "redfieldClick") ~= false then return end
	scoreboardVisible = true
	scroll = 0
	toggleControl("fire", false)
	toggleControl("next_weapon", false)
	toggleControl("previous_weapon", false)
	bindKey("mouse_wheel_up", "down", ScoreboardScrollingUp)
	bindKey("mouse_wheel_down", "down", ScoreboardScrollingDown)
	addEventHandler("onClientRender", root, ScoreboardDraw)
end

local function hideScoreboard()
	if not scoreboardVisible then return end
	scoreboardVisible = false
	toggleControl("fire", true)
	toggleControl("next_weapon", true)
	toggleControl("previous_weapon", true)
	unbindKey("mouse_wheel_up", "down", ScoreboardScrollingUp)
	unbindKey("mouse_wheel_down", "down", ScoreboardScrollingDown)
	removeEventHandler("onClientRender", root, ScoreboardDraw)
end

bindKey("tab", "down", showScoreboard)
bindKey("tab", "up", hideScoreboard)