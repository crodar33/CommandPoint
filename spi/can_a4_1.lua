--Frame 1 battery charge voltage, DC charge current limitation, DC discharge current limitation, Battery discharge voltage
local chargeV = 576 --3.60*16
local chargeA = 450 --2.81*16
local dischargeA = 650
local cutFoffVoltage = 450
local SOC = struct.unpack("<h", struct.pack("H", battery.SOC))
local SOH = struct.unpack("<h", struct.pack("H", battery.SOH))


batTemp = struct.unpack("<h", struct.pack("H", battery.temp[1]*10))

if SOC >= 100 then
    chargeA = 0
elseif SOC>95 then
    chargeA = 50
elseif SOC>90 then
    chargeA = 100
elseif SOC>80 then
    chargeA = 150
elseif SOC <= 50 then
    dischargeA = 400
elseif SOC <= 40 then
    dischargeA = 200
elseif SOC <= 10 then
    dischargeA = 0
end

if (inverterCmdMod==3 and batTemp < 700) then
    chargeA = 450
    SOC = 90
elseif (inverterCmdMod==3 and batTemp >= 700) then
    inverterCmdMod = 0
elseif (inverterCmdMod==4 and SOC<99) then
    chargeA = 50
end

if ((batTemp > 500) ) then
    dischargeA = 0
elseif ((batTemp > 400) ) then
    dischargeA = dischargeA/2
end

if math.max(unpack(battery.cellVoltage))>3.6 then
    chargeA = 50;
end
if math.min(unpack(battery.cellVoltage))<2.8 then
    dischargeA = 0;
end

if (batTemp > 450) then
    chargeA = 0
elseif (batTemp > 400 and chargeA > 50) then
    chargeA = 50
end


local canBuss = require "can_module"
--print("Charge values: ", chargeV, chargeA)
sendStatus, sendFlag, msg = canBuss.sendCanMessage(0x0351, {
    struct.pack("<H", chargeV), 
    struct.pack("<H", chargeA), 
    struct.pack("<H", dischargeA), 
    struct.pack("<H", cutFoffVoltage)
})
package.loaded.can_module = nil
