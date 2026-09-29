local sx, sy = guiGetScreenSize()
local scale = math.min(sx / 1920, sy / 1080)
local jobcenterVisible = false
local selectedJob = 0
local jobScroll = 0
local visibleJobs = 4
local jobBlip, jobBlipTimer = nil, nil

local jobInfos = {
	[1] = {name = {[0] = "Pilot", [1] = "Pilot"}, x = -1421.4528808594, y = -287.35494995117, z = 14.1484375},
	[2] = {name = {[0] = "Pizzalieferant", [1] = "Pizza delivery driver"}, x = 2122.1867675781, y = -1823.1586914063, z = 13.557378768921},
	[3] = {name = {[0] = "Holzfäller", [1] = "Lumberjack"}, x = -538.60534667969, y = -78.070526123047, z = 62.8671875},
	[4] = {name = {[0] = "Tankwart", [1] = "Gas station attendant"}, x = 639.02117919922, y = 1683.3165283203, z = 7.1875},
	[5] = {name = {[0] = "Busfahrer", [1] = "Bus driver"}, x = 12.60000038147, y = 1225.5, z = 19.299999237061},
	[6] = {name = {[0] = "Farmer", [1] = "Farmer"}, x = -1061.4000244141, y = -1195.5999755859, z = 129.80000305176}
}

local function lang()
	local language = tonumber(getElementData(localPlayer, "Language")) or 0
	return language == 1 and 1 or 0
end

local function isCursorOnElement(x, y, width, height)
	if not isCursorShowing() then return false end
	local cx, cy = getCursorPosition()
	if not cx or not cy then return false end
	cx, cy = cx * sx, cy * sy
	return cx >= x and cx <= x + width and cy >= y and cy <= y + height
end

local function getJobcenterLayout()
	local width = math.min(430 * scale, sx * 0.50)
	local height = math.min(310 * scale, sy * 0.55)
	local x = (sx - width) / 2
	local y = (sy - height) / 2
	local padding = 15 * scale
	return x, y, width, height, padding
end

local function drawButton(text, x, y, width, height)
	local hover = isCursorOnElement(x, y, width, height)
	dxDrawRectangle(x, y, width, height, hover and tocolor(0, 100, 200, 255) or tocolor(35, 35, 35, 255), false)
	dxDrawRectangle(x, y + height - 2 * scale, width, 2 * scale, tocolor(0, 100, 200, 255), false)
	dxDrawText(text, x + 5 * scale, y, x + width - 5 * scale, y + height, tocolor(255, 255, 255, 255), 1, "default-bold", "center", "center", true, false, false)
end

