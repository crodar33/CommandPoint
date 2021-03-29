-- light http server implementation
return function(httpCallback)
    local httpServer
    if httpServer then httpServer.socket:close() end
    httpServer = {}

    --collectgarbage()
    --collectgarbage("collect")
    httpServer.socket = net.createServer(net.TCP, 5) 
    httpServer.socket:listen(80, function(socket) 
    
        local connectionHandler = nil
        local finished = false

        local function onReceive(connection, data) 
            httpMuted = httpMuted + 1
            connectionHandler = coroutine.create(function(connection, data) 
                local headers = dofile("http_server_header_parser.lc")(data)
                if (headers==nil) then
                    print("bad http request, no header parsed")
                    return false
                end
                print("+R", connectionHandler, headers.method, headers.url, headers.version, node.heap())
                if not (httpCallback == nil) then
                    httpCallback(httpServer, connection, headers)
                    print("done")
                else
                    print("http default callback")
                    httpServer.sendHeader(connection, dofile("http_headers.lc")[404])
                    connection:send("Not found, or not implemented")
                end
                return true
            end)

            result, error = coroutine.resume(connectionHandler, connection, data)
            if (result==false) then
                print(result, "http coroutine error", error)
                connectionHandler = false
                connection:close()
                collectgarbage()
                httpMuted = httpMuted - 1
            end
        end

        local function onSent(connection, data) 
            collectgarbage()
            local connectionHandlerStatus = coroutine.status(connectionHandler)
            if "suspended" == connectionHandlerStatus then
                local status, err = coroutine.resume(connectionHandler, connection, data)
                --print("status", connectionHandler, statis, err, connectionHandlerStatus, node.heap())
                if err ~= nil then 
                    print("handler have broken", connectionHandler, node.heap(), err)
                    connection:close()
                    connectionHandler = nil
                    collectgarbage()
                    httpMuted = httpMuted - 1
                end
            elseif connectionHandlerStatus=='dead' then
                print("request have done", connectionHandler, node.heap())
                connection:close()
                connectionHandler = nil
                collectgarbage()
                httpMuted = httpMuted - 1
            end
        end

        local function onDisconnect(connection, data) 
            connectionHandler = nil
            collectgarbage()
            print("onDisconnect", node.heap())
        end

        socket:on("receive", onReceive)
        socket:on("sent", onSent)
        socket:on("disconnection", onDisconnect)

    end)
    
    httpServer.sendHeader = function(sck, headers)
        local buffer = ''
        for key, value in pairs(headers) do
            buffer = buffer .. value .. "\n"
        end
        buffer = buffer .. "\n"
        sck:send(buffer)
    end

    return httpServer
end
