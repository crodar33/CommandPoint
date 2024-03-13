--frame 5 Manufacture-Name-ASCII
local canBuss = require "can_module"
sendStatus, sendFlag = canBuss.sendCanMessage(0x035E, {
    struct.pack("c2", '-J'),
    struct.pack("c2", 'K '),
    struct.pack("c2", 'BM'),
    struct.pack("c0", 'S-')
})
package.loaded.can_module = nil
