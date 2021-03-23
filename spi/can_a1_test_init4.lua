print("Init can")
print("start SPI init")
spi.setup(1, spi.MASTER, spi.CPOL_LOW, spi.CPHA_LOW, 8, 8, spi.FULLDUPLEX)
--reset
dofile("can_reset.lc")
print("reset")
--setConfigMode() 
dofile("can_setMode.lc")(0x80)
print("config mode")

--set speed 500kbs
dofile("can_setRegister.lc")(0x2A, 0x00)
dofile("can_setRegister.lc")(0x29, 0x90)
dofile("can_setRegister.lc")(0x28, 0x02)

--set speed 100kbs
--dofile("can_setRegister.lc")(0x2A, 0x01)
--dofile("can_setRegister.lc")(0x29, 0xB4)
--dofile("can_setRegister.lc")(0x28, 0x86)

print("set up speed")
--set One Shot Mode
dofile("can_modifyRegister.lc")(0x0F, 0x10, 0x00)
dofile("can_modifyRegister.lc")(0x0F, 0x08, 0x08)
--setNormalMode() 
dofile("can_setMode.lc")(0x00)
print("normal mode")
print("can module initiated")