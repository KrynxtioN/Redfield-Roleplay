for i = 1,4 do
    setInteriorFurnitureEnabled(i,false)
end

local showNormalObjectTabelle = {
[1] = {1704,500},
[2] = {1705,500},
[3] = {1708,600},
[4] = {1711,650},
[5] = {1720,700},
[6] = {1723,800},
[7] = {1726,900},
[8] = {1727,400},
[9] = {1728,900},
[10] = {1729,500},
[11] = {1739,200},
[12] = {1825,1000},
[13] = {1896,1200},
[14] = {1998,800},
[15] = {2096,500},
[16] = {2205,800},
[17] = {2313,750},
[18] = {1518,1400},
[19] = {1752,1600},
[20] = {1786,1800},
[21] = {16377,900},
}

local showBathObjectsTabelle = {
[1] = {2526,3000},
[2] = {2514,1200},
[3] = {2527,2000},
[4] = {2524,1000},
}

local showOutsideObjectTabelle = {
[1] = {638,600},
[2] = {970,700},
[3] = {17037,2000},
}

local furnitureKategorie = {button = {},window = {}}

function openFurnitureKategorieWindow()
	if(not(isElement(furnitureKategorie.window[1])))then
		if(not(getElementData(localPlayer,'redfieldClick')) == true)then
			showCursor(true)
			setElementData(localPlayer,'redfieldClick',true)
		
			furnitureKategorie.window[1] = guiCreateStaticImage(0.40, 0.41, 0.21, 0.17, 'Images/Background.png', true)

			furnitureKategorie.button[1] = guiCreateButton(0.03, 0.19, 0.93, 0.18, 'Normale Möbel', true, furnitureKategorie.window[1])
			guiSetProperty(furnitureKategorie.button[1], 'NormalTextColour', 'FFAAAAAA')
			furnitureKategorie.button[2] = guiCreateButton(0.03, 0.47, 0.93, 0.18, 'Badezimmer', true, furnitureKategorie.window[1])
			guiSetProperty(furnitureKategorie.button[2], 'NormalTextColour', 'FFAAAAAA')
			furnitureKategorie.button[3] = guiCreateButton(0.03, 0.75, 0.93, 0.18, 'Objekte für außen', true, furnitureKategorie.window[1])
			guiSetProperty(furnitureKategorie.button[3], 'NormalTextColour', 'FFAAAAAA')
			
			if(getElementData(localPlayer,"Language")==1)then
				guiSetText(furnitureKategorie.button[1],"Normal")
				guiSetText(furnitureKategorie.button[2],"Bath")
				guiSetText(furnitureKategorie.button[3],"Outside")
			end
			
			addEventHandler('onClientGUIClick',furnitureKategorie.button[1],function()
				showNormalObjectNumber = 1
				showObject = createObject(showNormalObjectTabelle[showNormalObjectNumber][1],1723.720703125,-1663.48046875,36.38969039917,0,0,0)
				setElementInterior(showObject,18)
				showNormalObjects = true
				createAllForObject()
				destroyElement(furnitureKategorie.window[1])
				showCursor(false)
			end,false)
			addEventHandler('onClientGUIClick',furnitureKategorie.button[2],function()
				showBathObjectNumber = 1
				showObject = createObject(showBathObjectsTabelle[showBathObjectNumber][1],1723.720703125,-1663.48046875,36.38969039917,0,0,0)
				setElementInterior(showObject,18)
				showBathObjects = true
				createAllForObject()
				destroyElement(furnitureKategorie.window[1])
				showCursor(false)
			end,false)
			addEventHandler('onClientGUIClick',furnitureKategorie.button[3],function()
				showOutdoorObjectNumber = 1
				showObject = createObject(showOutsideObjectTabelle[showOutdoorObjectNumber][1],1723.720703125,-1663.48046875,36.38969039917,0,0,0)
				setElementInterior(showObject,18)
				showOutsideObjects = true
				createAllForObject()
				destroyElement(furnitureKategorie.window[1])
				showCursor(false)
			end,false)
		end
    end
