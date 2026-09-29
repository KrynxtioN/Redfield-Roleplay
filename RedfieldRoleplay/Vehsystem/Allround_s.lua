carPrices = {
	[411] = 55000,
	[541] = 45000,
	[415] = 30000,
	[429] = 27500,
	[480] = 40000,
	[477] = 130000,
	[561] = 17500,
	[404] = 5000,
	[458] = 22000,
	[479] = 11000,
	[589] = 13500,
	[522] = 26000,
	[521] = 9000,
	[549] = 1000,
	[542] = 1200,
	[527] = 4000,
	[518] = 5000,
	[405] = 4500,
	[426] = 6000,
	[516] = 3000,
	[529] = 4000,
	[551] = 7000,
	[585] = 8000,
	[512] = 180000,
	[519] = 250000,
	[593] = 150000,
	[513] = 125000,
	[469] = 40000,
	[487] = 80000,
	[484] = 200000,
	[493] = 100000,
	[452] = 80000,
	[446] = 120000,
	[454] = 250000,
	[453] = 70000,
	[473] = 30000,
	[472] = 50000,
}

local allowedCarData = {
	X = true,
	Y = true,
	Z = true,
	Rotation = true,
	Autoid = true,
	Benzin = true
}

local fahrzeugTimer = {}

function getCarData(name,slot,data)
	if not allowedCarData[data] then return nil end
	local query = dbQuery(dbConnection,"SELECT ?? FROM cardata WHERE Besitzer = ? AND Slot = ? LIMIT 1",data,name,slot)
	if not query then return nil end
	local rows = dbPoll(query,-1)
	if rows and rows[1] then return rows[1][data] end
	return nil
end

function setCarData(name,slot,data,value)
	if not allowedCarData[data] then return false end
	return dbExec(dbConnection,"UPDATE cardata SET ?? = ? WHERE Besitzer = ? AND Slot = ?",data,value,name,slot)
end

function vehicleEnter(player,seat)
	if seat == 0 then
		bindKey(player,"x","down",motorAn)
		bindKey(player,"l","down",lichtAn)
	end
end
addEventHandler("onVehicleEnter",root,vehicleEnter)

function vehicleExit(player,seat)
	if seat == 0 then
		unbindKey(player,"x","down",motorAn)
		unbindKey(player,"l","down",lichtAn)
	end
end
addEventHandler("onVehicleExit",root,vehicleExit)

function motorAn(player)
	if not isPedInVehicle(player) or getPedOccupiedVehicleSeat(player) ~= 0 then return end
	local veh = getPedOccupiedVehicle(player)
	if not isElement(veh) then return end

	local benzin = tonumber(getElementData(veh,"Benzin")) or 0
	if benzin <= 0 then
		infobox_func(player,getText(player,"Fahrzeug16"),255,0,0)
		return
	end

	if fahrzeugTimer[veh] and isTimer(fahrzeugTimer[veh]) then return end

	if getVehicleEngineState(veh) then
		setVehicleEngineState(veh,false)
		return
	end

	local motorStuerztAb = math.random(1,20)
	setTimer(function(vehicle)
		if isElement(vehicle) then
			local vx,vy,vz = getElementVelocity(vehicle)
			setElementVelocity(vehicle,vx+math.random(-10,10)/10000,vy+math.random(-10,10)/10000,vz+math.random(2,5)/10000)
		end
	end,100,10,veh)

	if motorStuerztAb ~= 16 then
		fahrzeugTimer[veh] = setTimer(function(vehicle)
			if isElement(vehicle) then setVehicleEngineState(vehicle,true) end
			fahrzeugTimer[vehicle] = nil
		end,1000,1,veh)
	else
		fahrzeugTimer[veh] = setTimer(function(vehicle)
			if isElement(vehicle) then
				local vx,vy,vz = getElementVelocity(vehicle)
				setElementVelocity(vehicle,vx+math.random(-20,20)/10000,vy+math.random(-20,20)/10000,vz+0.003)
			end
			fahrzeugTimer[vehicle] = nil
		end,1000,1,veh)
		infobox_func(player,getText(player,"Fahrzeug5"),255,0,0)
	end
end

function lichtAn(player)
	if not isPedInVehicle(player) or getPedOccupiedVehicleSeat(player) ~= 0 then return end
	local veh = getPedOccupiedVehicle(player)
	if not isElement(veh) then return end
	setVehicleOverrideLights(veh,getVehicleOverrideLights(veh) ~= 2 and 2 or 1)
end

function respawnVeh(player,cmd,slot)
	if not slot then
		infobox_func(player,getText(player,"Fahrzeug7"),255,0,0)
		return
	end

	local besitzer = getPlayerName(player)
	local vehKey = "vehicle"..besitzer..slot
	if not _G[vehKey] then
		infobox_func(player,getText(player,"Fahrzeug6"),255,0,0)
		return
	end

	if isElement(_G[vehKey]) then destroyElement(_G[vehKey]) end

	local x = tonumber(getCarData(besitzer,slot,"X"))
	local y = tonumber(getCarData(besitzer,slot,"Y"))
	local z = tonumber(getCarData(besitzer,slot,"Z"))
	local rotation = tonumber(getCarData(besitzer,slot,"Rotation")) or 0
	local id = tonumber(getCarData(besitzer,slot,"Autoid"))
	local benzin = tonumber(getCarData(besitzer,slot,"Benzin")) or 100

	if not x or not y or not z or not id then
		_G[vehKey] = nil
		infobox_func(player,getText(player,"Fahrzeug6"),255,0,0)
		return
	end

	local veh = createVehicle(id,x,y,z,0,0,rotation,besitzer)
	if not veh then
		_G[vehKey] = nil
		return
	end

	_G[vehKey] = veh
	setElementData(veh,"Besitzer",besitzer)
	setElementData(veh,"Slot",slot)
	setElementData(veh,"Benzin",benzin)
	setVehicleEngineState(veh,false)
	setVehicleLocked(veh,true)
	infobox_func(player,getText(player,"Fahrzeug8"),0,255,0)
