-- impelemntation for work with RS485

return function(readLen, RW_pin, RX_pin, TX_pin, baund)
    
    local rs = {}
    rs.sUart = nil
    rs.registers = {}
    rs.readLen = readLen
    rs.rFrom = 0
    rs.lastUpdate = 0

    rs.readRegisters = function(self, addr, funct, from, count, clearRead) 
        rs.rFrom = from
        -- clear old data
        local i
        if clearRead then
            for i = from, (from + count) do
                rs.registers[1 + i] = "-"
            end
        end
        --request new data
        local sendData = struct.pack(">BBHH", addr, funct, from, count)    
        local crc = dofile("crc16_arc_calc.lua")(sendData)
        gpio.write(RW_pin, gpio.HIGH)
        rs.sUart:write(sendData .. struct.pack("<H", crc))
        gpio.write(RW_pin, gpio.LOW)
        --set callback on what we waiting
        --print("Requested ", addr, funct, from, count)
        rs.sUart:on("data", 3 + count * 2 + 2, function(data) dofile("RS485_RegistersCallback.lc")(rs, data) end)
    end
    
    local i
    for i = 0, readLen do
        rs.registers[1 + i] = "-"
    end

    rs.sUart = softuart.setup(baund or 9600, TX_pin, RX_pin)
    gpio.mode(RW_pin, gpio.OUTPUT)
    return rs
end
