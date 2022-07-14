# Example Devices

An OT-sim device comprises one or more modules connected to a message bus and is
built via an XML configuration file. The configuration file describes all the
modules used to make up the device and the configuration of each specific
module.

Below are examples of configurations showing how specific devices can be built
using XML.

## Intelligent Electronic Device (IED)

The term "IED" is typically used as an umbrella term for any digital control
system field device capable of communication. Here we'll provide a configuration
for a simple device that basically acts as an analog-to-digital converter
between HELICS (a simulated physical process) and an OT protocol (Modbus).

```
<?xml version="1.0"?>
<ot-sim>
  <message-bus>
    <pull-endpoint>tcp://127.0.0.1:1234</pull-endpoint>
    <pub-endpoint>tcp://127.0.0.1:5678</pub-endpoint>
  </message-bus>
  <cpu>
    <module name="backplane">ot-sim-message-bus {{config_file}}</module>
    <module name="modbus">ot-sim-modbus-module {{config_file}}</module>
    <module name="io">ot-sim-io-module {{config_file}}</module>
  </cpu>
  <modbus name="outstation" mode="server">
    <endpoint>0.0.0.0:502</endpoint>
    <register type="coil">
      <address>0</address>
      <tag>line-650632.closed</tag>
    </register>
    <register type="discrete">
      <address>0</address>
      <tag>line-650632.closed</tag>
    </register>
    <register type="input">
      <address>30000</address>
      <tag>bus-692.voltage</tag>
      <scaling>-2</scaling>
    </register>
    <register type="input">
      <address>30001</address>
      <tag>line-650632.kW</tag>
      <scaling>-2</scaling>
    </register>
  </modbus>
  <io name="helics-federate">
    <broker-endpoint>localhost</broker-endpoint>
    <federate-name>ot-sim-io</federate-name>
    <subscription>
      <key>OpenDSS/bus-692.voltage</key>
      <type>double</type>
      <tag>bus-692.voltage</tag>
    </subscription>
    <subscription>
      <key>OpenDSS/line-650632.kW</key>
      <type>double</type>
      <tag>line-650632.kW</tag>
    </subscription>
    <subscription>
      <key>OpenDSS/line-650632.closed</key>
      <type>boolean</type>
      <tag>line-650632.closed</tag>
    </subscription>
    <publication>
      <key>line-650632.closed</key>
      <type>boolean</type>
      <tag>line-650632.closed</tag>
    </publication>
  </io>
</ot-sim>
```

## Remote Telemetry Unit (RTU)

The term "RTU" is sometimes used interchangeably with "IED". However, here we'll
be using the term "RTU" to represent a device that's acting more like an OT
protocol gateway or front-end processor, where it's receiving requests from one
or more upstream devices using one protocol, but communicating with one or more
downstream devices using a different protocol.

```
<?xml version="1.0"?>
<ot-sim>
  <message-bus>
    <pull-endpoint>tcp://127.0.0.1:1234</pull-endpoint>
    <pub-endpoint>tcp://127.0.0.1:5678</pub-endpoint>
  </message-bus>
  <cpu>
    <module name="backplane">ot-sim-message-bus {{config_file}}</module>
    <module name="dnp3">ot-sim-dnp3-module {{config_file}}</module>
    <module name="modbus">ot-sim-modbus-module {{config_file}}</module>
  </cpu>
  <dnp3 name="dnp3-outstation" mode="server">
    <endpoint>0.0.0.0:20000</endpoint>
    <cold-restart-delay>15</cold-restart-delay>
    <outstation name="outstation-1">
      <local-address>1024</local-address>
      <remote-address>1</remote-address>
      <warm-restart-delay>5</warm-restart-delay>
      <input type="binary">
        <address>0</address>
        <tag>line-650632.closed</tag>
        <svar>Group1Var1</svar>
        <evar>Group2Var1</evar>
        <class>Class1</class>
      </input>
      <output type="binary">
        <address>10</address>
        <tag>line-650632.closed</tag>
        <svar>Group10Var2</svar>
        <evar>Group11Var2</evar>
        <class>Class1</class>
        <sbo>false</sbo>
      </output>
      <input type="analog">
        <address>0</address>
        <tag>line-650632.kW</tag>
        <svar>Group30Var6</svar>
        <evar>Group32Var6</evar>
        <class>Class1</class>
      </input>
      <input type="analog">
        <address>1</address>
        <tag>bus-692.voltage</tag>
        <svar>Group30Var6</svar>
        <evar>Group32Var6</evar>
        <class>Class1</class>
      </input>
    </outstation>
  </dnp3>
  <modbus name="modbus-client" mode="client">
    <endpoint>127.0.0.1:502</endpoint>
    <period>2s</period>
    <register type="coil">
      <address>0</address>
      <tag>line-650632.closed</tag>
    </register>
    <register type="discrete">
      <address>0</address>
      <tag>line-650632.closed</tag>
    </register>
    <register type="input">
      <address>30000</address>
      <tag>bus-692.voltage</tag>
      <scaling>2</scaling>
    </register>
    <register type="input">
      <address>30001</address>
      <tag>line-650632.kW</tag>
      <scaling>2</scaling>
    </register>
  </modbus>
</ot-sim>
```

