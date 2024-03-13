-- light http server implementation
return function()
    local httpServer
    if httpServer then httpServer.socket:close() end
    httpServer = {}

    --collectgarbage()
    --collectgarbage("collect")
    httpServer.socket = net.createServer(net.TCP, 5) 
    httpServer.socket:listen(80, function(socket) 
    
        local connectionHandler = nil
        httpMuted = httpMuted + 1

        local function onReceive(connection, data) 
            connectionHandler = coroutine.create(function(connection, data) 
                --local headers = dofile("http_server_header_parser.lc")(data)
                local headers = http_server.parse_header(data)
                if (headers==nil) then
                    print("bad http request, no header parsed")
                    return false
                end
                print("+R", connectionHandler, headers.method, headers.url, headers.version, node.heap())
                local httpCallback = dofile("http_server_router.lc")
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
                local status, err = coroutine.resume(connectionHandler)
                --print("status", connectionHandler, statis, err, connectionHandlerStatus, node.heap())
                if status==false then 
                    print("handler have broken", connectionHandler, node.heap(), err)
                end
                if err then 
                    --error or ok, but connection will be closed
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
            if httpMuted > 0 then
                httpMuted = httpMuted - 1
            end
            print("onDisconnect", node.heap())
        end

        socket:on("connection", onConnection)
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
