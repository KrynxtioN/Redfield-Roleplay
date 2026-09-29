local sx, sy = guiGetScreenSize()
local adminHelpVisible = false
local scrollPosition = 0
local maxVisibleRows = 8

local Adminnames = {
	[1] = {[0] = "Ticketbeauftragter", [1] = "Ticket Manager"},
	[2] = {[0] = "Supporter", [1] = "Supporter"},
	[3] = {[0] = "Moderator", [1] = "Moderator"},
	[4] = {[0] = "Projektleiter", [1] = "Project Manager"}
}

local AdminCommands = {
	{rank = 1, command = "/admins", text = "AdminHelpCmdAdmins"},
	{rank = 1, command = "/o [Text]", text = "AdminHelpCmdO"},
	{rank = 1, command = "/a [Text]", text = "AdminHelpCmdA"},
	{rank = 1, command = "/eventkasse", text = "AdminHelpCmdEvent"},
	{rank = 1, command = "/eventkasse take [Betrag]", commandEN = "/eventkasse take [Amount]", text = "AdminHelpCmdEventTake"},
	{rank = 1, command = "/eventkasse give [Betrag]", commandEN = "/eventkasse give [Amount]", text = "AdminHelpCmdEventGive"},
	{rank = 2, command = "/rkick [Spieler] [Grund]", commandEN = "/rkick [Player] [Reason]", text = "AdminHelpCmdKick"},
	{rank = 2, command = "/prison [Spieler] [Grund] [Zeit]", commandEN = "/prison [Player] [Reason] [Time]", text = "AdminHelpCmdPrison"},
	{rank = 2, command = "/mute [Spieler]", commandEN = "/mute [Player]", text = "AdminHelpCmdMute"},
	{rank = 2, command = "/goto [Spieler]", commandEN = "/goto [Player]", text = "AdminHelpCmdGoto"},
	{rank = 2, command = "/gethere [Spieler]", commandEN = "/gethere [Player]", text = "AdminHelpCmdGethere"},
	{rank = 3, command = "/makeleader [Spieler] [Fraktion]", commandEN = "/makeleader [Player] [Faction]", text = "AdminHelpCmdLeader"},
	{rank = 3, command = "/setrank [Spieler] [Rang]", commandEN = "/setrank [Player] [Rank]", text = "AdminHelpCmdRank"},
	{rank = 4, command = "/rban [Spieler] [Grund]", commandEN = "/rban [Player] [Reason]", text = "AdminHelpCmdBan"}
}

local function safeText(key)
	local text = getText(key)
	if text == nil or text == false then return key end
	return tostring(text)
end

local function getLanguage()
	local language = tonumber(getElementData(localPlayer, "Language")) or 0
	if language ~= 0 and language ~= 1 then language = 0 end
	return language
end

local function getAdminRankName(rank)
	rank = tonumber(rank) or 0
	local data = Adminnames[rank]
	if not data then return safeText("AdminUnknown") end
	return data[getLanguage()] or data[0] or safeText("AdminUnknown")
end

local function getCommandText(data)
	if not data then return "" end
	if getLanguage() == 1 and data.commandEN then return data.commandEN end
	return data.command or ""
end

local function getTextScale()
	local scale = math.min(sx / 1920, sy / 1080)
	if scale <= 1 then return 1 end
	scale = math.floor(scale / 0.2) * 0.2
	if scale < 1 then scale = 1 end
	return scale
end

