--[[ calculate crc16_arc_calc]]
local function fn(s)
    assert(type(s) == 'string')
    local crc = 0xFFFF
    for i = 1, #s do
        local c = s:byte(i)
        crc = bit.bxor(crc, c)
        for j = 1, 8 do
            local k = bit.band(crc, 1)
            crc = bit.rshift(crc, 1)
            if k == 0x01 then
                crc = bit.bxor(crc, 0xA001)
            end
        end
    end
    return crc
end
return fn