end

function createAllForObject()
	showChat(false)
	setCameraMatrix(1712.9627685547,-1645.9943847656,35.840400695801,1713.4787597656,-1646.8331298828,35.666633605957,0,70)
	addEventHandler('onClientRender',root,rotateShowObject)
	toggleAllControls(false)
	bindKey('enter','down',buyObject)
	bindKey('space','down',closeObject)
	bindKey('arrow_r','down',newobjectRight)
	bindKey('arrow_l','down',newobjectLeft)
	addEventHandler('onClientRender',root,drawObjectPreis)
end

function drawObjectPreis()
	if(getElementData(localPlayer,'Language') == 0)then
		if(showNormalObjects == true)then
			dxDrawText('Preis: '..showNormalObjectTabelle[showNormalObjectNumber][2]..'\nEnter - Kaufen, Leertaste - Schließen\nRechte Pfeiltaste & Linke Pfeiltaste - Objekt wechseln', 376, 10, 1064, 206, tocolor(255, 255, 255, 255), 0.60, 'bankgothic', 'center', 'center', false, false, false, false, false)
		elseif(showOutsideObjects == true)then
			dxDrawText('Preis: '..showOutsideObjectTabelle[showOutdoorObjectNumber][2]..'\nEnter - Kaufen, Leertaste - Schließen\nRechte Pfeiltaste & Linke Pfeiltaste - Objekt wechseln', 376, 10, 1064, 206, tocolor(255, 255, 255, 255), 0.60, 'bankgothic', 'center', 'center', false, false, false, false, false)
		elseif(showBathObjects == true)then
			dxDrawText('Preis: '..showBathObjectsTabelle[showBathObjectNumber][2]..'\nEnter - Kaufen, Leertaste - Schließen\nRechte Pfeiltaste & Linke Pfeiltaste - Objekt wechseln', 376, 10, 1064, 206, tocolor(255, 255, 255, 255), 0.60, 'bankgothic', 'center', 'center', false, false, false, false, false)
		end
	else
		if(showNormalObjects == true)then
			dxDrawText('Price: '..showNormalObjectTabelle[showNormalObjectNumber][2]..'\nEnter - Buy, Space - Close\nArrow Right & Arrow Left - Switch object', 376, 10, 1064, 206, tocolor(255, 255, 255, 255), 0.60, 'bankgothic', 'center', 'center', false, false, false, false, false)
		elseif(showOutsideObjects == true)then
			dxDrawText('Preis: '..showOutsideObjectTabelle[showOutdoorObjectNumber][2]..'\nEnter - Buy, Space - Close\nArrow Right & Arrow Left - Switch object', 376, 10, 1064, 206, tocolor(255, 255, 255, 255), 0.60, 'bankgothic', 'center', 'center', false, false, false, false, false)
		elseif(showBathObjects == true)then
			dxDrawText('Preis: '..showBathObjectsTabelle[showBathObjectNumber][2]..'\nEnter - Buy, Space - Close\nArrow Right & Arrow Left - Switch object', 376, 10, 1064, 206, tocolor(255, 255, 255, 255), 0.60, 'bankgothic', 'center', 'center', false, false, false, false, false)
		end
	end
end

local showObjectPickup = createPickup(1721.8173828125,-1652.5671386719,20.0625,3,1239,50)
setElementInterior(showObjectPickup,18)

addEventHandler('onClientPickupHit',showObjectPickup,function(hit)
	if(hit == localPlayer)then
		openFurnitureKategorieWindow()
	end
end)

