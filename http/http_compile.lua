
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
   'http_battery_raw.lua',
   'http_headers.lua',
   'http_responses.lua',
   'http_server_core.lua',
   'http_server_header_parser.lua',
   'http_server_router.lua',
}

for i, f in ipairs(serverFiles) do 
    compile(f) 
end
file.remove("http_compile.lua")
