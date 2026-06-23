--Frame 4 Alarms, Warnings - not implemented
local alarm1 = 0
local alarm2 = 0
local warn1 = 0
local warn2 = 0

if batTemp>400 then
    --temp high
    warn1 = bit.bor(warn1, 0x0040)
end
if batTemp<100 then
    --temp low
    warn1 = bit.bor(warn1, 0x0100)
end

--if bit.band(battery.warnings[3], 0x70)>0 then
--    --cell imbalance
--    warn2 = bit.bor(warn2, 0x0100)
--end

if batTemp>500 then
    --temp hight
    alarm1 = bit.bor(alarm1, 0x0040)
end
if batTemp<0 then
    --temp low
    alarm1 = bit.bor(alarm2, 0x0100)
end

local canBuss = require "can_module"
sendStatus, sendFlag = canBuss.sendCanMessage(0x035A, {
    struct.pack("<H", alarm1), 
    struct.pack("<H", alarm2), 
    struct.pack("<H", warn1), 
    struct.pack("<H", warn2)
})
package.loaded.can_module = nil
