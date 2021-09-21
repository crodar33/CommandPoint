return function(battery, sUart, RW_pin)
    
    local callback = function(data)
        battery.last_update = tmr.time()
        print("Response: ", dataToString(data)) 
        local frameIndex = (struct.unpack("b", data, 5) - 1) * 7
        for i=0, 7 do
            local t = struct.unpack("b", data, 5+i) - 40
            if t>0 then
                battery.temp[frameIndex] = t
                print(frameIndex .. ": " .. battery.temp[frameIndex] )
            end
            frameIndex = frameIndex + 1
        end
    end
  
    --request new data
    local sendData = struct.pack(">BBBBBBBBBBBBB", 0xA5, 0x40, 0x96, 0x08, 0, 0, 0, 0, 0, 0, 0, 0, 0x83)    
    --set callback on what we waiting
    print("Requested: ", dataToString(sendData))
    sUart:on("data", 13, callback)
    --send data
    gpio.write(RW_pin, gpio.HIGH)
    sUart:write(sendData)
    gpio.write(RW_pin, gpio.LOW)

end
