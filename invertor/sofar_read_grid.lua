return function(invertor, sUart, RW_pin)

    local callback = function(data)
        if (s == nil or #s < 4) then
            return false
        end
        local addr = struct.unpack(">B", data, 1)
        local funct = struct.unpack(">B", data, 2)
        local count = struct.unpack(">B", data, 3) / 2 
        print("Invertor responce " .. #data)
        print("Response: ", dataToString(data)) 
        if addr~=invertor.address then
            return
        end
        if #data < (3 + count + 2) then
            print("Bad lenght " .. count)
            return
        end
        if (struct.unpack("b", data, 2)~=battery.address) then
            return
        end
        local messageBody = data:sub(1, 3 + count * 2)
        local dataCrc16 = crc16(messageBody)
        local messageCrc16 = struct.unpack("<H", data, 4 + count * 2)
        
        if dataCrc16~=messageCrc16 then
            print("bad CRC sofar_read_grid")
            print("Response: ", dataToString(data)) 
            return
        end

        invertor.gridAVoltage = struct.unpack("H", messageBody, 0)
        invertor.gridACurrent = struct.unpack("H", messageBody, 2)
        invertor.gridBVoltage = struct.unpack("H", messageBody, 3)
        invertor.gridBCurrent = struct.unpack("H", messageBody, 4)
        invertor.gridCVoltage = struct.unpack("H", messageBody, 5)
        invertor.gridCCurrent = struct.unpack("H", messageBody, 6)
    end
  
    --request new data
    local sendData = struct.pack(">BBHH", invertor.address, 0x03, 0x0206, 0x06)   
    local crc = crc16(sendData)
    --set callback on what we waiting
    --print("Requested: ", dataToString(sendData))
    sUart:on("data", 5 + 0x06*2, callback)
    --send data
    gpio.write(RW_pin, gpio.HIGH)
    sUart:write(sendData .. struct.pack("<H", crc))
    gpio.write(RW_pin, gpio.LOW)
end
