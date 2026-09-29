local sx, sy = guiGetScreenSize()
local scale = math.min(sx / 1920, sy / 1080)

local tuningOpen = false
local tuningEdits = {}
local activeEdit = nil

local function isCursorOnElement(x, y, w, h)
	if not isCursorShowing() then return false end
	local cx, cy = getCursorPosition()
	if not cx or not cy then return false end
	cx, cy = cx * sx, cy * sy
	return cx >= x and cx <= x + w and cy >= y and cy <= y + h
end

local function getTuningLayout()
	local w, h = 500 * scale, 280 * scale
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

local function drawEdit(index, label, x, y, w, h)
	local hover = isCursorOnElement(x, y, w, h)
	local focused = activeEdit == index
	local text = isElement(tuningEdits[index]) and guiGetText(tuningEdits[index]) or ""

	dxDrawRectangle(x, y, w, h, focused and tocolor(0, 100, 200, 255) or hover and tocolor(35, 35, 35, 255) or tocolor(20, 20, 20, 255), false)
	dxDrawRectangle(x, y + h - 2 * scale, w, 2 * scale, tocolor(0, 100, 200, 255), false)
	dxDrawText(label, x, y - 24 * scale, x + w, y, tocolor(180, 180, 180, 255), 1 * scale, "default-bold", "center", "center")
	dxDrawText(text, x + 8 * scale, y, x + w - 8 * scale, y + h, tocolor(255, 255, 255, 255), 1 * scale, "default-bold", "center", "center", true)
end

local function createTuningEdits()
	for i = 1, 3 do
		tuningEdits[i] = guiCreateEdit(-1, -1, 1, 1, "", false)
		guiEditSetMaxLength(tuningEdits[i], 3)
		guiSetAlpha(tuningEdits[i], 0)
	end
end

local function destroyTuningEdits()
	for i = 1, 3 do
		if isElement(tuningEdits[i]) then destroyElement(tuningEdits[i]) end
	end
	tuningEdits = {}
	activeEdit = nil
	guiSetInputEnabled(false)
end

local function renderTuning()
	if not tuningOpen then return end

	local x, y, w, h, padding = getTuningLayout()
	local contentW = w - padding * 2
	local editGap = 10 * scale
	local editW = (contentW - editGap * 2) / 3
	local editH = 46 * scale
	local editY = y + 125 * scale
	local buttonH = 44 * scale
	local buttonGap = 10 * scale
	local buttonW = (contentW - buttonGap) / 2
	local buttonY = y + h - padding - buttonH

	dxDrawRectangle(x, y, w, h, tocolor(0, 0, 0, 240), false)
	dxDrawRectangle(x, y, w, 3 * scale, tocolor(0, 100, 200, 255), false)
	dxDrawRectangle(x + padding, y + 20 * scale, contentW, 65 * scale, tocolor(20, 20, 20, 255), false)
	dxDrawRectangle(x + padding, y + 20 * scale, 3 * scale, 65 * scale, tocolor(0, 100, 200, 255), false)
	dxDrawText(getText("Tuning2"), x + padding + 15 * scale, y + 20 * scale, x + w - padding - 15 * scale, y + 85 * scale, tocolor(255, 255, 255, 255), 1 * scale, "default-bold", "center", "center", true, true)

	drawEdit(1, "R", x + padding, editY, editW, editH)
	drawEdit(2, "G", x + padding + editW + editGap, editY, editW, editH)
	drawEdit(3, "B", x + padding + (editW + editGap) * 2, editY, editW, editH)

	drawButton(getText("Tuning3"), x + padding, buttonY, buttonW, buttonH)
	drawButton(getText("Tuning4"), x + padding + buttonW + buttonGap, buttonY, buttonW, buttonH)
end

local function closeTuningWindow()
	if not tuningOpen then return end
	tuningOpen = false
	removeEventHandler("onClientRender", root, renderTuning)
	removeEventHandler("onClientClick", root, tuningClick)
	destroyTuningEdits()
	showCursor(false)
	setElementData(localPlayer, "redfieldClick", false)
end

local function selectTuningEdit(index)
	if not isElement(tuningEdits[index]) then return end
	activeEdit = index
	guiBringToFront(tuningEdits[index])
	guiFocus(tuningEdits[index])
	guiSetInputEnabled(true)
end

function tuningClick(button, state)
	if not tuningOpen or button ~= "left" or state ~= "down" then return end

	local x, y, w, h, padding = getTuningLayout()
	local contentW = w - padding * 2
	local editGap = 10 * scale
	local editW = (contentW - editGap * 2) / 3
	local editH = 46 * scale
	local editY = y + 125 * scale
	local buttonH = 44 * scale
	local buttonGap = 10 * scale
	local buttonW = (contentW - buttonGap) / 2
	local buttonY = y + h - padding - buttonH

	for i = 1, 3 do
		local editX = x + padding + (i - 1) * (editW + editGap)
		if isCursorOnElement(editX, editY, editW, editH) then
			selectTuningEdit(i)
			return
		end
	end

	if isCursorOnElement(x + padding, buttonY, buttonW, buttonH) then
		local r = guiGetText(tuningEdits[1])
		local g = guiGetText(tuningEdits[2])
		local b = guiGetText(tuningEdits[3])

		if r == "" and g == "" and b == "" then
			r = math.random(1, 255)
			g = math.random(1, 255)
			b = math.random(1, 255)
		else
			r, g, b = tonumber(r), tonumber(g), tonumber(b)
			if not r or not g or not b or r < 0 or r > 255 or g < 0 or g > 255 or b < 0 or b > 255 or r % 1 ~= 0 or g % 1 ~= 0 or b % 1 ~= 0 then
				return
			end
		end

		triggerServerEvent("changeColor", localPlayer, r, g, b)
		return
	end

	if isCursorOnElement(x + padding + buttonW + buttonGap, buttonY, buttonW, buttonH) then
		closeTuningWindow()
	end
end

function createTankWindow()
	if tuningOpen then return end
	if getElementData(localPlayer, "redfieldClick") == true then return end

	tuningOpen = true
	activeEdit = nil
	showCursor(true)
	setElementData(localPlayer, "redfieldClick", true)
	createTuningEdits()
	addEventHandler("onClientRender", root, renderTuning)
	addEventHandler("onClientClick", root, tuningClick)
end
addEvent("openTuningWindow", true)
addEventHandler("openTuningWindow", root, createTankWindow)

addEventHandler("onClientPlayerWasted", localPlayer, function()
	closeTuningWindow()
end)