return {
    [200] = {
        "HTTP/1.1 200 OK",
        "Server: esp8266",
        "Content-Type: text/html charset=utf8",
        "Connection: Closed"
    },
    [301] = {
        "HTTP/1.1 301 Moved Permanently",
        "Server: esp8266",
        "Content-Type: text/html charset=utf8",
        "Location: /",
        "Cache-Control: no-cache, must-revalidate",
        "Pragma: no-cache",
        "Connection: Closed"
    },
    [404] = {
        "HTTP/1.1 404 Not Found",
        "Server: esp8266",
        "Content-Type: text/html charset=utf8",
        "Cache-Control: no-cache, must-revalidate",
        "Pragma: no-cache",
        "Connection: Closed"
    }
}
