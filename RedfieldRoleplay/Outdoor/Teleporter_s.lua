local TeleporterIn={
-- X, Y, Z, INTX, INTY, INTZ, ROT, INT, DIM
{-179.39999389648,1177.5,20,-178.39999389648,1137.5,5.5,180,0,1}, -- Bank
{-176.39999389648,1112,19.799999237061,2216.3000488281,-1150.5,1025.8000488281,270,15,0}, -- Motel
{-205.18353271484,1002.9782714844,19.715715408325,246.89999389648,64.5,1003.5999755859,0,6,0}, -- PD Dorf
{-207.69999694824,1119.1999511719,20.49999961853,-195.99772644043,1118.7913818359,6.2813839912415,90,0,1}, -- Stadthalle
{1419.1676025391,-1623.7145996094,13.546875,1727.0999755859,-1640.3000488281,20.200000762939,180,18,0}, -- Möbelhaus
{-320.28231811523,1048.2352294922,20.340259552002,2015.2199707031,-1907.8503417969,-88.631248474121,90,0,0}, -- Krankenhaus
}

local TeleporterOut={
-- X, Y, Z, INT, DIM
{-178.42607116699,1139.6175537109,5.5183153152466,0,1}, -- Bank
{2214.6000976563,-1150.5,1025.9000244141,15,0}, -- Motel
{246.80000305176,62.599998474121,1003.800012207,6,0}, -- PD Dorf
{-193.37344360352,1118.6829833984,5.1328125,0,1}, -- Stadthalle
{1727.0986328125,-1637.8337402344,20.222940444946,18,0}, -- Möbelhaus
{2018.1828613281,-1907.7233886719,-88.631248474121,0,0}, -- Krankenhaus
}

local playerx={}
local playery={}
local playerz={}
local teleportiert={}

function copxyz(player)
	playerx[player]=-201.72288513184
	playery[player]=1002.9848632813
	playerz[player]=19.72061920166
end

function createTeleporter()
	for k,v in ipairs(TeleporterIn)do
		pickup=createPickup(v[1],v[2],v[3],3,1318,50)
		addEventHandler("onPickupHit",pickup,function(player)
			if(teleportiert[player]==nil)then
				teleportiert[player]=true
				local x,y,z=getElementPosition(player)
				
				setTimer(function()
					setElementPosition(player,v[4],v[5],v[6])
					setPedRotation(player,v[7])
					setElementInterior(player,v[8])
					setElementDimension(player,v[9])
				end,1500,1)
				setTimer(function()
					teleportiert[player]=nil
				end,100*50,1)
				
				playerx[player]=x
				playery[player]=y
				playerz[player]=z
				
				triggerClientEvent(player,"ladeBalken",player)
			end
		end)
	end
	
	for k,v in ipairs(TeleporterOut)do
		pickup=createPickup(v[1],v[2],v[3],3,1318,50)
		setElementInterior(pickup,v[4])
		setElementDimension(pickup,v[5])
		
		addEventHandler("onPickupHit",pickup,function(player)
			if(teleportiert[player]==nil)then
				teleportiert[player]=true
				setTimer(function()
					setElementPosition(player,playerx[player],playery[player],playerz[player])
					setElementInterior(player,0)
					setElementDimension(player,0)
				end,1500,1)
				setTimer(function()
					teleportiert[player]=nil
				end,100*50,1)
			
				triggerClientEvent(player,"ladeBalken",player)
			end
		end)
	end
end
setTimer(createTeleporter,2000,1)

local copDachIn=createPickup(226.66780090332,75.792770385742,1005.0390625,3,1318,50)
local copDachOut=createPickup(-226.73481750488,998.13232421875,30.544471740723,3,1318,50)
setElementInterior(copDachIn,6)

addEventHandler("onPickupHit",copDachIn,function(player)
	if(isCop(player))then
		triggerClientEvent(player,"ladeBalken",player)
		setTimer(function()
			setElementPosition(player,-227.14280700684,995.41375732422,30.544471740723)
			setElementInterior(player,0)
		end,1500,1)
	end
end)

addEventHandler("onPickupHit",copDachOut,function(player)
	if(isCop(player))then
		triggerClientEvent(player,"ladeBalken",player)
		setTimer(function()
			setElementPosition(player,229.96192932129,75.758010864258,1005.0390625)
			setElementInterior(player,6)
		end,1500,1)
	end
end)