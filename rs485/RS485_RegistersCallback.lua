return function(rs, data)
    print("get data len " .. #data)
    if #data < 3 then
        print("respnse to short")
        return nil
    end
    local addr = struct.unpack(">B", data, 1)
    local funct = struct.unpack(">B", data, 2)
    local count = struct.unpack(">B", data, 3) / 2 
    print("Registers response: addres - " .. addr .. " funct - " .. funct .. " count - " .. count)   
    if  not (funct == 3) then
        print("respnse is not registers " .. funct)
        return nil
    end
    if #data < (3 + count + 2) then
        print("respnse len less then data count " .. count)
        return nil
    end
    local messageBody = data:sub(1, count * 2 + 3)
    local dataCrc16 = dofile("crc16_arc_calc.lc")(messageBody)
    local messageCrc16 = struct.unpack("<H", data, 4 + count * 2)
    if dataCrc16 ~= messageCrc16 then
        print("bad crc " .. string.format("%04X", dataCrc16) 
          .. " must be " 
          .. string.format("%04X", messageCrc16))
        local buf = ""
        for i = 1, #data do
            buf = buf .. string.format(" %02X", struct.unpack("B", data, i))
        end
        print("Message: " .. buf)
        return nil
    end
    rs.lastUpdate = tmr.time()
    local i
    for i = 0, count do
        rs.registers[1 + i + rs.rFrom] = struct.unpack(">H", data, 4 + i * 2)
        --print("Register " .. (1+i+ rs.rFrom) .. ": ".. struct.unpack(">H", data, 4 + i * 2))
        --rs.registers[1 + i + rs.rFrom] = string.sub(data, 3 + i * 2, 2)
    end
end
