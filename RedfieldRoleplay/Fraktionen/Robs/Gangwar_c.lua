local gangwarOwner = nil
local gangwarRendered = false
local sx,sy = guiGetScreenSize()
local scaleX,scaleY = sx/1920,sy/1080

function renderGangwar(besitzer)
	gangwarOwner = tostring(besitzer or getText("GangwarUnknown"))
	if gangwarRendered then return end
	gangwarRendered = true
	addEventHandler("onClientRender",root,dxDrawGangwar)
end
addEvent("renderGangwar",true)
addEventHandler("renderGangwar",root,renderGangwar)

function dxDrawGangwar()
	if not gangwarRendered then return end
	dxDrawRectangle(547*scaleX,672*scaleY,387*scaleX,142*scaleY,tocolor(0,0,0,200),false)
	dxDrawLine(547*scaleX,722*scaleY,933*scaleX,722*scaleY,tocolor(255,255,255,255),3*scaleY,false)
	dxDrawText(getText("Gangwar14"),557*scaleX,682*scaleY,915*scaleX,712*scaleY,tocolor(255,255,255,255),2*scaleY,"default","center","center",false,false,false,false,false)
	dxDrawText(getText("Gangwar15"):format(gangwarOwner or getText("GangwarUnknown")),557*scaleX,739*scaleY,915*scaleX,804*scaleY,tocolor(255,255,255,255),2*scaleY,"default","center","center",false,false,false,false,false)
end

function unrenderGangwar()
	if not gangwarRendered then return end
	removeEventHandler("onClientRender",root,dxDrawGangwar)
	gangwarRendered = false
	gangwarOwner = nil
end
addEvent("unrenderGangwar",true)
addEventHandler("unrenderGangwar",root,unrenderGangwar)

addEventHandler("onClientResourceStop",resourceRoot,function()
	if gangwarRendered then
		removeEventHandler("onClientRender",root,dxDrawGangwar)
	end
end)