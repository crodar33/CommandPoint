
local function httpCallback(httpServer, sck, headers)
    if headers.url=='/' then
        httpServer.sendHeader(sck, dofile("http_headers.lc")[200])
        local help = dofile("http_responses.lc")
        help.returnHeader(sck)
        help.returnState(sck)
        help.returnFooter(sck)
        help = nil
    elseif headers.url=='/battery-stop-pull' then
        battery:stopPullData()
        httpServer.sendHeader(sck, dofile("http_headers.lc")[301])
    elseif headers.url=='/battery-start-pull' then
        battery:startPullData()
        httpServer.sendHeader(sck, dofile("http_headers.lc")[301])
    elseif headers.url=='/update_battery' then
        if battery ~= nil then
          battery:readStaticData()        
        end              
        httpServer.sendHeader(sck, dofile("http_headers.lc")[301])
    elseif headers.url=='/state' then
        httpServer.sendHeader(sck, dofile("http_headers.lc")[200])
        local help = dofile("http_responses.lc")
        help.returnHeader(sck)
        help.returnFooter(sck)
        help = nil
    elseif headers.url=='/battery_raw' then
        httpServer.sendHeader(sck, dofile("http_headers.lc")[200])
        local help = dofile("http_responses.lc")
        local returnBetteryRaw = dofile("http_battery_raw.lc")
        help.returnHeader(sck)
        returnBetteryRaw(sck)
        help.returnFooter(sck)
        help = nil
        help2 = nil
    elseif headers.url=='/better-inverter-state' then
        httpServer.sendHeader(sck, dofile("http_headers.lc")[301])
    else
        httpServer.sendHeader(sck, dofile("http_headers.lc")[404])
    end
end

return dofile("http_server_core.lc")(httpCallback)
