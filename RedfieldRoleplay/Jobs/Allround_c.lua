local sx, sy = guiGetScreenSize()
local scale = math.min(sx / 1920, sy / 1080)

local jobWindowVisible = false
local currentJobType = nil

local jobTexts = {
	pizza = "Job5",
	tankwart = "Job6",
	pilot = "Job7",
	holzfaeller = "Job8",
	busfahrer = "Job9",
	farmer = "Job10"
}

local function isCursorOnElement(x, y, width, height)
	if not isCursorShowing() then return false end
	local cx, cy = getCursorPosition()
	if not cx or not cy then return false end
	cx, cy = cx * sx, cy * sy
	return cx >= x and cx <= x + width and cy >= y and cy <= y + height
end

local function getJobLayout()
	local width, height = 450 * scale, 260 * scale
	local x, y = (sx - width) / 2, (sy - height) / 2
	local padding = 15 * scale
	return x, y, width, height, padding
end

local function drawButton(text, x, y, width, height)
	local hover = isCursorOnElement(x, y, width, height)
	dxDrawRectangle(x, y, width, height, hover and tocolor(0, 100, 200, 255) or tocolor(30, 30, 30, 255), false)
	dxDrawRectangle(x, y + height - 2 * scale, width, 2 * scale, tocolor(0, 100, 200, 255), false)
	dxDrawText(text, x + 8 * scale, y, x + width - 8 * scale, y + height, tocolor(255, 255, 255, 255), 1 * scale, "default-bold", "center", "center", true)
end

local function drawJobWindow()
	if not jobWindowVisible or not currentJobType or not jobTexts[currentJobType] then return end

	local x, y, width, height, padding = getJobLayout()
	local contentWidth = width - padding * 2
	local buttonHeight = 42 * scale
	local buttonGap = 10 * scale
	local textY = y + 18 * scale
	local textHeight = 105 * scale
	local buttonY = textY + textHeight + 15 * scale

	dxDrawRectangle(x, y, width, height, tocolor(0, 0, 0, 240), false)
	dxDrawRectangle(x, y, width, 3 * scale, tocolor(0, 100, 200, 255), false)
	dxDrawRectangle(x + padding, textY, contentWidth, textHeight, tocolor(20, 20, 20, 255), false)
	dxDrawRectangle(x + padding, textY, 3 * scale, textHeight, tocolor(0, 100, 200, 255), false)
	dxDrawText(getText(jobTexts[currentJobType]), x + padding + 15 * scale, textY + 10 * scale, x + width - padding - 15 * scale, textY + textHeight - 10 * scale, tocolor(255, 255, 255, 255), 1 * scale, "default-bold", "center", "center", true, true)

	drawButton(getText("Job1"), x + padding, buttonY, contentWidth, buttonHeight)
	drawButton(getText("Job2"), x + padding, buttonY + buttonHeight + buttonGap, contentWidth, buttonHeight)
end

local function closeJobWindow()
	if not jobWindowVisible then return end
	jobWindowVisible = false
	currentJobType = nil
	removeEventHandler("onClientRender", root, drawJobWindow)
	removeEventHandler("onClientClick", root, jobWindowClick)
	showCursor(false)
	setElementData(localPlayer, "redfieldClick", false)
end

function jobWindowClick(button, state)
	if not jobWindowVisible or button ~= "left" or state ~= "down" then return end

	local x, y, width, height, padding = getJobLayout()
	local contentWidth = width - padding * 2
	local buttonHeight = 42 * scale
	local buttonGap = 10 * scale
	local buttonY = y + 138 * scale

	if isCursorOnElement(x + padding, buttonY, contentWidth, buttonHeight) then
		if currentJobType then triggerServerEvent("acceptJob", localPlayer, currentJobType) end
		return
	end

	if isCursorOnElement(x + padding, buttonY + buttonHeight + buttonGap, contentWidth, buttonHeight) then
		closeJobWindow()
	end
end

function openJobWindow(typ)
	if jobWindowVisible then return end
	if getElementData(localPlayer, "redfieldClick") == true then return end
	if not jobTexts[typ] then return end

	currentJobType = typ
	jobWindowVisible = true
	showCursor(true)
	setElementData(localPlayer, "redfieldClick", true)
	addEventHandler("onClientRender", root, drawJobWindow)
	addEventHandler("onClientClick", root, jobWindowClick)
end

addEvent("openJobWindow", true)
addEventHandler("openJobWindow", root, openJobWindow)

addEvent("jobAccepted", true)
addEventHandler("jobAccepted", root, function()
	closeJobWindow()
end)