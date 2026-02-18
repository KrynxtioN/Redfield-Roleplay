function spielerTimer(player)
	if(getElementData(player,'loggedin') == 1)then
		setElementData(player,'Spielzeit',getElementData(player,'Spielzeit') + 1)
		
		if(getElementData(player,'Hunger') > 0)then
			setElementData(player,'Hunger',getElementData(player,'Hunger') - 1)
		end
		
		if(getElementData(player,'Hunger') < 5)then
			if(isEnglish(player))then
				outputChatBox('You get hungry, visit a restaurant!',player,200,0,0)
			elseif(isGerman(player))then
				outputChatBox('Du bekommst Hunger, besuche ein Restaurant!',player,200,0,0)
			end
		end
		
		if(getElementData(player,'Hunger')==0)then
			killPed(player)
			if(isEnglish(player))then
				outputChatBox('You are starving!',player,200,0,0)
			end
			if(isGerman(player))then
				outputChatBox('Du bist verhungert!',player,200,0,0)
			end
		end
		
		if(getElementData(player,'Prisontime')>0)then
			setElementData(player,'Prisontime',getElementData(player,'Prisontime')-1)
			if(getElementData(player,'Prisontime')==0)then
				ausDemKnast(player)
			end
		end
		if(getElementData(player,'Knastzeit')>0)then
			setElementData(player,'Knastzeit',getElementData(player,'Knastzeit') - 1)
			if(getElementData(player,'Knastzeit') == 0)then
				ausDemKnast(player)
			end
		end
		
		if(math.floor(getElementData(player,'Spielzeit')/60) == (getElementData(player,'Spielzeit')/60))then
			if(getElementData(player,'Ach25TausendEXP') == 0)then
				setElementData(player,'Ach25TausendEXP',1)
				achievmentInfo(player)
			end
			if(getElementData(player,'AchPayday') == 0)then
				setElementData(player,'AchPayday',1)
				achievmentInfo(player)
			end
			
			if(getElementData(player,'Spielzeit') >= 3000)then
				if(getElementData(player,'Ach5Hours') == 0)then
					setElementData(player,'Ach5Hours',1)
					achievmentInfo(player)
				end
			end
			
			if(getElementData(player,'Ach1Million') == 0)then
				if(getElementData(player,'Bankmoney') >= 1000000)then
					setElementData(player,'Ach1Million',1)
					triggerServerEvent('achievmentInfo',localPlayer,localPlayer)
				end
			end
		
			local jobgehalt=getElementData(player,'Jobgehalt')
			setElementData(player,'paydayPlusCash',jobgehalt)
			setElementData(player,'paydayMinusCash',0)
			
			outputChatBox('..:: Payday ::..',player,255,255,255)
			outputChatBox('______________________________',player,255,255,255)
			if(isGerman(player))then
				outputChatBox('Jobgehalt: '..jobgehalt,player,0,150,0)
				if(getElementData(player,'Motel')==1)then
					outputChatBox('Motel-Zimmer: 630$',player,150,0,0)
					setElementData(player,'Bankmoney',getElementData(player,'Bankmoney') - 630)
				end
				if(getElementData(player,"Versicherung")==1)then
					outputChatBox("Versicherung: 750$",player,150,0,0)
					setElementData(player,'Bankmoney',getElementData(player,'Bankmoney') - 750)
				end
				outputChatBox('______________________________',player,255,255,255)
				outputChatBox('+ '..getElementData(player,'paydayPlusCash')..'$ / - '..getElementData(player,'paydayMinusCash')..'$',player,150,150,0)
				outputChatBox('Das Geld wurde auf dein Konto überwiesen',player,0,150,0)
			end
			if(isEnglish(player))then
				outputChatBox('Job salary: '..jobgehalt,player,0,150,0)
				if(getElementData(player,'Motel')==1)then
					outputChatBox('Motel-Room: 630$',player,150,0,0)
					setElementData(player,'Bankmoney',getElementData(player,'Bankmoney') - 630)
				end
				if(getElementData(player,"Versicherung")==1)then
					outputChatBox("Insurance: 750$",player,150,0,0)
					setElementData(player,'Bankmoney',getElementData(player,'Bankmoney') - 750)
				end
				outputChatBox('______________________________',player,255,255,255)
				outputChatBox('+ '..getElementData(player,'paydayPlusCash')..'$ / - '..getElementData(player,'paydayMinusCash')..'$',player,150,150,0)
				outputChatBox('The money was transferred to your bank account',player,0,150,0)
			end
			
			local paydaycash1=getElementData(player,'paydayPlusCash')
			setElementData(player,'Bankmoney',getElementData(player,'Bankmoney')+paydaycash1)
		end
		setTimer(spielerTimer,60000,1,player)
	end
