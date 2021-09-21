return function(battery, sUart, RW_pin)

    local callback = function(data)
        battery.last_update = tmr.time()
        print("Response: ", dataToString(data)) 
        battery.state = struct.unpack("b", data, 5+0)
        battery.mos_charging = struct.unpack("b", data, 5+1)
        battery.mos_discharge = struct.unpack("b", data, 5+2)
        battery.life = struct.unpack("b", data, 5+3)
        battery.resiual_capacity = struct.unpack(">L", data, 5+4)
        battery.SOH = math.ceil(battery.resiual_capacity / battery.base_capacity * 100)
    end
  
    --request new data
    local sendData = struct.pack(">BBBBBBBBBBBBB", 0xA5, 0x40, 0x93, 0x08, 0, 0, 0, 0, 0, 0, 0, 0, 0x80)    
    --set callback on what we waiting
    print("Requested: ", dataToString(sendData))
    sUart:on("data", 13, callback)
    --send data
    gpio.write(RW_pin, gpio.HIGH)
    sUart:write(sendData)
    gpio.write(RW_pin, gpio.LOW)

end
