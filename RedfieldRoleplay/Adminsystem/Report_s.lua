local report = {}

local reportpickup = createPickup(1483.8206787109,-1789.1024169922,-93.831253051758,3,1239,50)

function inreporthalle_func(player)
	if(getElementData(player,'loggedin') == 1)then
		if(getElementInterior(player) == 0)then
			if(not(report[player]))then
				report[player] = true
				
				local x,y,z = getElementPosition(player)
				setElementData(player,'posx',x)
				setElementData(player,'posy',y)
				setElementData(player,'posz',z)
				
				getChatBox(player,19)
				
				if(getElementData(player,'Adminrang') > 0)then
					setElementPosition(player,1477.1514892578,-1781.9364013672,-93.831253051758)
				else
					setElementPosition(player,1482.5185546875,-1799.3825683594,-93.831253051758)
				end
			end
		else
			getChatBox(player,18)
		end
	end
end
addCommandHandler('report',inreporthalle_func)

function outreport_func(player)
	if(getElementData(player,'loggedin') == 1)then
		if(report[player] == true)then
			local x = getElementData(player,'posx')
			local y = getElementData(player,'posy')
			local z = getElementData(player,'posz')
			setElementPosition(player,x,y,z)
			report[player] = false
		end
	end
end
addCommandHandler('leavereport',outreport_func)

function reportpickup_func(player)
	getChatBox(player,20)
end
addEventHandler('onPickupHit',reportpickup,reportpickup_func)

function hilfe_func(player)
	if(report[player] == true)then
		if(getDistanceBetweenPoints3D(1483.8206787109,-1789.1024169922,-93.831253051758,getElementPosition(player)) < 5)then
			local players = getElementsByType('player')
			
			for k,v in ipairs(players)do
				if(getElementData(v,'Adminrang') > 0)then
					getChatBox(v,21)
				end
			end
		end
	end
end
addCommandHandler('hilfe',hilfe_func)