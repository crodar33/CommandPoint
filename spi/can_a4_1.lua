--Frame 1 battery charge voltage, DC charge current limitation, DC discharge current limitation, Battery discharge voltage
local chargeV = 568
local chargeA = 500
local dischargeA = 500
local cutFoffVoltage = 490
local SOC = struct.unpack("<h", struct.pack("H", battery.remoteState.registers[6]))
local SOH = struct.unpack("<h", struct.pack("H", battery.remoteState.registers[7]))

batTemp = math.max(
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
end

if ((batTemp > 550) ) then
    dischargeA = 0
elseif ((batTemp > 500) ) then
    dischargeA = dischargeA/2
end
if (batTemp > 450) then
    chargeA = 0
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
