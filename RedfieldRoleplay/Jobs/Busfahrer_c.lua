local busfahrerMarker={
[1]={-29.832874298096,1201.1043701172,19.21614074707,false},
[2]={-145.9149017334,1201.0035400391,19.600311279297,false},
[3]={-210.1748046875,1201.5344238281,19.596260070801,true},
[4]={-273.29379272461,1197.9653320313,19.599969863892,false},
[5]={-277.41171264648,1110.9799804688,19.594045639038,false},
[6]={-314.68103027344,1101.0450439453,19.595317840576,false},
[7]={-319.04330444336,1081.3393554688,19.593879699707,true},
[8]={-289.05770874023,1060.9708251953,19.596710205078,false},
[9]={-274.65396118164,1020.4541625977,19.596899032593,false},
[10]={-205.89993286133,1015.41015625,19.589206695557,false},
[11]={-187.5,1084.7998046875,19.60000038147,false},
[12]={-79.400390625,1095.7001953125,19.60000038147,false},
[13]={-9.8000001907349,1096.1999511719,19.60000038147,false},
[14]={31.799999237061,1119.9000244141,19.60000038147,true},
[15]={16.723217010498,1150.7191162109,19.59375,false},
[16]={-62.89391708374,1174.2985839844,19.581422805786,false},
[17]={12.507538795471,1195.9011230469,19.189804077148,false},
[18]={107.31144714355,1195.1121826172,18.220653533936,false},
[19]={175.99220275879,1143.2995605469,14.231485366821,false},
[20]={297.02093505859,1253.6958007813,14.832268714905,false},
[21]={411.03948974609,1589.5395507813,17.820465087891,false},
[22]={626.40679931641,1738.4890136719,5.4139337539673,false},
[23]={656.19427490234,1828.5078125,5.46875,true},
[24]={660.33343505859,1860.3422851563,5.46875,false},
[25]={803.23596191406,1812.4262695313,3.9152269363403,false},
[26]={848.96398925781,1645.2437744141,8.5847854614258,false},
[27]={774.23455810547,1456.9074707031,20.24641418457,false},
[28]={823.75543212891,1239.7489013672,26.71692276001,false},
[29]={650.71783447266,1090.625,28.335670471191,false},
[30]={533.07818603516,1058.7810058594,28.333106994629,true},
[31]={241.16339111328,980.18579101563,28.194452285767,false},
[32]={94.439300537109,890.42535400391,22.759346008301,false},
[33]={-130.38558959961,824.37438964844,20.952310562134,true},
[34]={-246.51998901367,790.83428955078,17.547149658203,false},
[35]={-278.94030761719,798.66857910156,15.204532623291,true},
[36]={-234.87748718262,842.9404296875,12.279434204102,false},
[37]={-190.3243560791,966.65600585938,18.156667709351,false},
[38]={-188.01657104492,1195.8626708984,19.543041229248,false},
[39]={-0.60268729925156,1211.8502197266,19.352746963501,false},
}

local buspoints=0
local x,y=guiGetScreenSize()

function renderBus()
	dxDrawText("Wartezeit: "..bustime.." Sekunden", 449*(x/1440), 385*(y/900), 959*(x/1440), 508*(y/900), tocolor(254, 0, 0, 255), 3.00, "default-bold", "center", "center", false, false, false,false, false)
end

function showBusTimer()
	bustime=7
	
	setTimer(function()
		bustime=bustime-1
		if(bustime==0)then
			removeEventHandler("onClientRender",root,renderBus)
		end
	end,1000,7)
	addEventHandler("onClientRender",root,renderBus)
end

function startBusfahrer()
	if(isElement(busmarker))then
		destroyElement(busmarker)
	end
	if(isElement(busblip))then
		destroyElement(busblip)
	end

	buspoints=buspoints+1
	
	if(buspoints==40)then
		destroyBusShit()
		triggerServerEvent("giveJobMoney",localPlayer,39*75)
		triggerServerEvent("stopbus",localPlayer,localPlayer)
	else
		busmarker=createMarker(busfahrerMarker[buspoints][1],busfahrerMarker[buspoints][2],busfahrerMarker[buspoints][3],"checkpoint",2,200,0,0)
		busblip=createBlip(busfahrerMarker[buspoints][1],busfahrerMarker[buspoints][2],busfahrerMarker[buspoints][3],0,2,255,0,0)
		
		addEventHandler("onClientMarkerHit",busmarker,function(player)
			if(player==localPlayer)then
				if(busfahrerMarker[buspoints][4]==true)then
					triggerServerEvent("frozePlayer",localPlayer,localPlayer)
					showBusTimer()
				end
				startBusfahrer()
			end
		end)
	end
end
addEvent("startBusfahrerMarker",true)
addEventHandler("startBusfahrerMarker",root,startBusfahrer)

function destroyBusShit()
	if(isElement(busmarker))then
		destroyElement(busmarker)
	end
	if(isElement(busblip))then
		destroyElement(busblip)
	end
end