end

function adFunktion(player,cmd,...)
	local parametersTable = {...}
	local stringWithAllParameters = table.concat(parametersTable,' ')
	local length = #stringWithAllParameters
	local costs = length*2
	
	if(#stringWithAllParameters~=0)then
		if(getPlayerMoney(player) >= costs)then
			if(#stringWithAllParameters<=70)then
				outputChatBox('Werbung von '..getPlayerName(player)..': '..stringWithAllParameters,root,0,150,0)
				takePlayerMoney(player,costs)
			else
				if(isEnglish(player))then infobox_func(player,'Maximum 70 characters allowed!',255,0,0)end
				if(isGerman(player))then infobox_func(player,'Maximal 70 Zeichen erlaubt!',255,0,0)end
			end
		else 
			if(isEnglish(player))then infobox_func(player,'You need '..costs..'$!',255,0,0)end
			if(isGerman(player))then infobox_func(player,'Du benötigst '..costs..'$',255,0,0)end
		end
	else
		if(isEnglish(player))then infobox_func(player,'Please provide a text!',255,0,0)end
		if(isGerman(player))then infobox_func(player,'Gib einen Text an!',255,0,0)end
	end
end
addCommandHandler('ad',adFunktion)
addCommandHandler('werbung',adFunktion)

function krankenhausServer(ammo,killer,weapon,part)
	if(getElementData(source,'AchGestorben') == 0)then
		setElementData(source,'AchGestorben',1)
		achievmentInfo(source)
	end
	
	if(getElementData(source,'PilotJobAktiv') == true)then
		local veh=getPedOccupiedVehicle(source)
		destroyElement(veh)
		triggerClientEvent(source,'stopPilotJob',source)
		setElementData(source,'PilotJobAktiv',nil)
	end
	if(getElementData(source,'inholzjob') == true)then
		setElementData(source,'inholzjob',false)
		triggerClientEvent(source,'destroyHolz',source)
	end
	if(getElementData(source,'TankwartAktiv') == true)then
		triggerClientEvent(source,'destroyTankShit',source)
	end
	
	if(isElement(killer))then
		setElementData(killer,'Kills',getElementData(killer,'Kills')+1)
	end
	
	if(part)then
		if(part==9)then
			setPedHeadless(source,true)
		end
	end
	setElementData(source,'Tode',getElementData(source,'Tode')+1)
	
	if(getElementData(source,"Versicherung")==0)then
		if(isGerman(source))then
			outputChatBox("Da du keine Versicherung hast, musst du 2300$ zahlen.",source,200,100,0)
		elseif(isEnglish(source))then
			outputChatBox("Because you have no health insurance, you have to pay $ 2300th",source,200,100,0)
		end
		setElementData(source,"Bankmoney",getElementData(source,"Bankmoney")-2300)
	else
		if(isGerman(source))then
			outputChatBox("Da du eine Versicherung hast, zahlt diese die Arztrechnung.",source,200,100,0)
		elseif(isEnglish(source))then
			outputChatBox("Because you have an health insurance, they will pay the medical bill.",source,200,100,0)
		end
	end
	
	if(isCop(killer) and getElementData(killer,"copDuty")==true)then
		if(getPlayerWantedLevel(source)>0)then
			local wntds = getPlayerWantedLevel(source)
			local wntdstime = wntds*4
			giveErfahrungspunkte(killer,50)
			setElementData(source,'Knastzeit',wntdstime)
			inDenKnast(source)
		end
	end
	triggerClientEvent(source,'hospitalWindow',source)
end
addEventHandler('onPlayerWasted',root,krankenhausServer)

function afterHospitalSpawn(player)
	spawnPlayer(player,-316.16384887695,1056.6286621094,19.7421875)
	setElementDimension(player,0)
	setElementInterior(player,0)
	setCameraTarget(player)
	if(getElementData(player,'Hunger') == 0)then
		setElementData(player,'Hunger',5)
	end
	setElementModel(player,getElementData(player,'Skin'))
end
addEvent('afterHospitalSpawn',true)
addEventHandler('afterHospitalSpawn',root,afterHospitalSpawn)

function infobox_func(player,text,r,g,b)
	triggerClientEvent(player,'infobox',player,text,r,g,b)
end