local barMarker={

[1] = createPickup(2310.0864257813,-1643.5386962891,14.827047348022,3,1318,50),
[2] = createPickup(-2242.1437988281,-88.274787902832,35.3203125,3,1318,50),
[3] = createPickup(2441.1997070313,2065.4807128906,10.8203125,3,1318,50),

}

for i,barMarkers in pairs(barMarker)do
	addEventHandler('onPickupHit',barMarkers,function(player)
		if(not(isPedInVehicle(player)))then
			triggerClientEvent(player,"ladeBalken",player)
		
			local x,y,z = getElementPosition(player)
			setElementData(player,'saveposx',x)
			setElementData(player,'saveposy',y)
			setElementData(player,'saveposz',z)
			
			setTimer(function()
				setElementPosition(player,501.89999389648,-70.099998474121,998.79998779297)
				setPedRotation(player,180)
				setElementInterior(player,11)
				setElementDimension(player,i)
				
				barPed = createPed(181,498.10000610352,-77.5,998.79998779297)
				setPedRotation(barPed,0)
				setElementInterior(barPed,11)
				setElementDimension(barPed,i)
				
				barLeave = createPickup(502.001953125,-67.56315612793,998.7578125,3,1318,50)
				setElementInterior(barLeave,11)
				setElementDimension(barLeave,i)
				barBuy=createMarker(498.10000610352,-75.800003051758,997.79998779297,'cylinder',1,0,0,200)
				setElementInterior(barBuy,11)
				setElementDimension(barBuy,i)
				
				addEventHandler('onPickupHit',barLeave,barLeave_func)
				addEventHandler('onMarkerHit',barBuy,barBuy_func)
			end,1500,1)
		end
	end)
end

function barLeave_func(player)
	triggerClientEvent(player,"ladeBalken",player)
	setTimer(function()
		setElementPosition(player,getElementData(player,'saveposx'),getElementData(player,'saveposy'),getElementData(player,'saveposz'))
		setElementDimension(player,0)
		setElementInterior(player,0)
		setElementData(player,'saveposx',nil)
		setElementData(player,'saveposy',nil)
		setElementData(player,'saveposz',nil)
	end,1500,1)
end

function barBuy_func(player)
	triggerClientEvent(player,'openBarWindow',player)
end
			
function BuyAlcohol(player)
	toggleAllControls(player,false)
	setPedAnimation(player,'VENDING','VEND_Drink2_P')
	setTimer(function()
		setPedAnimation(player,false)
		toggleAllControls(player,true)
		setElementData(player,'Hunger',getElementData(player,'Hunger') + 10)
		if(getElementData(player,'Hunger') > 100)then
			setElementData(player,'Hunger',100)
		end
	end,4000,1)
end
addEvent('BuyAlcohol',true)
addEventHandler('BuyAlcohol',root,BuyAlcohol)