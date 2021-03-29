--Frame 7 remote command
--local cmdNormal = 0
--local cmdForcedCharging = 1
--local cmdForcedStandby = 2
if inverterCmdMod > 0 and inverterModTimer < tmr.time() then
    inverterCmdMod = 0
end
sendStatus, sendFlag = dofile("can_sendCanMessage.lc")(0x030F, {
    struct.pack("<H", inverterCmdMod),
    struct.pack("<H", 0), 
    struct.pack("<H", 0), 
    struct.pack("<H", 0), 
})