## Programmable Logic Controller (PLC)

This configuration is an example of how a very simplistic PLC can be implemented
using the OT-sim logic module to simulate the physics of a fluid tank process.
The logic running in this "PLC" generates outputs and responds to inputs that
might be present in an actual fluid tank process.

The goal of this configuration is to demonstrate the current capabilities of the
OT-sim logic module. Rather than measuring inlet and outlet flow, we're
calculating them simply as part of the simulation.

| Simulation Parameters          | |
| --------------- | -------------- |
| Max inlet flow  | 100 GPM        |
| Max outlet flow | 125 GPM        |
| Tank capacity   | 10,000 gallons |

The percent-open value for the inlet and outlet valves is controllable. For example, if the tank level gets above 9,500 gallons, the inlet valve will close and will not open again until the tank level gets below 7,500 gallons.

```
<?xml version="1.0"?>
<ot-sim>
  <message-bus>
    <pull-endpoint>tcp://127.0.0.1:1234</pull-endpoint>
    <pub-endpoint>tcp://127.0.0.1:5678</pub-endpoint>
  </message-bus>
  <cpu>
    <module name="backplane">ot-sim-message-bus {{config_file}}</module>
    <module name="logic">ot-sim-logic-module {{config_file}}</module>
    <module name="modbus">ot-sim-modbus-module {{config_file}}</module>
  </cpu>
  <logic name="PLC-tank-sim">
    <period>1s</period>
    <program>
      <![CDATA[
        # stay in event state if level is not low enough
        event = event && level > 7_500

        # only allow inlet valve to be opened again if not in event state
        setpoint = event ? 0 : inlet_pos

        inflow = ((100 / 60) * setpoint)
        outflow = ((125 / 60) * outlet_pos)

        # calculate current level of tank
        level = level + inflow - outflow
        level = level < 0 ? 0 : level

        # go into event state if tank level too high (or will be too high)
        event = event || (level + inflow) > 9_500
      ]]>
    </program>
    <variables>
      <event>false</event>
      <level>0</level>
      <inlet_pos>1.0</inlet_pos>
      <outlet_pos>0.75</outlet_pos>
    </variables>
    <process-updates>true</process-updates>
  </logic>
  <modbus name="outstation" mode="server">
    <endpoint>0.0.0.0:502</endpoint>
    <register type="discrete">
      <address>0</address>
      <tag>event</tag>
    </register>
    <register type="input">
      <address>30000</address>
      <tag>level</tag>
      <scaling>0</scaling>
    </register>
    <register type="holding">
      <address>40000</address>
      <tag>inlet_pos</tag>
      <scaling>-2</scaling>
    </register>
    <register type="holding">
      <address>40001</address>
      <tag>outlet_pos</tag>
      <scaling>-2</scaling>
    </register>
  </modbus>
</ot-sim>
```

## Overcurrent Protection Relay

This configuration is an example of how an (admittedly simple) overcurrent
protection relay can be implemented using the OT-sim logic module.

In this implementation, it is assumed that the I/O module provides the value of the `current` variable &mdash; i.e., from a HELICS federate. The value of the `closed` variable is monitored and processed by the I/O module to be published by a HELICS federate, and a protocol module can modify the `current_max` variable.

