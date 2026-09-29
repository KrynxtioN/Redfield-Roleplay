local sx, sy = guiGetScreenSize()
local scale = math.min(sx / 1920, sy / 1080)

local inventoryVisible = false
local selectedItem = nil
local scroll = 0
local visibleRows = 9
local showInvObject = nil
local lastClickTick = 0
local lastClickItem = nil
local lastAmountClickTick = 0
local amountSortDescending = true

local inventoryItems = {
	{data = "Eichenholz", name = {[0] = "Eichenholz", [1] = "Oak wood"}},
	{data = "Birkenholz", name = {[0] = "Birkenholz", [1] = "Birch wood"}},
	{data = "Drogen", name = {[0] = "Drogen", [1] = "Drugs"}},
	{data = "Mats", name = {[0] = "Materialien", [1] = "Mats"}},
	{data = "Objekt1704", model = 1704, name = {[0] = "Sessel", [1] = "Armchair"}},
	{data = "Objekt1705", model = 1705, name = {[0] = "Sessel 2", [1] = "Armchair 2"}},
	{data = "Objekt1708", model = 1708, name = {[0] = "Sessel 3", [1] = "Armchair 3"}},
	{data = "Objekt1711", model = 1711, name = {[0] = "Stuhl", [1] = "Chair"}},
	{data = "Objekt1720", model = 1720, name = {[0] = "Sofa", [1] = "Sofa"}},
	{data = "Objekt1723", model = 1723, name = {[0] = "Sofa 2", [1] = "Sofa 2"}},
	{data = "Objekt1726", model = 1726, name = {[0] = "Sessel 4", [1] = "Armchair 4"}},
	{data = "Objekt1727", model = 1727, name = {[0] = "Sessel 5", [1] = "Armchair 5"}},
	{data = "Objekt1728", model = 1728, name = {[0] = "Sessel 6", [1] = "Armchair 6"}},
	{data = "Objekt1729", model = 1729, name = {[0] = "Sessel 7", [1] = "Armchair 7"}},
	{data = "Objekt1739", model = 1739, name = {[0] = "Regal", [1] = "Shelf"}},
	{data = "Objekt1825", model = 1825, name = {[0] = "Tisch", [1] = "Table"}},
	{data = "Objekt1896", model = 1896, name = {[0] = "Stuhl 2", [1] = "Chair 2"}},
	{data = "Objekt1998", model = 1998, name = {[0] = "Schreibtisch", [1] = "Desk"}},
	{data = "Objekt2096", model = 2096, name = {[0] = "Stereoanlage", [1] = "Stereo"}},
	{data = "Objekt2205", model = 2205, name = {[0] = "Schreibtisch 2", [1] = "Desk 2"}},
	{data = "Objekt2313", model = 2313, name = {[0] = "Fernsehtisch", [1] = "TV Stand"}},
	{data = "Objekt1518", model = 1518, name = {[0] = "Fernseher", [1] = "Television"}},
	{data = "Objekt1752", model = 1752, name = {[0] = "Stereoanlage 2", [1] = "Stereo 2"}},
	{data = "Objekt1786", model = 1786, name = {[0] = "Fernseher 2", [1] = "Television 2"}},
	{data = "Objekt16377", model = 16377, name = {[0] = "Dekoration", [1] = "Decoration"}},
	{data = "Objekt638", model = 638, name = {[0] = "Pflanze", [1] = "Plant"}, outdoor = true},
	{data = "Objekt970", model = 970, name = {[0] = "Zaun", [1] = "Fence"}, outdoor = true},
	{data = "Objekt17037", model = 17037, name = {[0] = "Außenobjekt", [1] = "Outdoor Object"}, outdoor = true},
	{data = "Objekt2526", model = 2526, name = {[0] = "Badewanne", [1] = "Bathtub"}},
	{data = "Objekt2514", model = 2514, name = {[0] = "Toilette", [1] = "Toilet"}},
	{data = "Objekt2527", model = 2527, name = {[0] = "Dusche", [1] = "Shower"}},
	{data = "Objekt2524", model = 2524, name = {[0] = "Waschbecken", [1] = "Sink"}}
}

local function getInventoryItemName(item)
	local language = tonumber(getElementData(localPlayer, "Language")) or 0
	if language ~= 0 and language ~= 1 then language = 0 end
	return item.name[language] or item.name[0]
end

local function getVisibleInventoryItems()
	local items = {}
	for _, item in ipairs(inventoryItems) do
		if (tonumber(getElementData(localPlayer, item.data)) or 0) > 0 then
			table.insert(items, item)
		end
	end
	return items
end

local function isCursorOnElement(x, y, w, h)
	if not isCursorShowing() then return false end
	local cx, cy = getCursorPosition()
	if not cx or not cy then return false end
	cx, cy = cx * sx, cy * sy
	return cx >= x and cx <= x + w and cy >= y and cy <= y + h
