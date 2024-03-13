local M = {}

M.modifyRegister = function(reg, mask, data) 
    spi.set_mosi(1, 0, 8, mask, data)
    spi.transaction(1, 8, 0x05, 8, reg, 16, 0, 0)
end

M.readRegisters = function(register, len)
    spi.transaction(1, 8, 0x03, 8, register, 0, 0, 8 * len)
    return spi.get_miso(1, 0, 8, len)
end

M.getStatus = function() 
    spi.transaction(1, 8, 0xA0, 8, 0, 0, 0, 8)
    return spi.get_miso(1, 0, 8, 1)
end

--send only standart frame
--send data that have 4 word
M.sendCanMessage = function(canId, data) 
    local t, buferIndex, register, sendBufer, tmpData
    --select free bufer, bufer indexes 0x30 0x40 0x50
    for t, buferIndex in pairs({0x30, 0x40, 0x50}) do
        register = M.readRegisters(buferIndex, 1)
        if (bit.band(register, 0x08)==0x00) then
            sendBufer = {}
            sendBufer[1] = bit.rshift(canId, 3)
            sendBufer[2] = bit.lshift(bit.band(canId, 0x07), 5)
            sendBufer[3] = 0
            sendBufer[4] = 0
            sendBufer[5] = 8 --#data * 2
            for t, tmpData in pairs(data) do
                sendBufer[4 + t * 2] = struct.unpack("B", tmpData, 1)
                if (#tmpData == 1) then
                    sendBufer[5 + t * 2] = 0
                else
                    sendBufer[5 + t * 2] = struct.unpack("B", tmpData, 2)
                end
            end
            M.setRegisters(buferIndex + 1, sendBufer)
            M.modifyRegister(buferIndex, 0x08, 0x08)
            register = M.readRegisters(buferIndex, 1)
            local result = false
            --if (bit.band(register, 0x70)==0x00) then
            if (bit.band(register, 0x10)==0x00) then
                result = true
            end
            return result, register, sendBufer
        end
    end
    return false, 0, {}
end

M.setConfigMode = function() 
    return M.setMode(0x80)
end

M.setMode = function(newMode)
    local modeMask = 0xE0

    M.modifyRegister(0x0F, modeMask, newMode)
    resp = M.readRegisters(0x0E, 1)

    --print(string.format("%02x", resp), string.format("%02x", newMode))
    if ( bit.band(modeMask, resp) ~= newMode ) then
        print("Error set mode!!!", string.format("%02x", newMode), string.format("%02x", resp))
        return false
    end
    return true
end

M.setRegister = function(register, value) 
    spi.set_mosi(1, 0, 8, value)
    spi.transaction(1, 8, 0x02, 8, register, 8, 0, 0)
end

M.setRegisters = function(register, values) 
    spi.set_mosi(1, 0, 8, ROM.unpack(values))
    spi.transaction(1, 8, 0x02, 8, register, 8 * #values, 0, 0)
end

M.setNormalMode = function() 
    return M.setMode(0x00)
end

M.status2struct = function(s) 
    return {
        FLAG = s,
        RX0IF = (bit.band(s, 0x01) > 0),
        RX1IF = (bit.band(s, 0x02) > 0),
        TXB0TXREQ = (bit.band(s, 0x04) > 0),
        TX0IF = (bit.band(s, 0x08) > 0),
        TXB1TXREQ = (bit.band(s, 0x10) > 0),
        TX1IF = (bit.band(s, 0x20) > 0),
        TXB2TXREQ = (bit.band(s, 0x40) > 0),
        TX2IF = (bit.band(s, 0x80) > 0),
    }
end

M.status2string = function(s)
    return string.format("s: flag: %02x, RX0IF: %s, RX1IF: %s, TXB0TXREQ: %s, TX0IF: %s, TXB1TXREQ: %s, TX1IF: %s, TXB2TXREQ: %s, TX2IF: %s", 
        tostring(s.FLAG), 
        tostring(s.RX0IF), 
        tostring(s.RX1IF), 
        tostring(s.TXB0TXREQ), 
        tostring(s.TX0IF), 
        tostring(s.TXB1TXREQ), 
        tostring(s.TX1IF), 
        tostring(s.TXB2TXREQ), 
        tostring(s.TX2IF)
    )
end


return M
