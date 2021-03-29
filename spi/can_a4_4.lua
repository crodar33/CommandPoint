--Frame 4 Alarms, Warnings - not implemented
sendStatus, sendFlag = dofile("can_sendCanMessage.lc")(0x035A, {
    struct.pack("<H", 0), 
    struct.pack("<H", 0), 
    struct.pack("<H", 0), 
    struct.pack("<H", 0)
})

