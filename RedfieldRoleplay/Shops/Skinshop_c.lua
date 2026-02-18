local x,y = guiGetScreenSize()
local window_skinshop = false
local skinshop = {button = {}}
local skinid = 0
local skinname = 0
local skinpreise = 0
local minskin,maxskin = 1,50

function renderRotatePed ()
	local rot = getPedRotation(show_ped)
	setPedRotation(show_ped,rot+1)
end

skins  =  {

[0] = 0,
[1] = 299,
[2] = 181,
[3] = 1,
[4] = 7,
[5] = 12,
[6] = 17,
[7] = 18,
[8] = 19,
[9] = 20,
[10] = 22,
[11] = 23,
[12] = 45,
[13] = 44,
[14] = 46,
[15] = 47,
[16] = 48,
[17] = 55,
[18] = 67,
[19] = 69,
[20] = 75,
[21] = 78,
[22] = 79,
[23] = 85,
[24] = 87,
[25] = 88,
[26] = 96,
[27] = 97,
[28] = 98,
[29] = 101,
[30] = 128,
[31] = 134,
[32] = 136,
[33] = 137,
[34] = 147,
[35] = 148,
[36] = 150,
[37] = 156,
[38] = 157,
[39] = 158,
[40] = 159,
[41] = 160,
[42] = 176,
[43] = 177,
[44] = 180,
[45] = 191,
[46] = 192,
[47] = 249,
[48] = 250,
[49] = 298,
[50] = 299,

}

skinpreis  =  {

[0] = 500,
[1] = 500,
[2] = 1000,
[3] = 500,
[4] = 500,
[5] = 600,
[6] = 500,
[7] = 500,
[8] = 500,
[9] = 500,
[10] = 500,
[11] = 500,
[12] = 500,
[13] = 500,
[14] = 500,
[15] = 500,
[16] = 500,
[17] = 500,
[18] = 500,
[19] = 500,
[20] = 500,
[21] = 200,
[22] = 200,
[23] = 500,
[24] = 500,
[25] = 88,
[26] = 500,
[27] = 500,
[28] = 500,
[29] = 500,
[30] = 500,
[31] = 200,
[32] = 200,
[33] = 200,
[34] = 500,
[35] = 500,
[36] = 500,
[37] = 500,
[38] = 500,
[39] = 200,
[40] = 200,
[41] = 200,
[42] = 500,
[43] = 500,
[44] = 500,
[45] = 500,
[46] = 500,
[47] = 1000,
[48] = 600,
[49] = 500,
[50] = 500,

}

