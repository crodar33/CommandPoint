local toStruct = function(status) 
    return {
        FLAG = status,
        priority = bit.band(status, 0x03),
        TXREQ = (bit.band(status, 0x08) > 0),
        TXERR = (bit.band(status, 0x10) > 0),
        MLOA = (bit.band(status, 0x20) > 0),
        ABTF = (bit.band(status, 0x40) > 0)
    }
end

local toString = function(ctrlStruct)
    return string.format("status: flag: %02x, priority: %d, TXREQ: %s, TXERR: %s, MLOA: %s, ABTF: %s", 
        tostring(ctrlStruct.FLAG), 
        tostring(ctrlStruct.priority), 
        tostring(ctrlStruct.TXREQ), 
        tostring(ctrlStruct.TXERR), 
        tostring(ctrlStruct.MLOA), 
        tostring(ctrlStruct.ABTF)
    )
end

return {
    toStruct = toStruct,
    toString = toString
}