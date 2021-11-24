--[[ calculate crc16_arc_calc]]
function crc16(s)
    if (s == nil or #s < 4) then
        return false
    end
    local crc = 0xFFFF
    for i = 1, #s do
        local c = s:byte(i)
        crc = bit.bxor(crc, c)
        for j = 1, 8 do
            local k = bit.band(crc, 1)
            crc = bit.rshift(crc, 1)
            if k == 0x01 then
                crc = bit.bxor(crc, 0xA001)
            end
        end
    end
    return crc
end

return function(address, sUart, RW_pin)
    local invertor = {}

    invertor.address = address
    invertor.gridAVoltage = 0
    invertor.gridACurrent = 0
    invertor.gridBVoltage = 0
    invertor.gridBCurrent = 0
    invertor.gridCVoltage = 0
    invertor.gridCCurrent = 0

    invertor.batteryVoltage = 0
    invertor.batteryCurrent = 0
    invertor.batteryCapacity = 0
    invertor.batteryTemperature = 0

    invertor.feedPower = 0
    invertor.loadPower = 0
    invertor.IOPower = 0

    local timer = tmr.create()
    local readStep = 0
    invertor.callback = function(self)
        if readStep==0 then
            dofile("sofar_read_grid.lua")(invertor, sUart, RW_pin)
            readStep = -1
        end
        readStep = readStep + 1
    end
    timer:register(1900, tmr.ALARM_AUTO, invertor.callback)

    invertor.startPullData = function(self) 
        timer:start()
    end

    invertor.stopPullData = function(self) 
        timer:stop()
    end

    return invertor
end
