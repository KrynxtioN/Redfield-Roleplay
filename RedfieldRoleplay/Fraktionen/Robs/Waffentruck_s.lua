local waffentruckPickup=createPickup(219.03958129883,2.9537336826324,2.578125,3,1239,50)

addEventHandler("onPickupHit",waffentruckPickup,function(player)
	if(isEvil(player) and isPedInVehicle(player))then
		veh=getPedOccupiedVehicle(player)
		if(getElementModel(veh)==482)then
			getChatBox(player,154)
		end
	end
end)

function loadweapons_func(player)
	local query=dbQuery(dbConnection,"SELECT * FROM kassen WHERE Besitzer = '"..getElementData(player,"Fraktion").."'")
	local result,num_rows=dbPoll(query,-1)

	if(isEvil(player) and isPedInVehicle(player))then
		veh=getPedOccupiedVehicle(player)
		if(getElementModel(veh)==482)then
			if(getDistanceBetweenPoints3D(219.03958129883,2.9537336826324,2.578125,getElementPosition(player))<10)then
				getmoney=tonumber(result[1]["Geld"])
				if(getmoney>=2500)then
					if(not(getElementData(veh,"paketeBeladen")))then
						newmoney=tonumber(result[1]["Geld"])-2500
						dbQuery(dbConnection,"UPDATE kassen SET Geld = '"..newmoney.."' WHERE Besitzer = '"..getElementData(player,"Fraktion").."'")
						
						setElementData(veh,"paketeBeladen",true)
						getChatBox(player,157)
					else
						getChatBox(player,156)
					end
				else
					getChatBox(player,155)
				end
			end
		end
	end
end
addCommandHandler("loadweapons",loadweapons_func)