--Frame 2 SOC, SOH
local SOC = struct.unpack("<h", struct.pack("H", battery.SOC))
local SOH = struct.unpack("<h", struct.pack("H", battery.SOH))
if inverterCmdMod==3 then
    SOC = 90
elseif inverterCmdMod==4 and SOC>95 then
    SOC = 95
end
local canBuss = require "can_module"
sendStatus, sendFlag = canBuss.sendCanMessage(0x0355, {
    struct.pack("<H", SOC), --SOC
    struct.pack("<H", SOH), --SOH
    struct.pack("<H", 0), 
    struct.pack("<H", 0)
})
package.loaded.can_module = nil
