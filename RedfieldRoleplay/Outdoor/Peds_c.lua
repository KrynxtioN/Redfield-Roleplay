local ServerpedsText = {
	-- ID, X, Y, Z, ROT, INT, DIM
	{141,359.79998779297,173.5,1008.4000244141,270,3,0}, -- Stadthalle
	{171,-174.19999694824,1134.3000488281,5.5,95,0,1}, -- Bank
	{76,2217.3000488281,-1145.3000488281,1026,180,15,0}, -- Motel
	{280,251.19999694824,68.5,1003.5999755859,90,6,0}, -- Police Department
	{147,-212.60000610352,1119.3000488281,5.0999999046326,270,0,1}, -- Stadthalle
	{155,2123,-1823.0999755859,13.60000038147,170,0,0}, -- Pizzajob
	{202,638.90002441406,1683.5,7.1999998092651,42,0,0}, -- Tankwart
	{61,-1421.0999755859,-287,14.10000038147,144,0,0}, -- Pilot
	{158,-538.29998779297,-78.199996948242,62.900001525879,270,0,0}, -- Holzfäller
	{159,-2015.5,-2395.6999511719,30.60000038147,140,0,0}, -- Sägewerk
	{11,-207.63023376465,1114.8167724609,5.1393160820007,0,0,1}, -- Jobcenter
	{253,12.60000038147,1225.5,19.299999237061,90,0,0}, -- Busjob
	{158,-1061.4000244141,-1195.5999755859,129.80000305176,270,0,0}, -- Farmerjob
	{70,2010.1999511719,-1915,-88.599998474121,0,0,0}, -- Krankenversicherung
}

local NormalPeds = {
	{27,-203.80000305176,1086.5999755859,19.700000762939,170,0,0}, -- Bauarbeiter 1 Hotel
	{260,-203.89999389648,1085.5999755859,19.700000762939,0,0,0}, -- Bauarbeiter 2 Hotel
	{29,2322.8000488281,-1223.4000244141,22.60000038147,270,0,0}, -- Drogendealer
}

local interactionPed = nil

function createPeds()
	for _,v in ipairs(NormalPeds) do
		local ped = createPed(v[1],v[2],v[3],v[4],v[5])

		setElementInterior(ped,v[6])
		setElementDimension(ped,v[7])

		addEventHandler("onClientPedDamage",ped,function()
			cancelEvent()
		end)
	end

	for _,v in ipairs(ServerpedsText) do
		local ped = createPed(v[1],v[2],v[3],v[4],v[5])

		setElementFrozen(ped,true)
		setElementInterior(ped,v[6])
		setElementDimension(ped,v[7])

		local colSphere = createColSphere(v[2],v[3],v[4],3.5)
		setElementInterior(colSphere,v[6])
		setElementDimension(colSphere,v[7])

		addEventHandler("onClientPedDamage",ped,function()
			cancelEvent()
		end)

		addEventHandler("onClientColShapeHit",colSphere,function(element)
			if element ~= localPlayer then return end

			interactionPed = ped
		end)

		addEventHandler("onClientColShapeLeave",colSphere,function(element)
			if element ~= localPlayer then return end

			if interactionPed == ped then
				interactionPed = nil
			end
		end)
	end
end
setTimer(createPeds,5000,1)

function renderPressEnter()
	if not isElement(interactionPed) then return end
	if getElementData(localPlayer,"redfieldClick") == true then return end

	local x,y,z = getElementPosition(interactionPed)
	local sx,sy = getScreenFromWorldPosition(x,y,z+1.1,1000,true)

	if not sx or not sy then return end

	dxDrawText(
		getText("ServerPed1"),
		sx,
		sy,
		sx,
		sy+50,
		tocolor(255,255,255,255),
		1,
		"default-bold",
		"center",
		"bottom",
		false,
		false,
		false,
		true
	)
end
addEventHandler("onClientRender",root,renderPressEnter)