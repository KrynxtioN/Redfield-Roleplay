local help = {gridlist = {},window = {},label = {}}

function helpWindow()
	if(not(isElement(help.window[1])))then
		if(getElementData(localPlayer,'loggedin')==1)and(not(inTutorial)==true)then
			if(getElementData(localPlayer,'redfieldClick')==false)then
				showCursor(true)
				setElementData(localPlayer,'redfieldClick',true)
			
				help.window[1] = guiCreateStaticImage(0.28, 0.19, 0.42, 0.60, 'Images/Background.png', true)

				help.gridlist[1] = guiCreateGridList(0.02, 0.06, 0.41, 0.92, true, help.window[1])
				guiGridListAddColumn(help.gridlist[1], 'Kategorie', 1)
				for i = 1, 10 do
					guiGridListAddRow(help.gridlist[1])
				end
				if(getElementData(localPlayer,'Language') == 0)then
					guiGridListSetItemText(help.gridlist[1], 0, 1, 'Allgemeines', false, false)
					guiGridListSetItemText(help.gridlist[1], 1, 1, 'Fraktionssystem', false, false)
					guiGridListSetItemText(help.gridlist[1], 2, 1, 'Jobsystem', false, false)
					guiGridListSetItemText(help.gridlist[1], 3, 1, 'Fahrzeugsystem', false, false)
					guiGridListSetItemText(help.gridlist[1], 4, 1, 'Hungersystem', false, false)
					guiGridListSetItemText(help.gridlist[1], 5, 1, 'Waffensystem', false, false)
					guiGridListSetItemText(help.gridlist[1], 6, 1, 'Haussystem', false, false)
					guiGridListSetItemText(help.gridlist[1], 7, 1, 'Deine Fraktion', false, false)
					guiGridListSetItemText(help.gridlist[1], 9, 1, 'Levelsystem', false, false)
				else
					guiGridListSetItemText(help.gridlist[1], 0, 1, 'Information', false, false)
					guiGridListSetItemText(help.gridlist[1], 1, 1, 'Factionsystem', false, false)
					guiGridListSetItemText(help.gridlist[1], 2, 1, 'Jobsystem', false, false)
					guiGridListSetItemText(help.gridlist[1], 3, 1, 'Vehiclesystem', false, false)
					guiGridListSetItemText(help.gridlist[1], 4, 1, 'Hungersystem', false, false)
					guiGridListSetItemText(help.gridlist[1], 5, 1, 'Gunsystem', false, false)
					guiGridListSetItemText(help.gridlist[1], 6, 1, 'Housesystem', false, false)
					guiGridListSetItemText(help.gridlist[1], 7, 1, 'Your Faction', false, false)
					guiGridListSetItemText(help.gridlist[1], 9, 1, 'Levelsystem', false, false)
				end
				help.label[1] = guiCreateLabel(0.45, 0.06, 0.53, 0.92, 'Klicke per Doppelklick etwas in der Liste an, um Informationen zur jeweiligen Kategorie zu erhalten.', true, help.window[1])
				guiSetFont(help.label[1], 'default-bold-small')
				guiLabelSetColor(help.label[1], 255, 255, 0)
				guiLabelSetHorizontalAlign(help.label[1], 'center', true)
				guiLabelSetVerticalAlign(help.label[1], 'center')

				if(getElementData(localPlayer,'Language') == 1)then
					guiSetText(help.label[1],'Click a double click something on the list to get information about the category.')
				end
				
				addEventHandler('onClientGUIDoubleClick',help.gridlist[1],function()
					auswahl=guiGridListGetItemText(help.gridlist[1],guiGridListGetSelectedItem(help.gridlist[1]),1)
					
					if(auswahl == 'Allgemeines' or auswahl == 'Information')then
						if(getElementData(localPlayer,'Language') == 0)then
							guiSetText(help.label[1],'Scheine kannst du in der Stadthalle beantragen, welche sich am gelben Punkt befindet. Anschließend kannst du dir am Fort Carson Autohändler dein erstes Fahrzeug kaufen, um schneller alles erkunden zu können. Jobs kannst du in der Stadthalle annehmen. Die meisten Jobs befinden sich außerhalb von Fort Carson. Damit andere Spieler dich besser erreichen können, benötigst du ein Handy, welches du für 350$ in jedem 24/7 Shop erwerben kannst. Solltest du mal Hunger bekommen, besuche ein Fast Food Restaurant, welche mit Burgern, Pizzen und Chicken auf der Karte markiert wurden. Zudem kannst du in jedem 24/7 Shops Snacks erwerben.')
						else
							guiSetText(help.label[1],'You can buy licenses in our Cityhall. Our Cityhall is marked with a round yellow blip. After you buy a License, you can buy your first Vehicle at the Fort Carson Carhouse. You can accept jobs in the Cityhall too. Most of our jobs are not in Fort Carson. In our 24/7 Shops you can buy some Articles. Are you hungry? Visit a restaurant.')
						end
					elseif(auswahl == 'Fraktionssystem' or auswahl == 'Factionsystem')then
						guiSetText(help.label[1],'Test')
					elseif(auswahl == 'Fahrzeugsystem' or auswahl == 'Vehiclesystem')then
						if(getElementData(localPlayer,'Language') == 0)then
							guiSetText(help.label[1],'Fahrzeuge kannst du an Autohäusern erwerben, wofür du die nötigen Lizenzen benötigst, welche du in der Stadthalle (gelber Punkt) erwerben kannst. Es gibt mehrere Autohäuser, welche alle unterschiedliche Fahrzeuge in verschiedenen Preisklassen anbieten. Die billigsten Fahrzeuge findest du beim Autohändler in Fort Carson. Autohäuser sind auf der Karte mit einem blauen Auto markiert.\n\nBefehle:\n/park - Sein Fahrzeug umparken\n/respawnen [Slot] - Sein Fahrzeug respawnen\n/lock [Slot] - Sein Fahrzeug auf/abschließen\n/sellcar [Slot] - Sein Fahrzeug verkauf\n\nSolltest du dein Fahrzeug an den Server verkaufen, erhälst du nur 50% des eigentlichen Kaufpreises zurück.\n\nTanken kann man seine Fahrzeuge an Tankstellen, welche auf der Karte mit einem T markiert wurden.\n\nSollte dein Fahrzeug mal beschädigt werden, kannst du es in einem von vielen Pay N Sprays reparieren. Diese wurden mit einer Spraydose auf der Karter markiert.')
						else
							guiSetText(help.label[1],'You can buy Vehicles at Carhouses. For buy a Vehicle need you Licenses, which you can buy in our Cityhall. All Carhouses sell other Cars for other prices. Cheap cars can you find at the Forst Carson Carhouse.\n\nCommands:\n/park - Park your Vehicle\n/respawnen [slot] - Respawn your Vehicle\n/lock [slot] - Lock or unlock your Vehicle\n/sellcar [slot] - Sell your Vehicle\n\nWhen you sell your Vehicle to the System, you get 50% of the purchase price back.\n\nYour vehicle take damage? Visist a Paynspray.\n\nYour Vehicle need gas? Visit a gas station.')
						end
					elseif(auswahl == 'Hungersystem')then
						if(getElementData(localPlayer,'Language') == 0)then
							guiSetText(help.label[1],'Die ganzen Restaurants gibt es nicht umsonst! Regelmäßiges Essen ist wichtig, da man sonst verhungert. Rechts unter seiner HUD sieht man seinen Hungerbalken. Jede Minute verliert man 1% Hunger.')
						else
							guiSetText(help.label[1],'When you not eat, you die! Every minute lost you 1% hunger. When you are hungry, visit a restaurant.')
						end
					elseif(auswahl == 'Waffensystem' or auswahl == 'Gunsystem')then
						if(getElementData(localPlayer,'Language') == 0)then
							guiSetText(help.label[1],'Einen Waffenschein kannst du im Fort Carson Police Department beantragen. Dieser kostet 7500$ und ermöglicht einen den Kauf von Waffen. Waffenläden gibt es in ganz San Andreas und wurden auf der Karte mit einer Waffe markiert.')
						else
							guiSetText(help.label[1],'You can buy a gunlicense for 7500$ in Fort Carson Police Department. When you have a gunlicense, you can buy weapons in our Ammunations.')
						end
					elseif(auswahl == 'Haussystem' or auswahl == 'Housesystem')then
						if(getElementData(localPlayer,'Language') == 0)then
							guiSetText(help.label[1],'Ein Haus bietet dir Parkplätze wie auch einen Spawnpunkt. Zudem kannst du in jedem Haus dein Leben und Hunger auffüllen. Kaufbare Häuser sind auf der Karte mit einem grünen Blip markiert und bereits verkaufte Häuser sind mit einem roten Blip markiert. Der Preis hängt davon ab, wie groß das Haus ist. Möbelstücke kannst du am grünen Haus in Los Santos kaufen. Es gibt Möbelstücke für innen wie auch für außen.\n\nBefehle:\n/sellhouse - Sein Haus verkaufen\n/buyhouse - Ein Haus kaufen\n/hlock - Haus ab/aufschließe\nF2 - Hausmenü')
						else
							guiSetText(help.label[1],'Have you enough money for a house? Then buy a house! A house give you the opportunity to park your Vehicles on a safe ground. Also you can spawn in your House. Green blips on the map are houses which you can buy, red houses are houses from users. Furniture you can buy at the green house in Los Santos. There are pieces of furniture for interior as well as exterior.\n\nCommands:\n/sellhouse - Sell your House\n/buyhouse - Buy a House\n/hlock - Lock/Unlock your House\nF2 - Housemenu')
						end
					elseif(auswahl == 'Deine Fraktion' or auswahl == 'Your Faction')then
						if(getElementData(localPlayer,'Fraktion') == 0)then
							if(getElementData(localPlayer,'Language') == 0)then
								guiSetText(help.label[1],'Du bist in keiner Fraktion.')
							else
								guiSetText(help.label[1],'You are not in a Faction.')
							end
						elseif(getElementData(localPlayer,'Fraktion') == 1)then
							if(getElementData(localPlayer,'Language') == 0)then
								guiSetText(help.label[1],'Du bist beim Police Department und zuständig für die Sicherheit der Bürger. Deine Basen befinden sich beim Blaulicht auf der Karte.\n\n/arrest [Spieler] - Einen Spieler einknasten\nF4 auf einem PD Fahrzeug - Überwachungskameras\n/duty [normal/swat] - Dienst beginnen\n/offduty - Dienst beenden\n/su - Wanteds verteilen\n\nAm Dollar Zeichen in Los Santos kannst du einen Geldtransporter starten.')
							else
								guiSetText(help.label[1],'You are member of the Police Department and responsible for the safety of citizens. The blue lights on the map are your Bases.\n\n Commands:\n/arrest [player] - Arrest a player\n/F4 in a Police Car - Use the cameras\n/duty [normal/swat] - Go duty\n/offduty - Stop duty\n/su - Give a player Wanteds\n\nYou can start a Moneytransporter on the Dollar Blip in Los Santos.')
							end
						elseif(getElementData(localPlayer,'Fraktion') == 4)then
							if(getElementData(localPlayer,'Language') == 0)then
								guiSetText(help.label[1],'Du bist Reporter und somit für Nachrichten sowie Events zuständig. Deine Base befindet sich in Fort Carson.\n\n/news [Text] - Öffentlicher Reporter-Chat\n/setlive [Spieler] - Spieler zum Interview einladen\n/move - Schranken öffnen')
							else
								guiSetText(help.label[1],'You are Reporter and thus responsible for News and Events. Your base are in Fort Carson.\n\nCommands:\n/news [message] - Reporter-Chat\n/setlive [player] - Start a interview\n/move - Open gates')
							end
						elseif(getElementData(localPlayer,'Fraktion') == 2)or(getElementData(localPlayer,'Fraktion')==3)or(getElementData(localPlayer,'Fraktion')==5)(getElementData(localPlayer,'Fraktion')==6)then
							if(getElementData(localPlayer,'Language') == 0)then
								guiSetText(help.label[1],'Du bist in einer bösen Fraktion. Neben illegalen Transporten, zum beschaffen von Geld, gibt es noch das Gangwarsystem. Die bunten Gebiete auf der Karte markieren ein Ganggebiete. Die Farbe kennzeichnet den Besitzer des Gebietes. Ganggbiete bringen einen Paydaybonus.\n\nCommands:\n/attack - Ein Gebiet angreifen\n/move - Gate öffnen\n/arm - Sich ausrüsten\n\nDu kannst einen Drogentransporter am D und einen Matstransporter am grauen Truck in San Fierro starten.')
							else
								guiSetText(help.label[1],'You are in a Evil Faction. Besides illegal transporters can Gangs start Gangwars. The colorful areas on the Map marked Gangareas. The color indicates the owner. Gangareas give you a Paydaybonus.\n\nCommands:\n/attack - Start a Gangwar\n/move - Open a Gate\n/arm - Buy weapons\n\nYou can start a Drugtransporter at the D on the map and a Matstransporter at the gray Truck in San Fierro.')
							end
						end
					elseif(auswahl == 'Levelsystem')then
						if(getElementData(localPlayer,'Language') == 0)then
							guiSetText(help.label[1],'Viele Aktivitäten bringen Erfahrungspunkte. Wenn du eine bestimmte Anzahl an EXP erreichst, steigst du ein Level auf. Zudem kann man Erfahrungspunkte dafür nutzen, sich im Bonusshop Artikel zu kaufen, welcher ab Level 1 zu verfügung steht. Mit jedem neuen Level erhält man eine größere Auswahl im Bonusshop.\n\n/bonusshop - Öffnet den Bonusshop\n/mylevel - Zeigt das eigene Level\n/myexp - Zeigt die eigenen Erfahrungspunkte\n\nDas maximale Level ist 5.')
						else
							guiSetText(help.label[1],'Some activities give you EXP. When you reach a certain number of EXP, you get a new level. Also you can buy with EXP some stuff in our Bonusshop. With every new Level, the Bonusshop sell you more Items.\n\nCommands:\n/bonusshop - Open the Bonusshop\n/mylevel - Show your Level\n/myexp - Show your EXP\n\nThe maximum Level is 5.')
						end
					end
				end,false)
			end
		end
	else
		showCursor(false)
		destroyElement(help.window[1])
		setElementData(localPlayer,'redfieldClick',false)
    end
end
bindKey('f1','down',helpWindow)