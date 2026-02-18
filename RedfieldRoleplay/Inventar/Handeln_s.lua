function handeln(player,cmd,target,item,anzahl)
	if(getElementData(player,'loggedin') == 1)then
		if(target and item and anzahl)then
			local tplayer = getPlayerFromName(target)
			local menge = tonumber(anzahl)
			
			if(item == 'mats')then
				if(getElementData(player,'Mats') >= menge)then
					setElementData(player,'Mats',getElementData(player,'Mats') - menge)
					setElementData(tplayer,'Mats',getElementData(tplayer,'Mats') + menge)
					if(isGerman(tplayer))then
						infobox_func(tplayer,getPlayerName(player)..' hat dir '..menge..' Materialien gegeben.',255,255,255)
					end
					if(isGerman(player))then
						infobox_func(player,'Du hast '..getPlayerName(tplayer)..' '..menge..' Materialien gegeben.',255,255,255)
					end
					if(isEnglish(tplayer))then
						infobox_func(tplayer,getPlayerName(player)..' has give you '..menge..' Mats.',255,255,255)
					end
					if(isEnglish(player))then
						infobox_func(player,'You give '..getPlayerName(tplayer)..' '..menge..' Mats.',255,255,255)
					end
				else
					getChatBox(player,31)
				end
			elseif(item == 'drugs')then
				if(getElementData(player,'Drogen') >= menge)then
					setElementData(player,'Drogens',getElementData(player,'Drogen') - menge)
					setElementData(tplayer,'Drogen',getElementData(tplayer,'Drogen') + menge)
					if(isGerman(tplayer))then
						infobox_func(tplayer,getPlayerName(player)..' hat dir '..menge..'g Drogen gegeben.',255,255,255)
					end
					if(isGerman(player))then
						infobox_func(player,'Du hast '..getPlayerName(tplayer)..' '..menge..'g Drogen gegeben.',255,255,255)
					end
					if(isEnglish(tplayer))then
						infobox_func(tplayer,getPlayerName(player)..' has give you '..menge..'g Drugs.',255,255,255)
					end
					if(isEnglish(player))then
						infobox_func(player,'You give '..getPlayerName(tplayer)..' '..menge..'g Drugs.',255,255,255)
					end
				else
					getChatBox(player,30)
				end
			end
		else
			getChatBox(player,29)
		end
	end
end
addCommandHandler('trade',handeln)