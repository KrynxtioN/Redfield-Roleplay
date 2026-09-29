local sx, sy = guiGetScreenSize()
local scale = math.min(sx / 1920, sy / 1080)

local bankMode = nil
local bankEdit = nil

local function isCursorOnElement(x, y, width, height)
	if not isCursorShowing() then return false end
	local cx, cy = getCursorPosition()
	if not cx or not cy then return false end
	cx, cy = cx * sx, cy * sy
	return cx >= x and cx <= x + width and cy >= y and cy <= y + height
end

local function getBankLayout()
	local width = 450 * scale
	local height = bankMode == "pin" and 300 * scale or 410 * scale
	local x, y = (sx - width) / 2, (sy - height) / 2
	local padding = 15 * scale
	return x, y, width, height, padding
end

local function createBankEdit(masked)
	if isElement(bankEdit) then destroyElement(bankEdit) end
	bankEdit = guiCreateEdit(-1, -1, 1, 1, "", true)
	guiEditSetMaxLength(bankEdit, 10)
	guiEditSetMasked(bankEdit, masked == true)
	guiSetAlpha(bankEdit, 0)
	guiBringToFront(bankEdit)
	guiFocus(bankEdit)
end

local function getBankEditText()
	if not isElement(bankEdit) then return "" end
	return guiGetText(bankEdit)
end

local function clearBankEdit()
	if isElement(bankEdit) then
		guiSetText(bankEdit, "")
		guiFocus(bankEdit)
	end
end

local function drawButton(text, x, y, width, height)
	local hover = isCursorOnElement(x, y, width, height)
	dxDrawRectangle(x, y, width, height, hover and tocolor(0, 100, 200, 255) or tocolor(30, 30, 30, 255), false)
	dxDrawRectangle(x, y + height - 2 * scale, width, 2 * scale, tocolor(0, 100, 200, 255), false)
	dxDrawText(text, x + 8 * scale, y, x + width - 8 * scale, y + height, tocolor(255, 255, 255, 255), 1 * scale, "default-bold", "center", "center", true)
end

