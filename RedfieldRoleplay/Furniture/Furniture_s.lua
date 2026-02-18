function createAllObjects()
	local objecte = dbQuery(dbConnection,'SELECT * FROM `??`','objekte')
	local result,row = dbPoll(objecte,-1)
	local IDS = #dbPoll(dbQuery(dbConnection,'SELECT ID FROM objekte'),-1)

	if((result)and(row) >= 1)then
		for i,object in pairs(result)do
			local int = object['Interior']
			local dim = object['Dimension']
			dataObject = createObject(object['Model'],object['Positionx'],object['Positiony'],object['Positionz'],0,0,object['Rotation'])
			setElementInterior(dataObject,int)
			setElementDimension(dataObject,dim)
		end
		outputDebugString(IDS..' object(s) load')
	end
end
createAllObjects()

addEvent('createNewObjectPlace',true)
addEventHandler('createNewObjectPlace',root,function(id,x,y,z,rx,ry,rz,interior,dimension)
	local takeObject = 'Objekt'..id
	newObject = createObject(id,x,y,z,rx,ry,rz)
	setElementInterior(newObject,interior)
	setElementDimension(newObject,dimension)
	
	setElementData(source,takeObject,getElementData(source,takeObject) - 1)

	dbExec(dbConnection,"INSERT INTO objekte (Model,Positionx,Positiony,Positionz,Rotation,Besitzer,Interior,Dimension) VALUES ('"..id.."','"..x.."','"..y.."','"..z.."','"..rz.."','"..getPlayerName(source).."','"..interior.."','"..dimension.."')")
end)

addEvent('buyObject',true)
addEventHandler('buyObject',root,function(object,price)
	local buyObject = 'Objekt'..object
	takePlayerMoney(source,price)
	setElementData(source,buyObject,getElementData(source,buyObject) + 1)
	updateEventkasse("einzahlen",price)
	getChatBox(source,32)
end)

function createnewobject(id)
	if(getElementData(source,"Objekt"..id)>=1)then
		triggerClientEvent(source,'createobject',source,id)
	end
end
addEvent('createnewobject',true)
addEventHandler('createnewobject',root,createnewobject)