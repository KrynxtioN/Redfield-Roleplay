local Anmeldung = {}
local sx, sy = guiGetScreenSize()
local german = false
local english = true
local selectedTab = 1
local password = ""
local passwordActive = false
local loginVisible = false

setElementInterior(localPlayer,0)
setElementDimension(localPlayer,0)

setElementData(localPlayer, "loggedin", 0)
setElementData(localPlayer, "redfieldClick", false)
setElementData(localPlayer, "Language", 1)

local function isCursorOnElement(x, y, width, height)
	if not isCursorShowing() then return false end
	local cx, cy = getCursorPosition()
	if not cx or not cy then return false end
	cx, cy = cx * sx, cy * sy
	return cx >= x and cx <= x + width and cy >= y and cy <= y + height
end

local function getLoginText(germanText, englishText)
	if english then return englishText end
	return germanText
end

local function drawButton(text, x, y, width, height, active)
	local hover = isCursorOnElement(x, y, width, height)
	local background = tocolor(235, 235, 235, 235)
	local textColor = tocolor(30, 30, 30, 255)
	if hover then background = tocolor(215, 225, 235, 245) end
	if active then
		background = tocolor(0, 100, 200, 245)
		textColor = tocolor(255, 255, 255, 255)
	end
	dxDrawRectangle(x, y, width, height, background, false)
	dxDrawRectangle(x, y + height - 2, width, 2, tocolor(0, 100, 200, 255), false)
	dxDrawText(text, x, y, x + width, y + height, textColor, 1, "default-bold", "center", "center", true, false, false)
end

local function drawEdit(text, placeholder, x, y, width, height, active)
	local hover = isCursorOnElement(x, y, width, height)
	local border = tocolor(175, 175, 175, 255)
	if hover then border = tocolor(0, 120, 220, 255) end
	if active then border = tocolor(0, 100, 200, 255) end
	dxDrawRectangle(x, y, width, height, tocolor(240, 240, 240, 245), false)
	dxDrawRectangle(x, y, width, 1, border, false)
	dxDrawRectangle(x, y + height - 2, width, 2, border, false)
	dxDrawRectangle(x, y, 1, height, border, false)
	dxDrawRectangle(x + width - 1, y, 1, height, border, false)
	local displayText = text
	if displayText == "" then
		dxDrawText(placeholder, x + 10, y, x + width - 10, y + height, tocolor(120, 120, 120, 255), 1, "default", "left", "center", true, false, false)
	else
		dxDrawText(displayText, x + 10, y, x + width - 10, y + height, tocolor(25, 25, 25, 255), 1, "default-bold", "left", "center", true, false, false)
	end
	if active and getTickCount() % 1000 < 500 then
		local textWidth = dxGetTextWidth(displayText, 1, "default-bold")
		local cursorX = x + 10 + textWidth + 2
		if cursorX > x + width - 10 then cursorX = x + width - 10 end
		dxDrawRectangle(cursorX, y + 8, 1, height - 16, tocolor(0, 100, 200, 255), false)
	end
end

local function blackBalken()
	dxDrawRectangle(0, 0, sx, 49 * (sy / 900), tocolor(0, 0, 0, 255), false)
	dxDrawRectangle(0, 851 * (sy / 900), sx, 49 * (sy / 900), tocolor(0, 0, 0, 255), false)
end

local function drawAnmeldung()
	if not loginVisible then return end
	dxDrawImage(0, 0, sx, sy, "Images/Login.png", 0, 0, 0, tocolor(255, 255, 255, 255), false)
	blackBalken()

	local x = sx * 0.31
	local y = sy * 0.47
	local width = sx * 0.40
	local height = sy * 0.20
	local padding = width * 0.02
	local gap = width * 0.015

	local tabGap = width * 0.015
	local tabWidth = width * 0.245
	local tabHeight = height * 0.20
	local tabsWidth = tabWidth * 2 + tabGap
	local tabX = x + (width - tabsWidth) / 2
	local tabY = y

	drawButton(getLoginText("Einloggen", "Login"), tabX, tabY, tabWidth, tabHeight, selectedTab == 1)
	drawButton(getLoginText("Registrieren", "Register"), tabX + tabWidth + tabGap, tabY, tabWidth, tabHeight, selectedTab == 2)

	local labelY = y + height * 0.26
	local fieldY = y + height * 0.39
	local fieldHeight = height * 0.18
	local fieldWidth = (width - padding * 2 - gap) / 2
	local usernameX = x + padding
	local passwordX = usernameX + fieldWidth + gap

	dxDrawText("Username", usernameX, labelY, usernameX + fieldWidth, fieldY, tocolor(255, 255, 255, 255), 1, "default-bold", "center", "center")
	dxDrawText(getLoginText("Passwort", "Password"), passwordX, labelY, passwordX + fieldWidth, fieldY, tocolor(255, 255, 255, 255), 1, "default-bold", "center", "center")
	drawEdit(getPlayerName(localPlayer), "Username", usernameX, fieldY, fieldWidth, fieldHeight, false)

	local maskedPassword = ""
	if password ~= "" then maskedPassword = string.rep("*", utf8.len(password) or 0) end
	drawEdit(maskedPassword, getLoginText("Passwort", "Password"), passwordX, fieldY, fieldWidth, fieldHeight, passwordActive)

	local buttonX = x + padding
	local buttonY = y + height * 0.69
	local buttonWidth = width - padding * 2
	local buttonHeight = height * 0.23
	drawButton(selectedTab == 1 and getLoginText("Einloggen", "Login") or getLoginText("Registrieren", "Register"), buttonX, buttonY, buttonWidth, buttonHeight, true)
