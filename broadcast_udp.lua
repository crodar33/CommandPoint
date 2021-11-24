--send to udp broadcast information about state
if (wifi.sta.getip()) then
    
    local socket = net.createUDPSocket()
    local v1 = 0
    local v2 = 0
    local v3 = 0
    local v4 = node.random(-60000, 60000) / 100
    print("broadcast to " .. wifi.sta.getbroadcast())
    socket:send(7798, wifi.sta.getbroadcast(), "cm:" .. struct.pack("fffff", 0, 0, 0, battery.current, battery.SOC))
    socket:close()

end