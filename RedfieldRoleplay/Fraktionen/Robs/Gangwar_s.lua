local colors = {

[2] = {0,50,255,200},
[3] = {100,50,50,50},
[5] = {255,0,200,200},
[6] = {200,200,0,0},

}

local names = {

[2] = 'Yakuza',
[3] = 'Biker',
[5] = 'Ballas',
[6] = 'Surenos',

}

local gangs = {

[2] = true,
[3] = true,
[5] = true,
[6] = true

}

local gebiete = 0
local gangarea = {}
local gangpickup = {}
local aktivesgw = false
local angreiferpoints = 1
local verteidigerpoints = 0
local angreifermarker = false
local verteidigermarker = false
local bikerAttacker = false
local yakuzaAttacker = false
local ballasAttacker = false
local surenosAttacker = false
local markerwirdeingenommen = false
local attackerfrak = 0

function getOwnerByColShape(colshape)
	for index,tables in pairs (gangpickup)do
		if(colshape==tables["colshape"])then
			return tables["besitzer"]
		end
	end
	return false
end

function createGanggebiete()
	local result = dbPoll(dbQuery(dbConnection,'SELECT * FROM ganggebiete'),-1)
	for i = 1,#result do
		local row = result[i]
		gebiete = gebiete+1
		local besitzer = tonumber(row['Besitzer'])
		local x1 = tonumber(row['Posx1'])
		local y1 = tonumber(row['Posy1'])
		local x2 = tonumber(row['Posx2'])
		local y2 = tonumber(row['Posy2'])
		local xs = math.abs(x1-x2)
		local ys = math.abs(y1-y2)
		local tkx = tonumber(row['Tkx'])
		local tky = tonumber(row['Tky'])
		local tkz = tonumber(row['Tkz'])
		local r = colors[besitzer][1]
		local g = colors[besitzer][2]
		local b = colors[besitzer][3]
		gangarea[gebiete] = createRadarArea(x1,y1,xs,ys,r,g,b,150,root)
		gangpickup[gebiete] = {
		['pickup'] = createPickup(tkx,tky,tkz,3,1313,50),
		['besitzer'] = besitzer,
		['tkx'] = tkx,
		['tky'] = tky,
		['tkz'] = tkz,
		['original'] = row['ID'],
		['blocked'] = false,
		["colshape"] = createColCuboid(x1,y1,-50,xs,ys,7500) }
		addEventHandler('onPickupHit',gangpickup[gebiete]['pickup'],function(player)
			if(isEvil(player))then
				if(aktivesgw == false)then
					getChatBox(player,99)
				end
			end
		end)
		addEventHandler("onColShapeHit",gangpickup[gebiete]["colshape"],function(player)
			if(aktivesgw == false)then
				triggerClientEvent(player,"renderGangwar",player,names[getOwnerByColShape(source)])
			end
		end)
		addEventHandler("onColShapeLeave",gangpickup[gebiete]["colshape"],function(player)
			triggerClientEvent(player,"unrenderGangwar",player)
		end)
	end
end
createGanggebiete()

function attack_func(player)
	if(gangs[getElementData(player,'Fraktion')])then
		if(not(isPedInVehicle(player)))then
			local x,y,z = getElementPosition(player)
			sucess = false
			validId = nil
			for i = 1,gebiete do
				local xx,yy,zz = getElementPosition(gangpickup[i]['pickup'])
				if(getDistanceBetweenPoints3D(x,y,z,xx,yy,zz) < 5)then
					validID = i
					sucess = true
					break
				end
			end
			if(sucess)then
				if(aktivesgw == false)then
					local attacker = getElementData(player,'Fraktion')
					local owner = gangpickup[validID]['besitzer']
					if(gangpickup[validID]['blocked'] == false)then
						if(attacker ~= owner)then
							if(getElementData(player,'Fraktionrang') >= 3)then
								giveErfahrungspunkte(player,100)
								startgw_func()
								setElementData(player,'Gwsgestartet',getElementData(player,'Gwsgestartet')+1)
								outputChatBox('Die '..names[attacker]..' haben einen Gangwar gegen die '..names[owner]..' gestartet!',root,150,0,0)
								if(attacker == 2)then
									yakuzaAttacker = true
									attackerfrak = 2
								elseif(attacker == 3)then
									bikerAttacker = true
									attackerfrak = 3
								elseif(attacker == 5)then	
									ballasAttacker = true
									attackerfrak = 5
								elseif(attacker == 6)then
									surenosAttacker = true
									attackerfrak = 6
								end
							else
								getChatBoxt(player,100)
							end
						end
					else
						getChatBox(player,101)
					end
				else
					getChatBox(player,102)
				end
			end
		else 
			getChatBox(player,103)
		end
	end