function buyObject()
	if(showNormalObjects == true)then
		if(getPlayerMoney(localPlayer) >= showNormalObjectTabelle[showNormalObjectNumber][2])then
			triggerServerEvent('buyObject',localPlayer,showNormalObjectTabelle[showNormalObjectNumber][1],showNormalObjectTabelle[showNormalObjectNumber][2])
		else
			if(getElementData(localPlayer,'Language') == 0)then
				infobox('Du hast nicht genug Geld!',255,0,0)
			else
				infobox('You have not enough money!',255,0,0)
			end
		end
	elseif(showBathObjects == true)then
		if(getPlayerMoney(localPlayer) >= showBathObjectsTabelle[showBathObjectNumber][2])then
			triggerServerEvent('buyObject',localPlayer,showBathObjectsTabelle[showBathObjectNumber][1],showBathObjectsTabelle[showBathObjectNumber][2])
		else
			if(getElementData(localPlayer,'Language') == 0)then
				infobox('Du hast nicht genug Geld!',255,0,0)
			else
				infobox('You have not enough money!',255,0,0)
			end
		end
	elseif(showOutsideObjects == true)then
		if(getPlayerMoney(localPlayer) >= showOutsideObjectTabelle[showOutdoorObjectNumber][2])then
			triggerServerEvent('buyObject',localPlayer,showOutsideObjectTabelle[showOutdoorObjectNumber][1],showOutsideObjectTabelle[showOutdoorObjectNumber][2])
		else
			if(getElementData(localPlayer,'Language') == 0)then
				infobox('Du hast nicht genug Geld!',255,0,0)
			else
				infobox('You have not enough money!',255,0,0)
			end
		end
	end
end

function closeObject()
	unbindKey('enter','down',buyObject)
	unbindKey('space','down',closeObject)
	removeEventHandler('onClientRender',root,rotateShowObject)
	unbindKey('arrow_r','down',newobjectRight)
	unbindKey('arrow_l','down',newobjectLeft)
	toggleAllControls(true)
	setCameraTarget(localPlayer)
	destroyElement(showObject)
	removeEventHandler('onClientRender',root,drawObjectPreis)
	showChat(true)
	setElementData(localPlayer,'redfieldClick',false)
	showNormalObjects = nil
	showOutsideObjects = nil
	showBathObjects = nil
end

function newobjectRight()
	if(showNormalObjects == true)then
		if(not(showNormalObjectNumber == 21))then
			showNormalObjectNumber = showNormalObjectNumber + 1
			setElementModel(showObject,showNormalObjectTabelle[showNormalObjectNumber][1])
		end
	elseif(showBathObjects == true)then
		if(not(showBathObjectNumber == 4))then
			showBathObjectNumber = showBathObjectNumber + 1
			setElementModel(showObject,showBathObjectsTabelle[showBathObjectNumber][1])
		end
	elseif(showOutsideObjects == true)then
		if(not(showOutdoorObjectNumber == 3))then
			showOutdoorObjectNumber = showOutdoorObjectNumber + 1
			setElementModel(showObject,showOutsideObjectTabelle[showOutdoorObjectNumber][1])
		end
	end
end

function newobjectLeft()
	if(showNormalObjects == true)then
		if(not(showNormalObjectNumber == 1))then
			showNormalObjectNumber = showNormalObjectNumber-1
			setElementModel(showObject,showNormalObjectTabelle[showNormalObjectNumber][1])
		end
	elseif(showBathObjects == true)then
		if(not(showBathObjectNumber == 1))then
			showBathObjectNumber = showBathObjectNumber-1
			setElementModel(showObject,showBathObjectsTabelle[showBathObjectNumber][1])
		end
	elseif(showOutsideObjects == true)then
		if(not(showOutdoorObjectNumber == 1))then
			showOutdoorObjectNumber = showOutdoorObjectNumber-1
			setElementModel(showObject,showOutsideObjectTabelle[showOutdoorObjectNumber][1])
		end
	end
end

function rotateShowObject()
	local x,y,z = getElementRotation(showObject)
	setElementRotation(showObject,x,y,z+1)
end

