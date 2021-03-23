local toStruct = function(status) 
    return {
        FLAG = status,
        RX0IF = (bit.band(status, 0x01) > 0),
        RX1IF = (bit.band(status, 0x02) > 0),
        TXB0TXREQ = (bit.band(status, 0x04) > 0),
        TX0IF = (bit.band(status, 0x08) > 0),
        TXB1TXREQ = (bit.band(status, 0x10) > 0),
        TX1IF = (bit.band(status, 0x20) > 0),
        TXB2TXREQ = (bit.band(status, 0x40) > 0),
        TX2IF = (bit.band(status, 0x80) > 0),
    }
end

local toString = function(statusStruct)
    return string.format("status: flag: %02x, RX0IF: %s, RX1IF: %s, TXB0TXREQ: %s, TX0IF: %s, TXB1TXREQ: %s, TX1IF: %s, TXB2TXREQ: %s, TX2IF: %s", 
        tostring(statusStruct.FLAG), 
        tostring(statusStruct.RX0IF), 
        tostring(statusStruct.RX1IF), 
        tostring(statusStruct.TXB0TXREQ), 
        tostring(statusStruct.TX0IF), 
        tostring(statusStruct.TXB1TXREQ), 
        tostring(statusStruct.TX1IF), 
        tostring(statusStruct.TXB2TXREQ), 
        tostring(statusStruct.TX2IF)
    )
end

return {
    toStruct = toStruct,
    toString = toString
}