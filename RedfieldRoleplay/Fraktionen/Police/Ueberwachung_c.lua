local pdPosition = 0
local useCam = false
local ueberwachungImage = nil
local pdStartTimer = nil
local pdStopTimer = nil
local pdEffectTimer = nil

local pdCamPos = {
	[1] ={x = -174.88130187988,y = 1186.4981689453,z = 37.140598297119,sx = -175.74739074707,sy = 1186.767578125,sz = 36.719547271729},
	[2] ={x = -211.58219909668,y = 1120.9427490234,z = 31.05299949646,sx = -211.40757751465,sy = 1120.0690917969,sz = 30.598924636841},
	[3] ={x = -177.58149719238,y = 1039.1198730469,z = 32.557098388672,sx = -178.13130187988,sy = 1038.3712158203,sz = 32.186637878418},
}

local function changeCamPos()
	if not useCam then return end
	pdPosition = pdPosition+1
	if pdPosition > #pdCamPos then pdPosition = 1 end
	local pdpos = pdCamPos[pdPosition]
	setCameraMatrix(pdpos.x,pdpos.y,pdpos.z,pdpos.sx,pdpos.sy,pdpos.sz)
end

local function stopPDCam()
	if not useCam then return end
	useCam = false
	if isTimer(pdStartTimer) then killTimer(pdStartTimer) end
	if isTimer(pdStopTimer) then killTimer(pdStopTimer) end
	if isTimer(pdEffectTimer) then killTimer(pdEffectTimer) end
	unbindKey("mouse1","down",changeCamPos)
	unbindKey("mouse2","down",stopPDCam)
	fadeCamera(false)
	pdEffectTimer = setTimer(function()
		removeEventHandler("onClientPreRender",root,blackWhiteScreen)
	end,1000,1)
	pdStopTimer = setTimer(function()
		if isElement(ueberwachungImage) then destroyElement(ueberwachungImage) end
		ueberwachungImage = nil
		setCameraTarget(localPlayer)
		toggleAllControls(true)
		setPlayerHudComponentVisible("radar",true)
		removeEventHandler("onClientRender",root,hungerBalken)
		addEventHandler("onClientRender",root,hungerBalken)
		fadeCamera(true)
		pdPosition = 0
	end,1500,1)
end

local function bindKeysForPC()
	if useCam then
		infobox(getText("PDCam1"),255,0,0)
		return
	end
	useCam = true
	pdPosition = 0
	if isTimer(pdStartTimer) then killTimer(pdStartTimer) end
	if isTimer(pdStopTimer) then killTimer(pdStopTimer) end
	if isTimer(pdEffectTimer) then killTimer(pdEffectTimer) end
	fadeCamera(false)
	removeEventHandler("onClientRender",root,hungerBalken)
	setPlayerHudComponentVisible("radar",false)
	toggleAllControls(false)
	pdStartTimer = setTimer(function()
		if not useCam then return end
		removeEventHandler("onClientPreRender",root,blackWhiteScreen)
		addEventHandler("onClientPreRender",root,blackWhiteScreen)
		if isElement(ueberwachungImage) then destroyElement(ueberwachungImage) end
		ueberwachungImage = guiCreateStaticImage(0,0,1,1,"Images/PDCam.png",true)
		bindKey("mouse1","down",changeCamPos)
		bindKey("mouse2","down",stopPDCam)
		changeCamPos()
		fadeCamera(true)
		infobox(getText("PDCam2"),255,255,255)
	end,1500,1)
end
addEvent("bindKeysForPC",true)
addEventHandler("bindKeysForPC",root,bindKeysForPC)