# cantest

A bash script to analyze connection reliability between devices on CAN.

**Basic Usage**:
```
sudo ip link set can0 type can bitrate 1000000
sudo ip link set can1 type can bitrate 1000000
sudo ip link set can0 up
sudo ip link set can1 up

cantest send can1
cantest stat can0
```
