local sx, sy = guiGetScreenSize()
local scale = math.min(sx / 1920, sy / 1080)
local function textScale(v)
	v = math.max(1, v * scale)
	return math.max(1, math.floor(v / 0.2 + 0.5) * 0.2)
end

local introAktiv = false
local position = 0
local introStartTick = 0
local introTimer = nil
local dauerProPosition = 8000
local kameraFahrtDauer = 2500
local kameraVon, kameraZu = nil, nil
local kameraStartTick = 0

setElementData(localPlayer,"inIntro",false)

local kameraPosis = {
	[1] = {x = -182.18699645996, y = 1198.3631591797, z = 43.022899627686, sx = -182.4111328125, sy = 1197.4898681641, sz = 42.590351104736},
	[2] = {x = -189.74659729004, y = 1119.623046875, z = 28.545299530029, sx = -190.62219238281, sy = 1119.6069335938, sz = 28.062517166138},
	[3] = {x = -193.7592010498, y = 1173.3603515625, z = 28.210699081421, sx = -193.04528808594, sy = 1173.5838623047, sz = 27.547090530396},
	[4] = {x = -189.75799560547, y = 1065.7182617188, z = 26.081899642944, sx = -190.65197753906, sy = 1065.5305175781, sz = 25.674995422363},
	[5] = {x = -191.01989746094, y = 1097.6451416016, z = 37.794998168945, sx = -190.50085449219, sy = 1098.1516113281, sz = 37.106410980225},
	[6] = {x = -213.33500671387, y = 1189.8454589844, z = 35.267200469971, sx = -213.99644470215, sy = 1190.3978271484, sz = 34.759872436523},
	[7] = {x = -195.87390136719, y = 1040.6214599609, z = 27.512800216675, sx = -195.08810424805, sy = 1040.3238525391, sz = 26.970600128174},
	[8] = {x = 106.60299682617, y = 1189.0810546875, z = 36.022800445557, sx = 107.50762176514, sy = 1188.9350585938, sz = 35.622360229492},
	[9] = {x = -182.16040039063, y = 1195.3642578125, z = 35.91540145874, sx = -181.9722442627, sy = 1196.15625, sz = 35.334632873535},
}

local kameraTexte = {
	[1] = {titel = "EINFÜHRUNG", text = "Willkommen auf Redfield Roleplay. In diesem kurzen Intro lernst du die wichtigsten Orte und Möglichkeiten kennen."},
	[2] = {titel = "STADTHALLE", text = "Die Stadthalle ist eine deiner wichtigsten Anlaufstellen. Hier kannst du Lizenzen beantragen und verschiedene Jobs annehmen."},
	[3] = {titel = "BANK", text = "Bei der Bank kannst du ein eigenes Konto eröffnen und dein Geld sicher verwalten."},
	[4] = {titel = "KLEIDUNG", text = "Du möchtest deinen Charakter verändern? In ganz San Andreas findest du verschiedene Kleidungsgeschäfte."},
	[5] = {titel = "FORT CARSON MOTEL", text = "Du suchst eine Unterkunft? Im Fort Carson Motel kannst du dir ein Zimmer mieten und einen neuen Rückzugsort schaffen."},
	[6] = {titel = "AUTOHAUS", text = "Zeit für dein erstes eigenes Fahrzeug. Beim örtlichen Autohändler findest du günstige Fahrzeuge für deinen Einstieg."},
	[7] = {titel = "24/7 SHOP", text = "In den 24/7 Shops findest du wichtige Alltagsgegenstände. Unter anderem kannst du dir hier ein Handy kaufen."},
	[8] = {titel = "HUNGER", text = "Achte regelmäßig auf deinen Hunger. Besorge dir rechtzeitig etwas zu essen, damit dein Charakter fit bleibt."},
	[9] = {titel = "VIEL SPASS!", text = "Damit kennst du die wichtigsten Grundlagen. Weitere Informationen findest du jederzeit unter F1. Viel Spaß auf Redfield Roleplay!"},
}

local kameraTexteEnglish = {
	[1] = {titel = "INTRODUCTION", text = "Welcome to Redfield Roleplay. This short introduction will show you the most important places and features."},
	[2] = {titel = "CITY HALL", text = "City Hall is one of your most important destinations. Here you can apply for licenses and find different jobs."},
	[3] = {titel = "BANK", text = "At the bank you can open your own account and safely manage your money."},
	[4] = {titel = "CLOTHING", text = "Want to change your character's appearance? You can find clothing stores throughout San Andreas."},
	[5] = {titel = "FORT CARSON MOTEL", text = "Looking for a place to stay? Rent a room at the Fort Carson Motel and make it your temporary home."},
	[6] = {titel = "CAR DEALERSHIP", text = "Ready for your first vehicle? The local dealership offers affordable vehicles to help you get started."},
	[7] = {titel = "24/7 SHOP", text = "24/7 stores offer useful everyday items. You can also purchase your first mobile phone here."},
	[8] = {titel = "HUNGER", text = "Keep an eye on your hunger. Make sure to eat regularly so your character stays healthy."},
	[9] = {titel = "ENJOY YOUR STAY!", text = "You now know the most important basics. More information is available under F1. Have fun on Redfield Roleplay!"},
}

function setIntroHud(state)
	showChat(state)
	setPlayerHudComponentVisible("all", state)
end

function interpolateCamera()
	if not introAktiv or not kameraVon or not kameraZu then return end
	local progress = math.min((getTickCount() - kameraStartTick) / kameraFahrtDauer, 1)
	local easedProgress = getEasingValue(progress, "InOutQuad")
	local x, y, z = interpolateBetween(kameraVon.x, kameraVon.y, kameraVon.z, kameraZu.x, kameraZu.y, kameraZu.z, easedProgress, "Linear")
	local tx, ty, tz = interpolateBetween(kameraVon.sx, kameraVon.sy, kameraVon.sz, kameraZu.sx, kameraZu.sy, kameraZu.sz, easedProgress, "Linear")
	setCameraMatrix(x, y, z, tx, ty, tz)
