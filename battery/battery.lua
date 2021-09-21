-- GPIO4-RX pin 4
-- GPIO2-TX pin 2
-- GPIO0-RW_flag pin 3

return function()

    local RW_pin = 3
    local RX_pin = 4
    local TX_pin = 2
    local sUart = softuart.setup(9600, TX_pin, RX_pin)
    gpio.mode(RW_pin, gpio.OUTPUT)    

    local battery = {}
    battery.SOC = 0
    battery.SOH = 0
    battery.voltage = 0
    battery.current = 0
    battery.state = 0
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
            dofile("daly_read_stat.lc")(battery, sUart, RW_pin)
        elseif readStep==3 then
            dofile("daly_read_temp.lc")(battery, sUart, RW_pin)
        elseif readStep==4 then
            dofile("daly_read_cell.lc")(battery, sUart, RW_pin)
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