end
addCommandHandler('attack',attack_func)

function startgw_func()
	pointsTimer = setTimer(function()
		if(angreifermarker == true)then
			angreiferpoints = angreiferpoints + 1
		elseif(verteidigermarker == true)then
			verteidigerpoints = verteidigerpoints + 1
		end
	end,60000,15)
	
	victoryTimer = setTimer(finishgw_func,900000,1)

	aktivesgw = true
	setRadarAreaFlashing(gangarea[validID],true)
	setRadarAreaColor(gangarea[validID],200,0,0,100)
	local x = gangpickup[validID]['tkx']
	local y = gangpickup[validID]['tky']
	local z = gangpickup[validID]['tkz']
	gwmarker = createMarker(x,y,z,'checkpoint',2,255,255,255)
	addEventHandler('onMarkerHit',gwmarker,function(player)
		if(isEvil(player))then
			local attacker = getElementData(player,'Fraktion')
			local owner = gangpickup[validID]['besitzer']
			
			if(getElementData(player,'Fraktion') == owner or getElementData(player,'Fraktion') == attackerfrak)then
				if(markerwirdeingenommen == false)then
					if(attacker ~= owner)then
						if(angreifermarker == false)then
							markerwirdeingenommen = true
							setElementData(player,'gweinnehmer',true)
							getChatBox(player,104)
							einnehmenTimer = setTimer(function()
								angreifermarker = true
								verteidigermarker = false
								setMarkerColor(gwmarker,colors[attacker][1],colors[attacker][2],colors[attacker][3],colors[attacker][4])
							end,10000,1)
						end
					else
						if(verteidigermarker == false)then
							markerwirdeingenommen = true
							setElementData(player,'gweinnehmer',true)
							getChatBox(player,104)
							einnehmenTimer = setTimer(function()
								angreifermarker = false
								verteidigermarker = true
								setMarkerColor(gwmarker,colors[owner][1],colors[owner][2],colors[owner][3],colors[owner][4])
							end,10000,1)
						end
					end
				end
			end
		end
	end)
	addEventHandler('onMarkerLeave',gwmarker,function(player)
		if(markerwirdeingenommen == true)then
			if(getElementData(player,'gweinnehmer') == true)then
				if(isTimer(einnehmenTimer))then
					killTimer(einnehmenTimer)
					getChatBox(player,105)
				end
				setElementData(player,'gweinnehmer',false)
				markerwirdeingenommen = false
			end
		end
	end)
end

function finishgw_func()
	setRadarAreaFlashing(gangarea[validID],false)
	local owner = gangpickup[validID]['besitzer']
	
	if(angreiferpoints>verteidigerpoints)then
		if(yakuzaAttacker == true)then
			dbExec(dbConnection,"UPDATE ?? SET ??  =  ? WHERE ??  =  ?","ganggebiete","Besitzer",'2',"ID",gangpickup[validID]["original"])
			setRadarAreaColor(gangarea[validID],0,0,200,150)
		end
		if(bikerAttacker == true)then
			dbExec(dbConnection,"UPDATE ?? SET ??  =  ? WHERE ??  =  ?","ganggebiete","Besitzer",'3',"ID",gangpickup[validID]["original"])
			setRadarAreaColor(gangarea[validID],100,50,50,150)
		end
		if(ballasAttacker == true)then
			dbExec(dbConnection,"UPDATE ?? SET ??  =  ? WHERE ??  =  ?","ganggebiete","Besitzer",'5',"ID",gangpickup[validID]["original"])
			setRadarAreaColor(gangarea[validID],255,0,200,150)
		end
		if(surenosAttacker == true)then
			dbExec(dbConnection,"UPDATE ?? SET ??  =  ? WHERE ??  =  ?","ganggebiete","Besitzer",'6',"ID",gangpickup[validID]["original"])
			setRadarAreaColor(gangarea[validID],200,200,0,150)
		end
	else
		setRadarAreaColor(gangarea[validID],colors[owner][1],colors[owner][2],colors[owner][3],100)
	end
	aktivesgw = false
	angreiferpoints = 0
	verteidigerpoints = 0
	angreifermarker = false
	verteidigermarker = false
	destroyElement(gwmarker)
	yakuzaAttacker = false
	bikerAttacker = false
	ballasAttacker = false
	surenosAttacker = false
	attackerfrak = 0
	gangpickup[validID]['blocked'] = true
end