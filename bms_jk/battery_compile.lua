
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
   'jk_read_all.lua',
}

for i, f in ipairs(serverFiles) do 
    compile(f) 
end
file.remove("battery_compile.lua")
