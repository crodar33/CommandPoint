--frame 6 BMS version, Bat cap
local batCap = battery.base_capacity/1000
sendStatus, sendFlag = dofile("can_sendCanMessage.lc")(0x035F, {
    struct.pack("<H", 0), 
    struct.pack("<H", 0x0001), 
    struct.pack("<H", batCap),
    struct.pack("<H", 0), 
})