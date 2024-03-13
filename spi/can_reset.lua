--reset cmd
--spi.send(1, 0xC0)
spi.transaction(1, 8, 0xC0, 0, 0, 0, 0, 0)
--clean send buffer
local canBuss = require "can_module"
canBuss.setRegisters(0x30, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0})
canBuss.setRegisters(0x40, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0})
canBuss.setRegisters(0x50, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0})

canBuss.setRegister(0x60, 0)
canBuss.setRegister(0x70, 0)
--interrupt mode
canBuss.setRegister(0x2B, 0xA3)

--enable both receive-buffers
canBuss.modifyRegister(0x60, 0x67, 0x04)
canBuss.modifyRegister(0x70, 0x67, 0x01)
--Clear wake flag
canBuss.modifyRegister(0x2C, 0x40, 0x00)