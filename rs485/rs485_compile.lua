
local compile = function(f)
    
    if file.exists(f) then
        local newf = f:gsub("%w+/", "")
        file.rename(f, newf)
        print('Compiling:', newf)
        node.compile(newf)
        file.remove(newf)
        collectgarbage()
    end
end

local serverFiles = {
   'RS485.lua',
   'RS485_RegistersCallback.lua',
   'battery.lua',
   'crc16_arc_calc.lua'
}

for i, f in ipairs(serverFiles) do 
    compile(f) 
end
file.remove("rs485_compile.lua")
