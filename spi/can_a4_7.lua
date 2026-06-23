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
    local SOC = struct.unpack("<h", struct.pack("H", battery.SOC))
    if bit.band(battery.warnings, 0x20)>0 and SOC<90 then
        --cell imbalance, ask to charge
        inverterCmdMod = 1
        print("cell balance error, request to charge")
    end
end

if inverterCmdMod==20 then 
    inverterCmdModTmp = 2 
elseif inverterCmdMod > 0  and inverterCmdMod < 10 then
    -- 1-9 commands fro charge
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
