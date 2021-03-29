if battery==nil or battery.remoteState.lastUpdate==0 or (tmr.time() - battery.remoteState.lastUpdate)>10 then
    print("No battery state")
    return
end
for i, j in pairs(battery.remoteState.registers) do
    if j == '-' then
        --battery not initiated
        return
    end
end
print("Can send messages")

if canStates > 7 then
    canStates = 1
end

dofile('can_a4_' .. canStates .. '.lua');
canStates = canStates + 1