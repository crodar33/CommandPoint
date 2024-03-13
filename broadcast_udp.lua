--send to udp broadcast information about state
if (wifi.sta.getip()) then
    
    local socket = net.createUDPSocket()
    print("broadcast to " .. wifi.sta.getbroadcast())
    socket:send(7798, wifi.sta.getbroadcast(), "cm:" .. struct.pack("fffff", 0, 0, 0, battery.current, battery.SOC))
    socket:close()

end