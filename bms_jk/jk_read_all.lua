return function(battery, sUart, RW_pin)
    
    local bodyLen = 0

    local getTemp = function(v, old) 
        if v>140 then
            return old
        end
        if v>100 then
            return v - 140
        end
        return v
    end

    local getCurent = function(v)
        if bit.band(v, 0x8000) == 0 then
            v = -1 * bit.band(v, 0x7FFF)
        else
            v = bit.band(v, 0x7FFF)
        end
        return v / 100
    end

    local callbackBody = function(data)
        print("Got data: ", dataToString(data)) 
        if (struct.unpack("B", data, 12)~=0x79) then
            return
        end
        print("BMS responsed")
        battery.cellCount = struct.unpack("B", data, 13) / 3 -- cells count
        if (battery.cellCount>30) then
            return
        end
        local i = 0
        for i=0, battery.cellCount - 1 do
            local tmp = struct.unpack(">H", data, i*3 + 15) / 1000
            if tmp<5 then
                battery.cellVoltage[i + 1] = tmp
                --print(string.format("battary voltage %d %0.3f", i + 1, battery.cellVoltage[i + 1]))
            end
        end
        battery.temp[1] = getTemp(struct.unpack(">H", data, 63), battery.temp[1])
        battery.temp[2] = getTemp(struct.unpack(">H", data, 66), battery.temp[2])
        battery.temp[3] = getTemp(struct.unpack(">H", data, 69), battery.temp[3])
        --print(string.format("temp %0.3f, %0.3f, %0.3f", battery.temp[1], battery.temp[2], battery.temp[3]))
        local tmpVoltage = struct.unpack(">H", data, 72) / 100
        if tmpVoltage < 80 then
            battery.voltage = tmpVoltage
        end
        battery.current = getCurent(struct.unpack(">H", data, 75))
        local tmpSOC = struct.unpack("B", data, 78)
        if tmpSOC < 101 then
            battery.SOC = tmpSOC
        end
        print(string.format("Stat %0.3fV, %0.3fA, %d%%", battery.voltage, battery.current, battery.SOC))
        battery.cicles = struct.unpack(">H", data, 82) 
        battery.cicled_capacity = struct.unpack(">L", data, 85) 
        battery.warnings = struct.unpack(">H", data, 93) 
        battery.messages = struct.unpack(">H", data, 96) 
        battery.status = struct.unpack(">H", data, 99) 
        battery.mos_charging = bit.band(battery.status, 0x0001)>0
        battery.mos_discharge = bit.band(battery.status, 0x0002)>0
        battery.equalizing = bit.band(battery.status, 0x0004)>0
        battery.last_update = tmr.time()

        sUart:on("data", 1, function(data) end)
    end

    --request new data
    --local sendData = "\x4E\x57\x00\x13\x00\x00\x00\x00\x06\x03\x00\x00\x00\x00\x00\x00\x68\x00\x00\x01\x29"
    local sendData = struct.pack(">BBBBBBBBBBBBBBBBBBBBBB", 0x4E, 0x4E, 0x57, 0x00, 0x13, 0x00, 0x00, 0x00, 0x00, 0x06, 0x03, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x68, 0x00, 0x00, 0x01, 0x29)    
    --set callback on what we waiting
    --print("Requested: ", dataToString(sendData))
    print("Requested BMS")
    --sUart:on("data", 11, callbackHeader)
    sUart:on("data", 100, callbackBody)
    --send data
    gpio.write(RW_pin, gpio.HIGH)
    sUart:write(sendData)
    gpio.write(RW_pin, gpio.LOW)

end
