return function(battery, sUart, RW_pin)

    local callback = function(data)
        print("Response: ", dataToString(data)) 
        local u1 = struct.unpack(">H", data, 5+0) / 10
        local u2 = struct.unpack(">H", data, 5+2) / 10
        local curr = struct.unpack(">H", data, 5+4) / 10
        local soc = struct.unpack(">H", data, 5+6) / 10
        --print("R: u1 ".. u1 .. ", u2 ".. u2 .. ", curr ".. curr .. ", soc ".. soc )
        battery.SOC = soc
        if u1>0 then
            battery.voltage = u1
        elseif u2>0 then
            battery.voltage = u2
        else           
            battery.voltage = 0
        end
        battery.current = curr - 3000
        battery.SOC = soc
    end
  
    --request new data
    local sendData = struct.pack(">BBBBBBBBBBBBB", 0xA5, 0x40, 0x90, 0x08, 0, 0, 0, 0, 0, 0, 0, 0, 0x7D)    
    --set callback on what we waiting
    print("Requested: ", dataToString(sendData))
    sUart:on("data", 13, callback)
    --send data
    gpio.write(RW_pin, gpio.HIGH)
    sUart:write(sendData)
    gpio.write(RW_pin, gpio.LOW)

end
