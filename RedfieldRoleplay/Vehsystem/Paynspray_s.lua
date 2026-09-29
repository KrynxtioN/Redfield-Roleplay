function createPns()
	pnsMarker = {}
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
	
	local newmarker = createMarker(2063.349609375,-1831.2890625,11.252596855164,'cylinder',4,0,0,0)
	setElementAlpha(newmarker,0)
	table.insert(pnsMarker,{newmarker,8})
	local newmarker = createMarker(487.388671875,-1741.552734375,8.837544441223,'cylinder',4,0,0,0)
	setElementAlpha(newmarker,0)
	table.insert(pnsMarker,{newmarker,12})
	local newmarker = createMarker(1025.044921875,-1020.9736328125,32.098804473877,'cylinder',4,0,0,0)
	setElementAlpha(newmarker,0)
	table.insert(pnsMarker,{newmarker,11})	
	local newmarker = createMarker(1977.2177734375,2162.5048828125,11.0703125,'cylinder',4,0,0,0)
	setElementAlpha(newmarker,0)
	table.insert(pnsMarker,{newmarker,36})	
	local newmarker = createMarker(-1420.5849609375,2584.3154296875,55.84326171875,'cylinder',4,0,0,0)
	setElementAlpha(newmarker,0)
	table.insert(pnsMarker,{newmarker,40})	
	local newmarker = createMarker(-100.0478515625,1117.5234375,19.74169921875,'cylinder',4,0,0,0)
	setElementAlpha(newmarker,0)
	table.insert(pnsMarker,{newmarker,41})	
	local newmarker = createMarker(719.955078125,-456.3466796875,16.3359375,'cylinder',4,0,0,0)
	setElementAlpha(newmarker,0)
	table.insert(pnsMarker,{newmarker,47})	
	local newmarker = createMarker(-1904.517578125,285.4404296875,41.046875,'cylinder',4,0,0,0)
	setElementAlpha(newmarker,0)
	table.insert(pnsMarker,{newmarker,19})
	local newmarker = createMarker(-2425.642578125,1021.76953125,50.397659301758,'cylinder',4,0,0,0)
	setElementAlpha(newmarker,0)
	table.insert(pnsMarker,{newmarker,27})
end
createPns()

function pnsMarkerHit(hitElement)
	if getElementType(hitElement) ~= "vehicle" then return end

	for _,v in pairs(pnsMarker) do
		if v[1] == source then
			local player = getVehicleOccupant(hitElement,0)
			if not player or getElementType(player) ~= "player" then return end
			if getElementData(hitElement,"inPaynSpray") then return end

			local price = 25
			if(tonumber(getElementData(player,"Money")) >= price)then
				takePlayerMoney(player,price)
				setElementData(player,"Money",tonumber(getElementData(player,"Money"))-price)
				infobox_func(player,getText(player,"PaynSpray3"),0,255,0)
				setGarageOpen(v[2],false)
				updateEventkasse("einzahlen",price)
				setElementData(hitElement,"inPaynSpray",true)
				setElementData(hitElement,"paynSpray",v[2])
				setTimer(repairPaynSpray,4000,1,hitElement,v[2])
			else
				infobox_func(player,getText(player,"PaynSpray2"),255,0,0)
			end
			return
		end
	end
end

function repairPaynSpray(vehicle,gate)
	setGarageOpen(gate,true)

	if not isElement(vehicle) then return end

	fixVehicle(vehicle)
	setElementData(vehicle,"inPaynSpray",false)
	setElementData(vehicle,"paynSpray",false)

	local player = getVehicleOccupant(vehicle,0)
	if player and getElementType(player) == "player" then
		infobox_func(player,getText(player,"PaynSpray1"),0,255,0)
	end
end

function pnsQuit()
	local vehicle = getPedOccupiedVehicle(source)
	if not vehicle or not isElement(vehicle) then return end
	if not getElementData(vehicle,"inPaynSpray") then return end

	local gate = getElementData(vehicle,"paynSpray")
	if gate then setGarageOpen(gate,true) end

	setElementData(vehicle,"inPaynSpray",false)
	setElementData(vehicle,"paynSpray",false)
end
addEventHandler("onPlayerQuit",root,pnsQuit)

for _,v in pairs(pnsMarker) do
	addEventHandler("onMarkerHit",v[1],pnsMarkerHit)
end