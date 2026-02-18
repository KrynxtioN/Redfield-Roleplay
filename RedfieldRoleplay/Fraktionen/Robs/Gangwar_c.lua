function renderGangwar(besitzer)
	owner=besitzer
	addEventHandler("onClientRender",root,dxDrawGangwar)
end
addEvent("renderGangwar",true)
addEventHandler("renderGangwar",root,renderGangwar)

function dxDrawGangwar(besitzer)
    dxDrawRectangle(547, 672, 387, 142, tocolor(0, 0, 0, 200), false)
    dxDrawLine(547, 722, 933, 722, tocolor(255, 255, 255, 255), 3, false)
    dxDrawText("Gangwar", 557, 682, 915, 712, tocolor(255, 255, 255, 255), 2.00, "default", "center", "center", false, false, false, false, false)
    dxDrawText("Besitzer: "..owner, 557, 739, 915, 804, tocolor(255, 255, 255, 255), 2.00, "default", "center", "center", false, false, false, false, false)
end

addEvent("unrenderGangwar",true)
addEventHandler("unrenderGangwar",root,function()
	removeEventHandler("onClientRender",root,dxDrawGangwar)
end)