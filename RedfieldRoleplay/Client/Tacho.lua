local sx, sy = guiGetScreenSize()
local scale = math.min(sx / 1920, sy / 1080)
local rendering = false

function render_tacho()
	local veh = getPedOccupiedVehicle(localPlayer)
	if not isElement(veh) then return end
	local vx, vy, vz = getElementVelocity(veh)
	local kmh = math.floor(math.sqrt(vx * vx + vy * vy + vz * vz) * 180 + 0.5)
	local fuel = math.max(0, tonumber(getElementData(veh, "Benzin")) or 0)
	local engine = getVehicleEngineState(veh)
	local width, height = 300 * scale, 92 * scale
	local x, y = sx - width - 20 * scale, sy - height - 12 * scale
	local padding = 10 * scale
	dxDrawRectangle(x, y, width, height, tocolor(0, 0, 0, 235), false)
	dxDrawRectangle(x, y, width, 3 * scale, tocolor(0, 100, 200, 255), false)
	local speedWidth = 115 * scale
	local speedX, speedY = x + padding, y + 13 * scale
	local speedHeight = height - 25 * scale
	dxDrawRectangle(speedX, speedY, speedWidth, speedHeight, tocolor(25, 25, 25, 255), false)
	dxDrawText(string.format("%03d", kmh), speedX, speedY, speedX + speedWidth, speedY + speedHeight - 14 * scale, tocolor(255, 255, 255, 255), math.max(1, 1.4 * scale), "default-bold", "center", "center", true, false, false)
	dxDrawText("km/h", speedX, speedY + speedHeight - 25 * scale, speedX + speedWidth, speedY + speedHeight, tocolor(160, 160, 160, 255), 1, "default-bold", "center", "center", true, false, false)
	local infoX = speedX + speedWidth + 12 * scale
	dxDrawImage(infoX, y + 17 * scale, 20 * scale, 20 * scale, "Images/Tank.png", 0, 0, 0, tocolor(255, 255, 255, 255), false)
	dxDrawText(getText("TachoFuel"):format(math.floor(fuel)), infoX + 28 * scale, y + 12 * scale, x + width - padding, y + 42 * scale, tocolor(255, 255, 255, 255), 1, "default-bold", "left", "center", true, false, false)
	local engineY = y + 51 * scale
	local circleSize = 18 * scale
	local engineColor = engine and tocolor(0, 255, 0, 255) or tocolor(80, 80, 80, 255)
	dxDrawImage(infoX, engineY, circleSize, circleSize, "Images/Kreis.png", 0, 0, 0, engineColor, false)
	dxDrawText(engine and getText("TachoEngineOn") or getText("TachoEngineOff"), infoX + 28 * scale, engineY - 5 * scale, x + width - padding, engineY + circleSize + 5 * scale, tocolor(255, 255, 255, 255), 1, "default-bold", "left", "center", true, false, false)
end

local function setTacho(state)
	if state and not rendering then
		rendering = true
		addEventHandler("onClientRender", root, render_tacho)
	elseif not state and rendering then
		rendering = false
		removeEventHandler("onClientRender", root, render_tacho)
	end
end

addEventHandler("onClientVehicleEnter", root, function(player)
	if player == localPlayer then setTacho(true) end
end)

addEventHandler("onClientVehicleExit", root, function(player)
	if player == localPlayer then setTacho(false) end
end)

addEventHandler("onClientElementDestroy", root, function()
	if source == getPedOccupiedVehicle(localPlayer) then setTacho(false) end
end)

addEventHandler("onClientPlayerWasted", localPlayer, function()
	setTacho(false)
end)

if isPedInVehicle(localPlayer) then setTacho(true) end