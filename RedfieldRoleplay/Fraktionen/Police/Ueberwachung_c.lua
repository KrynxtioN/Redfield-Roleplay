local pdPosition = 0

local pdCamPos = {
[1] = {x = -174.88130187988,y = 1186.4981689453,z = 37.140598297119,sx = -175.74739074707,sy = 1186.767578125,sz = 36.719547271729},
[2] = {x = -211.58219909668,y = 1120.9427490234,z = 31.05299949646,sx = -211.40757751465,sy = 1120.0690917969,sz = 30.598924636841},
[3] = {x = -177.58149719238,y = 1039.1198730469,z = 32.557098388672,sx = -178.13130187988,sy = 1038.3712158203,sz = 32.186637878418},
}

local useCam = false

function changeCamPos()
	if(pdPosition == 3)then
		pdPosition = 0
	end
	pdPosition = pdPosition + 1
	
	local pdpos = pdCamPos[pdPosition]
	local x,y,z,sx,sy,sz = pdpos.x,pdpos.y,pdpos.z,pdpos.sx,pdpos.sy,pdpos.sz
	setCameraMatrix(x,y,z,sx,sy,sz)
	
	for i = 1,50 do outputChatBox(' ') end
end

function bindKeysForPC()
	if(useCam == false)then
		useCam = true
		fadeCamera(false)
		setTimer(function()
			addEventHandler('onClientPreRender',root,blackWhiteScreen)
			ueberwachungImage = guiCreateStaticImage(0,0,1,1,'Images/PDCam.png',true)
			bindKey('mouse1','down',changeCamPos)
			bindKey('mouse2','down',stopPDCam)
			changeCamPos()
			fadeCamera(true)
		end,1500,1)
		removeEventHandler('onClientRender',root,hungerBalken)
		setPlayerHudComponentVisible('radar',false)
		toggleAllControls(false)
	end
end
addEvent('bindKeysForPC',true)
addEventHandler('bindKeysForPC',root,bindKeysForPC)

function stopPDCam()
	fadeCamera(false)
	if(isElement(ueberwachungImage))then
		destroyElement(ueberwachungImage)
	end
	setTimer(function()
		unbindKey('mouse1','down',changeCamPos)
		unbindKey('mouse2','down',stopPDCam)
		fadeCamera(true)
		toggleAllControls(true)
		setPlayerHudComponentVisible('radar',true)
		addEventHandler('onClientRender',root,hungerBalken)
		setCameraTarget(localPlayer)
		useCam = false
	end,1500,1)
	setTimer(function()
		removeEventHandler('onClientPreRender',root,blackWhiteScreen)
	end,1000,1)
end