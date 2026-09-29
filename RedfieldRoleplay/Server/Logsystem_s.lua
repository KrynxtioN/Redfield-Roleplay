local logpath = 'redfieldlogs/'

function outputlog(text,logname)
	if(not(logname))then
		logname = 'allround'
	end
	logname = logname..'.log'
	local log = getlog(logpath..logname)
	local filesize = fileGetSize(log)
	fileSetPos(log,filesize)
	fileWrite(log,logtime()..': '..text..'\n')
	fileClose(log)
end
addEvent('outputlog',true)
addEventHandler('outputlog',root,outputlog)

function getlog(path)
	if(not(fileExists(path)))then
		fileClose(fileCreate(path))
	end
	return fileOpen(path,false)
end

function logtime()
	local logtime = getRealTime()
	local year = tostring(logtime.year+1900)
	local month = tostring(logtime.month+1)
	local day = tostring(logtime.monthday)
	local hour = tostring(logtime.hour)
	local minute = tostring(logtime.minute)
	local second = tostring(logtime.second+1)
	if(#month == 1)then month = '0'..month end
	if(#day == 1)then day = '0'..day end
	if(#hour == 1)then hour = '0'..hour end
	if(#minute == 1)then minute = '0'..minute end
	if(#second == 1)then second = '0'..second end
	return '('..day..'.'..month..'.'..year..' '..hour..':'..minute..':'..second..')'
end