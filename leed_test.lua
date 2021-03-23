pin = 2;
gpio.mode(pin, gpio.OUTPUT);
state = gpio.read(pin)
if (state==gpio.HIGH) then
    gpio.write(pin, gpio.LOW);
else
    gpio.write(pin, gpio.HIGH)
end