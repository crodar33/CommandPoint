spi.setup(1, spi.MASTER, spi.CPOL_HIGH, spi.CPHA_HIGH, 8, 8, spi.FULLDUPLEX)

print(spi.send(1, 0xC0))
print(spi.send(1, 0x05, 0x0F, 0xE0, 0x80))
print(spi.send(1, 0x03, 0x08, 0, 0))