end
addCommandHandler("respawnen",respawnVeh)

function lockVehicle(player,cmd,slot)
	if not slot then
		infobox_func(player,getText(player,"Fahrzeug7"),255,0,0)
		return
	end

	local veh = _G["vehicle"..getPlayerName(player)..slot]
	if not isElement(veh) then
		infobox_func(player,getText(player,"Fahrzeug6"),255,0,0)
		return
	end

	local x,y,z = getElementPosition(veh)
	local px,py,pz = getElementPosition(player)
	if getDistanceBetweenPoints3D(x,y,z,px,py,pz) <= 20 then
		infobox_func(player,getText(player,"Fahrzeug9"),255,0,0)
		return
	end

	if isVehicleLocked(veh) then
		setVehicleLocked(veh,false)
		infobox_func(player,getText(player,"Fahrzeug10"),0,255,0)
	else
		setVehicleLocked(veh,true)
		infobox_func(player,getText(player,"Fahrzeug11"),255,0,0)
	end
end
addCommandHandler("lock",lockVehicle)

function sellVehicle(player,cmd,slot)
	if not slot then
		infobox_func(player,getText(player,"Fahrzeug7"),255,0,0)
		return
	end

	local besitzer = getPlayerName(player)
	local vehKey = "vehicle"..besitzer..slot
	local veh = _G[vehKey]

	if not isElement(veh) then
		infobox_func(player,getText(player,"Fahrzeug6"),255,0,0)
		return
	end

	local id = tonumber(getCarData(besitzer,slot,"Autoid"))
	local price = id and carPrices[id]
	if not price then
		infobox_func(player,getText(player,"Fahrzeug12"),255,0,0)
		return
	end

	local sellPrice = math.floor(price*0.5)
	destroyElement(veh)
	_G[vehKey] = nil
	setElementData(player,"Money",tonumber(getElementData(player,"Money"))+sellPrice)
	infobox_func(player,string.format(getText(player,"Fahrzeug1"),sellPrice),0,255,0)
	dbExec(dbConnection,"DELETE FROM cardata WHERE Besitzer = ? AND Slot = ?",besitzer,slot)
end
addCommandHandler("sellcar",sellVehicle)

function parkVehicle(player)
	local veh = getPedOccupiedVehicle(player)
	if not isElement(veh) then return end

	local besitzer = getElementData(veh,"Besitzer")
	local slot = getElementData(veh,"Slot")
	if not besitzer or not slot then return end

	if besitzer ~= getPlayerName(player) then
		infobox_func(player,getText(player,"Fahrzeug13"),255,0,0)
		return
	end

	local x,y,z = getElementPosition(veh)
	local _,_,rz = getElementRotation(veh)
	setCarData(besitzer,slot,"X",x)
	setCarData(besitzer,slot,"Y",y)
	setCarData(besitzer,slot,"Z",z)
	setCarData(besitzer,slot,"Rotation",rz)
	infobox_func(player,getText(player,"Fahrzeug14"),0,255,0)
end
addCommandHandler("park",parkVehicle)

function CheckBenzin()
	local checkedVehicles = {}

	for _,player in ipairs(getElementsByType("player")) do
		if isPedInVehicle(player) and getPedOccupiedVehicleSeat(player) == 0 then
			local veh = getPedOccupiedVehicle(player)

			if isElement(veh) and not checkedVehicles[veh] and getVehicleEngineState(veh) then
				checkedVehicles[veh] = true

				local benzin = tonumber(getElementData(veh,"Benzin")) or 0
				if benzin > 0 then
					local newBenzin = math.max(benzin-1,0)
					local besitzer = getElementData(veh,"Besitzer")
					local slot = getElementData(veh,"Slot")

					setElementData(veh,"Benzin",newBenzin)

					if besitzer and slot and besitzer ~= "Police" and besitzer ~= "Reporter" and besitzer ~= "System" and besitzer ~= "Yakuza" and besitzer ~= "Biker" and besitzer ~= "Ballas" and besitzer ~= "Surenos" then
						setCarData(besitzer,slot,"Benzin",newBenzin)
					end

					if newBenzin <= 0 then setVehicleEngineState(veh,false) end
				else
					setVehicleEngineState(veh,false)
				end
			end
		end
	end
end
setTimer(CheckBenzin,30000,0)

function clickVehicle(button,state,player)
	if button ~= "left" or state ~= "down" or getElementType(source) ~= "vehicle" then return end
	if getElementData(player,"redfieldClick") ~= false then return end

	local x,y,z = getElementPosition(player)
	local vx,vy,vz = getElementPosition(source)
	if getDistanceBetweenPoints3D(vx,vy,vz,x,y,z) >= 10 then return end

	local besitzer = getElementData(source,"Besitzer")
	local benzin = getElementData(source,"Benzin")

	if not besitzer then besitzer = getText(player,"Fahrzeug2") end
	if benzin == nil then benzin = getText(player,"Fahrzeug2") end

	outputChatBox(string.format(getText(player,"Fahrzeug3"),tostring(besitzer)),player,200,100,0)
	outputChatBox(string.format(getText(player,"Fahrzeug4"),tostring(benzin)),player,200,100,0)
end
addEventHandler("onElementClicked",root,clickVehicle)