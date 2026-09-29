function getText(text)
	local language = getElementData(localPlayer,"Language")
	if(not(language))then language = 1 end
	if(TEXTS[language][text])then
		return TEXTS[language][text]
	end
end