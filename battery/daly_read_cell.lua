return function(battery, sUart, RW_pin)
    
    local callback = function(data)
        if not chechCRC(data) then
            print("bad CRC 0x95")
            print("Response: ", dataToString(data)) 
            return
        end
        if (struct.unpack("B", data, 2)~=battery.address) then
            return
        end
        battery.last_update = tmr.time()
        local frameIndex = (struct.unpack("b", data, 5) - 1) * 3
        for i=0, 2 do
            battery.cellVoltage[frameIndex] = struct.unpack(">H", data, 6+i*2) / 1000
            --print(frameIndex .. ": " .. battery.cellVoltage[frameIndex] )
            frameIndex = frameIndex + 1
        end
    end
  
    --request new data
    local sendData = struct.pack(">BBBBBBBBBBBBB", 0xA5, 0x40, 0x95, 0x08, 0, 0, 0, 0, 0, 0, 0, 0, 0x82)    
    --set callback on what we waiting
    --print("Requested: ", dataToString(sendData))
    sUart:on("data", 13, callback)
    --send data
    gpio.write(RW_pin, gpio.HIGH)
    sUart:write(sendData)
    gpio.write(RW_pin, gpio.LOW)

end
