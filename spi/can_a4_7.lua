--Frame 7 remote command
--local cmdNormal = 0
--local cmdForcedCharging = 1
--local cmdForcedStandby = 2
if inverterCmdMod > 0 and inverterModTimer < tmr.time() then
    inverterCmdMod = 0
    inverterModTimer = 0
end
local inverterCmdModTmp = 0

if battery.warnings > 0 then
    if bit.band(battery.warnings, 0x20)>0 and battery.SOC<100 then
        --cell imbalance, ask to charge
        inverterCmdMod = 1
        print("cell balance error, request to charge")
    end
end

if inverterCmdMod==2 then 
    inverterCmdModTmp = 2 
elseif inverterCmdMod > 0 then
    inverterCmdModTmp = 1 
end

local canBuss = require "can_module"
--print("Battery command ", inverterCmdModTmp)
sendStatus, sendFlag = canBuss.sendCanMessage(0x030F, {
    struct.pack("<H", inverterCmdModTmp),
    struct.pack("<H", 0), 
    struct.pack("<H", 0), 
    struct.pack("<H", 0), 
})
package.loaded.can_module = nil
