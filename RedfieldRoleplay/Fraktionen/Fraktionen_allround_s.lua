function isCop(player)
	if(tonumber(getElementData(player,'Fraktion')) == 1)then return true else return false end
end
function isYakuza(player)
	if(tonumber(getElementData(player,'Fraktion')) == 2)then return true else return false end
end
function isBiker(player)
	if(tonumber(getElementData(player,'Fraktion')) == 3)then return true else return false end
end
function isReporter(player)
	if(tonumber(getElementData(player,'Fraktion')) == 4)then return true else return false end
end
function isBallas(player)
	if(tonumber(getElementData(player,'Fraktion')) == 5)then return true else return false end
end
function isSurenos(player)
	if(tonumber(getElementData(player,'Fraktion')) == 6)then return true else return false end
end

function isEvil(player)
	if(isYakuza(player) or isBiker(player) or isBallas(player) or isSurenos(player))then return true else return false end
end

-- Fraktion verlassen --
function fraktionLeave(player)
	if(getElementData(player,'loggedin') == 1)then
		if(getElementData(player,'Fraktion') > 0)then
			local rang=tonumber(getElementData(player,'Fraktionrang'))
			
			if(rang<5)then
				setElementData(player,'Fraktion',0)
				setElementData(player,'Fraktionrang',0)
				getChatBox(player,88)
			end
		end
	end
end
addCommandHandler('fleave',fraktionLeave)

-- Spieler inviten --
function spielerInviten(player,cmd,target)
	if(getElementData(player,'loggedin') == 1)then
		if(getElementData(player,'Fraktion') > 0)then
			if(getElementData(player,'Fraktionrang') >= 5)then
				if(target)then
					local tplayer = getPlayerFromName(target)
					local tfraki = getElementData(tplayer,'Fraktion')
					local fraki = getElementData(player,'Fraktion')
					
					if(tfraki==0)then
						if(isGerman(player))then
							infobox_func(player,'Du hast '..getPlayerName(tplayer)..' in deine Fraktion aufgenommen.',0,255,0)
						elseif(isEnglish(player))then
							infobox_func(player,'You invite '..getPlayerName(tplayer)..'.',0,255,0)
						end
						if(isGerman(tplayer))then
							infobox_func(tplayer,'Du wurdest so eben in eine Fraktion aufgenommen.',0,255,0)
						elseif(isEnglish(tplayer))then
							infobox_func(tplayer,'You was invitet in a faction.',0,255,0)
						end
						
						setElementData(tplayer,'Fraktion',fraki)
						setElementData(tplayer,'Fraktionsrang',0)

						if(getElementData(tplayer,'AchFraktion') == 0)then
							setElementData(tplayer,'AchFraktion',1)
							achievmentInfo(tplayer)
						end
					end
				else
					getChatBox(player,85)
				end
			else
				getChatBox(player,84)
			end
		end
	end
end
addCommandHandler('invite',spielerInviten)

-- Spieler uninviten --
function spielerUninviten(player,cmd,target)
	if(getElementData(player,'loggedin')==1)then
		if(getElementData(player,'Fraktion')>0)then
			if(getElementData(player,'Fraktionrang')>=5)then
				if(target)then
					local tplayer=getPlayerFromName(target)
					local tfraki=getElementData(tplayer,'Fraktion')
					local trang=getElementData(tplayer,'Fraktionrang')
					local fraki=getElementData(player,'Fraktion')
					
					if(fraki==tfraki)then
						if(trang<5)then
							setElementData(tplayer,'Fraktion',0)
							setElementData(tplayer,'Fraktionrang',0)
							if(isGerman(tplayer))then infobox_func(tplayer,'Du wurdest so eben uninvitet!',255,0,0)end
							if(isEnglish(tplayer))then infobox_func(tplayer,'You would uninvitet!',255,0,0)end
							outputlog(getPlayerName(tplayer)..' wurde von '..getPlayerName(player)..' uninvitet','Fraktion')
						end
					end
				else
					getChatBox(player,85)
				end
			else
				getChatBox(player,84)
			end
		end
	end
end
addCommandHandler('uninvite',spielerUninviten)

