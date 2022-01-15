# cantest

A bash script to analyze connection reliability between devices on CAN.

**Basic Usage**:
In one terminal, run the following commands:
```
sudo ip link set can0 up type can bitrate 1000000
sudo ip link set can1 up type can bitrate 1000000

# Send packets from can1 and set gap as 200ms
./cantest.bash send can1
# Send packets from can1 and set gap as 1ms
./cantest.bash send can1 1

# Continuously send packets from can1 using built-in CAN frame (1ff#0bb80bb80bb80bb8) (200#0bb80bb80bb80bb8)
./cantest.bash start can1
# Or define your CAN frame (can1 can be replaced with other can device)
./cantest.bash start can1 1ff#0fa00fa00fa00fa0
./cantest.bash start can1 200#0fa00fa00fa00fa0
```

Then launch **another** terminal, run:
```
./cantest.bash stat can0
```
