local method = function(sck) 
    if battery ~= nil then      
        sck:send("Battery raw registers:<br/><div class='registers'><ul>")
        local key, variable, indexes, num
        num = 0
        for key, variable in pairs(battery.remoteState.registers) do
            num = num + 1
            local buf = ''

            if variable == '-' then 
                buf = buf .. (key - 1) .. ": -"
            else
                buf = buf .. (key - 1) .. ": " .. string.format("%04X", variable)
            end
            sck:send("<li>" .. buf .. "</li>")
            if (num % 15)==0 then
                sck:send("</ul><ul>")
                coroutine.yield()
            end
        end
        sck:send("</ul></div>")
    else        
        sck:send("No battery state")
    end
end

return method