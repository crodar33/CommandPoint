
buf = 'Device ID: <?= "123" ?> - <?= "321" ?> - <?= "444" ?> - <?= 555 ?><br/>'


for s1, s2 in buf:gmatch("(<%?=([^?>]+)%?>)") do
    print(s1)
    print(s2)
    sub = loadstring("return " .. s2)
    if not (sub == nil) then       
        p1, p2 = buf:find(s1, 0, 1)
        buf = buf:sub(0, p1 - 1) .. sub() .. buf:sub(p2 + 1, #buf)
        --buf = buf:gsub(s1, sub())
    end
end

print(buf)