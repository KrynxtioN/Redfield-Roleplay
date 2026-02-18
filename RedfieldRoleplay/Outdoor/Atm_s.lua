function auszahlenServer(auszahlenSumme)
	setElementData(source,'Bankmoney',getElementData(source,'Bankmoney')-auszahlenSumme)
	givePlayerMoney(source,auszahlenSumme)
	if(isGerman(source))then
		infobox_func(source,'Du hast '..auszahlenSumme..'$ von deinem Konto abgehoben.',0,255,0)
	elseif(isEnglish(source))then
		infobox_func(source,'You have pay out '..auszahlenSumme..'$ from your account.',0,255,0)
	end
	triggerClientEvent(source,'updateMoneyLabel',source)
end
addEvent('auszahlenServer',true)
addEventHandler('auszahlenServer',root,auszahlenServer)

function einzahlenServer(einzahlenSumme)
	setElementData(source,'Bankmoney',getElementData(source,'Bankmoney')+einzahlenSumme)
	takePlayerMoney(source,einzahlenSumme)
	if(isGerman(source))then
		infobox_func(source,'Du hast '..einzahlenSumme..'$ auf dein Konto eingezahlt.',0,255,0)
	elseif(isEnglish(source))then
		infobox_func(source,'You have pay '..einzahlenSumme..'$ on your account.',0,255,0)
	end
	triggerClientEvent(source,'updateMoneyLabel',source)
end
addEvent('einzahlenServer',true)
addEventHandler('einzahlenServer',root,einzahlenServer)

local bankautomaten = {}

function createAtms()
	atm = createObject(2942,-180.69999694824,1180,19.39999961853,0,0,270)
	table.insert(bankautomaten,atm)
	atm = createObject(2942,-207.89999389648,1116.8000488281,19.39999961853,0,0,90)
	table.insert(bankautomaten,atm)
end
addEventHandler('onResourceStart',getResourceRootElement(getThisResource()),createAtms)

function atmWindowShow(button,state,player)
	local x,y,z = getElementPosition(player)
	
	for key,atm in pairs(bankautomaten)do
		if(atm == source)then
			local x1,y1,z1 = getElementPosition(atm)
			local dis = getDistanceBetweenPoints3D(x1,y1,z1,x,y,z)
			if(dis < 5)then
				triggerClientEvent(player,'bankpinWindow',player)
			end
		end
	end
end
addEventHandler('onElementClicked',root,atmWindowShow)