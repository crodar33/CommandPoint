--frame 6 BMS version, Bat cap
local batCap = battery.base_capacity/1000
local canBuss = require "can_module"
sendStatus, sendFlag = canBuss.sendCanMessage(0x035F, {
    struct.pack("<H", 0), 
    struct.pack("<H", 0x0001), 
    struct.pack("<H", batCap),
    struct.pack("<H", 0), 
})
package.loaded.can_module = nil
