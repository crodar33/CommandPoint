--reset cmd
--spi.send(1, 0xC0)
spi.transaction(1, 8, 0xC0, 0, 0, 0, 0, 0)
--clean send buffer
local fn = dofile("can_setRegisters.lc")
fn(0x30, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0})
fn(0x40, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0})
fn(0x50, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0})

fn = dofile("can_setRegister.lc")
fn(0x60, 0)
fn(0x70, 0)
--interrupt mode
fn(0x2B, 0xA3)

--enable both receive-buffers
fn = dofile("can_modifyRegister.lc")
fn(0x60, 0x67, 0x04)
fn(0x70, 0x67, 0x01)
--Clear wake flag
fn(0x2C, 0x40, 0x00)

fn = nil