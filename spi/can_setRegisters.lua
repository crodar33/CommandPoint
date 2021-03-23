return function(register, values) 
    spi.set_mosi(1, 0, 8, ROM.unpack(values))
    spi.transaction(1, 8, 0x02, 8, register, 8 * #values, 0, 0)
end