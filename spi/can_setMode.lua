return function(newMode)
    local modeMask = 0xE0

    dofile("can_modifyRegister.lc")(0x0F, modeMask, newMode)
    resp = dofile("can_readRegisters.lc")(0x0E, 1)

    --print(string.format("%02x", resp), string.format("%02x", newMode))
    if ( bit.band(modeMask, resp) ~= newMode ) then
        print("Error set mode!!!", string.format("%02x", newMode), string.format("%02x", resp))
        return false
    end
    return true
end
