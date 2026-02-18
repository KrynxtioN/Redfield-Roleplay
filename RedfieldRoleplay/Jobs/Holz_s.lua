function holzJobStarten(player)
	if(getElementData(player,"loggedin") == 1)then
		if(getElementData(player,"Job") == "Holzfaeller")then
			if(getDistanceBetweenPoints3D(-538.60534667969,-78.070526123047,62.8671875,getElementPosition(player)) < 5)then
				if(getElementData(player,"inholzjob") == false)then
					if(isGerman(player))then
						infobox_func(player,"Holz die Bäume, welche auf der Karte mit einem roten Blip markiert werden.",0,255,0)
						outputChatBox("Tippe /stopjob, um den Job zu beenden. Das gesammelte Holz kannst du am gelben Bagger auf der Karte verkaufen.",player,200,200,0)
					elseif(isEnglish(player))then
						infobox_func(player,"Destroy the trees, which are marked on the map with a red blip.",0,255,0)
						outputChatBox("Use /stopjob, to stop the Job. The collected wood you can sell at the yellow excavator on the map.",player,200,200,0)
					end
					triggerClientEvent(player,"holzjobStart",player)
					setElementData(player,"inholzjob",true)
				end
			end
		end
	end
end
addCommandHandler("holzjob",holzJobStarten)

function sellEichenholz(menge)
	if(getElementData(source,"Eichenholz") >= menge)then
		local price = menge*6
		setElementData(source,"Eichenholz",getElementData(source,"Eichenholz") - menge)
		if(isGerman(source))then
			infobox_func(source,"Du hast "..menge.." Eichenholz für "..price.."$ verkauft.",0,255,0)
		elseif(isEnglish(source))then
			infobox_func(source,"You sell "..menge.." Oak wood for "..price.."$.",0,255,0)
		end
		givePlayerMoney(source,price)
		if(getElementData(source,"AchHolz") == 0)then
			setElementData(source,"AchHolz",1)
			achievmentInfo(source)
		end
	else
		getChatBox(player,133)
	end
end
addEvent("sellEichenholz",true)
addEventHandler("sellEichenholz",root,sellEichenholz)

function sellBirkenholz(menge)
	if(getElementData(source,"Birkenholz") >= menge)then
		local price = menge*12
		setElementData(source,"Birkenholz",getElementData(source,"Birkenholz") - menge)
		if(isGerman(source))then
			infobox_func(source,"Du hast "..menge.." Birkenholz für "..price.."$ verkauft.",0,255,0)
		elseif(isEnglish(source))then
			infobox_func(source,"You sell "..menge.." Birch wood for "..price.."$.",0,255,0)
		end
		givePlayerMoney(source,price)
		if(getElementData(source,"AchHolz") == 0)then
			setElementData(source,"AchHolz",1)
			achievmentInfo(source)
		end
	else 
		getChatBox(player,132)
	end
end
addEvent("sellBirkenholz",true)
addEventHandler("sellBirkenholz",root,sellBirkenholz)