Initially, the current will be less than the max current, so there will be no
active event, and the counter will remain at zero. Therefore, the breaker will
be closed initially and stay that way since the counter will be less than `5`.

If the I/O module reports the current to be above the max current for longer
than 5s, the `closed` variable would be set to zero, and the I/O module would
process that update. (In this example, the logic is processed on a period of
every 1s so that the counter would reach `5` in 5s.) Processing the update would
cause the `current` variable to go to `0`, but the breaker would not close again
until manually changed via some other means &mdash; i.e., simlar to a protocol
module.

```
<?xml version="1.0"?>
<ot-sim>
  <message-bus>
    <pull-endpoint>tcp://127.0.0.1:1234</pull-endpoint>
    <pub-endpoint>tcp://127.0.0.1:5678</pub-endpoint>
  </message-bus>
  <cpu>
    <module name="backplane">ot-sim-message-bus {{config_file}}</module>
    <module name="logic">ot-sim-logic-module {{config_file}}</module>
    <module name="dnp3">ot-sim-dnp3-module {{config_file}}</module>
    <module name="io">ot-sim-io-module {{config_file}}</module>
  </cpu>
  <logic name="overcurrent-relay">
    <period>1s</period>
    <program>
      <![CDATA[
        event   = current > current_max ? 1 : 0
        counter = (counter + 1) * event
        closed  = closed == 0 || counter >= 5 ? 0 : 1
      ]]>
    </program>
    <variables>
      <current tag="line-650632.kW">100</current>
      <current_max tag="line-650632.kW_max">150</current_max>
      <closed tag="line-650632.closed">1</closed>
    </variables>
  </logic>
  <dnp3 name="dnp3-outstation" mode="server">
    <endpoint>127.0.0.1:20000</endpoint>
    <cold-restart-delay>15</cold-restart-delay>
    <outstation name="dnp3-outstation">
      <local-address>1024</local-address>
      <remote-address>1</remote-address>
      <warm-restart-delay>5</warm-restart-delay>
      <input type="binary">
        <address>0</address>
        <tag>line-650632.closed</tag>
        <svar>Group1Var1</svar>
        <evar>Group2Var1</evar>
        <class>Class1</class>
      </input>
      <output type="binary">
        <address>10</address>
        <tag>line-650632.closed</tag>
        <svar>Group10Var2</svar>
        <evar>Group11Var2</evar>
        <class>Class1</class>
        <sbo>false</sbo>
      </output>
      <input type="analog">
        <address>0</address>
        <tag>line-650632.kW</tag>
        <svar>Group30Var6</svar>
        <evar>Group32Var6</evar>
        <class>Class1</class>
      </input>
      <input type="analog">
        <address>1</address>
        <tag>line-650632.kVAR</tag>
        <svar>Group30Var6</svar>
        <evar>Group32Var6</evar>
        <class>Class1</class>
      </input>
      <input type="analog">
        <address>2</address>
        <tag>bus-692.voltage</tag>
        <svar>Group30Var6</svar>
        <evar>Group32Var6</evar>
        <class>Class1</class>
      </input>
      <output type="analog">
        <address>10</address>
        <tag>line-650632.kW_max</tag>
        <svar>Group40Var2</svar>
        <evar>Group41Var2</evar>
        <class>Class1</class>
      </input>
    </outstation>
  </dnp3>
  <io name="helics-federate">
    <broker-endpoint>127.0.0.1</broker-endpoint>
    <federate-name>ot-sim-io</federate-name>
    <subscription>
      <key>OpenDSS/bus-692.voltage</key>
      <type>double</type>
      <tag>bus-692.voltage</tag>
    </subscription>
    <subscription>
      <key>OpenDSS/line-650632.kW</key>
      <type>double</type>
      <tag>line-650632.kW</tag>
    </subscription>
    <subscription>
      <key>OpenDSS/line-650632.kVAR</key>
      <type>double</type>
      <tag>line-650632.kVAR</tag>
    </subscription>
    <subscription>
      <key>OpenDSS/line-650632.closed</key>
      <type>boolean</type>
      <tag>line-650632.closed</tag>
    </subscription>
    <publication>
      <key>line-650632.closed</key>
      <type>boolean</type>
      <tag>line-650632.closed</tag>
    </publication>
  </io>
</ot-sim>
```
