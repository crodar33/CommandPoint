--Frame 2 SOC, SOH
local SOC = struct.unpack("<h", struct.pack("H", battery.SOC))
local SOH = struct.unpack("<h", struct.pack("H", battery.SOH))
if inverterCmdMod==3 then
    chargeA = 50
    SOC = 90
end
sendStatus, sendFlag = dofile("can_sendCanMessage.lc")(0x0355, {
    struct.pack("<H", SOC), --SOC
    struct.pack("<H", SOH), --SOH
    struct.pack("<H", 0), 
    struct.pack("<H", 0)
})
