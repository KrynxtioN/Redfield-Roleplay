local sx, sy = guiGetScreenSize()
local scale = math.min(sx / 1920, sy / 1080)

local hudVisible = true

local hudHiddenComponents = {
	"ammo",
	"armour",
	"breath",
	"clock",
	"health",
	"money",
	"weapon",
	"wanted",
	"area_name"
}

local function formatMoney(value)
	value = math.floor(tonumber(value) or 0)
	local formatted = tostring(math.abs(value))
	local result = ""

	while #formatted > 3 do
		result = "." .. formatted:sub(-3) .. result
		formatted = formatted:sub(1, -4)
	end

	result = formatted .. result
	if value < 0 then result = "-" .. result end
	return "$" .. result
end

local function getCurrentLocation()
	local x, y, z = getElementPosition(localPlayer)
	local zone = getZoneName(x, y, z, false)
	local city = getZoneName(x, y, z, true)

	if zone and city and zone ~= city then
		return zone .. ", " .. city
	end

	return zone or city or "-"
end

local function getCurrentWeapon()
	local weaponID = getPedWeapon(localPlayer)
	if not weaponID or weaponID == 0 then
		return "-"
	end

	return getWeaponNameFromID(weaponID) or "-"
end

local function drawHudRow(label, value, x, y, w, h)
	dxDrawRectangle(x, y, w, h, tocolor(0, 0, 0, 200), false)
	dxDrawRectangle(x, y, 3 * scale, h, tocolor(0, 100, 200, 255), false)
	dxDrawText(label, x + 13 * scale, y, x + 100 * scale, y + h, tocolor(170, 170, 170, 255), 1 * scale, "default-bold", "left", "center", true)
	dxDrawText(value, x + 100 * scale, y, x + w - 13 * scale, y + h, tocolor(255, 255, 255, 255), 1 * scale, "default-bold", "right", "center", true)
end

local function renderHud()
	if not hudVisible then return end
	if getElementData(localPlayer, "loggedin") ~= 1 then return end
	if(isPlayerMapVisible())then return end
	if(getElementData(localPlayer,"inIntro") == true)then return end

	local w = 330 * scale
	local rowH = 38 * scale
	local gap = 4 * scale
	local x = sx - w - 20 * scale
	local y = 20 * scale

	local hour, minute = getTime()
	local timeText = string.format("%02d:%02d", hour, minute)
	local locationText = getCurrentLocation()
	local weaponText = getCurrentWeapon()
	local moneyText = formatMoney(getElementData(localPlayer, "Money"))

	dxDrawRectangle(x, y, w, 3 * scale, tocolor(0, 100, 200, 255), false)
	y = y + 3 * scale

	drawHudRow(getText("HUD1"), timeText, x, y, w, rowH)
	y = y + rowH + gap

	drawHudRow(getText("HUD2"), locationText, x, y, w, rowH)
	y = y + rowH + gap

	drawHudRow(getText("HUD3"), weaponText, x, y, w, rowH)
	y = y + rowH + gap

	drawHudRow(getText("HUD4"), moneyText, x, y, w, rowH)
end

addEventHandler("onClientRender", root, function()
	for _, v in pairs(hudHiddenComponents) do
		setPlayerHudComponentVisible(v, false)
	end
end)

addEventHandler("onClientRender", root, renderHud)