function skinshop_buttons()
	if(getElementData(localPlayer,'redfieldClick') == false)then
		showCursor(true)
		setElementData(localPlayer,'redfieldClick',true)
		local dim = getElementDimension(localPlayer)
		setCameraMatrix(208.70359802246,-12.220499992371,1002.629699707,207.73143005371,-12.205281257629,1002.395874023)
		show_ped = createPed(0,202.400390625,-12.2509765625,1001.2109375,271)
		setElementInterior(show_ped,5)
		setElementDimension(show_ped,dim)
		setElementFrozen(localPlayer,true)
		addEventHandler("onClientRender",root,dxdraw_skinshop)
		addEventHandler("onClientRender",getRootElement(),renderRotatePed)
	
        skinshop.button[1] = guiCreateButton(0.97, 0.01, 0.01, 0.02, "yes", true)
        guiSetAlpha(skinshop.button[1], 0.00)
        guiSetProperty(skinshop.button[1], "NormalTextColour", "FFAAAAAA")
 
		addEventHandler('onClientGUIClick',skinshop.button[1],function()
			showCursor(false)
			destroyElement(skinshop.button[1])
			destroyElement(skinshop.button[2])
			setElementData(localPlayer,'redfieldClick',false)
			removeEventHandler('onClientRender',root,dxdraw_skinshop)
			removeEventHandler("onClientRender",getRootElement(),renderRotatePed)
			triggerEvent('close_skin',getLocalPlayer(),getLocalPlayer())
			triggerServerEvent('skinchange',localPlayer,localPlayer,skins[skinid],skinpreis[skinpreise])
		end,false)
 
        skinshop.button[2] = guiCreateButton(0.98, 0.01, 0.01, 0.02, "no", true)
        guiSetAlpha(skinshop.button[2], 0.00)
        guiSetProperty(skinshop.button[2], "NormalTextColour", "FFAAAAAA")
		
		addEventHandler('onClientGUIClick',skinshop.button[2],function()
			showCursor(false)
			destroyElement(skinshop.button[1])
			destroyElement(skinshop.button[2])
			setElementData(localPlayer,'redfieldClick',false)
			removeEventHandler("onClientRender",root,dxdraw_skinshop)
			removeEventHandler("onClientRender",getRootElement(),renderRotatePed)
			triggerEvent('close_skin',getLocalPlayer(),getLocalPlayer())
		end,false)
		
        skinshop.button[3] = guiCreateButton(0.42, 0.86, 0.04, 0.08, "links", true)
        guiSetAlpha(skinshop.button[3], 0.00)
        guiSetProperty(skinshop.button[3], "NormalTextColour", "FFAAAAAA")
		
		addEventHandler('onClientGUIClick',skinshop.button[3],function()
			skin_links()
		end,false)
 
        skinshop.button[4] = guiCreateButton(0.53, 0.86, 0.04, 0.08, "rechts", true)
        guiSetAlpha(skinshop.button[4], 0.00)
        guiSetProperty(skinshop.button[4], "NormalTextColour", "FFAAAAAA")  
		
		addEventHandler('onClientGUIClick',skinshop.button[4],function()
			skin_rechts()
		end,false)
    end
end
 
