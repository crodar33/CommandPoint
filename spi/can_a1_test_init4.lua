print("Init can")
print("start SPI init")
spi.setup(1, spi.MASTER, spi.CPOL_LOW, spi.CPHA_LOW, 8, 8, spi.FULLDUPLEX)
--reset
dofile("can_reset.lc")
print("reset")
local canBuss = require "can_module"
--setConfigMode() 
canBuss.setMode(0x80)
print("config mode")

--set speed 500kbs
canBuss.setRegister(0x2A, 0x00)
canBuss.setRegister(0x29, 0x90)
canBuss.setRegister(0x28, 0x02)

--set speed 250kbs
--canBuss.setRegister(0x2A, 0x00)
--canBuss.setRegister(0x29, 0xB1)
--canBuss.setRegister(0x28, 0x05)

--set speed 100kbs
--canBuss.setRegister(0x2A, 0x01)
--canBuss.setRegister(0x29, 0xB4)
--canBuss.setRegister(0x28, 0x86)

print("set up speed")
--set One Shot Mode
canBuss.modifyRegister(0x0F, 0x10, 0x00)
canBuss.modifyRegister(0x0F, 0x08, 0x08)
--setNormalMode() 
canBuss.setMode(0x00)
print("normal mode")
print("can module initiated")

package.loaded.can_module = nil