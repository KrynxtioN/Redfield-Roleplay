local x,y = guiGetScreenSize()
local infoboxActiv = false

function infobox(text,r,g,b)
	infoboxtext = text
	farbeR = r
	farbeG = g
	farbeB = b
	
	--if(getElementData(localPlayer,'Infobox')==0)then
		if(infoboxActiv == false)then
			infoboxActiv = true
			addEventHandler('onClientRender',root,dxdrawInfobox)
			setTimer(function()
				infoboxActiv = false
				removeEventHandler('onClientRender',root,dxdrawInfobox)
			end,5000,1)
		end
	--else outputChatBox(infoboxtext,farbeR,farbeG,farbeB)end
end
addEvent('infobox',true)
addEventHandler('infobox',root,infobox)

function dxdrawInfobox(text,r,g,b)
	dxDrawRectangle(544*(x/1440), 14*(y/900), 359*(x/1440), 141*(y/900), tocolor(0, 0, 0, 200), false)
	dxDrawRectangle(544*(x/1440), 14*(y/900), 359*(x/1440), 20*(y/900), tocolor(254, 254, 254, 255), false)
	dxDrawText('Infobox', 632*(x/1440), 17*(y/900), 818*(x/1440), 34*(y/900), tocolor(171, 0, 0, 255), 1.00, 'default-bold', 'center', 'top', false, false, false, false, false)
	dxDrawText(infoboxtext, 555*(x/1440), 40*(y/900), 893*(x/1440), 145*(y/900), tocolor(farbeR,farbeG,farbeB, 255), 1.00, 'sans', 'center', 'center', false, true, false, false, false)
end

function changeInfobox_func()
	if(getElementData(localPlayer,'loggedin') == 1)then
		if(getElementData(localPlayer,'Infobox') == 0)then
			setElementData(localPlayer,'Infobox',1)
		else
			setElementData(localPlayer,'Infobox',0)
		end
		
		if(getElementData(localPlayer,'Language') == 0)then
			infobox('Infobox gewechselt.',0,255,0)
		else
			infobox('Changed infobox.',0,255,0)
		end
	end
end
addCommandHandler('infobox',changeInfobox_func)