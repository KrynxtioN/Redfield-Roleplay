local colors = {
	[2]={0,50,255,200},
	[3]={100,50,50,50},
	[5]={255,0,200,200},
	[6]={200,200,0,200}
}

local names = {
	[2]={[0]="Yakuza",[1]="Yakuza"},
	[3]={[0]="Biker",[1]="Biker"},
	[5]={[0]="Ballas",[1]="Ballas"},
	[6]={[0]="Surenos",[1]="Surenos"}
}

local gangs = {
	[2]=true,
	[3]=true,
	[5]=true,
	[6]=true
}

local gebiete = 0
local gangarea = {}
local gangpickup = {}
local aktivesgw = false
local angreiferpoints = 0
local verteidigerpoints = 0
local angreifermarker = false
local verteidigermarker = false
local markerwirdeingenommen = false
local attackerfrak = 0
local activeGangwarID = nil
local gwmarker = nil
local pointsTimer = nil
local victoryTimer = nil
local einnehmenTimer = nil
local einnehmer = nil

local function getPlayerLanguage(player)
	local language = tonumber(getElementData(player,"Language")) or 0
	if language ~= 0 and language ~= 1 then language = 0 end
	return language
end

local function getGangName(player,faction)
	faction = tonumber(faction)
	if not faction or not names[faction] then return getText(player,"GangwarUnknown") end
	local language = getPlayerLanguage(player)
	return names[faction][language] or names[faction][0]
end

function getOwnerByColShape(colshape)
	for _,data in pairs(gangpickup) do
		if colshape == data.colshape then return data.besitzer end
	end
	return false
end

local function resetCapture()
	if isTimer(einnehmenTimer) then killTimer(einnehmenTimer) end
	if isElement(einnehmer) then setElementData(einnehmer,"gweinnehmer",false) end
	einnehmenTimer = nil
	einnehmer = nil
	markerwirdeingenommen = false
end

function createGanggebiete()
	local result = dbPoll(dbQuery(dbConnection,"SELECT * FROM ganggebiete"),-1)
	if not result then return end
	for i=1,#result do
		local row = result[i]
		local besitzer = tonumber(row.Besitzer)
		local x1,y1,x2,y2 = tonumber(row.Posx1),tonumber(row.Posy1),tonumber(row.Posx2),tonumber(row.Posy2)
		local tkx,tky,tkz = tonumber(row.Tkx),tonumber(row.Tky),tonumber(row.Tkz)
		if gangs[besitzer] and x1 and y1 and x2 and y2 and tkx and tky and tkz then
			gebiete = gebiete+1
			local minX,minY = math.min(x1,x2),math.min(y1,y2)
			local xs,ys = math.abs(x1-x2),math.abs(y1-y2)
			local area = gebiete
			gangarea[area] = createRadarArea(minX,minY,xs,ys,colors[besitzer][1],colors[besitzer][2],colors[besitzer][3],150,root)
			gangpickup[area] = {
				pickup = createPickup(tkx,tky,tkz,3,1313,50),
				besitzer = besitzer,
				tkx = tkx,
				tky = tky,
				tkz = tkz,
				original = row.ID,
				blocked = false,
				blockTimer = nil,
				colshape = createColCuboid(minX,minY,-50,xs,ys,7500)
			}
			addEventHandler("onPickupHit",gangpickup[area].pickup,function(player)
				if getElementType(player) ~= "player" then return end
				if getElementData(player,"loggedin") ~= 1 or not isEvil(player) then return end
				if not aktivesgw then
					infobox_func(player,getText(player,"Gangwar1"),255,255,255)
				end
			end)
			addEventHandler("onColShapeHit",gangpickup[area].colshape,function(element)
				if getElementType(element) ~= "player" then return end
				if aktivesgw then return end
				triggerClientEvent(element,"renderGangwar",element,getGangName(element,gangpickup[area].besitzer))
			end)
			addEventHandler("onColShapeLeave",gangpickup[area].colshape,function(element)
				if getElementType(element) ~= "player" then return end
				triggerClientEvent(element,"unrenderGangwar",element)
			end)
		end
	end
end
createGanggebiete()

function attack_func(player)
	if getElementData(player,"loggedin") ~= 1 then return end
	local attacker = tonumber(getElementData(player,"Fraktion")) or 0
	if not gangs[attacker] then return end
	if isPedInVehicle(player) then
		infobox_func(player,getText(player,"Gangwar2"),255,0,0)
		return
	end
	if aktivesgw then
		infobox_func(player,getText(player,"Gangwar3"),255,0,0)
		return
	end
	local x,y,z = getElementPosition(player)
	local validID = nil
	for i=1,gebiete do
		local xx,yy,zz = getElementPosition(gangpickup[i].pickup)
		if getElementInterior(player) == getElementInterior(gangpickup[i].pickup) and getElementDimension(player) == getElementDimension(gangpickup[i].pickup) and getDistanceBetweenPoints3D(x,y,z,xx,yy,zz) < 5 then
			validID = i
			break
		end
	end
	if not validID then
		infobox_func(player,getText(player,"Gangwar4"),255,0,0)
		return
	end
	local owner = tonumber(gangpickup[validID].besitzer)
	if gangpickup[validID].blocked then
		infobox_func(player,getText(player,"Gangwar5"),255,0,0)
		return
	end
	if attacker == owner then
		infobox_func(player,getText(player,"Gangwar6"),255,0,0)
		return
	end
	if (tonumber(getElementData(player,"Fraktionrang")) or 0) < 3 then
		infobox_func(player,getText(player,"Gangwar7"),255,0,0)
		return
	end
	activeGangwarID = validID
	attackerfrak = attacker
	setElementData(player,"Gwsgestartet",(tonumber(getElementData(player,"Gwsgestartet")) or 0)+1)
	giveErfahrungspunkte(player,100)
	for _,target in ipairs(getElementsByType("player")) do
		outputChatBox(getText(target,"Gangwar8"):format(getGangName(target,attacker),getGangName(target,owner)),target,150,0,0)
	end
	startgw_func()