end

function introDxDraw()
	if not introAktiv or position < 1 or position > #kameraPosis then return end
	showChat(false)
	setPlayerHudComponentVisible("all", false)
	local data = tonumber(getElementData(localPlayer, "Language")) == 0 and kameraTexte[position] or kameraTexteEnglish[position]
	if not data then return end

	local vergangen = getTickCount() - introStartTick
	local alpha = 255
	if vergangen < 700 then
		alpha = interpolateBetween(0, 0, 0, 255, 0, 0, vergangen / 700, "OutQuad")
	elseif vergangen > dauerProPosition - 700 then
		alpha = interpolateBetween(255, 0, 0, 0, 0, 0, (vergangen - (dauerProPosition - 700)) / 700, "InQuad")
	end
	alpha = math.max(0, math.min(255, alpha))

	local balkenH = sy * 0.09
	dxDrawRectangle(0, 0, sx, balkenH, tocolor(0, 0, 0, 255), false)
	dxDrawRectangle(0, sy - balkenH, sx, balkenH, tocolor(0, 0, 0, 255), false)

	local panelW, panelH = math.min(760 * scale, sx * 0.65), math.min(120 * scale, sy * 0.14)
	local panelX, panelY = (sx - panelW) / 2, sy - balkenH - panelH - 15 * scale
	local padding = 14 * scale
	local progress = math.max(0, math.min(1, vergangen / dauerProPosition))

	dxDrawRectangle(panelX, panelY, panelW, panelH, tocolor(0, 0, 0, math.floor(alpha * 0.88)), false)
	dxDrawRectangle(panelX, panelY, panelW, math.max(2, 2 * scale), tocolor(0, 100, 200, alpha), false)
	dxDrawRectangle(panelX + padding, panelY + 12 * scale, math.max(3, 3 * scale), 28 * scale, tocolor(0, 100, 200, alpha), false)
	dxDrawText(data.titel, panelX + padding + 12 * scale, panelY + 7 * scale, panelX + panelW - padding - 80 * scale, panelY + 45 * scale, tocolor(255, 255, 255, alpha), textScale(1.2), "default-bold", "left", "center")
	dxDrawText(string.format("%02d / %02d", position, #kameraPosis), panelX + panelW - padding - 70 * scale, panelY + 7 * scale, panelX + panelW - padding, panelY + 45 * scale, tocolor(170, 170, 170, alpha), textScale(1), "default-bold", "right", "center")
	dxDrawRectangle(panelX + padding, panelY + 47 * scale, panelW - padding * 2, math.max(1, scale), tocolor(45, 45, 45, alpha), false)
	dxDrawText(data.text, panelX + padding, panelY + 56 * scale, panelX + panelW - padding, panelY + panelH - 16 * scale, tocolor(225, 225, 225, alpha), textScale(1), "default", "left", "top", false, true)
	dxDrawRectangle(panelX + padding, panelY + panelH - 7 * scale, panelW - padding * 2, math.max(3, 3 * scale), tocolor(30, 30, 30, alpha), false)
	dxDrawRectangle(panelX + padding, panelY + panelH - 7 * scale, (panelW - padding * 2) * progress, math.max(3, 3 * scale), tocolor(0, 100, 200, alpha), false)
end

function naechsteIntroPosition()
	if not introAktiv then return end
	position = position + 1
	if position > #kameraPosis then
		beendeIntro()
		return
	end

	introStartTick = getTickCount()
	local neuePosition = kameraPosis[position]

	if position == 1 then
		kameraVon, kameraZu = neuePosition, neuePosition
		kameraStartTick = getTickCount()
		setCameraMatrix(neuePosition.x, neuePosition.y, neuePosition.z, neuePosition.sx, neuePosition.sy, neuePosition.sz)
	else
		kameraVon, kameraZu = kameraPosis[position - 1], neuePosition
		kameraStartTick = getTickCount()
	end

	if position < #kameraPosis then
		introTimer = setTimer(naechsteIntroPosition, dauerProPosition, 1)
	else
		introTimer = setTimer(beendeIntro, dauerProPosition, 1)
	end
end

function startintro_func()
	if introAktiv then return end
	introAktiv = true
	position = 0
	setElementData(localPlayer, "redfieldClick", true)
	setElementData(localPlayer,"inIntro",true)
	setIntroHud(false)
	showCursor(false)
	addEventHandler("onClientRender", root, introDxDraw)
	addEventHandler("onClientPreRender", root, interpolateCamera)
	fadeCamera(false, 0)

	setTimer(function()
		if not introAktiv then return end
		naechsteIntroPosition()
		fadeCamera(true, 1.5)
	end, 500, 1)
end
addEvent("startintro_func", true)
addEventHandler("startintro_func", root, startintro_func)

function beendeIntro()
	if not introAktiv then return end
	introAktiv = false
	if isTimer(introTimer) then killTimer(introTimer) end
	fadeCamera(false, 1)

	setTimer(function()
		removeEventHandler("onClientRender", root, introDxDraw)
		removeEventHandler("onClientPreRender", root, interpolateCamera)
		position = 0
		kameraVon, kameraZu = nil, nil
		setIntroHud(true)
		setElementData(localPlayer, "redfieldClick", false)
		triggerServerEvent("spawnAfterIntro", localPlayer, localPlayer)
		setTimer(function()
			fadeCamera(true, 1.5)
			setElementData(localPlayer,"inIntro",false)
		end, 500, 1)
	end, 1000, 1)
end