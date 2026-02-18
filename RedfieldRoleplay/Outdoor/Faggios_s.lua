local noobfaggios={

[1] = createVehicle(462,-178.80000305176,1216.5999755859,19.39999961853,0,0,270),
[2] = createVehicle(462,-178.80000305176,1218.5999755859,19.39999961853,0,0,270),
[3] = createVehicle(462,-178.80000305176,1220.5999755859,19.39999961853,0,0,270),
[4] = createVehicle(462,-178.80000305176,1222.5999755859,19.39999961853,0,0,270),
[5] = createVehicle(462,-178.80000305176,1224.5999755859,19.39999961853,0,0,270),
[6] = createVehicle(462,-178.80000305176,1226.5999755859,19.39999961853,0,0,270),
[7] = createVehicle(462,-178.80000305176,1228.5999755859,19.39999961853,0,0,270),

}

for i=1,#noobfaggios do
	setElementData(noobfaggios[i],"Benzin",100)
	setElementData(noobfaggios[i],"Besitzer","System")
	setElementFrozen(noobfaggios[i],true)
	setVehicleColor(noobfaggios[i],0,255,0)
	
	addEventHandler("onVehicleStartEnter",noobfaggios[i],function(player)
		if(getElementData(player,"Spielzeit") <= 300)then
			setElementFrozen(noobfaggios[i],false)
		else
			cancelEvent()
			getChatBox(player,80)
		end
	end)
end