end
addCommandHandler("attack",attack_func)

function startgw_func()
	if not activeGangwarID or not gangpickup[activeGangwarID] then return end
	aktivesgw = true
	angreiferpoints = 0
	verteidigerpoints = 0
	angreifermarker = false
	verteidigermarker = false
	markerwirdeingenommen = false
	setRadarAreaFlashing(gangarea[activeGangwarID],true)
	setRadarAreaColor(gangarea[activeGangwarID],200,0,0,100)
	local x,y,z = gangpickup[activeGangwarID].tkx,gangpickup[activeGangwarID].tky,gangpickup[activeGangwarID].tkz
	gwmarker = createMarker(x,y,z,"checkpoint",2,255,255,255,200)
	pointsTimer = setTimer(function()
		if angreifermarker then
			angreiferpoints = angreiferpoints+1
		elseif verteidigermarker then
			verteidigerpoints = verteidigerpoints+1
		end
	end,60000,15)
	victoryTimer = setTimer(finishgw_func,900000,1)
	addEventHandler("onMarkerHit",gwmarker,function(player)
		if getElementType(player) ~= "player" then return end
		if getElementData(player,"loggedin") ~= 1 or not isEvil(player) then return end
		if not activeGangwarID or markerwirdeingenommen then return end
		local faction = tonumber(getElementData(player,"Fraktion")) or 0
		local owner = tonumber(gangpickup[activeGangwarID].besitzer)
		if faction ~= owner and faction ~= attackerfrak then return end
		if faction == attackerfrak and angreifermarker then return end
		if faction == owner and verteidigermarker then return end
		markerwirdeingenommen = true
		einnehmer = player
		setElementData(player,"gweinnehmer",true)
		infobox_func(player,getText(player,"Gangwar9"),255,255,255)
		einnehmenTimer = setTimer(function(target,captureFaction)
			if not isElement(target) or not isElement(gwmarker) or not activeGangwarID then
				resetCapture()
				return
			end
			if not isElementWithinMarker(target,gwmarker) then
				resetCapture()
				return
			end
			local ownerFaction = tonumber(gangpickup[activeGangwarID].besitzer)
			if captureFaction == attackerfrak then
				angreifermarker = true
				verteidigermarker = false
			elseif captureFaction == ownerFaction then
				angreifermarker = false
				verteidigermarker = true
			else
				resetCapture()
				return
			end
			local color = colors[captureFaction]
			setMarkerColor(gwmarker,color[1],color[2],color[3],color[4])
			setElementData(target,"gweinnehmer",false)
			einnehmer = nil
			einnehmenTimer = nil
			markerwirdeingenommen = false
			infobox_func(target,getText(target,"Gangwar10"),0,255,0)
		end,10000,1,player,faction)
	end)
	addEventHandler("onMarkerLeave",gwmarker,function(player)
		if getElementType(player) ~= "player" or player ~= einnehmer then return end
		if isTimer(einnehmenTimer) then killTimer(einnehmenTimer) end
		einnehmenTimer = nil
		setElementData(player,"gweinnehmer",false)
		einnehmer = nil
		markerwirdeingenommen = false
		infobox_func(player,getText(player,"Gangwar11"),255,0,0)
	end)
end

function finishgw_func()
	if not activeGangwarID or not gangpickup[activeGangwarID] then return end
	local id = activeGangwarID
	local owner = tonumber(gangpickup[id].besitzer)
	local attacker = attackerfrak
	if isTimer(pointsTimer) then killTimer(pointsTimer) end
	if isTimer(victoryTimer) then killTimer(victoryTimer) end
	resetCapture()
	setRadarAreaFlashing(gangarea[id],false)
	if angreiferpoints > verteidigerpoints and gangs[attacker] then
		dbExec(dbConnection,"UPDATE ganggebiete SET Besitzer = ? WHERE ID = ?",attacker,gangpickup[id].original)
		gangpickup[id].besitzer = attacker
		setRadarAreaColor(gangarea[id],colors[attacker][1],colors[attacker][2],colors[attacker][3],150)
		for _,target in ipairs(getElementsByType("player")) do
			outputChatBox(getText(target,"Gangwar12"):format(getGangName(target,attacker),getGangName(target,owner),angreiferpoints,verteidigerpoints),target,0,200,0)
		end
	else
		setRadarAreaColor(gangarea[id],colors[owner][1],colors[owner][2],colors[owner][3],150)
		for _,target in ipairs(getElementsByType("player")) do
			outputChatBox(getText(target,"Gangwar13"):format(getGangName(target,owner),getGangName(target,attacker),verteidigerpoints,angreiferpoints),target,200,100,0)
		end
	end
	if isElement(gwmarker) then destroyElement(gwmarker) end
	gwmarker = nil
	pointsTimer = nil
	victoryTimer = nil
	aktivesgw = false
	angreiferpoints = 0
	verteidigerpoints = 0
	angreifermarker = false
	verteidigermarker = false
	attackerfrak = 0
	activeGangwarID = nil
	gangpickup[id].blocked = true
	if isTimer(gangpickup[id].blockTimer) then killTimer(gangpickup[id].blockTimer) end
	gangpickup[id].blockTimer = setTimer(function(areaID)
		if gangpickup[areaID] then
			gangpickup[areaID].blocked = false
			gangpickup[areaID].blockTimer = nil
		end
	end,3600000,1,id)
end

addEventHandler("onPlayerQuit",root,function()
	if source == einnehmer then resetCapture() end
end)