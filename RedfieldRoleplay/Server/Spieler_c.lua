local hospitalActive = false
local hospitalTime = 0
local hospitalTimer = nil
local hospitalEndTimer = nil
local sx, sy = guiGetScreenSize()
local scale = math.min(sx / 1920, sy / 1080)

function showCursorClient()
	if getElementData(localPlayer, "loggedin") ~= 1 then return end
	if getElementData(localPlayer, "redfieldClick") == true then return end
	showCursor(not isCursorShowing())
end
bindKey("m", "down", showCursorClient)

function renderHospital()
	if not hospitalActive then return end

	local w, h = 440 * scale, 150 * scale
	local x, y = (sx - w) / 2, (sy - h) / 2
	local padding = 15 * scale
	local progress = math.max(0, math.min(1, hospitalTime / 30))
	local progressW = w - padding * 2
	local progressH = 5 * scale
	local progressY = y + h - padding - progressH

	dxDrawRectangle(x, y, w, h, tocolor(0, 0, 0, 240), false)
	dxDrawRectangle(x, y, w, 3 * scale, tocolor(0, 100, 200, 255), false)

	dxDrawRectangle(x + padding, y + 18 * scale, w - padding * 2, 78 * scale, tocolor(20, 20, 20, 255), false)
	dxDrawRectangle(x + padding, y + 18 * scale, 3 * scale, 78 * scale, tocolor(0, 100, 200, 255), false)

	dxDrawText(getText("Hospital1"), x + padding + 15 * scale, y + 23 * scale, x + w - padding - 15 * scale, y + 53 * scale, tocolor(255, 255, 255, 255), 1.1 * scale, "default-bold", "center", "center", true)
	dxDrawText(getText("Hospital2"):format(hospitalTime), x + padding + 15 * scale, y + 53 * scale, x + w - padding - 15 * scale, y + 91 * scale, tocolor(210, 210, 210, 255), 1 * scale, "default-bold", "center", "center", true, true)

	dxDrawRectangle(x + padding, progressY, progressW, progressH, tocolor(30, 30, 30, 255), false)
	dxDrawRectangle(x + padding, progressY, progressW * progress, progressH, tocolor(0, 100, 200, 255), false)
end

function hospitalWindow()
	if hospitalActive then return end

	hospitalActive = true
	hospitalTime = 30
	setElementData(localPlayer, "redfieldClick", true)
	showCursor(false)

	if isPedInVehicle(localPlayer) then
		removeEventHandler("onClientRender", root, render_tacho)
	end

	setCameraMatrix(-309.30661010742, 1072.3266601563, 35.636001586914, -309.77633666992, 1071.5665283203, 35.186965942383, 0, 70)
	setCameraInterior(0)
	setElementInterior(localPlayer, 0)
	setElementDimension(localPlayer, 0)
	addEventHandler("onClientRender", root, renderHospital)

	hospitalTimer = setTimer(function()
		hospitalTime = math.max(hospitalTime - 1, 0)
	end, 1000, 29)

	hospitalEndTimer = setTimer(function()
		if isTimer(hospitalTimer) then killTimer(hospitalTimer) end
		removeEventHandler("onClientRender", root, renderHospital)

		hospitalActive = false
		hospitalTime = 0
		hospitalTimer = nil
		hospitalEndTimer = nil

		setElementData(localPlayer, "redfieldClick", false)
		triggerServerEvent("afterHospitalSpawn", localPlayer)
	end, 30000, 1)
end
addEvent("hospitalWindow", true)
addEventHandler("hospitalWindow", root, hospitalWindow)

function noDamage()
	if getElementData(localPlayer, "imKnast") == true then
		cancelEvent()
	end
end
addEventHandler("onClientPlayerDamage", localPlayer, noDamage)