end

local function getInventoryLayout()
	local w, h = 500 * scale, 530 * scale
	local x, y = (sx - w) / 2, (sy - h) / 2
	local padding = 15 * scale
	local headerH = 48 * scale
	local columnH = 34 * scale
	local rowH = 42 * scale
	local listY = y + headerH + columnH
	return x, y, w, h, padding, headerH, columnH, rowH, listY
end

local function destroyPreview()
	removeEventHandler("onClientRender", root, rotateshowInvObject)
	if isElement(showInvObject) then destroyElement(showInvObject) end
	showInvObject = nil
end

local function createPreview(item)
	if not item or not item.model or getElementInterior(localPlayer) ~= 0 then return end
	destroyPreview()
	local x, y, z = getElementPosition(localPlayer)
	showInvObject = createObject(item.model, x, y - 4, z + 2)
	if not isElement(showInvObject) then return end
	setElementDimension(showInvObject, getElementDimension(localPlayer))
	setObjectScale(showInvObject, 0.5)
	setElementCollisionsEnabled(showInvObject, false)
	addEventHandler("onClientRender", root, rotateshowInvObject)
end

local function closeInventar()
	if not inventoryVisible then return end
	inventoryVisible = false
	selectedItem = nil
	scroll = 0
	lastClickTick = 0
	lastClickItem = nil
	lastAmountClickTick = 0
	destroyPreview()
	removeEventHandler("onClientRender", root, drawInventory)
	removeEventHandler("onClientClick", root, inventoryClick)
	unbindKey("mouse_wheel_up", "down", inventoryScrollUp)
	unbindKey("mouse_wheel_down", "down", inventoryScrollDown)
	showCursor(false)
	setElementData(localPlayer, "redfieldClick", false)
end

local function useInventoryItem(item)
	if not item or not item.model then return end

	if (tonumber(getElementData(localPlayer, item.data)) or 0) <= 0 then
		infobox(getText("Inventar5"), 255, 0, 0)
		return
	end

	if item.outdoor then
		if getElementInterior(localPlayer) ~= 0 then
			infobox(getText("Inventar6"), 255, 0, 0)
			return
		end
	else
		if getElementData(localPlayer, "isPlayerInHouse") ~= true then
			infobox(getText("Inventar7"), 255, 255, 255)
			return
		end
	end

	triggerServerEvent("createnewobject", localPlayer, tostring(item.model))
	closeInventar()
end

local function sortInventoryByAmount()
	table.sort(inventoryItems, function(a, b)
		local amountA = tonumber(getElementData(localPlayer, a.data)) or 0
		local amountB = tonumber(getElementData(localPlayer, b.data)) or 0
		if amountA == amountB then return getInventoryItemName(a):lower() < getInventoryItemName(b):lower() end
		if amountSortDescending then return amountA > amountB else return amountA < amountB end
	end)
	amountSortDescending = not amountSortDescending
	selectedItem = nil
	scroll = 0
	lastClickTick = 0
	lastClickItem = nil
	destroyPreview()
end

