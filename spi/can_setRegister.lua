return function(register, value) 
    spi.set_mosi(1, 0, 8, value)
    spi.transaction(1, 8, 0x02, 8, register, 8, 0, 0)
end
