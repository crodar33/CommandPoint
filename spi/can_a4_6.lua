--frame 6 BMS version, Bat cap
local batCap = struct.unpack("<h", struct.pack("H", battery.remoteState.registers[5007])) / 10
sendStatus, sendFlag = dofile("can_sendCanMessage.lc")(0x035F, {
    struct.pack("<H", 0), 
    struct.pack("<H", 0x0001), 
    struct.pack("<H", batCap),
    struct.pack("<H", 0), 
})