local function drawJobcenter()
	if not jobcenterVisible then return end
	local x, y, width, height, padding = getJobcenterLayout()
	local listX = x + padding
	local listY = y + 52 * scale
	local rowHeight = 38 * scale
	local rowGap = 3 * scale
	local scrollGap = 8 * scale
	local scrollWidth = 4 * scale
	local fullWidth = width - padding * 2
	local rowWidth = fullWidth - scrollGap - scrollWidth
	local listHeight = visibleJobs * rowHeight - rowGap
	local maxScroll = math.max(0, #jobInfos - visibleJobs)
	jobScroll = math.max(0, math.min(maxScroll, jobScroll))

	dxDrawRectangle(x, y, width, height, tocolor(0, 0, 0, 240), false)
	dxDrawRectangle(x, y, width, 3 * scale, tocolor(0, 100, 200, 255), false)
	dxDrawText(getText("JobcenterJob"), x + padding, y + 8 * scale, x + width - padding, y + 43 * scale, tocolor(255, 255, 255, 255), 1.1, "default-bold", "center", "center")

	for visibleIndex = 1, visibleJobs do
		local jobID = visibleIndex + jobScroll
		local info = jobInfos[jobID]
		if info then
			local rowY = listY + (visibleIndex - 1) * rowHeight
			local hover = isCursorOnElement(listX, rowY, rowWidth, rowHeight - rowGap)
			local background = jobID % 2 == 0 and tocolor(25, 25, 25, 255) or tocolor(35, 35, 35, 255)
			if hover then background = tocolor(45, 45, 45, 255) end
			if selectedJob == jobID then background = tocolor(0, 100, 200, 255) end
			dxDrawRectangle(listX, rowY, rowWidth, rowHeight - rowGap, background, false)
			dxDrawText(info.name[lang()], listX + 10 * scale, rowY, listX + rowWidth - 10 * scale, rowY + rowHeight - rowGap, tocolor(255, 255, 255, 255), 1, "default-bold", "left", "center", true, false, false)
		end
	end

	if #jobInfos > visibleJobs then
		local barX = listX + rowWidth + scrollGap
		local thumbHeight = listHeight * (visibleJobs / #jobInfos)
		local thumbY = listY
		if maxScroll > 0 then thumbY = listY + (listHeight - thumbHeight) * (jobScroll / maxScroll) end
		dxDrawRectangle(barX, listY, scrollWidth, listHeight, tocolor(40, 40, 40, 255), false)
		dxDrawRectangle(barX, thumbY, scrollWidth, thumbHeight, tocolor(0, 100, 200, 255), false)
	end

	local buttonY = y + height - 55 * scale
	local buttonHeight = 38 * scale
	local gap = 10 * scale
	local buttonWidth = (fullWidth - gap) / 2
	drawButton(getText("JobcenterAccept"), x + padding, buttonY, buttonWidth, buttonHeight)
	drawButton(getText("JobcenterClose"), x + padding + buttonWidth + gap, buttonY, buttonWidth, buttonHeight)
end

local function closeJobcenter()
	if not jobcenterVisible then return end
	jobcenterVisible = false
	selectedJob = 0
	jobScroll = 0
	removeEventHandler("onClientRender", root, drawJobcenter)
	removeEventHandler("onClientClick", root, clickJobcenter)
	removeEventHandler("onClientKey", root, keyJobcenter)
	showCursor(false)
	setElementData(localPlayer, "redfieldClick", false)
end

function jobInfos_func(job)
	local info = jobInfos[job]
	if not info then return end
	if isElement(jobBlip) then destroyElement(jobBlip) end
	if isTimer(jobBlipTimer) then killTimer(jobBlipTimer) end
	jobBlip = createBlip(info.x, info.y, info.z, 0, 2, 255, 255, 0)
	jobBlipTimer = setTimer(function()
		if isElement(jobBlip) then destroyElement(jobBlip) end
		jobBlip = nil
	end, 120000, 1)
	infobox(getText("JobcenterMarked"), 0, 200, 0)
end

function clickJobcenter(button, state)
	if not jobcenterVisible or button ~= "left" or state ~= "down" then return end
	local x, y, width, height, padding = getJobcenterLayout()
	local listX = x + padding
	local listY = y + 52 * scale
	local rowHeight = 38 * scale
	local rowGap = 3 * scale
	local scrollGap = 8 * scale
	local scrollWidth = 4 * scale
	local fullWidth = width - padding * 2
	local rowWidth = fullWidth - scrollGap - scrollWidth

	for visibleIndex = 1, visibleJobs do
		local jobID = visibleIndex + jobScroll
		local rowY = listY + (visibleIndex - 1) * rowHeight
		if jobInfos[jobID] and isCursorOnElement(listX, rowY, rowWidth, rowHeight - rowGap) then
			selectedJob = jobID
			return
		end
	end

	local buttonY = y + height - 55 * scale
	local buttonHeight = 38 * scale
	local gap = 10 * scale
	local buttonWidth = (fullWidth - gap) / 2

	if isCursorOnElement(x + padding, buttonY, buttonWidth, buttonHeight) then
		if getElementData(localPlayer, "Arbeitsgenehmigung") ~= 1 then
			infobox(getText("JobcenterLicense"), 255, 255, 255)
			return
		end
		if selectedJob <= 0 or not jobInfos[selectedJob] then
			infobox(getText("JobcenterSelect"), 255, 100, 100)
			return
		end
		jobInfos_func(selectedJob)
		return
	end

	if isCursorOnElement(x + padding + buttonWidth + gap, buttonY, buttonWidth, buttonHeight) then closeJobcenter() end
end

function keyJobcenter(button, press)
	if not jobcenterVisible or not press then return end
	local x, y, width, height, padding = getJobcenterLayout()
	local listX = x + padding
	local listY = y + 52 * scale
	local listWidth = width - padding * 2
	local listHeight = visibleJobs * 38 * scale

	if not isCursorOnElement(listX, listY, listWidth, listHeight) then return end

	local maxScroll = math.max(0, #jobInfos - visibleJobs)
	if button == "mouse_wheel_up" then
		jobScroll = math.max(0, jobScroll - 1)
		cancelEvent()
	elseif button == "mouse_wheel_down" then
		jobScroll = math.min(maxScroll, jobScroll + 1)
		cancelEvent()
	end
end

function jobcenterWindow()
	if jobcenterVisible or getElementData(localPlayer, "redfieldClick") == true then return end
	jobcenterVisible = true
	selectedJob = 0
	jobScroll = 0
	showCursor(true)
	setElementData(localPlayer, "redfieldClick", true)
	addEventHandler("onClientRender", root, drawJobcenter)
	addEventHandler("onClientClick", root, clickJobcenter)
	addEventHandler("onClientKey", root, keyJobcenter)
end

addEvent("jobcenterWindow", true)
addEventHandler("jobcenterWindow", root, jobcenterWindow)