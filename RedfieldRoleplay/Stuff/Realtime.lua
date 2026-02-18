function realTime()
    local realtime = getRealTime()
 
    setTime(realtime.hour,realtime.minute)
    setMinuteDuration(60000)
end
addEventHandler('onResourceStart',getResourceRootElement(getThisResource()),realTime)