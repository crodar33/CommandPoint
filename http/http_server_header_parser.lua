local function urldecode(s)
    s = s:gsub('+', ' ')
        :gsub('%%(%x%x)', function(h)
                            return string.char(tonumber(h, 16))
                          end)
    return s
end

local function parseurl(s)
    local ans = {}, k, v
    for k, v in s:gmatch('([^&=?]-)=([^&=?]+)' ) do
        ans[ k ] = urldecode(v)
    end
    return ans
end

-- parse http header
return function(headerBuf)
    local request = {}
    local headDiff = headerBuf:find("\n", 1, true)
    if headDiff == nill then 
        return nil 
    end
    request.http = headerBuf:sub(1, headDiff - 1)
    request.method = headerBuf:sub(1, request.http:find(" ", 1, true) - 1)
    local tmp = #request.method + 2
    request.url = headerBuf:sub(tmp, request.http:find(" ", tmp, true) - 1)
    tmp = #request.method + #request.url + 3
    request.version = headerBuf:sub(tmp, #request.http)
    request.headers = {}
    headDiff = headDiff + 1
    while headDiff < #headerBuf do
        local chunkEnd = headerBuf:find("\n", headDiff, true)
        local nameEnd = headerBuf:find(":", headDiff, true)
        if chunkEnd == nil then
           chunkEnd = #headerBuf + 1
        end
        if nameEnd == nil then
           break
        end
        local key = headerBuf:sub(headDiff, nameEnd - 1)
        local value = headerBuf:sub(nameEnd + 1, chunkEnd - 1)
        request.headers[key] = value
        headDiff = chunkEnd + 1
    end
    if request.method == "POST" and tonumber(request.headers['Content-Length']) > 0 then
        headDiff = headDiff + 1
        local postStr = headerBuf:sub(headDiff + 1, headDiff + tonumber(request.headers['Content-Length']))
        --print("post: ", #postStr, postStr)
        postStr = urldecode(postStr)
        request.post = parseurl(postStr)
    end
    return request
end

    