local function getAvailableCommands()
	local commands = {}
	local adminRank = tonumber(getElementData(localPlayer, "Adminrang")) or 0
	for i = 1, #AdminCommands do
		local data = AdminCommands[i]
		if data and adminRank >= (tonumber(data.rank) or 99) then
			commands[#commands + 1] = data
		end
	end
	return commands
end

local function drawAdminHelp()
	local loggedin = tonumber(getElementData(localPlayer, "loggedin")) or 0
	local adminRank = tonumber(getElementData(localPlayer, "Adminrang")) or 0
	if loggedin ~= 1 or adminRank < 1 then
		adminHelpVisible = false
		removeEventHandler("onClientRender", root, drawAdminHelp)
		return
	end

	local commands = getAvailableCommands()
	local textScale = getTextScale()
	local width = 720
	local height = 525
	local x = (sx - width) / 2
	local y = (sy - height) / 2
	local headerHeight = 48
	local rowHeight = 43
	local listY = y + 112
	local listHeight = maxVisibleRows * rowHeight
	local maxScroll = math.max(0, #commands - maxVisibleRows)

	scrollPosition = math.max(0, math.min(scrollPosition, maxScroll))

	dxDrawRectangle(x, y, width, height, tocolor(0, 0, 0, 225), false)
	dxDrawRectangle(x, y, width, headerHeight, tocolor(0, 100, 200, 245), false)
	dxDrawRectangle(x, y + headerHeight, width, 2, tocolor(255, 255, 255, 180), false)
	dxDrawText(safeText("AdminHelpTitle"), x + 18, y, x + width - 18, y + headerHeight, tocolor(255, 255, 255, 255), textScale + 0.2, "default-bold", "left", "center")
	dxDrawText("F6", x + 18, y, x + width - 18, y + headerHeight, tocolor(255, 255, 255, 220), textScale, "default-bold", "right", "center")

	local rankFormat = safeText("AdminHelpRank")
	local rankText = rankFormat
	if rankFormat:find("%%") then
		local success, formatted = pcall(string.format, rankFormat, getAdminRankName(adminRank), adminRank)
		if success then rankText = formatted end
	end

	dxDrawText(rankText, x + 18, y + 55, x + width - 18, y + 82, tocolor(0, 170, 255, 255), textScale, "default-bold", "left", "center")
	dxDrawText(safeText("AdminHelpCommand"), x + 18, y + 84, x + 290, y + 110, tocolor(180, 180, 180, 255), textScale, "default-bold", "left", "center")
	dxDrawText(safeText("AdminHelpDescription"), x + 300, y + 84, x + width - 35, y + 110, tocolor(180, 180, 180, 255), textScale, "default-bold", "left", "center")

	local visibleRow = 0
	local startIndex = scrollPosition + 1
	local endIndex = math.min(#commands, scrollPosition + maxVisibleRows)

	for i = startIndex, endIndex do
		local data = commands[i]
		if data then
			visibleRow = visibleRow + 1
			local rowY = listY + ((visibleRow - 1) * rowHeight)

			if visibleRow % 2 == 0 then
				dxDrawRectangle(x + 10, rowY, width - 30, rowHeight, tocolor(255, 255, 255, 10), false)
			end

			local description = ""
			if data.text then description = safeText(data.text) end

			dxDrawText(getCommandText(data), x + 18, rowY, x + 290, rowY + rowHeight, tocolor(0, 160, 255, 255), textScale, "default-bold", "left", "center", false, false, false)
			dxDrawText(description, x + 300, rowY, x + width - 35, rowY + rowHeight, tocolor(235, 235, 235, 255), textScale, "default", "left", "center", true, true, false)
		end
	end

	if #commands > maxVisibleRows then
		local scrollbarX = x + width - 15
		local scrollbarY = listY
		local scrollbarHeight = listHeight
		local thumbHeight = scrollbarHeight * (maxVisibleRows / #commands)
		if thumbHeight < 35 then thumbHeight = 35 end

		local scrollRange = scrollbarHeight - thumbHeight
		local thumbY = scrollbarY
		if maxScroll > 0 then thumbY = scrollbarY + ((scrollPosition / maxScroll) * scrollRange) end

		dxDrawRectangle(scrollbarX, scrollbarY, 5, scrollbarHeight, tocolor(255, 255, 255, 40), false)
		dxDrawRectangle(scrollbarX, thumbY, 5, thumbHeight, tocolor(0, 100, 200, 255), false)
	end

	local footer = safeText("AdminHelpFooter")
	if #commands > maxVisibleRows then
		footer = footer.." | "..safeText("AdminHelpScroll")
	end

	dxDrawRectangle(x, y + height - 42, width, 42, tocolor(0, 100, 200, 70), false)
	dxDrawText(footer, x + 18, y + height - 42, x + width - 18, y + height, tocolor(220, 220, 220, 255), textScale, "default-bold", "center", "center")
end

local function scrollAdminHelp(key)
	if not adminHelpVisible then return end

	local commands = getAvailableCommands()
	local maxScroll = math.max(0, #commands - maxVisibleRows)

	if key == "mouse_wheel_down" then
		scrollPosition = math.min(scrollPosition + 1, maxScroll)
	elseif key == "mouse_wheel_up" then
		scrollPosition = math.max(scrollPosition - 1, 0)
	end
end

local function toggleAdminHelp()
	if (tonumber(getElementData(localPlayer, "loggedin")) or 0) ~= 1 then return end
	if (tonumber(getElementData(localPlayer, "Adminrang")) or 0) < 1 then return end

	adminHelpVisible = not adminHelpVisible
	scrollPosition = 0

	if adminHelpVisible then
		if(getElementData(localPlayer,"redfieldClick") ~= true)then
			setElementData(localPlayer,"redfieldClick",false)
			addEventHandler("onClientRender", root, drawAdminHelp)
		end
	else
		setElementData(localPlayer,"redfieldClick",false)
		removeEventHandler("onClientRender", root, drawAdminHelp)
	end
end

bindKey("F6", "down", toggleAdminHelp)
bindKey("mouse_wheel_up", "down", scrollAdminHelp)
bindKey("mouse_wheel_down", "down", scrollAdminHelp)

addEventHandler("onClientResourceStop", resourceRoot, function()
	if adminHelpVisible then
		removeEventHandler("onClientRender", root, drawAdminHelp)
	end
end)