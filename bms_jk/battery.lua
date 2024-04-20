return function(address, sUart, RW_pin)
    local battery = {}
    battery.address = address
    battery.SOC = 0
    battery.SOH = 0
    battery.voltage = 0
    battery.current = 0
    battery.warnings = 0
    battery.messages = 0
    battery.status = 0
    battery.mos_charging = 0
    battery.mos_discharge = 0
    battery.equalizing = 0
    battery.base_capacity = 100000
    battery.cicled_capacity = 0
    battery.temp = {0, 0, 0}
    battery.cellCount = 0
    battery.cellVoltage = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}
    battery.cicles = 0
    battery.last_update = 0

    local timer = tmr.create()
    battery.callback = function(self)
        dofile("jk_read_all.lc")(battery, sUart, RW_pin)
    end
    timer:register(6000, tmr.ALARM_AUTO, battery.callback)

    battery.startPullData = function(self) 
        timer:start()
    end

    battery.stopPullData = function(self) 
        timer:stop()
    end

    return battery
end