-- Rang setzen --
function spielerRangsetzen(player,cmd,target,rang)
	if(getElementData(player,'loggedin') == 1)then
		if(getElementData(player,'Fraktion')>0)then
			if(getElementData(player,'Fraktionrang') >= 5)then
				if(target)then
					if(rang)then
						local rang = tonumber(rang)
						
						if(rang < 5)then
							local tplayer = getPlayerFromName(target)
							local tfraki = getElementData(tplayer,'Fraktion')
							local trang = getElementData(tplayer,'Fraktionrang')
							local fraki = getElementData(player,'Fraktion')
							
							if(fraki == tfraki)then
								setElementData(tplayer,'Fraktionrang',rang)
								if(isGerman(tplayer))then
									infobox_func(tplayer,'Du wurdest auf Rang '..rang..' gesetzt.',0,255,0)
								elseif(isEnglish(tplayer))then
									infobox_func(tplayer,'Your rank was set on '..rang..'.',0,255,0)
								end
							end
						else
							getChatBox(player,87)
						end
					else
						getChatBox(player,86)
					end
				else
					getChatBox(player,85)
				end
			else
				getChatBox(player,84)
			end
		end
	end
end
addCommandHandler('giverang',spielerRangsetzen)

-- In den Knast setzen --
function inDenKnast(player)
	local zelle = math.random(1,3)
	
	if(zelle == 1)then
		setElementPosition(player,264.20001220703,77.5,1001)
	elseif(zelle == 2)then
		setElementPosition(player,264.20001220703,82.199996948242,1001)
	elseif(zelle == 3)then
		setElementPosition(player,264.10000610352,86.599998474121,1001)
	end
	setPedRotation(player,270)
	setElementInterior(player,6)
	setElementModel(player,62)
	setElementData(player,'imKnast',true)
	setPlayerWantedLevel(player,0)
end

-- Aus dem Knast --
function ausDemKnast(player)
	setElementPosition(player,-216,978.5,19.5)
	setPedRotation(player,270)
	setElementInterior(player,0)
	setElementModel(player,getElementData(player,'Skin'))
	setElementData(player,'imKnast',nil)
end

-- /fskin --
factionskins={}

factionskins[1]={}
	factionskins[1][0]=71
	factionskins[1][1]=280
	factionskins[1][2]=281
	factionskins[1][3]=282
	factionskins[1][4]=283
	factionskins[1][5]=288
factionskins[2]={}
	factionskins[2][0]=122
	factionskins[2][1]=121
	factionskins[2][2]=118
	factionskins[2][3]=120
	factionskins[2][4]=123
	factionskins[2][5]=49
factionskins[3]={}
	factionskins[3][0]=292
	factionskins[3][1]=181
	factionskins[3][2]=291
	factionskins[3][3]=247
	factionskins[3][4]=248
	factionskins[3][5]=100
factionskins[4]={}
	factionskins[4][0]=250
	factionskins[4][1]=188
	factionskins[4][2]=185
	factionskins[4][3]=59
	factionskins[4][4]=187
	factionskins[4][5]=147
factionskins[5]={}
	factionskins[5][0]=13
	factionskins[5][1]=297
	factionskins[5][2]=296
	factionskins[5][3]=103
	factionskins[5][4]=102
	factionskins[5][5]=104
factionskins[6]={}
	factionskins[6][0]=114
	factionskins[6][1]=175
	factionskins[6][2]=174
	factionskins[6][3]=173
	factionskins[6][4]=116
	factionskins[6][5]=115

local yakuzaClothes=createPickup(-2170.7202148438,646.21838378906,1052.375,3,1275,50)
setElementInterior(yakuzaClothes,1)
local bikerClothes=createPickup(-221.30963134766,1407.095703125,27.7734375,3,1275,50)
setElementInterior(bikerClothes,18)
local surenosClothes=createPickup(321.8908996582,1117.1495361328,1083.8828125,3,1275,50)
setElementInterior(surenosClothes,5)
local ballasClothes=createPickup(961.19213867188,2102.1723632813,1011.0274658203,3,1275,50)
setElementInterior(ballasClothes,1)
local reporterClothes=createPickup(-2022.5893554688,-114.51982879639,1035.171875,3,1275,50)
setElementInterior(reporterClothes,3)

function changeSkin(player)
	if(getElementData(player,'Fraktion') > 0)then
		local faction = getElementData(player,'Fraktion')
		local frank = getElementData(player,'Fraktionrang')
		if(getDistanceBetweenPoints3D(-2170.7202148438,646.21838378906,1052.375,getElementPosition(player))<5 or getDistanceBetweenPoints3D(-221.30963134766,1407.095703125,27.7734375,getElementPosition(player))<5 or getDistanceBetweenPoints3D(321.8908996582,1117.1495361328,1083.8828125,getElementPosition(player))<5 or getDistanceBetweenPoints3D(961.19213867188,2102.1723632813,1011.0274658203,getElementPosition(player))<5 or getDistanceBetweenPoints3D(-2022.5893554688,-114.51982879639,1035.171875,getElementPosition(player))<5)then
			setElementModel(player,factionskins[faction][frank])
			if(not(faction)==1)then
				setElementData(player,'Skin',factionskins[faction][frank])
			end
		end
	end
