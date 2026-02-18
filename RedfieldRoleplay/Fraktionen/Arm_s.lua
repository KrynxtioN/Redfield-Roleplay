local yakuzaarm = createPickup(-2165.6899414063,646.27423095703,1052.375,3,353,50)
local bikerarm = createPickup(-217.61991882324,1401.9215087891,27.7734375,3,353,50)
local ballasarm = createPickup(961.10998535156,2112.453125,1011.0234375,3,353,50)
local surenosarm = createPickup(312.75573730469,1124.1958007813,1083.8828125,3,353,50)
setElementInterior(bikerarm,18)
setElementInterior(yakuzaarm,1)
setElementInterior(ballasarm,1)
setElementInterior(surenosarm,5)

function armPickupHit(player)
	if(isEvil(player))then
		getChatBox(player,89)
	end
end
addEventHandler('onPickupHit',yakuzaarm,armPickupHit)
addEventHandler('onPickupHit',bikerarm,armPickupHit)
addEventHandler('onPickupHit',ballasarm,armPickupHit)
addEventHandler('onPickupHit',surenosarm,armPickupHit)

addCommandHandler('arm',function(player)
	local query=dbQuery(dbConnection,"SELECT * FROM kassen WHERE Besitzer = '"..getElementData(player,"Fraktion").."'")
	local result,num_rows=dbPoll(query,-1)

	if(isEvil(player))then
		local dis = getDistanceBetweenPoints3D
		local x,y,z = getElementPosition(player)
		if(dis(-2165.6899414063,646.27423095703,1052.375,x,y,z) < 5)or(dis(-217.61991882324,1401.9215087891,27.7734375,x,y,z) < 5)or(dis(961.10998535156,2112.453125,1011.0234375,x,y,z) < 5)or(dis(312.75573730469,1124.1958007813,1083.8828125,x,y,z) < 5)then
			if(tonumber(result[1]["Waffenpakete"])>=1)then
				giveWeapon(player,24,50,true)
				giveWeapon(player,29,250,true)
				giveWeapon(player,31,300,true)
				giveWeapon(player,33,50,true)
				newpakete=tonumber(result[1]["Waffenpakete"])-1
				dbQuery(dbConnection,"UPDATE kassen SET Waffenpakete = '"..newpakete.."' WHERE Besitzer = '"..getElementData(player,"Fraktion").."'")
			else
				getChatBox(player,160)
			end
		end
	end
end)

--1279