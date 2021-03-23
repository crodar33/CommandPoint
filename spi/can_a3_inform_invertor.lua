print("Can send messages")

if battery==nil or battery.remoteState.lastUpdate==0 or (tmr.time() - battery.remoteState.lastUpdate)>10 then
    print("No battery state")
    return
end
local sendStatus, sendFlag, msg

local chargeV = 550
local chargeA = 250
local dischargeA = 250
local cutFoffVoltage = 500
local SOC = struct.pack("H", battery.remoteState.registers[5])
local SOH = struct.pack("H", battery.remoteState.registers[6])
local batTemp = math.max(
    struct.pack("H", battery.remoteState.registers[25]),
    struct.pack("H", battery.remoteState.registers[26]),
    struct.pack("H", battery.remoteState.registers[27]),
    struct.pack("H", battery.remoteState.registers[28])
)
if SOC == 100 then
    chargeA = 0
elseif SOC>80 then
    chargeA = 50
elseif SOC <= 20 then
    dischargeA = 0
elseif (batTemp > 40 and chargeA > 10) then
    chargeA = 10
end

sendStatus, sendFlag, msg = dofile("can_sendCanMessage.lc")(0x0351, {
    struct.pack("<H", chargeV), 
    struct.pack("<H", chargeA), 
    struct.pack("<H", dischargeA), 
    struct.pack("<H", cutFoffVoltage)
})
print(string.format("Send can message flag %s, status %02x", tostring(sendStatus), sendFlag))
print(ROM.unpack(msg))

sendStatus, sendFlag = dofile("can_sendCanMessage.lc")(0x0355, {
    struct.pack("<H", SOC), --SOC
    struct.pack("<H", SOH), --SOH
    struct.pack("<H", 0), 
    struct.pack("<H", 0)
})
print(string.format("Send can message flag %s, status %02x", tostring(sendStatus), sendFlag))

local batV = struct.pack("H", battery.remoteState.registers[3])
local batA = struct.pack("H", battery.remoteState.registers[4])
local batC = struct.pack("H", battery.remoteState.registers[7])

sendStatus, sendFlag = dofile("can_sendCanMessage.lc")(0x0356, {
    struct.pack("<H", batV), --batt V
    struct.pack("<h", batA), --batt A
    struct.pack("<h", batTemp), --batt T
    struct.pack("<H", batC) -- batt Cicles
})
print(string.format("Send can message flag %s, status %02x", tostring(sendStatus), sendFlag))

sendStatus, sendFlag = dofile("can_sendCanMessage.lc")(0x035A, {struct.pack("<H", 0), struct.pack("<H", 0), struct.pack("<H", 0), struct.pack("<H", 0)})
print(string.format("Send can message flag %s, status %02x", tostring(sendStatus), sendFlag))

sendStatus, sendFlag = dofile("can_sendCanMessage.lc")(0x035E, {struct.pack("c0", ' SLOP48 ')})
print(string.format("Send can message flag %s, status %02x", tostring(sendStatus), sendFlag))

local batCap = struct.pack("H", battery.remoteState.registers[5006]) / 10
sendStatus, sendFlag = dofile("can_sendCanMessage.lc")(0x035F, {
    struct.pack("<H", 0), 
    struct.pack("<H", 0x0001), 
    struct.pack("<H", batCap),
    struct.pack("<H", 0), 
})
print(string.format("Send can message flag %s, status %02x", tostring(sendStatus), sendFlag))

--local cmdNormal = 0
--local cmdForcedCharging = 1
--local cmdForcedStandby = 2
sendStatus, sendFlag = dofile("can_sendCanMessage.lc")(0x030F, {
    struct.pack("<H", inverterCmdMod),
    struct.pack("<H", 0), 
    struct.pack("<H", 0), 
    struct.pack("<H", 0), 
})
print(string.format("Send can message flag %s, status %02x", tostring(sendStatus), sendFlag))
