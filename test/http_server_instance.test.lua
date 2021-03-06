dofile("./../test/moc.node.lua")
dofile("./../test/moc.net.lua")

local originalDofile = dofile

function dofile(file) 
    if (file:find(".lc")) then
        file = file:gsub(".lc", ".lua");
    end
    return originalDofile(file)
end

httpMuted = 0
httpServer = dofile("./http_server_core.lua")()

socket = net.mocSockets[1]
socket.callback(socket)

request = [[GET /battery_raw HTTP/1.1
Host: 192.168.42.36
User-Agent: Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:86.0) Gecko/20100101 Firefox/86.0
Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8
Accept-Language: en-GB,en;q=0.5
Accept-Encoding: gzip, deflate
Connection: keep-alive
Upgrade-Insecure-Requests: 1
Pragma: no-cache
Cache-Control: no-cache
]]
socket.eventCallback["receive"](socket, request)
print("http mute count " .. httpMuted)
print()

request = [[POST /better-inverter-state HTTP/1.1
Host: 192.168.42.36
User-Agent: Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:86.0) Gecko/20100101 Firefox/86.0
Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8
Accept-Language: en-GB,en;q=0.5
Accept-Encoding: gzip, deflate
Connection: keep-alive
Upgrade-Insecure-Requests: 1
Pragma: no-cache
Cache-Control: no-cache
Content-Length: 15

state=1&time=10

]]
socket.eventCallback["receive"](socket, request)
print("http mute count " .. httpMuted)