function dxdraw_skinshop()
    dxDrawRectangle(1691*(x/1920), 10*(y/1080), 219*(x/1920), 27*(y/1080), tocolor(49, 49, 49, 255), false)
    dxDrawRectangle(1691*(x/1920), 37*(y/1080), 219*(x/1920), 2*(y/1080), tocolor(255, 157, 0, 255), false)
    dxDrawRectangle(1691*(x/1920), 39*(y/1080), 219*(x/1920), 51*(y/1080), tocolor(239, 239, 239, 255), false)
    dxDrawImage(1883*(x/1920), 13*(y/1080), 27*(x/1920), 24*(y/1080), "Images/Close.png", 0, 0, 0, tocolor(255, 255, 255, 255), false)
    dxDrawImage(1856*(x/1920), 13*(y/1080), 27*(x/1920), 24*(y/1080), "Images/Accept.png", 0, 0, 0, tocolor(255, 255, 255, 255), false)
    dxDrawText("Skinshop", 1696*(x/1920), 10*(y/1080), 1765*(x/1920), 37*(y/1080), tocolor(255, 255, 255, 255), 1.00*(y/1080), "default-bold", "left", "center", false, false, false, false, false)
	if(getElementData(localPlayer,"Language") == 0)then
		dxDrawText("Diesen Skin für "..skinpreis[skinpreise].."$ kaufen?", 1701*(x/1920) - 1, 47*(y/1080) - 1, 1900*(x/1920) - 1, 80*(y/1080) - 1, tocolor(0, 0, 0, 255), 1.00*(y/1080), "default-bold", "center", "center", false, false, false, false, false)
		dxDrawText("Diesen Skin für "..skinpreis[skinpreise].."$ kaufen?", 1701*(x/1920) + 1, 47*(y/1080) - 1, 1900*(x/1920) + 1, 80*(y/1080) - 1, tocolor(0, 0, 0, 255), 1.00*(y/1080), "default-bold", "center", "center", false, false, false, false, false)
		dxDrawText("Diesen Skin für "..skinpreis[skinpreise].."$ kaufen?", 1701*(x/1920) + 1, 47*(y/1080) + 1, 1900*(x/1920) + 1, 80*(y/1080) + 1, tocolor(0, 0, 0, 255), 1.00*(y/1080), "default-bold", "center", "center", false, false, false, false, false)
		dxDrawText("Diesen Skin für "..skinpreis[skinpreise].."$ kaufen?", 1701*(x/1920) - 1, 47*(y/1080) + 1, 1900*(x/1920) - 1, 80*(y/1080) + 1, tocolor(0, 0, 0, 255), 1.00*(y/1080), "default-bold", "center", "center", false, false, false, false, false)
		dxDrawText("Diesen Skin für "..skinpreis[skinpreise].."$ kaufen?", 1701*(x/1920), 47*(y/1080), 1900*(x/1920), 80*(y/1080), tocolor(255, 255, 255, 255), 1.00*(y/1080), "default-bold", "center", "center", false, false, false, false, false)
	else
		dxDrawText("Buy this Skin for "..skinpreis[skinpreise].."$", 1701*(x/1920) - 1, 47*(y/1080) - 1, 1900*(x/1920) - 1, 80*(y/1080) - 1, tocolor(0, 0, 0, 255), 1.00*(y/1080), "default-bold", "center", "center", false, false, false, false, false)
		dxDrawText("Buy this Skin for "..skinpreis[skinpreise].."$", 1701*(x/1920) + 1, 47*(y/1080) - 1, 1900*(x/1920) + 1, 80*(y/1080) - 1, tocolor(0, 0, 0, 255), 1.00*(y/1080), "default-bold", "center", "center", false, false, false, false, false)
		dxDrawText("Buy this Skin for "..skinpreis[skinpreise].."$", 1701*(x/1920) + 1, 47*(y/1080) + 1, 1900*(x/1920) + 1, 80*(y/1080) + 1, tocolor(0, 0, 0, 255), 1.00*(y/1080), "default-bold", "center", "center", false, false, false, false, false)
		dxDrawText("Buy this Skin for "..skinpreis[skinpreise].."$", 1701*(x/1920) - 1, 47*(y/1080) + 1, 1900*(x/1920) - 1, 80*(y/1080) + 1, tocolor(0, 0, 0, 255), 1.00*(y/1080), "default-bold", "center", "center", false, false, false, false, false)
		dxDrawText("Buy this Skin for "..skinpreis[skinpreise].."$", 1701*(x/1920), 47*(y/1080), 1900*(x/1920), 80*(y/1080), tocolor(255, 255, 255, 255), 1.00*(y/1080), "default-bold", "center", "center", false, false, false, false, false)
	end
    dxDrawImage(804*(x/1920), 932*(y/1080), 82*(x/1920), 89*(y/1080), "Images/Left.png", 0, 0, 0, tocolor(255, 255, 255, 255), false)
    dxDrawImage(1016*(x/1920), 932*(y/1080), 82*(x/1920), 89*(y/1080), "Images/Right.png", 0, 0, 0, tocolor(255, 255, 255, 255), false)
end

function open_skinshop()
	skinshop_buttons()
end
addEvent('open_skinshop',true)
addEventHandler('open_skinshop',root,open_skinshop)

function skin_rechts()
	skinid  =  skinid -1
	skinpreise  =  skinpreise -1
	
	if(skinid < minskin)then
		skinid  =  maxskin
		skinpreise  =  maxskin
	end
	setElementModel(show_ped,skins[skinid])
end

function skin_links()
	skinid = skinid + 1
	skinpreise = skinpreise + 1
	
	if(skinid > maxskin)then
		skinid = minskin
		skinpreise = minskin
	end
	setElementModel(show_ped,skins[skinid])
end

addEvent('close_skin',true)
addEventHandler('close_skin',root,function()
	destroyElement(show_ped)
	setElementFrozen(localPlayer,false)
	triggerServerEvent('dont_skinbuy',getLocalPlayer(),getLocalPlayer(),skins[skinid])
end)