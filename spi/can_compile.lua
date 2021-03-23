
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
   'can_getStatus.lua',
   'can_formatState.lua',
   'can_formatTXCTRL.lua',
   'can_init_can.lua',
   'can_modifyRegister.lua',
   'can_reset.lua',
   'can_sendCanMessage.lua',
   'can_setConfigMode.lua',
   'can_readRegisters.lua',
   'can_setMode.lua',
   'can_setNormalMode.lua',
   'can_setRegister.lua',
   'can_setRegisters.lua',
}

for i, f in ipairs(serverFiles) do 
    compile(f) 
end
file.remove("can_compile.lua")
