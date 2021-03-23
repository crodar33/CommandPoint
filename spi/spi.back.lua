local function printResp(resp) 
    print(type(resp))
    print(#resp, resp)

    for key, val in pairs(resp) do
        print(type(val))
        print(key .. " " .. val)
    end
end

local function setMode(newMode)
    local modeMask = 0xE0

    --spi.set_mosi(1, 0, 8, 0x05, 0x0F, modeMask, newMode)
    --spi.transaction(1, 0, 0, 0, 0, 8, 0, 0)
    spi.set_mosi(1, 0, 8, modeMask, newMode)
    spi.transaction(1, 8, 0x05, 8, 0x0F, 16, 0, 0)

    --spi.set_mosi(1, 0, 8, 0x03, 0x0E)
    --spi.transaction(1, 0, 0, 0, 0, 8, 0, 1)
    spi.transaction(1, 8, 0x03, 8, 0x0E, 0, 0, 8)

    resp = spi.get_miso(1, 0, 8, 1)
    --print(string.format("%02x", resp), string.format("%02x", newMode))
    if ( bit.band(modeMask, resp) ~= newMode ) then
        print("Error set mode!!!", string.format("%02x", newMode), string.format("%02x", resp))
        return false
    end
    return true

end

local function modifyRegister(reg, mask, data) 
    spi.set_mosi(1, 0, 8, 0x05, reg, mask, data)
    spi.transaction(1, 0, 0, 0, 0, 8, 0, 0)
end

local function setConfigMode() 
    return setMode(0x80)
end

local function setNormalMode() 
    return setMode(0x00)
end

local function setRegister(register, value) 
    spi.set_mosi(1, 0, 8, 0x02, register, value)
    spi.transaction(1, 0, 0, 0, 0, 8, 0, 0)
end

local function setRegisters(register, values) 
    spi.set_mosi(1, 0, 8, 0x02, register, ROM.unpack(values))
    spi.transaction(1, 0, 0, 0, 0, 8, 0, 0)
end

local function readRegisters(register, len)
    spi.transaction(1, 8, 0x03, 8, register, 0, 0, 8 * len)
    return spi.get_miso(1, 0, 8, len)
end

local function readMessage(bufer) 
    local bufData = readRegisters(bufer, 5)
    --fig poimi che dalshe
end

--send only standart frame
--send data that have 4 word
local function sendCanMessage(canId, data) 
    local t, buferIndex, register, sendBufer, tmpData
    --select free bufer, bufer indexes 0x30 0x40 0x50
    for t, buferIndex in pairs({0x30, 0x40, 0x50}) do
        register = readRegisters(buferIndex, 1)
        if (bit.band(register, 0x08)==0x00) then
            sendBufer = {}
            sendBufer[0] = bit.arshift(canId, 3)
            sendBufer[1] = bit.arshift(bit.band(canId, 0x07), 5)
            sendBufer[2] = 0
            sendBufer[3] = 0
            sendBufer[4] = 4 --#data
            for t, tmpData in pairs(data) do
                sendBufer[3 + t * 2] = struct.unpack("B", tmpData, 1)
                if (#tmpData == 1) then
                    sendBufer[4 + t * 2] = 0
                else
                    sendBufer[4 + t * 2] = struct.unpack("B", tmpData, 2)
                end
            end
            setRegisters(buferIndex + 1, sendBufer)
            modifyRegister(buferIndex, 0x08, 0x08)
            register = readRegisters(buferIndex, 1)
            print(string.format("Send can message status %02x", register))
            return true
        end
    end
    return false
end

local function getStatus() 
    spi.transaction(1, 8, 0xA0, 8, 0, 0, 0, 8)
    return spi.get_miso(1, 0, 8, 1)
end

local function reset() 
    spi.send(1, 0xC0)

    setRegisters(0x30, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0})
    setRegisters(0x40, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0})
    setRegisters(0x50, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0})

    setRegister(0x60, 0)
    setRegister(0x70, 0)
    setRegister(0x2B, 0xA3)

    modifyRegister(0x60, 0x67, 0x04)
    modifyRegister(0x70, 0x67, 0x01)
end

spi.setup(1, spi.MASTER, spi.CPOL_LOW, spi.CPHA_LOW, 8, 8, spi.FULLDUPLEX)
local t1, resp, key, val, i
--reset
--spi.send(1, 0xC0)
reset() 
print("reset")
--set speed 500kbs
setConfigMode() 
print("config mode")
--setRegister(0x2A, 0x00)
--setRegister(0x29, 0x90)
--setRegister(0x28, 0x82)

setRegister(0x2A, 0x00)
setRegister(0x29, 0xF0)
setRegister(0x28, 0x86)
print("set up speed")

setNormalMode() 
print("normal mode")
--set speed 500kbs end
local messageStatus =  getStatus()
print(string.format("status %02x", messageStatus))
if (messageStatus == 0x01) then
    readMessage(0x61)
elseif (messageStatus == 0x02) then 
    readMessage(0x71)
else
    print("No new messages")
end

local chargeV = 550
local chargeA = 250
local dischargeA = 250
local cutFoffVoltage = 520
sendCanMessage(0x0351, {
    struct.pack("<H", chargeV), 
    struct.pack("<H", chargeA), 
    struct.pack("<H", dischargeA), 
    struct.pack("<H", cutFoffVoltage)
})

local SOC = 20
local SOH = 30
sendCanMessage(0x0355, {
    struct.pack("<H", SOC), 
    struct.pack("<H", SOH), 
    struct.pack("<H", 0), 
    struct.pack("<H", 0)
})

local battV = 5200
local battA = 100
local battT = 180
local battC = 10
sendCanMessage(0x0356, {
    struct.pack("<H", battV), 
    struct.pack("<H", battA), 
    struct.pack("<H", battT), 
    struct.pack("<H", battC)
})

sendCanMessage(0x035A, {struct.pack("<H", 0), struct.pack("<H", 0), struct.pack("<H", 0), struct.pack("<H", 0)})

sendCanMessage(0x035E, {struct.pack("c0", ' SLOP48 ')})

local battCapA = 100
sendCanMessage(0x035F, {
    struct.pack("<H", 0), 
    struct.pack("<H", 0x0001), 
    struct.pack("<H", battCapA),
    struct.pack("<H", 0), 
})

local cmdNormal = 0
local cmdForcedCharging = 1
local cmdForcedStandby = 2
sendCanMessage(0x030F, {
    struct.pack("<H", cmdNormal),
    struct.pack("<H", 0), 
    struct.pack("<H", 0), 
    struct.pack("<H", 0), 
})
