function bbVal(num, format, div)
    num = num + 1
    local val = battery.remoteState.registers[num]
    if div == nil then div = 1 end
    if val == '-' or val == nil then
        return '-'
    end
    --if #val ~= 2 then
    --    return 'X'
    --end
    local tmp = struct.pack("H", val)
    return struct.unpack(format, tmp) / div
end


local function getNextLine(file) 
    local buf, s1, s2, sub, p1, p2
    buf = file.read('\n')
    if (buf == nill) then 
        return nill 
    end
    --for s1, s2 in buf:gmatch("([<][?][=](.+)[?][>])") do
    for s1, s2 in buf:gmatch("(<%?=([^?>]+)%?>)") do
        sub = loadstring("return " .. s2)
        if not (sub == nil) then       
            p1, p2 = buf:find(s1, 0, 1)
            buf = buf:sub(0, p1 - 1) .. sub() .. buf:sub(p2 + 1, #buf)
            --buf = buf:gsub(s1, sub())
        end
    end
    sub = nil
    s1 = nil
    s2 = nil
    return buf
end

local function processFile(sck, filename) 
    if file.open(filename, "r") then
        repeat
            local newRow = getNextLine(file)
            if (newRow == nil) then
                file.close()
                return
            end
            local buf = newRow
            repeat
                newRow = getNextLine(file)
                if newRow ~= nil then buf = buf .. newRow end
                --print(filename, #buf, node.heap(), newRow)
            until #buf > 150 or newRow == nil
            --print(filename, #buf, node.heap(), buf)
            sck:send(buf)
            coroutine.yield()
        until newRow == nil
    else
        sck:send(filename .. " not found ")
    end 
end


local M
M = {}
M.processFile = processFile

M.returnHeader = function(sck)
    processFile(sck, "header.html")
end

M.returnFooter = function(sck)
    processFile(sck, "footer.html")
end

M.returnState = function(sck) 
    if battery ~= nil then        
        processFile(sck, "state.html")
    else        
        sck:send("No battery state")
    end
end

return M