local fraknames={
[0]='Zivilist',
[1]='Police Department',
[2]='Yakuza',
[3]='Biker',
[4]='Reporter',
[5]='Ballas',
[6]='Surenos'
}

fcolors={}
fcolors[-1] = {}
	fcolors[-1][1] = 100
	fcolors[-1][2] = 100
	fcolors[-1][3] = 100
fcolors[0] = {}
	fcolors[0][1] = 255
	fcolors[0][2] = 255
	fcolors[0][3] = 255
fcolors[1] = {}
	fcolors[1][1] = 0
	fcolors[1][2] = 200
	fcolors[1][3] = 0
fcolors[2] = {}
	fcolors[2][1] = 0
	fcolors[2][2] = 50
	fcolors[2][3] = 255
fcolors[3] = {}
	fcolors[3][1] = 100
	fcolors[3][2] = 50
	fcolors[3][3] = 50
fcolors[4] = {}
	fcolors[4][1] = 250
	fcolors[4][2] = 150
	fcolors[4][3] = 0
fcolors[5] = {}
	fcolors[5][1] = 255
	fcolors[5][2] = 0
	fcolors[5][3] = 200
fcolors[6] = {}
	fcolors[6][1] = 200
	fcolors[6][2] = 200
	fcolors[6][3] = 0

local Scrollposition = 0
local x,y = guiGetScreenSize()

function ScoreboardScrollingUp()
	if(Scrollposition >= 2)then
		Scrollposition = 0
	else
		Scrollposition = Scrollposition -2
	end
end

