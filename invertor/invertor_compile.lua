
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
   'sofar_hyd6es.lua',
   'sofar_read_grid.lua',
}

for i, f in ipairs(serverFiles) do 
    compile(f) 
end
file.remove("invertor_compile.lua")
