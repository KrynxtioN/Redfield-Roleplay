local sx, sy = guiGetScreenSize()
local scale = math.min(sx / 1440, sy / 900)
local infoboxActive = false
local infoboxText = ""
local colorR, colorG, colorB = 255, 255, 255
local infoboxTimer = nil

function dxdrawInfobox()
	local w, h = 359 * scale, 125 * scale
	local x, y = (sx - w) / 2, 14 * scale
	local headerH = 26 * scale
	dxDrawRectangle(x, y, w, h, tocolor(0, 0, 0, 145), false)
	dxDrawRectangle(x, y, w, 3 * scale, tocolor(0, 100, 200, 230), false)
	dxDrawRectangle(x, y + headerH, w, 2 * scale, tocolor(0, 100, 200, 210), false)
	dxDrawText(getText("UIInfoboxTitle"), x + 10 * scale, y, x + w - 10 * scale, y + headerH, tocolor(255, 255, 255, 255), 1, "default-bold", "center", "center")
	dxDrawText(infoboxText, x + 12 * scale, y + headerH + 8 * scale, x + w - 12 * scale, y + h - 8 * scale, tocolor(colorR, colorG, colorB, 255), 1, "default-bold", "center", "center", false, true, false)
end

function infobox(text, r, g, b)
	infoboxText = tostring(text or "")
	colorR, colorG, colorB = tonumber(r) or 255, tonumber(g) or 255, tonumber(b) or 255
	if isTimer(infoboxTimer) then killTimer(infoboxTimer) end
	if not infoboxActive then
		infoboxActive = true
		addEventHandler("onClientRender", root, dxdrawInfobox)
	end
	infoboxTimer = setTimer(function()
		infoboxActive = false
		removeEventHandler("onClientRender", root, dxdrawInfobox)
		infoboxTimer = nil
	end, 5000, 1)
end

addEvent("infobox", true)
addEventHandler("infobox", root, infobox)

function changeInfobox_func()
	if getElementData(localPlayer, "loggedin") ~= 1 then return end
	local enabled = tonumber(getElementData(localPlayer, "Infobox")) or 0
	setElementData(localPlayer, "Infobox", enabled == 0 and 1 or 0)
	infobox(getText("UIInfoboxChanged"), 0, 255, 0)
end

addCommandHandler("infobox", changeInfobox_func)