local sx, sy = guiGetScreenSize()
local scale = math.min(sx / 1920, sy / 1080)

for i = 1, 4 do
	setInteriorFurnitureEnabled(i, false)
end

local showNormalObjectTabelle = {
	{1704, 500}, {1705, 500}, {1708, 600}, {1711, 650}, {1720, 700}, {1723, 800}, {1726, 900},
	{1727, 400}, {1728, 900}, {1729, 500}, {1739, 200}, {1825, 1000}, {1896, 1200}, {1998, 800},
	{2096, 500}, {2205, 800}, {2313, 750}, {1518, 1400}, {1752, 1600}, {1786, 1800}, {16377, 900}
}

local showBathObjectsTabelle = {
	{2526, 3000}, {2514, 1200}, {2527, 2000}, {2524, 1000}
}

local showOutsideObjectTabelle = {
	{638, 600}, {970, 700}, {17037, 2000}
}

local furnitureKategorieVisible = false
local showNormalObjectNumber, showBathObjectNumber, showOutdoorObjectNumber
local showNormalObjects, showBathObjects, showOutsideObjects
local showObject, dropObjekt, massDistance, camX, camY, camZ

local higher = {
	[638] = 0.6,
	[970] = 0.5,
	[17037] = 2.3
}

local function isCursorOnElement(x, y, width, height)
	if not isCursorShowing() then return false end
	local cx, cy = getCursorPosition()
	if not cx or not cy then return false end
	cx, cy = cx * sx, cy * sy
	return cx >= x and cx <= x + width and cy >= y and cy <= y + height
end

local function getFurnitureLayout()
	local width = math.min(390 * scale, sx * 0.45)
	local height = math.min(245 * scale, sy * 0.45)
	local x = (sx - width) / 2
	local y = (sy - height) / 2
	local padding = 15 * scale
	return x, y, width, height, padding
end

local function drawFurnitureButton(text, x, y, width, height)
	local hover = isCursorOnElement(x, y, width, height)
	dxDrawRectangle(x, y, width, height, hover and tocolor(0, 100, 200, 255) or tocolor(35, 35, 35, 255), false)
	dxDrawRectangle(x, y + height - 2 * scale, width, 2 * scale, tocolor(0, 100, 200, 255), false)
	dxDrawText(text, x + 8 * scale, y, x + width - 8 * scale, y + height, tocolor(255, 255, 255, 255), 1, "default-bold", "center", "center", true, false, false)
end

local function drawFurnitureKategorie()
	if not furnitureKategorieVisible then return end
	local x, y, width, height, padding = getFurnitureLayout()
	local buttonWidth = width - padding * 2
	local buttonHeight = 48 * scale
	local gap = 10 * scale
	local buttonY = y + 38 * scale

	dxDrawRectangle(x, y, width, height, tocolor(0, 0, 0, 240), false)
	dxDrawRectangle(x, y, width, 3 * scale, tocolor(0, 100, 200, 255), false)

	drawFurnitureButton(getText("Furniture8"), x + padding, buttonY, buttonWidth, buttonHeight)
	drawFurnitureButton(getText("Furniture9"), x + padding, buttonY + buttonHeight + gap, buttonWidth, buttonHeight)
	drawFurnitureButton(getText("Furniture10"), x + padding, buttonY + (buttonHeight + gap) * 2, buttonWidth, buttonHeight)
end

local function closeFurnitureKategorie()
	if not furnitureKategorieVisible then return end
	furnitureKategorieVisible = false
	removeEventHandler("onClientRender", root, drawFurnitureKategorie)
	removeEventHandler("onClientClick", root, clickFurnitureKategorie)
	showCursor(false)
	setElementData(localPlayer, "redfieldClick", false)
end

local function startFurniturePreview(category)
	if category == 1 then
		showNormalObjectNumber = 1
		showNormalObjects, showBathObjects, showOutsideObjects = true, false, false
		showObject = createObject(showNormalObjectTabelle[showNormalObjectNumber][1], 1723.720703125, -1663.48046875, 36.38969039917)
	elseif category == 2 then
		showBathObjectNumber = 1
		showNormalObjects, showBathObjects, showOutsideObjects = false, true, false
		showObject = createObject(showBathObjectsTabelle[showBathObjectNumber][1], 1723.720703125, -1663.48046875, 36.38969039917)
	elseif category == 3 then
		showOutdoorObjectNumber = 1
		showNormalObjects, showBathObjects, showOutsideObjects = false, false, true
		showObject = createObject(showOutsideObjectTabelle[showOutdoorObjectNumber][1], 1723.720703125, -1663.48046875, 36.38969039917)
	end

	if not isElement(showObject) then
		showNormalObjects, showBathObjects, showOutsideObjects = false, false, false
		return
	end

	setElementInterior(showObject, 18)
	furnitureKategorieVisible = false
	removeEventHandler("onClientRender", root, drawFurnitureKategorie)
	removeEventHandler("onClientClick", root, clickFurnitureKategorie)
	showCursor(false)
	createAllForObject()
