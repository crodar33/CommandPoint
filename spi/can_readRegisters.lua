return function(register, len)
    spi.transaction(1, 8, 0x03, 8, register, 0, 0, 8 * len)
    return spi.get_miso(1, 0, 8, len)
end
