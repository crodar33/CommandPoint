# Code and shecme for control inverter
Scheme based on ESP8266 for pool data from BSM of the battery with **daly smart bms**
and provide battery data to **SOFAR HYBRID** inverter **HYD6000-ES**

They not compatible to each to other, so I need to make middle man for it work together.

In current implementation it can:

  * pull data from battery by RS485, UART
  * put data to the inverter by CAN and inner inverter protocol
  * show battery state by HTTP

Used ESP8266, MCP2515, MAX485 and nodeMCU, code writed on LUA
Build nodemcu with **I2C_MASTER_GPIO16_ENABLE** and without **I2C_MASTER_OLD_VERSION**