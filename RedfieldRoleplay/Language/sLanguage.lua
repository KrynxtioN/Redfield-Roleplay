function getText(player,text)
	local language = getElementData(player,"Language")
	if(not(language))then language = 1 end
	if(TEXTS[language][text])then
		return TEXTS[language][text]
	end
end