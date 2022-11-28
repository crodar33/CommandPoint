return function(battery, sUart, RW_pin)

    local callback = function(data)
        if not chechCRC(data) then
            print("bad CRC 0x98")
            print("Response: ", dataToString(data)) 
            return
        end
        if (struct.unpack("B", data, 2)~=battery.address) then
            return
        end
        battery.last_update = tmr.time()
        --print("Got state: ", dataToString(data)) 
        battery.state[0] = struct.unpack("b", data, 5+0)
        battery.state[1] = struct.unpack("b", data, 5+1)
        battery.state[2] = struct.unpack("b", data, 5+2)
        battery.state[3] = struct.unpack("b", data, 5+3)
        battery.state[4] = struct.unpack("b", data, 5+4)
        battery.state[5] = struct.unpack("b", data, 5+5)
        battery.state[6] = struct.unpack("b", data, 5+6)
        battery.state[7] = struct.unpack("b", data, 5+7)
    end
  
    print("request state")
    --request new data
    local sendData = struct.pack(">BBBBBBBBBBBBB", 0xA5, 0x40, 0x98, 0x08, 0, 0, 0, 0, 0, 0, 0, 0, 0x85)    
    --set callback on what we waiting
    --print("Requested: ", dataToString(sendData))
    sUart:on("data", 13, callback)
    --send data
    gpio.write(RW_pin, gpio.HIGH)
    sUart:write(sendData)
    gpio.write(RW_pin, gpio.LOW)

end
