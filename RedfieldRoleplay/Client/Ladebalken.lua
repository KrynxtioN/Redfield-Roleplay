local sx, sy = guiGetScreenSize()
local scale = math.min(sx / 1400, sy / 900)
local progress = 0
local loading = false
local loadStart = 0
local loadDuration = 1650

function dxLadebalken()
	if not loading then return end
	local elapsed = getTickCount() - loadStart
	progress = math.min(100, (elapsed / loadDuration) * 100)
	local w, h = 596 * scale, 67 * scale
	local x, y = (sx - w) / 2, (sy - h) / 2
	local innerW, innerH = w - 16 * scale, h - 16 * scale
	dxDrawText(getText("LoadingWorld"), x, y - 70 * scale, x + w, y - 15 * scale, tocolor(255, 255, 255, 255), 2.2 * scale, "default-bold", "center", "center")
	dxDrawRectangle(x, y, w, h, tocolor(0, 0, 0, 235), false)
	dxDrawRectangle(x, y, w, 3 * scale, tocolor(0, 100, 200, 255), false)
	dxDrawRectangle(x, y + h - 3 * scale, w, 3 * scale, tocolor(0, 100, 200, 255), false)
	dxDrawRectangle(x, y, 3 * scale, h, tocolor(0, 100, 200, 255), false)
	dxDrawRectangle(x + w - 3 * scale, y, 3 * scale, h, tocolor(0, 100, 200, 255), false)
	dxDrawRectangle(x + 8 * scale, y + 8 * scale, innerW, innerH, tocolor(25, 25, 25, 255), false)
	dxDrawRectangle(x + 8 * scale, y + 8 * scale, innerW * (progress / 100), innerH, tocolor(0, 100, 200, 255), false)
	dxDrawText(math.floor(progress) .. "%", x, y, x + w, y + h, tocolor(255, 255, 255, 255), 2.2 * scale, "default-bold", "center", "center")
	if progress >= 100 then
		loading = false
		removeEventHandler("onClientRender", root, dxLadebalken)
		fadeCamera(true)
	end
end

function ladeBalken()
	if loading then removeEventHandler("onClientRender", root, dxLadebalken) end
	progress = 0
	loadStart = getTickCount()
	loading = true
	fadeCamera(false)
	addEventHandler("onClientRender", root, dxLadebalken)
end

addEvent("ladeBalken", true)
addEventHandler("ladeBalken", root, ladeBalken)