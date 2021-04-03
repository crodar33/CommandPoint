--test class for net
net = {}
net.TCP = 'tcp'
net.mocSockets = {}

net.createServer = function(protocol, port)
    local socket = {}
   
    socket.listen = function(self, port, callback)
        self.callback = callback
        self.eventCallback = {}
    end

    socket.on = function(self, event, callback)
        self.eventCallback[event] = callback
    end

    socket.close = function()
    end

    socket.send = function(msg)
        print(msg)
        socket.eventCallback['sent']()
    end

    net.mocSockets[#net.mocSockets + 1] = socket
    return socket
end