function chechCRC(data) 
    if (data == nil or #data ~= 13) then
        return false
    end
    sum = 0
    for i=1, 12 do
        sum = sum + struct.unpack("B", data, i) 
    end
    --print(bit.band(sum, 0xFF), struct.unpack("B", data, 13))
    return bit.band(sum, 0xFF) == struct.unpack("B", data, 13)
end

return function(address, sUart, RW_pin)
    local battery = {}
    battery.address = address
    battery.SOC = 0
    battery.SOH = 0
    battery.pressure = 0
    battery.acquisition = 0
    battery.voltage = 0
    battery.current = 0
    battery.status = 0
    battery.state = {}
    battery.mos_charging = 0
    battery.mos_discharge = 0
    battery.life = 0
    battery.base_capacity = 100000
    battery.resiual_capacity = 0
    battery.temp = {}
    battery.cellVoltage = {}
    battery.string = 0
    battery.temp2 = 0
    battery.cicles = 0
    battery.last_update = 0

    local timer = tmr.create()
    local readStep = 0
    battery.callback = function(self)
        if readStep==0 then
            dofile("daly_read_information.lc")(battery, sUart, RW_pin)
        elseif readStep==1 then
            dofile("daly_read_soc.lc")(battery, sUart, RW_pin)
        elseif readStep==2 then
            dofile("daly_read_status.lc")(battery, sUart, RW_pin)
        elseif readStep==3 then
            dofile("daly_read_temp.lc")(battery, sUart, RW_pin)
        elseif readStep==4 then
            dofile("daly_read_cell.lc")(battery, sUart, RW_pin)
        elseif readStep==5 then
            dofile("daly_read_state.lc")(battery, sUart, RW_pin)
            readStep = - 1
        end
        readStep = readStep + 1
    end
    timer:register(1500, tmr.ALARM_AUTO, battery.callback)

    battery.startPullData = function(self) 
        timer:start()
    end

    battery.stopPullData = function(self) 
        timer:stop()
    end

    return battery
end
