--frame 5 Manufacture-Name-ASCII
sendStatus, sendFlag = dofile("can_sendCanMessage.lc")(0x035E, {
    struct.pack("c2", '--'),
    struct.pack("c2", 'DA'),
    struct.pack("c2", 'LY'),
    struct.pack("c0", '--')
})
