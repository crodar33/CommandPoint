-- HTTP router
return function(httpServer, sck, headers)
    if headers.url == '/' then
        httpServer.sendHeader(sck, dofile("http_headers.lc")['200cachecompesed'])
        local help = dofile("http_responses.lc")
        help.sendFile(sck, "main.html.gz")
        help = nil
    elseif headers.url == '/favicon.png' then
        httpServer.sendHeader(sck, dofile("http_headers.lc")['200image'])
        local help = dofile("http_responses.lc")
        help.sendFile(sck, "favicon.png")
        help = nil
    elseif headers.url == '/favicon.ico' then
        httpServer.sendHeader(sck, dofile("http_headers.lc")['200image'])
        local help = dofile("http_responses.lc")
        help.sendFile(sck, "favicon.png")
        help = nil
    elseif headers.url == '/inverter_full_data' then
        httpServer.sendHeader(sck, dofile("http_headers.lc")['200binary'])
        sck:send(struct.pack(">f>f>f>f>f>f>f>f>f>f>H>H>H>H", 
            tmr.time(), 
            battery.SOC, 
            battery.voltage, 
            battery.current,
            battery.cicled_capacity,
            battery.temp[0],
            battery.temp[1],
            battery.temp[2],
            battery.cicles,
            battery.last_update,
            battery.warnings,
            battery.messages,
            battery.status,
            battery.cellCount)
        )
        sck:send(struct.pack(">f>f>f>f>f>f>f>f>f>f>f>f>f>f>f>f",
            battery.cellVoltage[0],
            battery.cellVoltage[1],
            battery.cellVoltage[2],
            battery.cellVoltage[3],
            battery.cellVoltage[4],
            battery.cellVoltage[5],
            battery.cellVoltage[6],
            battery.cellVoltage[7],
            battery.cellVoltage[8],
            battery.cellVoltage[9],
            battery.cellVoltage[10],
            battery.cellVoltage[11],
            battery.cellVoltage[12],
            battery.cellVoltage[13],
            battery.cellVoltage[14],
            battery.cellVoltage[15])
        )
    elseif headers.url=='/battery-stop-pull' then
        battery:stopPullData()
        httpServer.sendHeader(sck, dofile("http_headers.lc")[301])
    elseif headers.url=='/battery-start-pull' then
        battery:startPullData()
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
        --[[print(headers.post)
        print("post: ")
        for i,j in pairs(headers.post) do
            print(" ", i, j, #i)
        end]]
        if (headers.post~=nil and headers.post.state~=nil and headers.post.time~=nil) then
            --set forc battery mode
            inverterCmdMod = tonumber(headers.post.state)
            inverterModTimer = tmr.time() + tonumber(headers.post.time) * 60
            print("Set new battery mod " .. inverterCmdMod .." on time " .. (inverterModTimer - tmr.time()))
        end
        httpServer.sendHeader(sck, dofile("http_headers.lc")[301])
    else
        httpServer.sendHeader(sck, dofile("http_headers.lc")[404])
    end
end