end

function clickFurnitureKategorie(button, state)
	if not furnitureKategorieVisible or button ~= "left" or state ~= "down" then return end
	local x, y, width, height, padding = getFurnitureLayout()
	local buttonWidth = width - padding * 2
	local buttonHeight = 48 * scale
	local gap = 10 * scale
	local buttonY = y + 38 * scale

	if isCursorOnElement(x + padding, buttonY, buttonWidth, buttonHeight) then
		startFurniturePreview(1)
	elseif isCursorOnElement(x + padding, buttonY + buttonHeight + gap, buttonWidth, buttonHeight) then
		startFurniturePreview(2)
	elseif isCursorOnElement(x + padding, buttonY + (buttonHeight + gap) * 2, buttonWidth, buttonHeight) then
		startFurniturePreview(3)
	end
end

function openFurnitureKategorieWindow()
	if furnitureKategorieVisible then return end
	if getElementData(localPlayer, "redfieldClick") == true then return end
	furnitureKategorieVisible = true
	showCursor(true)
	setElementData(localPlayer, "redfieldClick", true)
	addEventHandler("onClientRender", root, drawFurnitureKategorie)
	addEventHandler("onClientClick", root, clickFurnitureKategorie)
end

function createAllForObject()
	showChat(false)
	setCameraMatrix(1712.9627685547, -1645.9943847656, 35.840400695801, 1713.4787597656, -1646.8331298828, 35.666633605957, 0, 70)
	addEventHandler("onClientRender", root, rotateShowObject)
	addEventHandler("onClientRender", root, drawObjectPreis)
	toggleAllControls(false)
	bindKey("enter", "down", buyObject)
	bindKey("space", "down", closeObject)
	bindKey("arrow_r", "down", newobjectRight)
	bindKey("arrow_l", "down", newobjectLeft)
end

local function getCurrentObject()
	if showNormalObjects then return showNormalObjectTabelle[showNormalObjectNumber] end
	if showBathObjects then return showBathObjectsTabelle[showBathObjectNumber] end
	if showOutsideObjects then return showOutsideObjectTabelle[showOutdoorObjectNumber] end
	return nil
end

function drawObjectPreis()
	local object = getCurrentObject()
	if not object then return end

	local width = 430 * scale
	local height = 52 * scale
	local x = (sx - width) / 2
	local y = 25 * scale

	dxDrawRectangle(x, y, width, height, tocolor(0, 0, 0, 190), false)
	dxDrawRectangle(x, y, width, 3 * scale, tocolor(0, 100, 200, 255), false)
	dxDrawText(getText("Furniture11"):format(object[2]), x + 10 * scale, y, x + width - 10 * scale, y + height, tocolor(255, 255, 255, 255), 1, "default-bold", "center", "center", true, false, false)
end

local showObjectPickup = createPickup(1721.8173828125, -1652.5671386719, 20.0625, 3, 1239, 50)
setElementInterior(showObjectPickup, 18)

addEventHandler("onClientPickupHit", showObjectPickup, function(hit)
	if hit == localPlayer then
		openFurnitureKategorieWindow()
	end
end)

function buyObject()
	local object = getCurrentObject()
	if not object then return end
	triggerServerEvent("buyObject", localPlayer, object[1])
end

function closeObject()
	unbindKey("enter", "down", buyObject)
	unbindKey("space", "down", closeObject)
	unbindKey("arrow_r", "down", newobjectRight)
	unbindKey("arrow_l", "down", newobjectLeft)
	removeEventHandler("onClientRender", root, rotateShowObject)
	removeEventHandler("onClientRender", root, drawObjectPreis)
	toggleAllControls(true)
	setCameraTarget(localPlayer)
	if isElement(showObject) then destroyElement(showObject) end
	showObject = nil
	showChat(true)
	setElementData(localPlayer, "redfieldClick", false)
	showNormalObjects, showOutsideObjects, showBathObjects = false, false, false
end

function newobjectRight()
	if not isElement(showObject) then return end

	if showNormalObjects and showNormalObjectNumber < #showNormalObjectTabelle then
		showNormalObjectNumber = showNormalObjectNumber + 1
		setElementModel(showObject, showNormalObjectTabelle[showNormalObjectNumber][1])
	elseif showBathObjects and showBathObjectNumber < #showBathObjectsTabelle then
		showBathObjectNumber = showBathObjectNumber + 1
		setElementModel(showObject, showBathObjectsTabelle[showBathObjectNumber][1])
	elseif showOutsideObjects and showOutdoorObjectNumber < #showOutsideObjectTabelle then
		showOutdoorObjectNumber = showOutdoorObjectNumber + 1
		setElementModel(showObject, showOutsideObjectTabelle[showOutdoorObjectNumber][1])
	end
end

