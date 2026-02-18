local x,y=guiGetScreenSize()

local EXPTabelle={
[1]=600,
[2]=1200,
[3]=2400,
[4]=4800,
[5]=9600,
[6]=19200,
[7]=38400,
[8]=76800,
[9]=153600,
}

function Leiste_func()
	if(getElementData(localPlayer,"loggedin")==1)then
		--if(getElementData(localPlayer,"redfieldClick")==false)then
			local Hunger=getElementData(localPlayer,"Hunger")
			local EXP=getElementData(localPlayer,"Erfahrungspunkte")
			local Oxgen=getPedOxygenLevel(localPlayer)
			local Level=getElementData(localPlayer,"Level")
		
			dxDrawRectangle(0*(x/1440), 857*(y/900), 1440*(x/1440), 51*(y/900), tocolor(0, 0, 0, 200), false)
			dxDrawLine(0*(x/1440), 857*(y/900), 1439*(x/1440), 857*(y/900), tocolor(255, 255, 255, 255), 5, false)
			dxDrawRectangle(1007*(x/1440), 866*(y/900), 414*(x/1440)/EXPTabelle[Level+1]*EXP, 30*(y/900), tocolor(1, 191, 193, 200), false)
			dxDrawText(EXP.."/"..EXPTabelle[Level+1].." EXP", 1017*(x/1440), 871*(y/900), 1411*(x/1440), 890*(y/900), tocolor(255, 255, 255, 255), 1.50, "default-bold", "center", "center", false, false, false, false, false)
			dxDrawLine(1007*(x/1440), 866*(y/900), 1419*(x/1440), 866*(y/900), tocolor(255, 255, 255, 255), 2, false)
			dxDrawLine(1009*(x/1440), 896*(y/900), 1421*(x/1440), 896*(y/900), tocolor(255, 255, 255, 255), 2, false)
			dxDrawLine(1007*(x/1440), 866*(y/900), 1007*(x/1440), 897*(y/900), tocolor(255, 255, 255, 255), 2, false)
			dxDrawLine(1419*(x/1440), 866*(y/900), 1419*(x/1440), 897*(y/900), tocolor(255, 255, 255, 255), 2, false)
			dxDrawRectangle(17*(x/1440), 866*(y/900), 178*(x/1440)/100*Hunger, 30*(y/900), tocolor(0, 200, 0, 200), false)
			dxDrawLine(17*(x/1440), 865*(y/900), 17*(x/1440), 896*(y/900), tocolor(255, 255, 255, 255), 2, false)
			dxDrawLine(195*(x/1440), 865*(y/900), 195*(x/1440), 896*(y/900), tocolor(255, 255, 255, 255), 2, false)
			dxDrawLine(17*(x/1440), 865*(y/900), 195*(x/1440), 865*(y/900), tocolor(255, 255, 255, 255), 2, false)
			dxDrawLine(17*(x/1440), 896*(y/900), 195*(x/1440), 896*(y/900), tocolor(255, 255, 255, 255), 2, false)
			dxDrawRectangle(221*(x/1440), 865*(y/900), 178*(x/1440)/1000*Oxgen, 30*(y/900), tocolor(27, 136, 172, 200), false)
			dxDrawLine(221*(x/1440), 865*(y/900), 221*(x/1440), 896*(y/900), tocolor(255, 255, 255, 255), 2, false)
			dxDrawLine(399*(x/1440), 866*(y/900), 399*(x/1440), 897*(y/900), tocolor(255, 255, 255, 255), 2, false)
			dxDrawLine(221*(x/1440), 865*(y/900), 399*(x/1440), 865*(y/900), tocolor(255, 255, 255, 255), 2, false)
			dxDrawLine(221*(x/1440), 896*(y/900), 399*(x/1440), 896*(y/900), tocolor(255, 255, 255, 255), 2, false)
			dxDrawText(Hunger.."% Hunger", 27*(x/1440), 871*(y/900), 185*(x/1440), 890*(y/900), tocolor(255, 255, 255, 255), 1.50, "default-bold", "center", "center", false, false, false, false, false)
			dxDrawText(math.floor(Oxgen).."% Oxygen", 231*(x/1440), 871*(y/900), 389*(x/1440), 890*(y/900), tocolor(255, 255, 255, 255), 1.50, "default-bold", "center", "center", false, false, false, false, false)
		--end
    end
end
addEventHandler("onClientRender",root,Leiste_func)