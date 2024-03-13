print("Can read messages")
local canBuss = require "can_module"
local function printResp(resp) 
    print(type(resp))
    print(#resp, resp)

    for key, val in pairs(resp) do
        print(type(val))
        print(key .. " " .. val)
    end
end

local function readMessage(bufer) 
    local bufData = canBuss.readRegisters(bufer, 14)
    --fig poimi che dalshe
    return bufData
end

sendStatus, sendFlag, msg = canBuss.sendCanMessage(0x0351, {
    struct.pack("<H", chargeV), 
    struct.pack("<H", chargeA), 
    struct.pack("<H", dischargeA), 
    struct.pack("<H", cutFoffVoltage)
})
sendFlag = statusFormat.toStruct(sendFlag)
print(string.format("Send can message flag %s", tostring(sendStatus)))
print(statusFormat.toString(sendFlag))
print(ROM.unpack(msg))

local t1, resp, key, val, i

local status = canBuss.status2struct(canBuss.getStatus());
print(canBuss.status2string(status))

if (status.RX0IF) then
    print("queue 1: ", readMessage(0x61))
end
if (status.RX1IF) then 
    print("queue 2: ", readMessage(0x71))
end
if (bit.band(status.FLAG, 0x03) == 0x00) then
    print("No new messages")
end

package.loaded.can_module = nil