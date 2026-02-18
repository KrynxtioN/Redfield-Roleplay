function createPns()
	pnsMarker={}
	setGarageOpen(12,true)
	setGarageOpen(8,true)
	setGarageOpen(11,true)
	setGarageOpen(36,true)
	setGarageOpen(40,true)
	setGarageOpen(41,true)
	setGarageOpen(47,true)
	setGarageOpen(32,true)
	setGarageOpen(19,true)
	setGarageOpen(27,true)
	
	local newmarker=createMarker(2063.349609375,-1831.2890625,11.252596855164,'cylinder',4,0,0,0)
	setElementAlpha(newmarker,0)
	table.insert(pnsMarker,{newmarker,8})
	local newmarker=createMarker(487.388671875,-1741.552734375,8.837544441223,'cylinder',4,0,0,0)
	setElementAlpha(newmarker,0)
	table.insert(pnsMarker,{newmarker,12})
	local newmarker=createMarker(1025.044921875,-1020.9736328125,32.098804473877,'cylinder',4,0,0,0)
	setElementAlpha(newmarker,0)
	table.insert(pnsMarker,{newmarker,11})	
	local newmarker=createMarker(1977.2177734375,2162.5048828125,11.0703125,'cylinder',4,0,0,0)
	setElementAlpha(newmarker,0)
	table.insert(pnsMarker,{newmarker,36})	
	local newmarker=createMarker(-1420.5849609375,2584.3154296875,55.84326171875,'cylinder',4,0,0,0)
	setElementAlpha(newmarker,0)
	table.insert(pnsMarker,{newmarker,40})	
	local newmarker=createMarker(-100.0478515625,1117.5234375,19.74169921875,'cylinder',4,0,0,0)
	setElementAlpha(newmarker,0)
	table.insert(pnsMarker,{newmarker,41})	
	local newmarker=createMarker(719.955078125,-456.3466796875,16.3359375,'cylinder',4,0,0,0)
	setElementAlpha(newmarker,0)
	table.insert(pnsMarker,{newmarker,47})	
	local newmarker=createMarker(-1904.517578125,285.4404296875,41.046875,'cylinder',4,0,0,0)
	setElementAlpha(newmarker,0)
	table.insert(pnsMarker,{newmarker,19})
	local newmarker=createMarker(-2425.642578125,1021.76953125,50.397659301758,'cylinder',4,0,0,0)
	setElementAlpha(newmarker,0)
	table.insert(pnsMarker,{newmarker,27})
	
	for k,v in ipairs(pnsMarker)do
		local x,y,z=getElementPosition(v[1])
		createBlip(x,y,z,63,0,0,0,0,0,0,200,root)
	end
end
createPns()

function pnsMarkerHit(player)
	if(isElement(player))then
		if(getElementType(player) == 'vehicle')then
			for k,v in pairs(pnsMarker)do
				if(v[1] == source)then
					local veh = getVehicleOccupant(player,0)
					if(veh)then
						local price = 25
						if(getPlayerMoney(veh) >= price)then
							takePlayerMoney(veh,25)
							getChatBox(veh,51)
							setGarageOpen(v[2],false)
							updateEventkasse("einzahlen",25)
							setElementData(veh,'inPaynSpray',true)
							setElementData(veh,'paynSpray',v[2])
							setTimer(repairPaynSpray,4000,1,player,v[2])
						else
							getChatBox(veh,33)
						end
					end
				end
			end
		end
	end
end
addEventHandler('onMarkerHit',getRootElement(),pnsMarkerHit)

function repairPaynSpray(player,gate)
	local veh = getVehicleOccupant(player,0)
	fixVehicle(player)
	setGarageOpen(gate,true)
	setElementData(veh,'inPaynSpray',true)
	getChatBox(veh,52)
end

function pnsQuit()
	if(getElementData(source,'inPaynSpray'))then
	setGarageOpen(getElementData(source,'paynSpray'),true)end
end
addEventHandler('onPlayerQuit',root,pnsQuit)