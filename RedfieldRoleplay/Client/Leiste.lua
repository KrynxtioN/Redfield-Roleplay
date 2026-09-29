local sx, sy = guiGetScreenSize()
local scale = math.min(sx / 1440, sy / 900)
local MAX_LEVEL = 100

local function getRequiredEXP(level)
	level = tonumber(level) or 1
	return math.floor(500+(level^1.6)*350)
end

local function clamp(v, min, max)
	return math.max(min, math.min(max, v))
end

local function drawHudBar(x, y, w, h, percent, text)
	dxDrawRectangle(x, y, w, h, tocolor(0, 0, 0, 235), false)
	dxDrawRectangle(x, y, w, 2 * scale, tocolor(0, 100, 200, 255), false)
	dxDrawRectangle(x + 4 * scale, y + 5 * scale, w - 8 * scale, h - 8 * scale, tocolor(25, 25, 25, 255), false)
	dxDrawRectangle(x + 4 * scale, y + 5 * scale, (w - 8 * scale) * clamp(percent, 0, 1), h - 8 * scale, tocolor(0, 100, 200, 255), false)
	dxDrawText(text, x + 4 * scale, y, x + w - 4 * scale, y + h, tocolor(255, 255, 255, 255), 1, "default-bold", "center", "center", true, false, false)
end

function Leiste_func()
	if not isPlayerMapVisible() then
		if getElementData(localPlayer, "loggedin") ~= 1 then return end

		local hunger = clamp(tonumber(getElementData(localPlayer, "Hunger")) or 0, 0, 100)
		local exp = math.max(0, tonumber(getElementData(localPlayer, "Erfahrungspunkte")) or 0)
		local oxygen = clamp(tonumber(getPedOxygenLevel(localPlayer)) or 0, 0, 1000)
		local level = tonumber(getElementData(localPlayer, "Level")) or 1
		local needed = level < MAX_LEVEL and getRequiredEXP(level) or nil

		local hungerWidth = 140 * scale
		local oxygenWidth = 140 * scale
		local expWidth = 270 * scale
		local gap = 8 * scale
		local totalWidth = hungerWidth + oxygenWidth + expWidth + gap * 2
		local height = 27 * scale
		local x = (sx - totalWidth) / 2
		local y = sy - height

		drawHudBar(x, y, hungerWidth, height, hunger / 100, getText("HudHunger"):format(math.floor(hunger)))
		drawHudBar(x + hungerWidth + gap, y, oxygenWidth, height, oxygen / 1000, getText("HudOxygen"):format(math.floor(oxygen / 10)))

		if needed then
			drawHudBar(x + hungerWidth + oxygenWidth + gap * 2, y, expWidth, height, exp / needed, getText("HudExp"):format(exp, needed))
		else
			drawHudBar(x + hungerWidth + oxygenWidth + gap * 2, y, expWidth, height, 1, getText("HudMaxLevel"))
		end
	end
end

addEventHandler("onClientRender", root, Leiste_func)