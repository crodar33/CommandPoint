--test class for net
node = {}
node.heap = function()
    return collectgarbage("count")
end