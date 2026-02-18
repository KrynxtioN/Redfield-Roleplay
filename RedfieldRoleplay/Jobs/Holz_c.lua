local holzjobmarker = {
{-464.88827514648,6.5740828514099,52.596855163574},
{-464.40997314453,23.507080078125,49.468074798584},
{-448.31390380859,24.899824142456,49.783142089844},
{-436.86318969727,19.715198516846,51.32043838501},
{-449.03115844727,8.9561500549316,52.018310546875},
{-436.80294799805,0.74320089817047,52.772216796875},
{-451.62973022461,-6.8297567367554,54.319541931152},
{-448.80157470703,-22.947471618652,56.520484924316},
{-437.52938842773,-12.761728286743,54.06884765625},
{-434.16989135742,-28.562366485596,57.03689956665},
}

function holzjobStart()
	local holzpickup = math.random(1,table.getn(holzjobmarker))
	holzmarkerpickup = createPickup(holzjobmarker[holzpickup][1],holzjobmarker[holzpickup][2],holzjobmarker[holzpickup][3],3,1318,50)
	holzmarkerblip = createBlip(holzjobmarker[holzpickup][1],holzjobmarker[holzpickup][2],holzjobmarker[holzpickup][3],0,2,255,0,0)
	
	addEventHandler('onClientPickupHit',holzmarkerpickup,function(element)
		if(element == localPlayer)then
			toggleAllControls(false)
			
			setTimer(function()
				toggleAllControls(true)
			end,4000,1)
		
			destroyElement(holzmarkerpickup)
			destroyElement(holzmarkerblip)
			
			if(getElementData(localPlayer,'Holzjobskillpunkte') < 400)then
				setElementData(localPlayer,'Holzjobskillpunkte',getElementData(localPlayer,'Holzjobskillpunkte') + 1)
			end
			if(getElementData(localPlayer,'Holzjobskillpunkte') == 200)then
				if(getElementData(localPlayer,'Language') == 0)then 
				infobox('Dein Chef hat dich befördet, du hast nun die Chance Birkenholz zu bekommen.',0,255,0)else
				infobox('Your boss has give you a new job rank. Now you have the chance to get Birch wood.',0,255,0)end
			end
			
			if(getElementData(localPlayer,'Holzjobskillpunkte') > 199)then
				holz = math.random(1,2)
				
				if(holz == 1)then
					if(getElementData(localPlayer,'Language') == 0)then 
						infobox('+ 1 Eichenholz',0,255,0)
					else
						infobox('+ 1 Oak wood',0,255,0)
					end
					setElementData(localPlayer,'Eichenholz',getElementData(localPlayer,'Eichenholz') + 1)
				else
					if(getElementData(localPlayer,'Language') == 0)then 
						infobox('+ 1 Birkenholz',0,255,0)
					else
						infobox('+ 1 Birch wood',0,255,0)
					end
					setElementData(localPlayer,'Birkenholz',getElementData(localPlayer,'Birkenholz') + 1)
				end
			else
				if(getElementData(localPlayer,'Language') == 0)then 
					infobox('+ 1 Eichenholz',0,255,0)
				else
					infobox('+ 1 Oak wood',0,255,0)
				end
				setElementData(localPlayer,'Eichenholz',getElementData(localPlayer,'Eichenholz') + 1)
			end

			holzjobStart()
		end
	end)
end
addEvent('holzjobStart',true)
addEventHandler('holzjobStart',root,holzjobStart)

function destroyHolz()
	if(isElement(holzmarkerpickup))then
		destroyElement(holzmarkerpickup)
	end
	if(isElement(holzmarkerblip))then
		destroyElement(holzmarkerblip)
	end
end
addEvent('destroyHolz',true)
addEventHandler('destroyHolz',root,destroyHolz)

-- Sägewerk --

local holz = {button = {},window = {},edit = {},label = {}}

function holzWindow()
	if(not(isElement(holz.window[1])))then
		showCursor(true)
		setElementData(localPlayer,'redfieldClick',true)
	
        holz.window[1] = guiCreateStaticImage(0.42, 0.39, 0.19, 0.22, 'Images/Background.png', true)

        holz.label[1] = guiCreateLabel(0.04, 0.15, 0.92, 0.40, 'Pro Eichenholz: 6$\nPro Birkenholz: 12$\n\nDrücke F3, um das Fenster zu schließen.\n______________________________________', true,holz.window[1])
        guiSetFont(holz.label[1], 'default-bold-small')
        guiLabelSetHorizontalAlign(holz.label[1], 'left', true)
        holz.button[1] = guiCreateButton(0.54, 0.82, 0.43, 0.13, 'Eichenholz Verkaufen', true, holz.window[1])
        guiSetProperty(holz.button[1], 'NormalTextColour', 'FFAAAAAA')
        holz.button[2] = guiCreateButton(0.04, 0.82, 0.43, 0.13, 'Birkenholz Verkaufen', true, holz.window[1])
        guiSetProperty(holz.button[2], 'NormalTextColour', 'FFAAAAAA')
        holz.edit[1] = guiCreateEdit(12, 117, 245, 27, '', false, holz.window[1])
		
		if(getElementData(localPlayer,'Language') == 1)then
			guiSetText(holz.label[1],'1x Oak wood: 6$\n1x Birch Wood: 12$\n\nUse F3 to close the Window.\n______________________________________')
			guiSetText(holz.button[1],'Sell Oak wood')
			guiSetText(holz.button[2],'Sell Birch wood')
		end
		
		bindKey('f3','down',function()
			unbindKey('f3','down')
			destroyElement(holz.window[1])
			showCursor(false)
			setElementData(localPlayer,'redfieldClick',false)
		end)
		
		addEventHandler('onClientGUIClick',holz.button[1],function()
			local menge = tonumber(guiGetText(holz.edit[1]))
			if(menge)then
				triggerServerEvent('sellEichenholz',localPlayer,menge)
			else
				if(getElementData(localPlayer,'Language') == 0)then 
					infobox('Trage eine Zahl ein!',255,0,0)
				else
					infobox('Please provide a number!',255,0,0)
				end
			end
		end,false)
		addEventHandler('onClientGUIClick',holz.button[2],function()
			local menge = tonumber(guiGetText(holz.edit[1]))
			if(menge)then
				triggerServerEvent('sellBirkenholz',localPlayer,menge)
			else 
				if(getElementData(localPlayer,'Language') == 0)then 
					infobox('Trage eine Zahl ein!',255,0,0)
				else
					infobox('Please provide a number!',255,0,0)
				end
			end
		end,false)
    end
end
addEvent('holzWindow',true)
addEventHandler('holzWindow',root,holzWindow)