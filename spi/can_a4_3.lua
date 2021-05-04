--frame 3, Battery voltage, Battery current, Battery Temperature, Cycles
local batV = struct.unpack("<h", struct.pack("H", battery.remoteState.registers[4]))
local batA = struct.unpack("<h", struct.pack("H", battery.remoteState.registers[5]))
local batC = struct.unpack("<h", struct.pack("H", battery.remoteState.registers[8]))

--batA = 10
--batC = 100
sendStatus, sendFlag = dofile("can_sendCanMessage.lc")(0x0356, {
    struct.pack("<h", batV), --batt V
    struct.pack("<h", batA), --batt A
    struct.pack("<h", batTemp), --batt T
    struct.pack("<H", batC) -- batt Cicles
})
