
local function getNextLine(file) 
    local buf, s1, s2, subf, p1, p2, t
    buf = file.read('\n')
    if (buf == nill) then 
        return nill 
    end
    --for s1, s2 in buf:gmatch("([<][?][=](.+)[?][>])") do
    for s1, s2 in buf:gmatch("(<%?=([^?>]+)%?>)") do
        subf = loadstring("return " .. s2)
        if not (subf == nil) then       
            p1, p2 = buf:find(s1, 0, 1)
            t = subf()
            if t == nill then
                buf = buf:sub(0, p1 - 1) .. "-" .. buf:sub(p2 + 1, #buf)
            else
                buf = buf:sub(0, p1 - 1) .. t .. buf:sub(p2 + 1, #buf)
            end
            --buf = buf:gsub(s1, subf())
        end
    end
    subf = nil
    s1 = nil
    s2 = nil
    t = nil
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
            until #buf > 1000 or newRow == nil
            --print(filename, #buf, node.heap(), buf)
            sck:send(buf)
            coroutine.yield()
        until newRow == nil
    else
        sck:send(filename .. " not found ")
    end 
end

local function sendFile(sck, filename) 
    if file.open(filename, "r") then
        repeat
            local newRow = file.read()
            if (newRow == nil) then
                file.close()
                return
            end
            sck:send(newRow)
            coroutine.yield()
        until newRow == nil
    else
        sck:send(filename .. " not found ")
    end 
end


local M
M = {}
M.processFile = processFile
M.sendFile = sendFile

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