end

local function submitAnmeldung()
	if password == "" then
		infobox(getText("Anmeldung6"), 255, 0, 0)
		return
	end
	if (utf8.len(password) or 0) < 4 then
		infobox(getText("Anmeldung7"), 255, 0, 0)
		return
	end
	local name = getPlayerName(localPlayer)
	if selectedTab == 1 then
		triggerServerEvent("redfieldEinloggen", localPlayer, name, password)
	else
		if german then
			triggerServerEvent("redfieldRegistrieren", localPlayer, name, password, 0)
		elseif english then
			triggerServerEvent("redfieldRegistrieren", localPlayer, name, password, 1)
		end
	end
end

local function clickAnmeldung(button, state)
	if not loginVisible or button ~= "left" or state ~= "down" then return end
	local x = sx * 0.31
	local y = sy * 0.47
	local width = sx * 0.40
	local height = sy * 0.20
	local padding = width * 0.02
	local gap = width * 0.015

	local tabGap = width * 0.015
	local tabWidth = width * 0.245
	local tabHeight = height * 0.20
	local tabsWidth = tabWidth * 2 + tabGap
	local tabX = x + (width - tabsWidth) / 2
	local tabY = y

	local fieldY = y + height * 0.39
	local fieldHeight = height * 0.18
	local fieldWidth = (width - padding * 2 - gap) / 2
	local usernameX = x + padding
	local passwordX = usernameX + fieldWidth + gap

	if isCursorOnElement(tabX, tabY, tabWidth, tabHeight) then
		selectedTab = 1
		password = ""
		passwordActive = false
		return
	end
	if isCursorOnElement(tabX + tabWidth + tabGap, tabY, tabWidth, tabHeight) then
		selectedTab = 2
		password = ""
		passwordActive = false
		return
	end
	if isCursorOnElement(passwordX, fieldY, fieldWidth, fieldHeight) then
		passwordActive = true
		return
	end

	local buttonX = x + padding
	local buttonY = y + height * 0.69
	local buttonWidth = width - padding * 2
	local buttonHeight = height * 0.23

	if isCursorOnElement(buttonX, buttonY, buttonWidth, buttonHeight) then
		passwordActive = false
		submitAnmeldung()
		return
	end

	if isCursorOnElement(sx * 0.34, sy * 0.69, sx * 0.14, sy * 0.10) then
		english = true
		german = false
		setElementData(localPlayer, "Language", 1)
		setElementData(localPlayer, "german", false)
		return
	end

	if isCursorOnElement(sx * 0.54, sy * 0.69, sx * 0.14, sy * 0.10) then
		english = false
		german = true
		setElementData(localPlayer, "Language", 0)
		setElementData(localPlayer, "german", true)
		return
	end

	passwordActive = false
end

local function characterAnmeldung(character)
	if not loginVisible or not passwordActive then return end
	local length = utf8.len(password) or 0
	if length >= 64 then return end
	password = password .. character
end

local function keyAnmeldung(button, press)
	if not loginVisible or not passwordActive or not press then return end
	if button == "backspace" then
		local length = utf8.len(password) or 0
		if length > 0 then password = utf8.sub(password, 1, length - 1) end
		cancelEvent()
	elseif button == "enter" then
		passwordActive = false
		submitAnmeldung()
		cancelEvent()
	elseif button == "tab" then
		passwordActive = true
		cancelEvent()
	end
end

local function startAnmeldung()
	if loginVisible then return end
	loginVisible = true
	selectedTab = 1
	password = ""
	passwordActive = false
	german = false
	english = true

	showChat(false)
	fadeCamera(true)
	showCursor(true)
	setElementData(localPlayer, "Language", 1)
	setElementData(localPlayer, "german", false)
	setElementData(localPlayer, "redfieldClick", true)
	setPlayerHudComponentVisible("radar", false)
	setCameraMatrix(-181.89030456543, 1188.7331542969, 75.061599731445, -181.4167175293, 1188.0411376953, 74.516807556152, 0, 70)

	addEventHandler("onClientRender", root, drawAnmeldung)
	addEventHandler("onClientClick", root, clickAnmeldung)
	addEventHandler("onClientCharacter", root, characterAnmeldung)
	addEventHandler("onClientKey", root, keyAnmeldung)
end
addEventHandler("onClientResourceStart", resourceRoot, startAnmeldung)

function destroyAnmeldung()
	if not loginVisible then return end
	loginVisible = false
	password = ""
	passwordActive = false

	removeEventHandler("onClientRender", root, drawAnmeldung)
	removeEventHandler("onClientClick", root, clickAnmeldung)
	removeEventHandler("onClientCharacter", root, characterAnmeldung)
	removeEventHandler("onClientKey", root, keyAnmeldung)

	showChat(true)
	showCursor(false)
	setCameraTarget(localPlayer)
	setPlayerHudComponentVisible("radar", true)
	setElementData(localPlayer, "redfieldClick", false)
end
addEvent("destroyAnmeldung", true)
addEventHandler("destroyAnmeldung", root, destroyAnmeldung)

addEventHandler("onClientResourceStop", resourceRoot, function()
	if not loginVisible then return end
	removeEventHandler("onClientRender", root, drawAnmeldung)
	removeEventHandler("onClientClick", root, clickAnmeldung)
	removeEventHandler("onClientCharacter", root, characterAnmeldung)
	removeEventHandler("onClientKey", root, keyAnmeldung)
end)