digsMap = {}
digsMap["nil"] = 0x00
digsMap[0] = 0xFC
digsMap[1] = 0x60
digsMap[2] = 0xDA
digsMap[3] = 0xF2
digsMap[4] = 0x66
digsMap[5] = 0xB6
digsMap[6] = 0xBE
digsMap[7] = 0xE0
digsMap[8] = 0xFE
digsMap[9] = 0xF6
digsMap["-"] = 0x40
digsMap["H"] = 0x6E

i2c.setup(0, 0, 12, i2c.SLOW)

i2c.start(0)
i2c.write(0, 0x02)
i2c.stop(0)
i2c.start(0)
i2c.write(0, 0x03, digsMap["-"], digsMap["-"], digsMap["-"], digsMap["-"])
i2c.stop(0)
i2c.start(0)
i2c.write(0, 0x51)
i2c.stop(0)

showTemp = true

function updateValue() 
    status, temp, humi = dht.read11(2)
    if status ~= dht.OK then
        print("dht error " .. status)
        return
    end
    if showTemp then
        print("show temp " .. temp)
        showValue = temp*10
        d4 = 'nil'
    else
        print("humi " .. humi)
        showValue = humi
        d4 = 'H'
    end


    
    d3 = math.floor(showValue/100)%10
    d2 = math.floor(showValue/10)%10
    d1 = showValue%10

    i2c.start(0)
    i2c.write(0, 0x03, 
        digsMap[d4],
        digsMap[d3],
        digsMap[d2],
        digsMap[d1]
    )
    i2c.stop(0)

    showTemp = not showTemp 
end

--local mytimer = tmr.create()
--mytimer:register(1000, tmr.ALARM_AUTO, updateValue)
--mytimer:start()
