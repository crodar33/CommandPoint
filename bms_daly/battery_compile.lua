
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
   'battery.lua',
   'daly_read_cell.lua',
   'daly_read_information.lua',
   'daly_read_soc.lua',
   'daly_read_status.lua',
   'daly_read_temp.lua',
   'daly_read_state.lua'
}

for i, f in ipairs(serverFiles) do 
    compile(f) 
end
file.remove("battery_compile.lua")
