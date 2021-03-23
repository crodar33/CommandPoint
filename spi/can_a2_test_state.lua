print("Can read messages")
local function printResp(resp) 
    print(type(resp))
    print(#resp, resp)

    for key, val in pairs(resp) do
        print(type(val))
        print(key .. " " .. val)
    end
end

local function readMessage(bufer) 
    local bufData = dofile("can_readRegisters.lc")(bufer, 14)
    --fig poimi che dalshe
    return bufData
end

local t1, resp, key, val, i

local statusFormat = dofile("can_formatState.lc")
local status = statusFormat.toStruct(dofile("can_getStatus.lc")());
print(statusFormat.toString(status))

if (status.RX0IF) then
    print("queue 1: ", readMessage(0x61))
end
if (status.RX0IF) then 
    print("queue 2: ", readMessage(0x71))
end
if (bit.band(status.FLAG, 0x03) == 0x00) then
    print("No new messages")
end