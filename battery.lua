-- GPIO4-RX pin 4
-- GPIO2-TX pin 2
-- GPIO0-RW_flag pin 3

return function(readRegisters)

    local timer = tmr.create()
    if readRegisters == nil then
        readRegisters = 40
    end
    print("battery 1", node.heap())

    print("battery 2", node.heap())
    local battery = {}
    battery.readRegisters = readRegisters
    battery.remoteState = dofile("RS485.lua")(readRegisters, 3, 4, 2)
    battery.readDiff = 0

    battery.requestUpdates = function (self) 
        print( "request battery registers " .. self.readDiff )
        self.remoteState:readRegisters(1, 3, self.readDiff, 10)
        self.readDiff = self.readDiff + 10
        if self.readDiff >= self.readRegisters then
            self.readDiff = 0
        end
        --self:startPullData()
    end
        
    battery.startPullData = function(self)
        timer:register(1000, tmr.ALARM_AUTO, function() if httpMuted==0 then battery:requestUpdates() end end)
        timer:start()
    end

    battery.stopPullData = function(self) 
        timer:stop()
    end

    battery.readStaticData = function(self)         
        print( "request battery static " )
        self.remoteState:readRegisters(1, 3, 5000, 13)
    end
    
    return battery
end