function createobject_func(id)
	showCursor(true)
	local px,py,pz = getPedBonePosition(localPlayer,6)
	bool,camX,camY,camZ,hit = processLineOfSight(px,py,pz,px,py,pz+20,true,true,false)
	if(bool == false)then
		camX,camY,camZ = px,py,pz+20
	else
		camZ = camZ-0.1
	end
	setCameraMatrix(camX,camY,camZ,px,py,pz)
	local int = getElementInterior(localPlayer)
	local dim = getElementDimension(localPlayer)
	
	dropObjekt = createObject(id,0,0,0)
	setElementInterior(dropObjekt,int)
	setElementDimension(dropObjekt,dim)
	massDistance = getElementDistanceFromCentreOfMassToBaseOfModel(dropObjekt)
	setElementCollisionsEnabled(dropObjekt,false)
	addEventHandler('onClientRender',root,refreshObjectPosition)
	addEventHandler('onClientClick',root,objectPosition)
	setElementData(localPlayer,'redfieldClick',true)
	bindKey('mouse_wheel_up','down',refreshObjectRotationRight)
	bindKey('mouse_wheel_down','down',refreshObjectRotationLeft)
	bindKey('enter','down',stopPlaceObject)
	
	if(getElementData(localPlayer,'Language') == 0)then
		outputChatBox('Beweg die Maus, um das Objekt zu bewegen und das Mausrad um es zu drehen. Enter - Schließen, Linke/Rechte Maustaste - Objekt platzieren.',0,200,0)
	else
		outputChatBox('Move the object with your mouse and rotate it with your mouse wheel. Enter - Close, Left/Right Mouse - Place the object.',0,200,0)
	end
end
addEvent('createobject',true)
addEventHandler('createobject',root,createobject_func)

function objectPosition(button,state)
	if(state == 'down')then
		if(isElement(dropObjekt))then
			removeEventHandler('onClientRender',root,refreshObjectPosition)
			removeEventHandler('onClientClick',root,objectPosition)
			placeObject()
		end
	end
end

function refreshObjectRotationRight()
	x,y,z = getElementRotation(dropObjekt)
	setElementRotation(dropObjekt,x,y,z+1)
end

function refreshObjectRotationLeft()
	x,y,z = getElementRotation(dropObjekt)
	setElementRotation(dropObjekt,x,y,z-1)
end

function placeObject()
	if(isElement(dropObjekt))then
		setCameraTarget(localPlayer)
			
		local x,y,z = getElementPosition(dropObjekt)
		local rx,ry,rz = getElementRotation(dropObjekt)
		local model = getElementModel(dropObjekt)
		local interior = getElementInterior(dropObjekt)
		local dimension = getElementDimension(dropObjekt)
		destroyElement(dropObjekt)
			
		triggerServerEvent('createNewObjectPlace',localPlayer,model,x,y,z,rx,ry,rz,interior,dimension)
		unbindKey('mouse_wheel_up','down',refreshObjectRotationRight)
		unbindKey('mouse_wheel_down','down',refreshObjectRotationLeft)
			
		showCursor(false)
		setElementData(localPlayer,'redfieldClick',false)
	end
end

function stopPlaceObject()
	unbindKey('mouse_wheel_up','down',refreshObjectRotationRight)
	unbindKey('mouse_wheel_down','down',refreshObjectRotationLeft)
	unbindKey('enter','down',stopPlaceObject)
	removeEventHandler('onClientRender',root,refreshObjectPosition)
	removeEventHandler('onClientClick',root,objectPosition)
	destroyElement(dropObjekt)
	showCursor(false)
	setCameraTarget(localPlayer)
	setElementData(localPlayer,'redfieldClick',false)
end

higher = {}
 higher[638] = 0.6
 higher[970] = 0.5
 higher[17037] = 2.3

function refreshObjectPosition()
	local sx,sy,x,y,z = getCursorPosition()
	local px,py,pz = camX,camY,camZ
	blabla,nx,ny,nz,hit = processLineOfSight(px,py,pz,x,y,z,true,true,false)
	
	if(nz)then
		nz = nz+3
	end
	
	blabla,nx,ny,nz,hit = processLineOfSight(nx,ny,nz,x,y,z,true,true,false)
	
	if(not(blabla))then
		nx,ny,nz = x,y,z
	end
	
	if(higher[getElementModel(dropObjekt)])then
	nz = nz+higher[getElementModel(dropObjekt)]end

	setElementPosition(dropObjekt,nx,ny,nz+massDistance)
end