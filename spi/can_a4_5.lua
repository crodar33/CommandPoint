--frame 5 Manufacture-Name-ASCII
sendStatus, sendFlag = dofile("can_sendCanMessage.lc")(0x035E, {
    struct.pack("c2", 'SL'),
    struct.pack("c2", 'OP'),
    struct.pack("c2", '48'),
    struct.pack("c0", '  ')
})
