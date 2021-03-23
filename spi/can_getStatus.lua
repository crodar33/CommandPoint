return function() 
    spi.transaction(1, 8, 0xA0, 8, 0, 0, 0, 8)
    return spi.get_miso(1, 0, 8, 1)
end