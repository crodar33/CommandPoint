--Frame 1 battery charge voltage, DC charge current limitation, DC discharge current limitation, Battery discharge voltage
local chargeV = 568
local chargeA = 400
local dischargeA = 500
local cutFoffVoltage = 490
local SOC = struct.unpack("<h", struct.pack("H", battery.SOC))
local SOH = struct.unpack("<h", struct.pack("H", battery.SOH))


batTemp = struct.unpack("<h", struct.pack("H", battery.temp[1]*10))

if SOC == 100 then
    chargeA = 0
elseif SOC>80 then
    chargeA = 200
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
elseif (batTemp > 400 and chargeA > 50) then
    chargeA = 50
end

if (inverterCmdMod==3 and batTemp < 700) then
    chargeA = 500
    SOC = 90
elseif (inverterCmdMod==3 and batTemp >= 700) then
    inverterCmdMod = 0
end

--print(batTemp, chargeA)
sendStatus, sendFlag, msg = dofile("can_sendCanMessage.lc")(0x0351, {
    struct.pack("<H", chargeV), 
    struct.pack("<H", chargeA), 
    struct.pack("<H", dischargeA), 
    struct.pack("<H", cutFoffVoltage)
})