end
addCommandHandler('fskin',changeSkin)

function clothesMarkerHit(player)
	getChatBox(player,161)
end
addEventHandler("onPickupHit",yakuzaClothes,clothesMarkerHit)
addEventHandler("onPickupHit",bikerClothes,clothesMarkerHit)
addEventHandler("onPickupHit",surenosClothes,clothesMarkerHit)
addEventHandler("onPickupHit",ballasClothes,clothesMarkerHit)

-- Spawnpunkt --
function changeSpawn(x,y,z,interior)
	setElementData(source,'SpawnX',x)
	setElementData(source,'SpawnY',y)
	setElementData(source,'SpawnZ',z)
	setElementData(source,'Interior',interior)
	
	if(getElementData(source,'AchSpawn') == 0)then
		setElementData(source,'AchSpawn',1)
		achievmentInfo(source)
	end
	setElementData(source,'ImHaus',0)
	getChatBox(source,83)
end
addEvent('changeSpawn',true)
addEventHandler('changeSpawn',root,changeSpawn)

-- Fraktionslager --
function fstate_func(player)
	if(getElementData(player,"Fraktion")>0)then
		local query=dbQuery(dbConnection,"SELECT * FROM kassen WHERE Besitzer = '"..getElementData(player,"Fraktion").."'")
		local result,num_rows=dbPoll(query,-1)
		
		if(query)then
			outputChatBox("___________________________",player,255,255,255)
			if(isGerman(player))then
				outputChatBox("Geld: "..tonumber(result[1]["Geld"]).."$",player,0,100,200)
				outputChatBox("Drogen: "..tonumber(result[1]["Drogen"]).."g",player,0,100,200)
				outputChatBox("Materialien: "..tonumber(result[1]["Materialien"]).." Stk",player,0,100,200)
				if(isEvil(player))then
					outputChatBox("Waffenpakete: "..tonumber(result[1]["Waffenpakete"]),player,0,100,200)
				end
			elseif(isEnglish(player))then
				outputChatBox("Money: "..tonumber(result[1]["Geld"]).."$",player,0,100,200)
				outputChatBox("Drugs: "..tonumber(result[1]["Drogen"]).."g",player,0,100,200)
				outputChatBox("Mats: "..tonumber(result[1]["Materialien"]).." Stk",player,0,100,200)
				if(isEvil(player))then
					outputChatBox("Weaponpacks: "..tonumber(result[1]["Waffenpakete"]),player,0,100,200)
				end
			end
			outputChatBox("___________________________",player,255,255,255)
		end
	end
end
addCommandHandler("fstate",fstate_func)
addEvent("fstate",true)
addEventHandler("fstate",root,fstate_func)

function updatefstate(typ,item,menge,id)
	local query=dbQuery(dbConnection,"SELECT * FROM kassen WHERE Besitzer = '"..id.."'")
	local result,num_rows=dbPoll(query,-1)
	
	if(query)then
		if(typ=="auszahlen")then
			if(item=="drugs")then
				getdrugs=tonumber(result[1]["Drogen"])
				if(getdrugs>=tonumber(menge))then
					setElementData(source,"Drogen",getElementData(source,"Drogen")+menge)
					newdrugs=tonumber(result[1]["Drogen"])-menge
					dbQuery(dbConnection,"UPDATE kassen SET Drogen = '"..newdrugs.."' WHERE Besitzer = '"..id.."'")
				else
					getChatBox(source,162)
				end
			elseif(item=="money")then
				getmoney=tonumber(result[1]["Geld"])
				if(getmoney>=tonumber(menge))then
					givePlayerMoney(source,menge)
					setElementData(source,"Money",getElementData(source,"Money")+menge)
					newmoney=tonumber(result[1]["Geld"])-menge
					dbQuery(dbConnection,"UPDATE kassen SET Geld = '"..newmoney.."' WHERE Besitzer = '"..id.."'")
				else
					getChatBox(source,155)
				end
			elseif(item=="mats")then
				getmats=tonumber(result[1]["Materialien"])
				if(getmats>=tonumber(menge))then
					setElementData(source,"Materialien",getElementData(source,"Materialien")+menge)
					newmats=tonumber(result[1]["Materialien"])-menge
					dbQuery(dbConnection,"UPDATE kassen SET Materialien = '"..newmats.."' WHERE Besitzer = '"..id.."'")
				else
					getChatBox(source,162)
				end
			end
		elseif(typ=="einzahlen")then
			if(item=="drugs")then
				getdrugs=tonumber(result[1]["Drogen"])
				if(getElementData(source,"Drogen")>=tonumber(menge))then
					setElementData(source,"Drogen",getElementData(source,"Drogen")-menge)
					newdrugs=tonumber(result[1]["Drogen"])+menge
					dbQuery(dbConnection,"UPDATE kassen SET Drogen = '"..newdrugs.."' WHERE Besitzer = '"..id.."'")
				else
					getChatBox(source,30)
				end
			elseif(item=="money")then
				getmoney=tonumber(result[1]["Geld"])
				if(getPlayerMoney(source)>=tonumber(menge))then
					takePlayerMoney(source,menge)
					setElementData(source,"Money",getElementData(source,"Money")-menge)
					newmoney=tonumber(result[1]["Geld"])+menge
					dbQuery(dbConnection,"UPDATE kassen SET Geld = '"..newmoney.."' WHERE Besitzer = '"..id.."'")
				else
					getChatBox(source,33)
				end
			elseif(item=="mats")then
				getmats=tonumber(result[1]["Materialien"])
				if(getElementData(source,"Materialien")>=tonumber(menge))then
					setElementData(source,"Materialien",getElementData(source,"Materialien")-menge)
					newmats=tonumber(result[1]["Materialien"])+menge
					dbQuery(dbConnection,"UPDATE kassen SET Materialien = '"..newmats.."' WHERE Besitzer = '"..id.."'")
				else
					getChatBox(source,31)
				end
			end
		end
	end
