local WangCars = createBlip(-1965.0631103516,293.7331237793,35.46875,55,0,0,0,0,0,0,200,root)
local OttosCars = createBlip(-1645.1030273438,1205.021484375,7.25,55,0,0,0,0,0,0,200,root)
local FortCarson = createBlip(-230.95945739746,1218.01953125,19.7421875,55,0,0,0,0,0,0,200,root)
local Flughafen = createBlip(1956.7330322266,-2183.6652832031,13.546875,5,0,0,0,0,0,0,200,root)

local AutohausFahrzeuge={

createVehicle(getVehicleModelFromName('infernus'),-1648.9000244141,1207.5999755859,13.5,0,0,20),
createVehicle(getVehicleModelFromName('bullet'),-1664.4000244141,1222.5999755859,13.39999961853,0,0,210),
createVehicle(getVehicleModelFromName('cheetah'),-1668.0999755859,1207.1999511719,7.0999999046326,0,0,332),
createVehicle(getVehicleModelFromName('banshee'),-1654.3000488281,1214.0999755859,7,0,0,180),
createVehicle(getVehicleModelFromName('zr-350'),-1662.1999511719,1206.5999755859,21,0,0,0),
createVehicle(getVehicleModelFromName('comet'),-1650.4000244141,1209.4000244141,21,0,0,68),
createVehicle(getVehicleModelFromName('tampa'),-260.60000610352,1221.1999511719,19.60000038147,0,0,208),
createVehicle(getVehicleModelFromName('clover'),-255.89999389648,1221,19.60000038147,0,0,208),
createVehicle(getVehicleModelFromName('cadrona'),-251.39999389648,1221.5,19.5,0,0,208),
createVehicle(getVehicleModelFromName('buccaneer'),-246.39999389648,1221,19.5,0,0,208),
createVehicle(getVehicleModelFromName('sentinel'),-241.69999694824,1221.0999755859,19.700000762939,0,0,208),
createVehicle(getVehicleModelFromName('premier'),-236.69999694824,1221.0999755859,19.60000038147,0,0,208),
createVehicle(getVehicleModelFromName('nebula'),-231.60000610352,1221.0999755859,19.60000038147,0,0,208),
createVehicle(getVehicleModelFromName('willard'),-226.69999694824,1221.1999511719,19.5,0,0,208),
createVehicle(getVehicleModelFromName('merit'),-221.5,1220.8000488281,19.60000038147,0,0,208),
createVehicle(getVehicleModelFromName('emperor'),-216.89999389648,1220.9000244141,19.39999961853,0,0,208),
createVehicle(getVehicleModelFromName('stratum'),-1945.2998046875,272.900390625,35.400001525879,0,0,119.99816894531),
createVehicle(getVehicleModelFromName('perennial'),-1947.2001953125,256.900390625,35.299999237061,0,0,27.998657226563),
createVehicle(getVehicleModelFromName('solair'),-1956.099609375,256.599609375,35.400001525879,0,0,0),
createVehicle(getVehicleModelFromName('regina'),-1961.900390625,269.900390625,35.400001525879,0,0,303.99719238281),
createVehicle(getVehicleModelFromName('club'),-1963.2001953125,284.2998046875,35.200000762939,0,0,344.49829101563),
createVehicle(getVehicleModelFromName('nrg-500'),-1951.400390625,290.599609375,35.099998474121,0,0,65.994873046875),
createVehicle(getVehicleModelFromName('fcr-900'),-1951.5,294.2001953125,35.099998474121,0,0,69.999328613281),
createVehicle(getVehicleModelFromName('cropduster'),2010.6999511719,-2181.3000488281,14.199999809265,0,0,214),
createVehicle(getVehicleModelFromName('shamal'),2043.2998046875,-2188.7001953125,14.5,0,0,90),
createVehicle(getVehicleModelFromName('dodo'),2002.2998046875,-2218.599609375,14.10000038147,0,0,0),
createVehicle(getVehicleModelFromName('stuntplane'),2018.2998046875,-2219.2998046875,14.300000190735,0,0,35.996704101563),
createVehicle(getVehicleModelFromName('sparrow'),2034.2001953125,-2217.2998046875,13.60000038147,0,0,327.99682617188),
createVehicle(getVehicleModelFromName('maverick'),2048.400390625,-2216.7001953125,13.800000190735,0,0,0),
createVehicle(getVehicleModelFromName('marquis'),-2232.3999023438,2450.1000976563,-0,0,0,226),
createVehicle(getVehicleModelFromName('jetmax'),-2242.3000488281,2443,-0,0,0,226),
createVehicle(getVehicleModelFromName('speeder'),-2255.1000976563,2429.6999511719,-0,0,0,226),
createVehicle(getVehicleModelFromName('squalo'),-2261.3999023438,2422.3999023438,0,0,0,226),
createVehicle(getVehicleModelFromName('tropic'),-2231,2390.1005859375,0,0,0,46),
createVehicle(getVehicleModelFromName('reefer'),-2222.8994140625,2399,0,0,0,46),
createVehicle(getVehicleModelFromName('dinghy'),-2208.2001953125,2410,0,0,0,46),
createVehicle(getVehicleModelFromName('coastguard'),-2201.8994140625,2417.6005859375,0,0,0,46),

}

