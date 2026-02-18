local x,y=guiGetScreenSize()
local ladezeit=0

function dxLadebalken()
	fadeCamera(false)
	
	dxDrawRectangle(435*(x/1400), 416*(y/900), 596*(x/1400)/100*ladezeit, 67*(y/900), tocolor(214, 207, 40, 255), false)
    dxDrawLine(435*(x/1400), 414*(y/900), 1032*(x/1400), 414*(y/900), tocolor(255, 255, 255, 255), 4, false)
    dxDrawLine(435*(x/1400), 413*(y/900), 435*(x/1400), 483*(y/900), tocolor(255, 255, 255, 255), 4, false)
    dxDrawLine(1031*(x/1400), 414*(y/900), 1031*(x/1400), 484*(y/900), tocolor(255, 255, 255, 255), 4, false)
    dxDrawText(ladezeit.."%", 445*(x/1400), 426*(y/900), 1021*(x/1400), 473*(y/900), tocolor(255, 255, 255, 255), 3.00, "default-bold", "center", "center", false, false, false, false, false)
	if(getElementData(localPlayer,"Language")==0)then
		dxDrawText("Die Welt wird geladen...", 445*(x/1400), 352*(y/900), 1021*(x/1400), 399*(y/900), tocolor(255, 255, 255, 255), 3.00, "default-bold", "center", "center", false, false, false, false, false)
	else
		dxDrawText("Your world is loading...", 445*(x/1400), 352*(y/900), 1021*(x/1400), 399*(y/900), tocolor(255, 255, 255, 255), 3.00, "default-bold", "center", "center", false, false, false, false, false)
	end
    dxDrawLine(434*(x/1400), 483*(y/900), 1031*(x/1400), 483*(y/900), tocolor(255, 255, 255, 255), 4, false)
end

function ladeBalken()
	setTimer(function()
		ladezeit=ladezeit+1
		if(ladezeit==100)then
			removeEventHandler("onClientRender",root,dxLadebalken)
			ladezeit=0
			fadeCamera(true)
		end
	end,50,100)
	addEventHandler("onClientRender",root,dxLadebalken)
end
addEvent("ladeBalken",true)
addEventHandler("ladeBalken",root,ladeBalken)