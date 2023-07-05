--Frame 4 Alarms, Warnings - not implemented
alarm1 = 0
alarm2 = 0
warn1 = 0
warn2 = 0
if #battery.state > 0 then
    if bit.band(battery.state[0], 0x11)>0 then
        --temp high
        warn1 = bit.bor(warn1, 0x0040)
    end
    if bit.band(battery.state[1], 0x44)>0 then
        --temp low
        warn1 = bit.bor(warn1, 0x0100)
    end
    if bit.band(battery.state[3], 0x01)>0 then
        --cell imbalance
        warn2 = bit.bor(warn2, 0x0100)
    end

    if bit.band(battery.state[1], 0x22)>0 then
        --temp hiht
        alarm1 = bit.bor(alarm1, 0x0040)
    end
    if bit.band(battery.state[1], 0x88)>0 then
        --temp low
        alarm1 = bit.bor(alarm2, 0x0100)
    end
    if bit.band(battery.state[3], 0x02)>0 then
        --cell imbalance
        alarm2 = bit.bor(alarm2, 0x0100)
    end
end
sendStatus, sendFlag = dofile("can_sendCanMessage.lc")(0x035A, {
    struct.pack("<H", alarm1), 
    struct.pack("<H", alarm2), 
    struct.pack("<H", warn1), 
    struct.pack("<H", warn2)
})

