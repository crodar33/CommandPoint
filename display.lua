--TM1637
--https://puntoflotante.net/DATASHEET-TM1637.pdf
digsMap = {}
digsMap["nil"] = 0x00
digsMap[0] = 0xFC
digsMap[1] = 0x0C
digsMap[2] = 0xDA
digsMap[3] = 0x9E
digsMap[4] = 0x2E
digsMap[5] = 0xB6
digsMap[6] = 0xF6
digsMap[7] = 0x1C
digsMap[8] = 0xFE
digsMap[9] = 0xBE
digsMap["-"] = 0x02
digsMap["H"] = 0x6E
digsMap["U"] = 0xEC
digsMap["A"] = 0x7E
digsMap["C"] = 0xF0

i2c.setup(0, 12, 0, i2c.SLOW)

--init
i2c.start(0)
i2c.write(0, 0x02)
i2c.stop(0)
--display epty value
i2c.start(0)
i2c.write(0, 0x03, digsMap["-"], digsMap["-"], digsMap["-"], digsMap["-"])
i2c.stop(0)

--display on and brightnes
i2c.start(0)
--i2c.write(0, 0x51)
i2c.write(0, 0x01)
i2c.stop(0)

local step = 0
local timer = tmr.create()
timer:register(3000, tmr.ALARM_AUTO, function() 
    step = step + 1
    local d1, d2, d3, d4, tmp
    if step == 0 then
        tmp = math.floor(battery.voltage * 10)
        d4 = "U"
    elseif step == 1 then
        tmp = math.floor(battery.SOC * 10)
        d4 = "C"
    else
        tmp = math.floor(battery.current * 10)
        d4 = "A"
        step = -1
    end

    tmp = math.abs(tmp)
    d1 = math.floor(tmp/100) % 10
    d2 = math.floor(tmp/10) % 10
    d3 = tmp % 10

    i2c.start(0)
    i2c.write(0, 0x03, 
        digsMap[d4],
        digsMap[d3],
        digsMap[d2],
        digsMap[d1]
    )
    i2c.stop(0)
end)
timer:start()