function drawInventory()
	if not inventoryVisible then return end

	local items = getVisibleInventoryItems()
	local x, y, w, h, padding, headerH, columnH, rowH, listY = getInventoryLayout()
	local contentW = w - padding * 2
	local scrollGap = 8 * scale
	local scrollWidth = 4 * scale
	local rowWidth = contentW - scrollGap - scrollWidth
	local amountWidth = 110 * scale
	local nameWidth = rowWidth - amountWidth
	local listH = visibleRows * rowH

	if scroll > math.max(0, #items - visibleRows) then scroll = math.max(0, #items - visibleRows) end

	dxDrawRectangle(x, y, w, h, tocolor(0, 0, 0, 240), false)
	dxDrawRectangle(x, y, w, 3 * scale, tocolor(0, 100, 200, 255), false)
	dxDrawText(getText("Inventar2"), x + padding, y, x + w - padding, y + headerH, tocolor(255, 255, 255, 255), 1.15 * scale, "default-bold", "left", "center")

	dxDrawRectangle(x + padding, y + headerH, rowWidth, columnH, tocolor(20, 20, 20, 255), false)
	dxDrawText(getText("Inventar2"), x + padding + 10 * scale, y + headerH, x + padding + nameWidth, y + headerH + columnH, tocolor(200, 200, 200, 255), 1 * scale, "default-bold", "left", "center")
	dxDrawText(getText("Inventar3"), x + padding + nameWidth, y + headerH, x + padding + rowWidth - 10 * scale, y + headerH + columnH, tocolor(200, 200, 200, 255), 1 * scale, "default-bold", "right", "center")

	for row = 1, visibleRows do
		local index = scroll + row
		local item = items[index]
		if item then
			local rowY = listY + (row - 1) * rowH
			local hover = isCursorOnElement(x + padding, rowY, rowWidth, rowH)
			local selected = selectedItem == item

			if selected then
				dxDrawRectangle(x + padding, rowY, rowWidth, rowH - 2 * scale, tocolor(0, 100, 200, 255), false)
			elseif hover then
				dxDrawRectangle(x + padding, rowY, rowWidth, rowH - 2 * scale, tocolor(35, 35, 35, 255), false)
			else
				dxDrawRectangle(x + padding, rowY, rowWidth, rowH - 2 * scale, tocolor(22, 22, 22, 235), false)
			end

			local amount = tonumber(getElementData(localPlayer, item.data)) or 0
			dxDrawText(getInventoryItemName(item), x + padding + 10 * scale, rowY, x + padding + nameWidth, rowY + rowH - 2 * scale, tocolor(255, 255, 255, 255), 1 * scale, "default-bold", "left", "center", true)
			dxDrawText(tostring(amount), x + padding + nameWidth, rowY, x + padding + rowWidth - 10 * scale, rowY + rowH - 2 * scale, tocolor(255, 255, 255, 255), 1 * scale, "default-bold", "right", "center")
		end
	end

	if #items > visibleRows then
		local barX = x + padding + rowWidth + scrollGap
		local maxScroll = #items - visibleRows
		local thumbH = math.max(35 * scale, listH * (visibleRows / #items))
		local thumbY = listY
		if maxScroll > 0 then thumbY = listY + (listH - thumbH) * (scroll / maxScroll) end
		dxDrawRectangle(barX, listY, scrollWidth, listH, tocolor(30, 30, 30, 255), false)
		dxDrawRectangle(barX, thumbY, scrollWidth, thumbH, tocolor(0, 100, 200, 255), false)
	end
end

function inventoryClick(button, state)
	if not inventoryVisible or button ~= "left" or state ~= "down" then return end

	local items = getVisibleInventoryItems()
	local x, y, w, h, padding, headerH, columnH, rowH, listY = getInventoryLayout()
	local contentW = w - padding * 2
	local scrollGap = 8 * scale
	local scrollWidth = 4 * scale
	local rowWidth = contentW - scrollGap - scrollWidth
	local amountWidth = 110 * scale
	local nameWidth = rowWidth - amountWidth

	if isCursorOnElement(x + padding + nameWidth, y + headerH, amountWidth, columnH) then
		local tick = getTickCount()
		if tick - lastAmountClickTick <= 400 then
			lastAmountClickTick = 0
			sortInventoryByAmount()
		else
			lastAmountClickTick = tick
		end
		return
	end

	lastAmountClickTick = 0

	for row = 1, visibleRows do
		local index = scroll + row
		local item = items[index]
		local rowY = listY + (row - 1) * rowH

		if item and isCursorOnElement(x + padding, rowY, rowWidth, rowH) then
			local tick = getTickCount()
			if lastClickItem == item and tick - lastClickTick <= 400 then
				lastClickTick = 0
				lastClickItem = nil
				useInventoryItem(item)
				return
			end

			selectedItem = item
			lastClickItem = item
			lastClickTick = tick
			createPreview(item)
			return
		end
	end
end

function inventoryScrollUp()
	if not inventoryVisible then return end
	scroll = math.max(0, scroll - 1)
end

function inventoryScrollDown()
	if not inventoryVisible then return end
	local items = getVisibleInventoryItems()
	scroll = math.min(math.max(0, #items - visibleRows), scroll + 1)
end

function inventarWindow()
	if getElementData(localPlayer, "loggedin") ~= 1 or inTutorial == true then return end

	if inventoryVisible then
		closeInventar()
		return
	end

	if getElementData(localPlayer, "redfieldClick") == true then return end

	if (tonumber(getElementData(localPlayer, "Knastzeit")) or 0) ~= 0 or (tonumber(getElementData(localPlayer, "Prisontime")) or 0) ~= 0 then
		infobox(getText("Inventar1"), 200, 0, 0)
		return
	end

	inventoryVisible = true
	selectedItem = nil
	scroll = 0
	lastClickTick = 0
	lastClickItem = nil
	lastAmountClickTick = 0
	showCursor(true)
	setElementData(localPlayer, "redfieldClick", true)
	addEventHandler("onClientRender", root, drawInventory)
	addEventHandler("onClientClick", root, inventoryClick)
	bindKey("mouse_wheel_up", "down", inventoryScrollUp)
	bindKey("mouse_wheel_down", "down", inventoryScrollDown)
	infobox(getText("Inventar4"), 0, 200, 0)
end

bindKey("i", "down", inventarWindow)

function rotateshowInvObject()
	if not isElement(showInvObject) then
		removeEventHandler("onClientRender", root, rotateshowInvObject)
		return
	end

	local rx, ry, rz = getElementRotation(showInvObject)
	setElementRotation(showInvObject, rx, ry, rz + 1)
end