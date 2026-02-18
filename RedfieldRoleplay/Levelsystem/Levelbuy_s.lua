local EXPTabelle={
[1]=600,
[2]=1200,
[3]=2400,
[4]=4800,
[5]=9600,
[6]=19200,
[7]=38400,
[8]=76800,
[9]=153600,
}

function isErfahrungspunkte(player,punkte)
	local points = getElementData(player,'Erfahrungspunkte')
	
	if(points >= punkte)then
		return true
	else
		return false
	end
end

function takeErfahrungspunkte(player,punkte)
	setElementData(player,'Erfahrungspunkte',getElementData(player,'Erfahrungspunkte') - punkte)
end

function giveErfahrungspunkte(player,punkte)
	local Level=getElementData(player,"Level")
	local EXP=getElementData(player,"Erfahrungspunkte")
	
	setElementData(player,'Erfahrungspunkte',getElementData(player,'Erfahrungspunkte') + punkte)
	if(isGerman(player))then
		outputChatBox("Du hast "..punkte.." EXP bekommen.",player,0,100,200)
	elseif(isEnglish(player))then
		outputChatBox("You get "..punkte.." EXP.",player,0,100,200)
	end
	
	if(isErfahrungspunkte(player,EXPTabelle[Level+1]))then
		getChatBox(player,27)
		setElementData(player,"Level",getElementData(player,"Level")+1)
		takeErfahrungspunkte(player,EXPTabelle[Level-1])
		money=getElementData(player,"Level")*3000
		if(isGerman(player))then
			outputChatBox("Du hast Level "..getElementData(player,"Level").." erreicht, wofür du einen Bonus von "..money.."$ bekommst.",player,0,100,200)
		elseif(isGerman(player))then
			outputChatBox("You've reached Level "..getElementData (player," Level ") ..", for which you get a bonus of "..money .." $.",player,0,100,200)
		end
		setElementData(player,"Bankmoney",getElementData(player,"Bankmoney")+money)
	end
end

function myLevel_func(player)
	if(getElementData(player,'loggedin') == 1)then
		if(isGerman(player))then
			infobox_func(player,'Dein Level: '..getElementData(player,'Level'),255,255,255)
		elseif(isEnglish(player))then
			infobox_func(player,'Your level: '..getElementData(player,'Level'),255,255,255)
		end
	end
end
addCommandHandler('mylevel',myLevel_func)

function myEXP_func(player)
	if(getElementData(player,'loggedin') == 1)then
		if(isGerman(player))then
			infobox_func(player,'Deine Erfahrungspunkte: '..getElementData(player,'Erfahrungspunkte'),255,255,255)
		elseif(isEnglish(player))then
			infobox_func(player,'Your EXP: '..getElementData(player,'Erfahrungspunkte'),255,255,255)
		end
	end
end
addCommandHandler('myexp',myEXP_func)