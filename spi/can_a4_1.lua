--Frame 1 battery charge voltage, DC charge current limitation, DC discharge current limitation, Battery discharge voltage
local chargeV = 550
local chargeA = 250
local dischargeA = 250
local cutFoffVoltage = 500
local SOC = struct.unpack("<h", struct.pack("H", battery.remoteState.registers[6]))
local SOH = struct.unpack("<h", struct.pack("H", battery.remoteState.registers[7]))

local batTemp = math.max(
    struct.unpack("<h", struct.pack("H", battery.remoteState.registers[26])),
    struct.unpack("<h", struct.pack("H", battery.remoteState.registers[27])),
    struct.unpack("<h", struct.pack("H", battery.remoteState.registers[28])),
    struct.unpack("<h", struct.pack("H", battery.remoteState.registers[29]))
)
if SOC == 100 then
    chargeA = 0
elseif SOC>80 then
    chargeA = 50
elseif SOC <= 20 then
    dischargeA = 0
elseif (batTemp > 400 and chargeA > 10) then
    chargeA = 10
end
--print(batTemp, chargeA)
sendStatus, sendFlag, msg = dofile("can_sendCanMessage.lc")(0x0351, {
    struct.pack("<H", chargeV), 
    struct.pack("<H", chargeA), 
    struct.pack("<H", dischargeA), 
    struct.pack("<H", cutFoffVoltage)
})