function newobjectLeft()
	if not isElement(showObject) then return end

	if showNormalObjects and showNormalObjectNumber > 1 then
		showNormalObjectNumber = showNormalObjectNumber - 1
		setElementModel(showObject, showNormalObjectTabelle[showNormalObjectNumber][1])
	elseif showBathObjects and showBathObjectNumber > 1 then
		showBathObjectNumber = showBathObjectNumber - 1
		setElementModel(showObject, showBathObjectsTabelle[showBathObjectNumber][1])
	elseif showOutsideObjects and showOutdoorObjectNumber > 1 then
		showOutdoorObjectNumber = showOutdoorObjectNumber - 1
		setElementModel(showObject, showOutsideObjectTabelle[showOutdoorObjectNumber][1])
	end
end

function rotateShowObject()
	if not isElement(showObject) then return end
	local x, y, z = getElementRotation(showObject)
	setElementRotation(showObject, x, y, z + 1)
end

function createobject_func(id)
	id = tonumber(id)
	if not id or isElement(dropObjekt) then return end

	showCursor(true)

	local px, py, pz = getPedBonePosition(localPlayer, 6)
	local hit
	hit, camX, camY, camZ = processLineOfSight(px, py, pz, px, py, pz + 20, true, true, false)

	if not hit then
		camX, camY, camZ = px, py, pz + 20
	else
		camZ = camZ - 0.1
	end

	setCameraMatrix(camX, camY, camZ, px, py, pz)

	local int = getElementInterior(localPlayer)
	local dim = getElementDimension(localPlayer)
	dropObjekt = createObject(id, px, py, pz)

	if not isElement(dropObjekt) then
		showCursor(false)
		setCameraTarget(localPlayer)
		return
	end

	setElementInterior(dropObjekt, int)
	setElementDimension(dropObjekt, dim)
	massDistance = getElementDistanceFromCentreOfMassToBaseOfModel(dropObjekt)
	setElementCollisionsEnabled(dropObjekt, false)
	addEventHandler("onClientRender", root, refreshObjectPosition)
	addEventHandler("onClientClick", root, objectPosition)
	setElementData(localPlayer, "redfieldClick", true)
	bindKey("mouse_wheel_up", "down", refreshObjectRotationRight)
	bindKey("mouse_wheel_down", "down", refreshObjectRotationLeft)
	bindKey("enter", "down", stopPlaceObject)
	infobox(getText("Furniture12"), 0, 200, 0)
end

addEvent("createobject", true)
addEventHandler("createobject", root, createobject_func)

function objectPosition(button, state)
	if state ~= "down" or (button ~= "left" and button ~= "right") then return end
	if not isElement(dropObjekt) then return end
	removeEventHandler("onClientRender", root, refreshObjectPosition)
	removeEventHandler("onClientClick", root, objectPosition)
	placeObject()
end

function refreshObjectRotationRight()
	if not isElement(dropObjekt) then return end
	local x, y, z = getElementRotation(dropObjekt)
	setElementRotation(dropObjekt, x, y, z + 1)
end

function refreshObjectRotationLeft()
	if not isElement(dropObjekt) then return end
	local x, y, z = getElementRotation(dropObjekt)
	setElementRotation(dropObjekt, x, y, z - 1)
end

local function clearObjectPlacement()
	unbindKey("mouse_wheel_up", "down", refreshObjectRotationRight)
	unbindKey("mouse_wheel_down", "down", refreshObjectRotationLeft)
	unbindKey("enter", "down", stopPlaceObject)
	removeEventHandler("onClientRender", root, refreshObjectPosition)
	removeEventHandler("onClientClick", root, objectPosition)
	showCursor(false)
	setCameraTarget(localPlayer)
	setElementData(localPlayer, "redfieldClick", false)
end

function placeObject()
	if not isElement(dropObjekt) then return end

	local x, y, z = getElementPosition(dropObjekt)
	local rx, ry, rz = getElementRotation(dropObjekt)
	local model = getElementModel(dropObjekt)
	local interior = getElementInterior(dropObjekt)
	local dimension = getElementDimension(dropObjekt)

	destroyElement(dropObjekt)
	dropObjekt = nil
	clearObjectPlacement()
	triggerServerEvent("createNewObjectPlace", localPlayer, model, x, y, z, rx, ry, rz, interior, dimension)
end

function stopPlaceObject()
	if isElement(dropObjekt) then destroyElement(dropObjekt) end
	dropObjekt = nil
	clearObjectPlacement()
end

function refreshObjectPosition()
	if not isElement(dropObjekt) then return end

	local _, _, x, y, z = getCursorPosition()
	if not x or not y or not z then return end

	local hit, nx, ny, nz = processLineOfSight(camX, camY, camZ, x, y, z, true, true, false)
	if nz then nz = nz + 3 end

	if nx and ny and nz then
		local hit2, hx, hy, hz = processLineOfSight(nx, ny, nz, x, y, z, true, true, false)
		if hit2 then
			nx, ny, nz = hx, hy, hz
		else
			nx, ny, nz = x, y, z
		end
	else
		nx, ny, nz = x, y, z
	end

	local extra = higher[getElementModel(dropObjekt)] or 0
	setElementPosition(dropObjekt, nx, ny, nz + massDistance + extra)
end