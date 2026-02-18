local position = 0
local x,y = guiGetScreenSize()
local introText = false

local kameraPosis = {
[1] = {x = -182.18699645996,y = 1198.3631591797,z = 43.022899627686,sx = -182.4111328125,sy = 1197.4898681641,sz = 42.590351104736},
[2] = {x = -189.74659729004,y = 1119.623046875,z = 28.545299530029,sx = -190.62219238281,sy = 1119.6069335938,sz = 28.062517166138},
[3] = {x = -193.7592010498,y = 1173.3603515625,z = 28.210699081421,sx = -193.04528808594,sy = 1173.5838623047,sz = 27.547090530396},
[4] = {x = -189.75799560547,y = 1065.7182617188,z = 26.081899642944,sx = -190.65197753906,sy = 1065.5305175781,sz = 25.674995422363},
[5] = {x = -191.01989746094,y = 1097.6451416016,z = 37.794998168945,sx = -190.50085449219,sy = 1098.1516113281,sz = 37.106410980225},
[6] = {x = -213.33500671387,y = 1189.8454589844,z = 35.267200469971,sx = -213.99644470215,sy = 1190.3978271484,sz = 34.759872436523},
[7] = {x = -195.87390136719,y = 1040.6214599609,z = 27.512800216675,sx = -195.08810424805,sy = 1040.3238525391,sz = 26.970600128174},
[8] = {x = 106.60299682617,y = 1189.0810546875,z = 36.022800445557,sx = 107.50762176514,sy = 1188.9350585938,sz = 35.622360229492},
[9] = {x = -182.16040039063,y = 1195.3642578125,z = 35.91540145874,sx = -181.9722442627,sy = 1196.15625,sz = 35.334632873535},
}

local kameraTexte = {
[1] = 'Herzlich willkommen auf Redfield Roleplay! In diesem kleinen Intro werden dir nun die wichtigsten Orte gezeigt.',
[2] = 'Dies ist die Stadthalle, in der du alle Scheine beantragen und Jobs annehmen kannst.',
[3] = 'Dies ist die Bank, in der du ein Konto erstellen kannst, um dein Geld besser verwalten zu können.',
[4] = 'Lust auf neue Klamotten? Skinshops gibt es in ganz San Andreas, achte auf die Tshirts!',
[5] = 'Keine Lust auf den Noobspawn? Dann miete dir ein Zimmer im Fort Carson Motel.',
[6] = 'Kauf dir dein erstes Fahrzeug beim billigsten Autohändler in ganz San Andreas.',
[7] = 'In den 24/7 Shops gibt es nützliche Dinge wie z.B das Handy.',
[8] = 'Du musst regelmäßig Essen, sonst verhungerst du!',
[9] = 'Weitere Infos gibt es unter F1, viel Spaß beim Spielen.',
}

local kameraTexteEnglish = {
[1] = 'Welcome on Redfield Roleplay! In this little Intro we will show you the most important positions.',
[2] = 'This is our Cityhall. Here you can buy Licenses and accept Jobs.',
[3] = 'This is our Bank. Here you can create a Bank-Account, around manage your money.',
[4] = 'You think, you look like Shit? Visit a Skinshop.',
[5] = 'No money for a house? Rent a room in the Fort Carson Motel.',
[6] = 'Here you can buy very cheap your first Vehicle.',
[7] = 'In 24/7 Shops you can buy some Articles.',
[8] = 'You must eat, or you die.',
[9] = 'More Information can you find under F1.',
}

function introDxDraw()
	dxDrawRectangle(0*(x/1440), 510*(y/900), 1440*(x/1440), 126*(y/900), tocolor(0, 0, 0, 200), false)
	if(getElementData(localPlayer,'Language') == 0)then
		dxDrawText(kameraTexte[position], 67*(x/1440), 523*(y/900), 1379*(x/1440), 626*(y/900), tocolor(255, 255, 255, 255), 2.00, "default-bold", "center", "center", false, true, false, false,false)
	else
		dxDrawText(kameraTexteEnglish[position], 67*(x/1440), 523*(y/900), 1379*(x/1440), 626*(y/900), tocolor(255, 255, 255, 255), 2.00, "default-bold", "center", "center", false, true, false,false, false)
	end
end

function startintro_func()
	setTimer(function()
		position = position+1
		setElementData(localPlayer,'redfieldClick',true)
		
		local campos = kameraPosis[position]
		local x,y,z,sx,sy,sz = campos.x,campos.y,campos.z,campos.sx,campos.sy,campos.sz
		setCameraMatrix(x,y,z,sx,sy,sz)
		
		if(introText == false)then
			addEventHandler('onClientRender',root,introDxDraw)
		end
			
		introText = true	
			
		showChat(false)
		setPlayerHudComponentVisible('radar',false)
		
		if(position == 9)then
			setTimer(function()
				position = 0
				setPlayerHudComponentVisible('radar',true)
				triggerServerEvent('spawnAfterIntro',localPlayer,localPlayer)
				removeEventHandler('onClientRender',root,introDxDraw)
				setElementData(localPlayer,'redfieldClick',false)
			end,8000,1)
			setTimer(function()
				blackscreen()
			end,7000,1)
		else
			setTimer(function()
				startintro_func()
			end,8000,1)
			setTimer(function()
				blackscreen()
			end,7000,1)
		end
	end,50,1)
end
addEvent('startintro_func',true)
addEventHandler('startintro_func',root,startintro_func)

function blackscreen()
	fadeCamera(false)
	setTimer(function()
		fadeCamera(true)
	end,1500,1)
end