function ScoreboardScrollingDown()
	if(#getElementsByType('player') - Scrollposition <= 2)then
		Scrollposition = #getElementsByType('player')
	else
		Scrollposition = Scrollposition +1
	end
end

function getFactionMembersOnline(factionID)
	local online = 0
	for _,p in pairs(getElementsByType('player'))do
		if(getElementData(p,'Fraktion') == factionID)then
			online = online +1
		end
	end
	return online
end

function formString(text)
	if(string.len(text) == 1)then
		text = '0'..text
	end return text
end

function getPingColor(ping)
	if(ping <= 70)then
		return 0,200,0
	elseif(ping >= 70 and ping <= 120)then
		return 255,250,0
	elseif(ping >= 120 and ping <= 200)then
		return 255,150,0
	elseif(ping >= 200)then
		return 200,0,0
	end
end

function ScoreboardDraw()
	dxDrawRectangle(x * 0.2643, y * 0.2952, x * 0.4649, y * 0.4419, tocolor(0, 0, 0, 139), false)
	dxDrawRectangle(x * 0.2643, y * 0.5886, x * 0.4649, y * 0.0343, tocolor(125,125,0), false)
	dxDrawRectangle(x * 0.2643, y * 0.3286, x * 0.4649, y * 0.0038, tocolor(125,125,0), false)
	if(getElementData(localPlayer,'Language') == 0)then
		dxDrawText('Spieler', x * 0.2851, y * 0.3076, x * 0.3107, y * 0.3229, tocolor(125,125,0), 1.00, 'default-bold', 'left', 'top', false, false, false, false, false)
		dxDrawText('Fraktion', x * 0.3679, y * 0.3076, x * 0.3935, y * 0.3229, tocolor(125,125,0), 1.00, 'default-bold', 'left', 'top', false, false, false, false, false)
		dxDrawText('Sozialer Status', x * 0.4435, y * 0.3076, x * 0.4952, y * 0.3229, tocolor(125,125,0), 1.00, 'default-bold', 'left', 'top', false, false, false, false, false)
		dxDrawText('Handy-NR', x * 0.5405, y * 0.3076, x * 0.5750, y * 0.3229, tocolor(125,125,0), 1.00, 'default-bold', 'left', 'top', false, false, false, false, false)
		dxDrawText('Spielzeit', x * 0.6244, y * 0.3076, x * 0.6589, y * 0.3229, tocolor(125,125,0), 1.00, 'default-bold', 'left', 'top', false, false, false, false, false)
		dxDrawText('Ping', x * 0.6827, y * 0.3076, x * 0.7173, y * 0.3229, tocolor(125,125,0), 1.00, 'default-bold', 'right', 'top', false, false, false, false, false)
		dxDrawText(#getElementsByType('player')..' Spieler online', x * 0.2667, y * 0.5876, x * 0.3298, y * 0.6229, tocolor(255,255,255), 1.00, 'default-bold', 'center', 'center', false, false, false, false, false)
	else
		dxDrawText('Player', x * 0.2851, y * 0.3076, x * 0.3107, y * 0.3229, tocolor(125,125,0), 1.00, 'default-bold', 'left', 'top', false, false, false, false, false)
		dxDrawText('Faction', x * 0.3679, y * 0.3076, x * 0.3935, y * 0.3229, tocolor(125,125,0), 1.00, 'default-bold', 'left', 'top', false, false, false, false, false)
		dxDrawText('Status', x * 0.4435, y * 0.3076, x * 0.4952, y * 0.3229, tocolor(125,125,0), 1.00, 'default-bold', 'left', 'top', false, false, false, false, false)
		dxDrawText('Phone number', x * 0.5405, y * 0.3076, x * 0.5750, y * 0.3229, tocolor(125,125,0), 1.00, 'default-bold', 'left', 'top', false, false, false, false, false)
		dxDrawText('Playtime', x * 0.6244, y * 0.3076, x * 0.6589, y * 0.3229, tocolor(125,125,0), 1.00, 'default-bold', 'left', 'top', false, false, false, false, false)
		dxDrawText('Ping', x * 0.6827, y * 0.3076, x * 0.7173, y * 0.3229, tocolor(125,125,0), 1.00, 'default-bold', 'right', 'top', false, false, false, false, false)
		dxDrawText(#getElementsByType('player')..' Player online', x * 0.2667, y * 0.5876, x * 0.3298, y * 0.6229, tocolor(255,255,255), 1.00, 'default-bold', 'center', 'center', false, false, false, false, false)
	end
	dxDrawText('Staatsfraktionen:', x * 0.2726, y * 0.6324, x * 0.3298, y * 0.6476, tocolor(255,255,255), 1.00, 'default-bold', 'left', 'top', false, false, false, false, false)
	dxDrawText('Police Department: '..getFactionMembersOnline(1), x * 0.2726, y * 0.6600, x * 0.3298, y * 0.6629, tocolor(0,200,0), 1.00, 'default-bold', 'left', 'top', false, false, false, false, false)
	dxDrawText('Böse Gangs:', x * 0.3702, y * 0.6324, x * 0.4274, y * 0.6476, tocolor(255,255,255), 1.00, 'default-bold', 'left', 'top', false, false, false, false, false)
	dxDrawText('Yakuza: '..getFactionMembersOnline(2), x * 0.3702, y * 0.6600, x * 0.4274, y * 0.7086, tocolor(0,150,255, 139), 1.00, 'default-bold', 'left', 'top', false, false, false, false, false)
	dxDrawText('Biker: '..getFactionMembersOnline(3), x * 0.3702, y * 0.6800, x * 0.4274, y * 0.6781, tocolor(100,50,50, 255), 1.00, 'default-bold', 'left', 'top', false, false, false, false, false)
	dxDrawText('Ballas: '..getFactionMembersOnline(5), x * 0.3702, y * 0.7000, x * 0.4274, y * 0.6781, tocolor(255,0,200, 255), 1.00, 'default-bold', 'left', 'top', false, false, false, false, false)
	dxDrawText('Surenos: '..getFactionMembersOnline(6), x * 0.3702, y * 0.7200, x * 0.4274, y * 0.6781, tocolor(200,200,0, 255), 1.00, 'default-bold', 'left', 'top', false, false, false, false, false)
	dxDrawText('Neutral:', x * 0.4452, y * 0.6324, x * 0.5024, y * 0.6476, tocolor(255,255,255), 1.00, 'default-bold', 'left', 'top', false, false, false, false, false)
	dxDrawText('Reporter: '..getFactionMembersOnline(4), x * 0.4452, y * 0.6600, x * 0.5024, y * 0.6629, tocolor(255,150,0), 1.00, 'default-bold', 'left', 'top', false, false, false, false, false)
	local id=0
	local Player={}
	for _,p in pairs(getElementsByType('player'))do 
		local name = getPlayerName(p)
		local fac = 0
		local nr = '-'
		local ptime = '-'
		local status = '_'
		local r,g,b = 255,255,255
		local ping = getPlayerPing(p)
		
		if(getElementData(p,'loggedin') == 1)then
			nr=getElementData(p,'Telefonnummer')
			if(nr == 0)then
				nr = 'Kein Handy'
			end
			fac = getElementData(p,'Fraktion')
			stn = getElementData(p,'Status')
			if(not(fraknames[fac]))then
				fac = 0
			end
			 r,g,b = fcolors[fac][1],fcolors[fac][2],fcolors[fac][3]
			 hour = math.floor(tonumber(getElementData(p,'Spielzeit'))/60)
			 minute = tonumber(getElementData(p,'Spielzeit'))-hour*60
			 ptime = formString(hour)..':'..formString(minute)
		end
		
		if(getElementData(p,'Adminrang'))then
			if(getElementData(p,'Adminrang') ~= 0)then
			name = '[BC]'..name end
		end
		
		Player[id] = {}
		Player[id].Name = name
		Player[id].Fraktion = fac
		Player[id].Spielzeit = ptime;
		Player[id].Nummer = nr
		Player[id].Status = stn
		Player[id].R = r
		Player[id].G = g
		Player[id].B = b
		Player[id].Ping = ping
		id = id +1
	end
	local scale = 0
	for i = 0+Scrollposition, 15+Scrollposition do	
		if Player[i] then
			dxDrawText(Player[i].Name, x * 0.2851, y * (0.3419+(scale*0.171)), x * 0.3679, y * 0.3590, tocolor(Player[i].R,Player[i].G,Player[i].B, 255), 1.00, 'default-bold', 'left', 'top', false, false, false, false, false)
			dxDrawText(fraknames[Player[i].Fraktion], x * 0.3667, y * (0.3419+(scale*0.171)), x * 0.4387, y * 0.3590, tocolor(Player[i].R,Player[i].G,Player[i].B, 255), 1.00, 'default-bold', 'left', 'top', false, false, false, false, false)
			dxDrawText(Player[i].Status, x * 0.4435, y * (0.3419+(scale*0.171)), x * 0.5262, y * 0.3590, tocolor(Player[i].R,Player[i].G,Player[i].B, 255), 1.00, 'default-bold', 'left', 'top', false, false, false, false, false)
			dxDrawText(Player[i].Nummer, x * 0.5405, y * (0.3419+(scale*0.171)), x * 0.6185, y * 0.3590, tocolor(Player[i].R,Player[i].G,Player[i].B,255), 1.00, 'default-bold', 'left', 'top', false, false, false, false, false)
			dxDrawText(Player[i].Spielzeit, x * 0.6244, y * (0.3419+(scale*0.171)), x * 0.6827, y * 0.3590, tocolor(Player[i].R,Player[i].G,Player[i].B, 255), 1.00, 'default-bold', 'left', 'top', false, false, false, false, false)
			local pr, pg, pb = getPingColor(Player[i].Ping)
			dxDrawText(Player[i].Ping, x * 0.7030, y * (0.3419+(scale*0.171)), x * 0.7173, y * 0.3590, tocolor(pr, pg, pb, 255), 1.00, 'default-bold', 'left', 'top', false, false, false, false, false)
			scale = scale + 0.1
		end
	end
end

bindKey('tab','down',function()
	if(getElementData(localPlayer,'loggedin') == 1)then
		if(getElementData(localPlayer,'redfieldClick') == false)then
			toggleControl('fire',false)
			toggleControl('next_weapon',false)
			toggleControl('previous_weapon',false)
			bindKey('mouse_wheel_up','down',ScoreboardScrollingUp)
			bindKey('mouse_wheel_up','down',ScoreboardScrollingDown)
			addEventHandler('onClientRender',root,ScoreboardDraw)
		end
	end
end)

bindKey('tab','up',function()
	toggleControl('fire',true)
	toggleControl('next_weapon',true)
	toggleControl('previous_weapon',true)
	unbindKey('mouse_wheel_up','down',ScoreboardScrollingUp)
	unbindKey('mouse_wheel_up','down',ScoreboardScrollingDown)
	removeEventHandler('onClientRender',root,ScoreboardDraw)
end)