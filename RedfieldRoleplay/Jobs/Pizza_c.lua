local pizzarollerMarker = {
{2072.46484375,-1628.9270019531,13.574811935425},
{1906.880859375,-1119.0152587891,25.760608673096},
{2087.1635742188,-1166.7205810547,25.420021057129},
{2082.435546875,-1040.9230957031,31.833154678345},
{2230.4477539063,-1284.3267822266,25.403818130493},
{2194.5739746094,-1455.8148193359,25.565704345703},
{2411.3530273438,-1547.0379638672,24.198656082153},
{1936.1622314453,-1917.7857666016,15.056922912598},
{995.24163818359,-1815.2902832031,14.210941314697},
{1025.7010498047,-1772.2547607422,13.580114364624},
}

local sultanpizzaMarker = {
{1152.8841552734,-1606.4869384766,13.810521125793},
{1366.4842529297,-1087.8923339844,24.507755279541},
{1260.0318603516,-1073.298828125,28.140007019043},
{1517.7856445313,-1443.6898193359,13.419595718384},
{1848.4799804688,-1928.0708007813,13.418472290039},
}

local yankeePizzaMarker = {
{1320.2615966797,-871.27941894531,38.987380981445},
{1026.5456542969,-916.0625,41.593036651611},
{1339.8265380859,-1766.4556884766,12.940467834473},
}

local pizzabeladen = false

function startPizzaJob()
	if(getElementData(localPlayer,'Language') == 0)then
		infobox('Belade dein Fahrzeug am grünen Blip.',0,255,0)
	else
		infobox('Take a pizza from the blue marker (green blip).',0,255,0)
	end
	beladenmarker = createMarker(2095.8999023438,-1805.5,12.60000038147,'cylinder',3,0,0,200)
	beladenblip = createBlip(2095.8999023438,-1805.5,12.60000038147,0,2,0,255,0)
	addEventHandler('onClientMarkerHit',beladenmarker,function(hit)
		if(hit == localPlayer)then
			if(pizzabeladen == false)then
				if(getElementData(localPlayer,'Language') == 0)then
					infobox('Bring die Lieferung zum Marker.',0,255,0)
				else
					infobox('Drive the pizza to the yellow blip.',0,255,0)
				end
				if(getElementData(localPlayer,'Pizzajobskills') < 200)then
					pizzaroller_func()
				elseif(getElementData(localPlayer,'Pizzajobskills') > 199)and(getElementData(localPlayer,'Pizzajobskills') < 400)then
					sultanpizza_func()
				elseif(getElementData(localPlayer,'Pizzajobskills') > 399)then
					yankeepizza_func()
				end
				
				pizzabeladen=true
			else 
				if(getElementData(localPlayer,'Language') == 0)then
					infobox('Dein Fahrzeug ist bereits beladen!',255,0,0)
				else
					infobox('Your vehicle has already a pizza!',255,0,0)
				end
			end
		end
	end)
end
addEvent('startPizzaJob',true)
addEventHandler('startPizzaJob',root,startPizzaJob)

function pizzaroller_func()
	local pizzamarker = math.random(1,table.getn(pizzarollerMarker))
	pizzaabgabemarker = createMarker(pizzarollerMarker[pizzamarker][1],pizzarollerMarker[pizzamarker][2],pizzarollerMarker[pizzamarker][3],'checkpoint',2,255,0,0)
	pizzaabgabeblip = createBlip(pizzarollerMarker[pizzamarker][1],pizzarollerMarker[pizzamarker][2],pizzarollerMarker[pizzamarker][3],0,2,255,255,0)
	
	addEventHandler('onClientMarkerHit',pizzaabgabemarker,function(hit)
		if(hit == localPlayer)then
			local trinkgeld = math.random(5,10)
			destroyElement(pizzaabgabemarker)
			destroyElement(pizzaabgabeblip)
			if(getElementData(localPlayer,'Language') == 0)then
				infobox('Fahr zurück, um eine weitere Lieferung abzuholen.',0,255,0)
			else
				infobox('Driving back to pick up another pizza.',0,255,0)
			end
			pizzabeladen = false
			triggerServerEvent('giveJobMoney',localPlayer,25+trinkgeld,1)
		end
	end)
end

function sultanpizza_func()
	local pizzamarker = math.random(1,table.getn(sultanpizzaMarker))
	pizzaabgabemarker = createMarker(sultanpizzaMarker[pizzamarker][1],sultanpizzaMarker[pizzamarker][2],sultanpizzaMarker[pizzamarker][3],'checkpoint',2,255,0,0)
	pizzaabgabeblip = createBlip(sultanpizzaMarker[pizzamarker][1],sultanpizzaMarker[pizzamarker][2],sultanpizzaMarker[pizzamarker][3],0,2,255,255,0)
	
	addEventHandler('onClientMarkerHit',pizzaabgabemarker,function(hit)
		if(hit == localPlayer)then
			local trinkgeld = math.random(5,10)
			destroyElement(pizzaabgabemarker)
			destroyElement(pizzaabgabeblip)
			if(getElementData(localPlayer,'Language') == 0)then
				infobox('Fahr zurück, um eine weitere Lieferung abzuholen.',0,255,0)
			else
				infobox('Driving back to pick up another pizza.',0,255,0)
			end
			pizzabeladen = false
			triggerServerEvent('giveJobMoney',localPlayer,75+trinkgeld,2)
		end
	end)
end

function yankeepizza_func()
	local pizzamarker = math.random(1,table.getn(yankeePizzaMarker))
	pizzaabgabemarker = createMarker(yankeePizzaMarker[pizzamarker][1],yankeePizzaMarker[pizzamarker][2],yankeePizzaMarker[pizzamarker][3],'checkpoint',2,255,0,0)
	pizzaabgabeblip = createBlip(yankeePizzaMarker[pizzamarker][1],yankeePizzaMarker[pizzamarker][2],yankeePizzaMarker[pizzamarker][3],0,2,255,255,0)
	
	addEventHandler('onClientMarkerHit',pizzaabgabemarker,function(hit)
		if(hit == localPlayer)then
			destroyElement(pizzaabgabemarker)
			destroyElement(pizzaabgabeblip)
			if(getElementData(localPlayer,'Language') == 0)then
				infobox('Fahr zurück, um eine weitere Lieferung abzuholen.',0,255,0)
			else
				infobox('Driving back to pick up another pizza.',0,255,0)
			end
			pizzabeladen = false
			if(getElementData(localPlayer,'Pizzajobskills')<600)then
				triggerServerEvent('giveJobMoney',localPlayer,250,3)
			elseif(getElementData(localPlayer,'Pizzajobskills')>=600)then
				triggerServerEvent('giveJobMoney',localPlayer,400,3)
			end
		end
	end)
end

function destroyPizzaShit()
	if(isElement(pizzaabgabemarker))then
		destroyElement(pizzaabgabemarker)
	end
	if(isElement(pizzaabgabeblip))then
		destroyElement(pizzaabgabeblip)
	end
	if(isElement(beladenmarker))then
		destroyElement(beladenmarker)
	end
	if(isElement(beladenblip))then
		destroyElement(beladenblip)
	end
	pizzabeladen = false
end
addEvent('destroyPizzaShit',true)
addEventHandler('destroyPizzaShit',root,destroyPizzaShit)