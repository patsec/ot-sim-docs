# Getting Started

Clone OT-sim from the [repo](https://github.com/patsec/ot-sim).

## Building

### Requirements

- `Debian-based Linux` (recommend Ubuntu 20.04 LTS or greater)
- `golang` v1.18 or greater
- `build-essential`
- `cmake` v3.11 or greater
- `libboost-dev`
- `libczmq-dev`
- `libxml2-dev`
- `libzmq5-dev`
- `pkg-config`
- `python3-dev`
- `python3-pip`

#### Install apt Packages
```
sudo apt update && sudo apt install \
  build-essential cmake libboost-dev libczmq-dev libxml2-dev libzmq5-dev pkg-config python3-dev python3-pip
```

#### Install Golang
```
wget -O go.tgz https://golang.org/dl/go1.18.linux-amd64.tar.gz \
  && sudo tar -C /usr/local -xzf go.tgz && rm go.tgz \
  && sudo ln -s /usr/local/go/bin/* /usr/local/bin
```

### Install OT-sim

Install the OT-sim C, C++, and Golang modules.

```
cmake -S . -B build && sudo cmake --build build --target install && sudo ldconfig
sudo make -C src/go install
```

Install the OT-sim Python modules. This step will also install the Python HELICS code, on which some of the OT-sim Python modules depend.

```
sudo python3 -m pip install src/python
```

### Optional Installations

#### Hivemind

```
wget -O hivemind.gz https://github.com/DarthSim/hivemind/releases/download/v1.1.0/hivemind-v1.1.0-linux-amd64.gz \
  && gunzip hivemind.gz \
  && sudo mv hivemind /usr/local/bin/hivemind \
  && sudo chmod +x /usr/local/bin/hivemind
```

#### Overmind

```
wget -O overmind.gz https://github.com/DarthSim/overmind/releases/download/v2.2.2/overmind-v2.2.2-linux-amd64.gz \
  && gunzip overmind.gz \
  && sudo mv overmind /usr/local/bin/overmind \
  && chmod +x /usr/local/bin/overmind
```

#### PyModbus

```
python3 -m pip install pymodbus prompt_toolkit pygments
```

#### OpenDSS

```
python3 -m pip install opendssdirect.py~=0.6.1
```

## Running an Example

If you have a Procfile-compatible tool, such as [Overmind](#overmind) or [Hivemind](#hivemind), you can use it to run the Procfile in the root directory.

For a complete example, you will need something like the [pymodbus.console](#pymodbus) to interact with the Modbus module that is run as part of the example.

From one terminal or `tmux` pane, run the following:

```
overmind start -D -f Procfile.single
```

In a separate terminal or `tmux` pane, run the following:

```
pymodbus.console tcp --host 127.0.0.1 --port 5502
```

From within the PyModbus console, you can read from holding register `30000` to get the bus voltage value.

PyModbus example:

```
> client.read_input_registers address=30000 count=1
{
    "registers": [
        98
    ]
}
```

Register `30000` is configured to be scaled by a factor of two, so given the above example the actual value in the experiment is 0.98.

You can trip the line feeding the bus by doing a coil write with a value of `0` to address `0`. When you read a second time, the holding register `30000` will update to `0`.

PyModbus example:

```
> client.write_coil address=0 value=0
{
    "address": 0,
    "value": false
}

> client.read_input_registers address=30000 count=1
{
    "registers": [
        0
    ]
}
```

### DNP3 Example with Docker

First, build the Docker image.

```
docker build -t ot-sim .
```

Then start a container running all the modules, including the HELICS I/O module and the DNP3 module, in outstation mode.

```
docker run -it --rm --name ot-test ot-sim hivemind Procfile.single
```

!!! note
    You can also run a multi-device configuration, where one device acts as a DNP3 outstation to the Modbus client gateway by using `Procfile.multi` instead of `Procfile.single` above. In this configuration, when you send the DNP3 CROB command below, it is translated to a Modbus message and sent along to the second device to modify the HELICS I/O module.

Next, from another terminal or `tmux` pane exec into the container and execute the test DNP3 master, which will do a Class 0 scan, then send a CROB command to trip a line in the OpenDSS HELICS federate that is also running, then do another Class 0 scan.

```
docker exec -it ot-test sh -c "cd testing/dnp3 && python3 master.py"
```
