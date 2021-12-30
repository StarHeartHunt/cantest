# cantest

A bash script to analyze connection reliability between devices on CAN.

**Basic Usage**:
In one terminal, run the following commands:
```
sudo ip link set can0 up type can bitrate 1000000
sudo ip link set can1 up type can bitrate 1000000

# Using default sending gap value (200ms)
./cantest.bash send can1
# Define sending gap as 1ms
./cantest.bash send can1 1
```

Then launch **another** terminal, run:
```
./cantest.bash stat can0
```
