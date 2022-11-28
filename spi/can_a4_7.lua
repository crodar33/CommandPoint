--Frame 7 remote command
--local cmdNormal = 0
--local cmdForcedCharging = 1
--local cmdForcedStandby = 2
if inverterCmdMod > 0 and inverterModTimer < tmr.time() then
    inverterCmdMod = 0
end
local inverterCmdModTmp = 0
if inverterCmdMod==3 then
    inverterCmdModTmp = 1 
else
    inverterCmdModTmp = inverterCmdModTmp 
end

if #battery.state > 0 then
    if bit.band(battery.state[3], 0x03)>0 and battery.SOC<100 then
        --cell imbalance, ask to charge
        inverterCmdModTmp = 1
        print("cell balance error, request to charge")
    end
end

sendStatus, sendFlag = dofile("can_sendCanMessage.lc")(0x030F, {
    struct.pack("<H", inverterCmdModTmp),
    struct.pack("<H", 0), 
    struct.pack("<H", 0), 
    struct.pack("<H", 0), 
})
