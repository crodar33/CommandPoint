return function(battery, sUart, RW_pin)

    local callback = function(data)
        if not chechCRC(data) then
            print("bad CRC 0x94")
            print("Response: ", dataToString(data)) 
            return
        end
        battery.last_update = tmr.time()
        battery.string = struct.unpack("b", data, 5+0)
        battery.temp2 = struct.unpack("b", data, 5+1)
        battery.cicles = struct.unpack(">H", data, 5+5)
        --print("R: string " .. battery.string .. ", temp2 " .. battery.temp2 .. ", cicles " .. battery.cicles )
    end
  
    --request new data
    local sendData = struct.pack(">BBBBBBBBBBBBB", 0xA5, 0x40, 0x94, 0x08, 0, 0, 0, 0, 0, 0, 0, 0, 0x81)    
    --set callback on what we waiting
    --print("Requested: ", dataToString(sendData))
    sUart:on("data", 13, callback)
    --send data
    gpio.write(RW_pin, gpio.HIGH)
    sUart:write(sendData)
    gpio.write(RW_pin, gpio.LOW)

end