for i=1,#AutohausFahrzeuge,1 do
	setVehicleLocked(AutohausFahrzeuge[i],true)
	setElementFrozen(AutohausFahrzeuge[i],true)
	setVehicleDamageProof(AutohausFahrzeuge[i],false)
	setElementData(AutohausFahrzeuge[i],"Benzin",0)
	
	addEventHandler("onElementClicked",AutohausFahrzeuge[i],function(theButton,theState,player)
		if(theButton=="left" and theState=="down")then
			triggerClientEvent(player,"buyVehicleWindow",player,getElementModel(source))
		end
	end)
end

function buyVehicle(vehid,preis,sx,sy,sz,rotation)
	local freeslot = 0
	
	for i=1,10 do
		if(not(_G['vehicle'..getPlayerName(source)..i]))then
			freeslot = i break
		end
	end
	if(not(freeslot==0))then
		--if(getPlayerMoney(source) >= tonumber(preis))then
			local r = math.random(1,255)
			local g = math.random(1,255)
			local b = math.random(1,255)

			giveErfahrungspunkte(source,60)
			_G['vehicle'..getPlayerName(source)..freeslot]=createVehicle(vehid,sx,sy,sz,0,0,rotation)
			setElementRotation(_G['vehicle'..getPlayerName(source)..freeslot],0,0,180)
			setVehiclePlateText(_G['vehicle'..getPlayerName(source)..freeslot],getPlayerName(source))
			setVehicleLocked(_G['vehicle'..getPlayerName(source)..freeslot],true)
			setElementData(_G['vehicle'..getPlayerName(source)..freeslot],'Slot',freeslot)
			setElementData(_G['vehicle'..getPlayerName(source)..freeslot],'Besitzer',getPlayerName(source))
			setElementData(_G['vehicle'..getPlayerName(source)..freeslot],'Benzin',100)
			warpPedIntoVehicle(source,_G['vehicle'..getPlayerName(source)..freeslot])
			setVehicleEngineState(_G['vehicle'..getPlayerName(source)..freeslot],false)
			setVehicleColor(_G['vehicle'..getPlayerName(source)..freeslot],r,g,b)
			dbExec(dbConnection,"INSERT INTO cardata (Besitzer,Slot,Autoid,X,Y,Z,Rotation,Benzin,R,G,B) VALUES ('"..getPlayerName(source).."','"..freeslot.."','"..vehid.."','"..sx.."','"..sy.."','"..sz.."','"..rotation.."','100','"..r.."','"..g.."','"..b.."')")
			takePlayerMoney(source,tonumber(preis))
			updateEventkasse("einezahlen",tonumber(preis))
			getChatBox(source,53)
			if(getElementData(source,'AchFahrzeug')==0)then
				setElementData(source,'AchFahrzeug',1)
				achievmentInfo(source)
			end
		--else 
		--	getChatBox(source,33)
		--end
	else 
		getChatBox(source,54)
	end
end
addEvent('buyVehicle',true)
addEventHandler('buyVehicle',root,buyVehicle)

function createVehicleScriptStart()
	local vehicle = dbQuery(dbConnection,"SELECT * FROM `??`","cardata")
	local result,row = dbPoll(vehicle,-1)
	local autos = 0
	
	if((result)and(row) >= 1)then
		for i,vehicle in pairs(result)do
			local besitzer = vehicle['Besitzer']
			local slot = vehicle['Slot']
			local x = vehicle['X']
			local y = vehicle['Y']
			local z = vehicle['Z']
			local rotation = vehicle['Rotation']
			local autoid = vehicle['Autoid']
			local benzin = vehicle['Benzin']
			local r = vehicle['R']
			local g = vehicle['G']
			local b = vehicle['B']
			_G['vehicle'..besitzer..slot]=createVehicle(autoid,x,y,z,0,0,rotation,besitzer)
			setVehicleColor(_G['vehicle'..besitzer..slot],r,g,b)
			setVehicleLocked(_G['vehicle'..besitzer..slot],true)
			setElementData(_G['vehicle'..besitzer..slot],'Slot',slot)
			setElementData(_G['vehicle'..besitzer..slot],'Besitzer',besitzer)
			setElementData(_G['vehicle'..besitzer..slot],'Benzin',benzin)
			setVehicleEngineState(_G['vehicle'..besitzer..slot],false)
			setElementFrozen(_G['vehicle'..besitzer..slot],true)
			setElementDimension(_G["vehicle"..besitzer..slot],math.random(99,999))
			addEventHandler('onVehicleEnter',_G['vehicle'..besitzer..slot],function(player)
				setElementFrozen(_G['vehicle'..besitzer..slot],false)
			end)
			autos = autos + 1
		end
		outputDebugString(autos..' vehicle(s) load')
	end
end
createVehicleScriptStart()