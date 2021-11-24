srv = net.createServer(net.TCP)
srv:listen(502, function(conn)
    local cc = function(data) 
        if (data ~= nil and #data == 13) then
            print("TCP response: ", dataToString(data)) 
            conn:send(data)
        end
    end
    conn:on("receive", function(sck, payload)
        --payload:gsub(".", function(c)
        --    table.insert(arr, string.byte(c))
        --end)
        --print (table.concat(arr, " "))
        
        print("TCP request: ", dataToString(payload)) 
        sUart:on("data", 13, cc)
        --send data
        gpio.write(RW_pin, gpio.HIGH)
        sUart:write(payload)
        gpio.write(RW_pin, gpio.LOW)
    end)
end)

return srv