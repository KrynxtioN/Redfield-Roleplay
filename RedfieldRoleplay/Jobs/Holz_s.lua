local holzJobAktiv = {}

function holzJobStarten(player)
	if getElementData(player,"loggedin") ~= 1 then return end
	if getElementData(player,"Job") ~= "Holzfaeller" then return end
	local x,y,z = getElementPosition(player)
	if getDistanceBetweenPoints3D(-538.60534667969,-78.070526123047,62.8671875,x,y,z) >= 5 then return end
	if getElementData(player,"inholzjob") == true then
		infobox_func(player,getText(player,"Holzjob1"),255,0,0)
		return
	end
	setElementData(player,"inholzjob",true)
	holzJobAktiv[player] = true
	infobox_func(player,getText(player,"Holzjob2"),0,255,0)
	infobox_func(player,getText(player,"Holzjob3"),200,200,0)
	triggerClientEvent(player,"holzjobStart",player)
end
addCommandHandler("holzjob",holzJobStarten)

addEvent("holzCollected",true)
addEventHandler("holzCollected",root,function()
	local player = client
	if not player or not isElement(player) then return end
	if getElementData(player,"loggedin") ~= 1 then return end
	if getElementData(player,"Job") ~= "Holzfaeller" then return end
	if getElementData(player,"inholzjob") ~= true then return end
	if holzJobAktiv[player] ~= true then return end
	local skill = tonumber(getElementData(player,"Holzjobskillpunkte")) or 0
	if skill < 400 then
		skill = skill+1
		setElementData(player,"Holzjobskillpunkte",skill)
		if skill == 200 then
			infobox_func(player,getText(player,"Holzjob4"),0,255,0)
		end
	end
	if skill >= 200 and math.random(1,2) == 2 then
		local holz = tonumber(getElementData(player,"Birkenholz")) or 0
		setElementData(player,"Birkenholz",holz+1)
		infobox_func(player,getText(player,"Holzjob5"),0,255,0)
	else
		local holz = tonumber(getElementData(player,"Eichenholz")) or 0
		setElementData(player,"Eichenholz",holz+1)
		infobox_func(player,getText(player,"Holzjob6"),0,255,0)
	end
	triggerClientEvent(player,"holzjobStart",player)
end)

function sellEichenholz(menge)
	local player = client
	if not player or not isElement(player) then return end
	if getElementData(player,"loggedin") ~= 1 then return end
	menge = tonumber(menge)
	if not menge or menge <= 0 or menge ~= math.floor(menge) then
		infobox_func(player,getText(player,"Holzjob7"),255,0,0)
		return
	end
	local eichenholz = tonumber(getElementData(player,"Eichenholz")) or 0
	if eichenholz < menge then
		infobox_func(player,getText(player,"Holzjob8"),255,0,0)
		return
	end
	local price = menge*6
	local money = tonumber(getElementData(player,"Money")) or 0
	setElementData(player,"Eichenholz",eichenholz-menge)
	setElementData(player,"Money",money+price)
	infobox_func(player,getText(player,"Holzjob9"):format(menge,price),0,255,0)
	if tonumber(getElementData(player,"AchHolz")) == 0 then
		setElementData(player,"AchHolz",1)
		achievementInfo(player)
	end
end
addEvent("sellEichenholz",true)
addEventHandler("sellEichenholz",root,sellEichenholz)

function sellBirkenholz(menge)
	local player = client
	if not player or not isElement(player) then return end
	if getElementData(player,"loggedin") ~= 1 then return end
	menge = tonumber(menge)
	if not menge or menge <= 0 or menge ~= math.floor(menge) then
		infobox_func(player,getText(player,"Holzjob7"),255,0,0)
		return
	end
	local birkenholz = tonumber(getElementData(player,"Birkenholz")) or 0
	if birkenholz < menge then
		infobox_func(player,getText(player,"Holzjob10"),255,0,0)
		return
	end
	local price = menge*12
	local money = tonumber(getElementData(player,"Money")) or 0
	setElementData(player,"Birkenholz",birkenholz-menge)
	setElementData(player,"Money",money+price)
	infobox_func(player,getText(player,"Holzjob11"):format(menge,price),0,255,0)
	if tonumber(getElementData(player,"AchHolz")) == 0 then
		setElementData(player,"AchHolz",1)
		achievementInfo(player)
	end
end
addEvent("sellBirkenholz",true)
addEventHandler("sellBirkenholz",root,sellBirkenholz)

addEventHandler("onPlayerQuit",root,function()
	holzJobAktiv[source] = nil
end)

addEventHandler("onPlayerWasted",root,function()
	if holzJobAktiv[source] then
		holzJobAktiv[source] = nil
		setElementData(source,"inholzjob",false)
		triggerClientEvent(source,"destroyHolz",source)
	end
end)