return function(reg, mask, data) 
    spi.set_mosi(1, 0, 8, mask, data)
    spi.transaction(1, 8, 0x05, 8, reg, 16, 0, 0)
end
