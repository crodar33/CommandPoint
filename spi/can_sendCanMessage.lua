--send only standart frame
--send data that have 4 word
return function(canId, data) 
    local t, buferIndex, register, sendBufer, tmpData
    --select free bufer, bufer indexes 0x30 0x40 0x50
    for t, buferIndex in pairs({0x30, 0x40, 0x50}) do
        register = dofile("can_readRegisters.lc")(buferIndex, 1)
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
            dofile("can_setRegisters.lc")(buferIndex + 1, sendBufer)
            dofile("can_modifyRegister.lc")(buferIndex, 0x08, 0x08)
            register = dofile("can_readRegisters.lc")(buferIndex, 1)
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