end
addEvent("updatefstate",true)
addEventHandler("updatefstate",root,updatefstate)

-- Waffentruck --
local yakuzaWTAbgabe=createMarker(676.20001220703,1932.4000244141,4.5999999046326,"cylinder",3,0,0,200)
setElementAlpha(yakuzaWTAbgabe,50)
local bikerWTAbgabe=createMarker(-20.2998046875,1387.900390625,8.3999996185303,"cylinder",3,0,0,200)
setElementAlpha(bikerWTAbgabe,50)
local surenosWTAbgabe=createMarker(-374.71676635742,2253.39453125,41.484375,"cylinder",3,0,0,200)
setElementAlpha(surenosWTAbgabe,50)
local ballasWTAbgabe=createMarker(2530.3103027344,-2005.8442382813,12.546875,"cylinder",3,0,0,200)
setElementAlpha(ballasWTAbgabe,50)

function hitWTAbgabe_func(player)
	if(isEvil(player))then
		if(isPedInVehicle(player))then
			veh=getPedOccupiedVehicle(player)
			if(getElementModel(veh)==482)then
				getChatBox(player,153)
			end
		end
	end
end
addEventHandler("onMarkerHit",yakuzaWTAbgabe,hitWTAbgabe_func)
addEventHandler("onMarkerHit",bikerWTAbgabe,hitWTAbgabe_func)
addEventHandler("onMarkerHit",surenosWTAbgabe,hitWTAbgabe_func)
addEventHandler("onMarkerHit",ballasWTAbgabe,hitWTAbgabe_func)

function unloadweapons_func(player)
	local query=dbQuery(dbConnection,"SELECT * FROM kassen WHERE Besitzer = '"..getElementData(player,"Fraktion").."'")
	local result,num_rows=dbPoll(query,-1)

	if(isEvil(player))then
		if(isPedInVehicle(player))then
			veh=getPedOccupiedVehicle(player)
			if(getElementModel(veh)==482)then
				if(getDistanceBetweenPoints3D(676.20001220703,1932.4000244141,4.5999999046326,getElementPosition(player))<8)or(getDistanceBetweenPoints3D(-20.2998046875,1387.900390625,8.3999996185303,getElementPosition(player))<8 or getDistanceBetweenPoints3D(-374.71676635742,2253.39453125,41.484375,getElementPosition(player))<5)then
					if(getElementData(veh,"paketeBeladen")==true)then
						waffenpacks=tonumber(result[1]["Waffenpakete"])
						newpakete=tonumber(result[1]["Waffenpakete"])+5
						dbQuery(dbConnection,"UPDATE kassen SET Waffenpakete = '"..newpakete.."' WHERE Besitzer = '"..getElementData(player,"Fraktion").."'")
						setElementData(veh,"paketeBeladen",nil)
						giveErfahrungspunkte(player,100)
						getChatBox(player,159)
					else
						getChatBox(player,158)
					end
				end
			end
		end
	end
end
addCommandHandler("unloadweapons",unloadweapons_func)