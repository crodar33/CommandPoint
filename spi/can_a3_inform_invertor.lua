if battery==nil or battery.last_update==0 or (tmr.time() - battery.last_update)>10 or #battery.temp==0 then
    print("No battery state")
    return
end

print("CAN send messages")

if canStates > 7 then
    canStates = 1
end

dofile('can_a4_' .. canStates .. '.lua');
canStates = canStates + 1