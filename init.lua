print("===========================================")
print("STARTING")
print("===========================================")
wifi.setmode(wifi.STATION)
local station_cfg= require("wifi_config")
wifi.sta.config(station_cfg)

function dataToString(data)
    local result = ''
    for i=1, #data do
        local val = struct.unpack(">B", data, i)
        result = result .. " 0X" .. string.format("%02X", val)
    end
    return result
end
 
--[[
ntpTime = 0
local wifiGotIpEvent = function(T)
    print("My IP: " .. T.IP)
    --watch for time
    timerNtp = tmr.create()
    timerNtp:register(10000, tmr.ALARM_AUTO, function()
        sntp.sync('192.168.42.1', 
            function(sec, usec, server, info) 
                print("ntp time " .. sec) 
                ntpTime = sec
            end,
            function()
                ntpTime = ntpTime + 10
            end
        )
    end)
    timerNtp:start()
end
]]
local wifiConnectEvent = function(T)
    print("Connection to AP("..T.SSID..") established!")
    print("Waiting for IP address...")
    if disconnect_ct ~= nil then disconnect_ct = nil end
end
wifiDisconnectEvent = function(T)
    if T.reason == wifi.eventmon.reason.ASSOC_LEAVE then
        --the station has disassociated from a previously connected AP
        return
    end
    -- total_tries: how many times the station will attempt to connect to the AP. Should consider AP reboot duration.
    local total_tries = 75
    print("\nWiFi connection to AP("..T.SSID..") has failed!")

    --There are many possible disconnect reasons, the following iterates through
    --the list and returns the string corresponding to the disconnect reason.
    for key,val in pairs(wifi.eventmon.reason) do
        if val == T.reason then
            print("Disconnect reason: "..val.."("..key..")")
            node.restart() 
            break
        end
    end

    if disconnect_ct == nil then
        disconnect_ct = 1
    else
        disconnect_ct = disconnect_ct + 1
    end
    if disconnect_ct < total_tries then
        print("Retrying connection...(attempt "..(disconnect_ct+1).." of "..total_tries..")")
    else
        wifi.sta.disconnect()
        print("Aborting connection to AP!")
        disconnect_ct = nil
        node.restart() 
    end
end
-- Register WiFi Station event callbacks
wifi.eventmon.register(wifi.eventmon.STA_CONNECTED, wifiConnectEvent)
wifi.eventmon.register(wifi.eventmon.STA_GOT_IP, wifiGotIpEvent)
wifi.eventmon.register(wifi.eventmon.STA_DISCONNECTED, wifiDisconnectEvent)

httpMuted = 0
battery = dofile("battery.lc")()
battery:startPullData();
--pull battery state
local timer2 = tmr.create()
timer2:register(2000, tmr.ALARM_SINGLE, function() if httpMuted==0 then print("started pull battery data") battery:startPullData() end end)
timer2:start()
--normal Mod
canStates = 1
inverterCmdMod = 0
inverterModTimer = 0
batTemp = 0
httpServer = dofile("http_server_core.lc")()
dofile("can_a1_test_init4.lua")
local timer3 = tmr.create()
timer3:register(600, tmr.ALARM_AUTO, function() if httpMuted==0 then dofile("can_a3_inform_invertor.lua") end end)
timer3:start()
dofile("display.lua")
print("===========================================")
print("STARTED")
print("===========================================")