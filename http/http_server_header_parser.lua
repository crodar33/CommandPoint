-- parse http header
return function(headerBuf)
    local request = {}
    local headDiff = headerBuf:find("\n", 1, true)
    if headDiff == nill then 
        return nil 
    end
    request.http = headerBuf:sub(1, headDiff - 1)
    request.method = headerBuf:sub(1, request.http:find(" ", 1, true))
    local tmp = #request.method + 1
    request.url = headerBuf:sub(tmp, request.http:find(" ", tmp, true) - 1)
    tmp = #request.method + #request.url + 2
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
           return request
        end
        local key = headerBuf:sub(headDiff, nameEnd - 1)
        local value = headerBuf:sub(nameEnd + 1, chunkEnd - 1)
        request.headers[key] = value
        headDiff = chunkEnd + 1
    end
    return request
end

    