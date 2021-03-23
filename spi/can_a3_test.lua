print("Can send messages")

local sendStatus, sendFlag, msg
local statusFormat = dofile("can_formatTXCTRL.lc")

local chargeV = 550
local chargeA = 250
local dischargeA = 250
local cutFoffVoltage = 520
sendStatus, sendFlag, msg = dofile("can_sendCanMessage.lc")(0x0351, {
    struct.pack("<H", chargeV), 
    struct.pack("<H", chargeA), 
    struct.pack("<H", dischargeA), 
    struct.pack("<H", cutFoffVoltage)
})
sendFlag = statusFormat.toStruct(sendFlag)
print(string.format("Send can message flag %s", tostring(sendStatus)))
print(statusFormat.toString(sendFlag))
print(ROM.unpack(msg))

local SOC = 20
local SOH = 30
sendStatus, sendFlag, msg = dofile("can_sendCanMessage.lc")(0x0355, {
    struct.pack("<H", SOC), 
    struct.pack("<H", SOH), 
    struct.pack("<H", 0), 
    struct.pack("<H", 0)
})
sendFlag = statusFormat.toStruct(sendFlag)
print(string.format("Send can message flag %s", tostring(sendStatus)))
print(statusFormat.toString(sendFlag))
print(ROM.unpack(msg))

local battV = 5200
local battA = 100
local battT = 180
local battC = 10
sendStatus, sendFlag, msg = dofile("can_sendCanMessage.lc")(0x0356, {
    struct.pack("<H", battV), 
    struct.pack("<H", battA), 
    struct.pack("<H", battT), 
    struct.pack("<H", battC)
})
sendFlag = statusFormat.toStruct(sendFlag)
print(string.format("Send can message flag %s", tostring(sendStatus)))
print(statusFormat.toString(sendFlag))
print(ROM.unpack(msg))

sendStatus, sendFlag, msg = dofile("can_sendCanMessage.lc")(0x035A, {struct.pack("<H", 0), struct.pack("<H", 0), struct.pack("<H", 0), struct.pack("<H", 0)})
sendFlag = statusFormat.toStruct(sendFlag)
print(string.format("Send can message flag %s", tostring(sendStatus)))
print(statusFormat.toString(sendFlag))
print(ROM.unpack(msg))

sendStatus, sendFlag, msg = dofile("can_sendCanMessage.lc")(0x035E, {struct.pack("c0", ' SLOP48 ')})
sendFlag = statusFormat.toStruct(sendFlag)
print(string.format("Send can message flag %s", tostring(sendStatus)))
print(statusFormat.toString(sendFlag))
print(ROM.unpack(msg))

local battCapA = 100
sendStatus, sendFlag, msg = dofile("can_sendCanMessage.lc")(0x035F, {
    struct.pack("<H", 0), 
    struct.pack("<H", 0x0001), 
    struct.pack("<H", battCapA),
    struct.pack("<H", 0), 
})
sendFlag = statusFormat.toStruct(sendFlag)
print(string.format("Send can message flag %s", tostring(sendStatus)))
print(statusFormat.toString(sendFlag))
print(ROM.unpack(msg))

local cmdNormal = 0
local cmdForcedCharging = 1
local cmdForcedStandby = 2
sendStatus, sendFlag, msg = dofile("can_sendCanMessage.lc")(0x030F, {
    struct.pack("<H", cmdNormal),
    struct.pack("<H", 0), 
    struct.pack("<H", 0), 
    struct.pack("<H", 0), 
})
sendFlag = statusFormat.toStruct(sendFlag)
print(string.format("Send can message flag %s", tostring(sendStatus)))
print(statusFormat.toString(sendFlag))
print(ROM.unpack(msg))
