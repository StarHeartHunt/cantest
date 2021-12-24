# cantest

A bash script to analyze connection reliability between devices on CAN.

**Basic Usage**:
In one terminal, run the following commands:
```
sudo ip link set can0 type can bitrate 1000000
sudo ip link set can1 type can bitrate 1000000
sudo ip link set can0 up
sudo ip link set can1 up

cantest send can1
```

Then open **another** terminal, run:
```
cantest stat can0
```