local function drawInput(x, y, width, height, masked)
	local text = getBankEditText()
	if masked and text ~= "" then text = string.rep("*", utf8.len(text) or #text) end

	local cursor = ""
	if isElement(bankEdit) and getTickCount() % 1000 < 500 then
		cursor = "|"
	end

	dxDrawRectangle(x, y, width, height, tocolor(20, 20, 20, 255), false)
	dxDrawRectangle(x, y + height - 2 * scale, width, 2 * scale, tocolor(0, 100, 200, 255), false)
	dxDrawText(text .. cursor, x + 12 * scale, y, x + width - 12 * scale, y + height, tocolor(255, 255, 255, 255), 1 * scale, "default-bold", "left", "center", true)
end

local function drawBankWindow()
	if not bankMode then return end
	local x, y, width, height, padding = getBankLayout()
	local contentWidth = width - padding * 2
	local inputWidth = contentWidth
	local inputHeight = 42 * scale
	local buttonHeight = 42 * scale

	dxDrawRectangle(x, y, width, height, tocolor(0, 0, 0, 240), false)
	dxDrawRectangle(x, y, width, 3 * scale, tocolor(0, 100, 200, 255), false)

	if bankMode == "pin" then
		local textY = y + 20 * scale
		local textHeight = 65 * scale
		local inputY = y + 100 * scale
		local buttonY = y + 165 * scale

		dxDrawRectangle(x + padding, textY, contentWidth, textHeight, tocolor(20, 20, 20, 255), false)
		dxDrawRectangle(x + padding, textY, 3 * scale, textHeight, tocolor(0, 100, 200, 255), false)
		dxDrawText(getText("Bank1"), x + padding + 15 * scale, textY, x + width - padding - 15 * scale, textY + textHeight, tocolor(255, 255, 255, 255), 1 * scale, "default-bold", "center", "center", true, true)

		drawInput(x + padding, inputY, inputWidth, inputHeight, true)
		drawButton(getText("Bank2"), x + padding, buttonY, contentWidth, buttonHeight)
		drawButton(getText("Bank3"), x + padding, buttonY + buttonHeight + 10 * scale, contentWidth, buttonHeight)
	else
		local bankmoney = tonumber(getElementData(localPlayer, "Bankmoney")) or 0
		local infoY = y + 20 * scale
		local infoHeight = 80 * scale
		local inputY = y + 120 * scale
		local buttonY = y + 182 * scale

		dxDrawRectangle(x + padding, infoY, contentWidth, infoHeight, tocolor(20, 20, 20, 255), false)
		dxDrawRectangle(x + padding, infoY, 3 * scale, infoHeight, tocolor(0, 100, 200, 255), false)
		dxDrawText(getText("Bank7"):format(bankmoney), x + padding + 15 * scale, infoY + 8 * scale, x + width - padding - 15 * scale, infoY + 40 * scale, tocolor(255, 255, 255, 255), 1 * scale, "default-bold", "center", "center", true)

		drawInput(x + padding, inputY, inputWidth, inputHeight, false)
		drawButton(getText("Bank9"), x + padding, buttonY, contentWidth, buttonHeight)
		drawButton(getText("Bank8"), x + padding, buttonY + buttonHeight + 10 * scale, contentWidth, buttonHeight)
		drawButton(getText("Bank3"), x + padding, buttonY + (buttonHeight + 10 * scale) * 2, contentWidth, buttonHeight)
	end
end

function closeBankWindow(sendServer)
	if not bankMode and not isElement(bankEdit) then return end

	bankMode = nil
	if isElement(bankEdit) then destroyElement(bankEdit) end
	bankEdit = nil

	removeEventHandler("onClientRender", root, drawBankWindow)
	removeEventHandler("onClientClick", root, bankWindowClick)
	guiSetInputEnabled(false)
	showCursor(false)
	setElementData(localPlayer, "redfieldClick", false)

	if sendServer then
		triggerServerEvent("closeBankSession", localPlayer)
	end
end

local function submitBankPin()
	local pin = getBankEditText()

	if pin == "" then
		infobox(getText("Bank4"), 255, 0, 0)
		return
	end

	if not tonumber(pin) then
		infobox(getText("Bank5"), 255, 0, 0)
		return
	end

	triggerServerEvent("checkBankPin", localPlayer, pin)
end

local function getBankAmount()
	local text = getBankEditText()
	local amount = tonumber(text)

	if text == "" then
		infobox(getText("Bank10"), 255, 0, 0)
		return nil
	end

	if not amount or amount <= 0 or amount ~= math.floor(amount) then
		infobox(getText("Bank11"), 255, 0, 0)
		return nil
	end

	return amount
end

function bankWindowClick(button, state)
	if not bankMode or button ~= "left" or state ~= "down" then return end

	local x, y, width, height, padding = getBankLayout()
	local contentWidth = width - padding * 2
	local inputHeight = 42 * scale
	local buttonHeight = 42 * scale

	if bankMode == "pin" then
		local inputY = y + 100 * scale
		local buttonY = y + 165 * scale

		if isCursorOnElement(x + padding, inputY, contentWidth, inputHeight) then
			if isElement(bankEdit) then guiFocus(bankEdit) end
			return
		end

		if isCursorOnElement(x + padding, buttonY, contentWidth, buttonHeight) then
			submitBankPin()
			return
		end

		if isCursorOnElement(x + padding, buttonY + buttonHeight + 10 * scale, contentWidth, buttonHeight) then
			closeBankWindow(true)
		end
	else
		local inputY = y + 120 * scale
		local buttonY = y + 182 * scale

		if isCursorOnElement(x + padding, inputY, contentWidth, inputHeight) then
			if isElement(bankEdit) then guiFocus(bankEdit) end
			return
		end

		if isCursorOnElement(x + padding, buttonY, contentWidth, buttonHeight) then
			local amount = getBankAmount()
			if amount then triggerServerEvent("einzahlenServer", localPlayer, amount) end
			return
		end

		if isCursorOnElement(x + padding, buttonY + buttonHeight + 10 * scale, contentWidth, buttonHeight) then
			local amount = getBankAmount()
			if amount then triggerServerEvent("auszahlenServer", localPlayer, amount) end
			return
		end

		if isCursorOnElement(x + padding, buttonY + (buttonHeight + 10 * scale) * 2, contentWidth, buttonHeight) then
			closeBankWindow(true)
		end
	end
end

function bankpinWindow()
	if bankMode then return end
	if getElementData(localPlayer, "redfieldClick") == true then return end

	bankMode = "pin"
	showCursor(true)
	setElementData(localPlayer, "redfieldClick", true)
	createBankEdit(true)
	guiSetInputEnabled(true)
	addEventHandler("onClientRender", root, drawBankWindow)
	addEventHandler("onClientClick", root, bankWindowClick)
end
addEvent("bankpinWindow", true)
addEventHandler("bankpinWindow", root, bankpinWindow)

function atmWindow()
	bankMode = "atm"
	createBankEdit(false)
	guiSetInputEnabled(true)
end

addEvent("bankPinCorrect", true)
addEventHandler("bankPinCorrect", root, function()
	if bankMode ~= "pin" then return end
	if isElement(bankEdit) then destroyElement(bankEdit) end
	bankEdit = nil
	atmWindow()
end)

addEvent("bankPinWrong", true)
addEventHandler("bankPinWrong", root, function()
	infobox(getText("Bank6"), 255, 0, 0)
	clearBankEdit()
end)

function updateMoneyLabel()
	if bankMode ~= "atm" then return end
	clearBankEdit()
end
addEvent("updateMoneyLabel", true)
addEventHandler("updateMoneyLabel", root, updateMoneyLabel)

addEventHandler("onClientPlayerWasted", localPlayer, function()
	closeBankWindow(true)
end)