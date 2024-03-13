--Frame 4 Alarms, Warnings - not implemented
alarm1 = 0
alarm2 = 0
warn1 = 0
warn2 = 0
if battery.warnings > 0 then
    if bit.band(battery.warnings[0], 0x02)>0 then
        --temp high
        warn1 = bit.bor(warn1, 0x0040)
    end
    if bit.band(battery.warnings[1], 0x100)>0 then
        --temp low
        warn1 = bit.bor(warn1, 0x0100)
    end
    if bit.band(battery.warnings[3], 0x70)>0 then
        --cell imbalance
        warn2 = bit.bor(warn2, 0x0100)
    end

    if bit.band(battery.warnings[1], 0x80)>0 then
        --temp hight
        alarm1 = bit.bor(alarm1, 0x0040)
    end
    if bit.band(battery.warnings[1], 0x100)>0 then
        --temp low
        alarm1 = bit.bor(alarm2, 0x0100)
    end
end
local canBuss = require "can_module"
sendStatus, sendFlag = canBuss.sendCanMessage(0x035A, {
    struct.pack("<H", alarm1), 
    struct.pack("<H", alarm2), 
    struct.pack("<H", warn1), 
    struct.pack("<H", warn2)
})
package.loaded.can_module = nil
