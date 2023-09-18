# Configuration

The following example configuration file has been separated into sections related to the current supported message bus and modules with a link to each of their documentation pages. The complete configuration file can be found at [patsec/ot-sim](https://github.com/patsec/ot-sim/blob/v1.0.0/config/multi-device/device-2.xml) GitHub page.

!!! note
    There are additional configuration examples available in the [config](https://github.com/patsec/ot-sim/blob/v1.0.0/config) directory and documented [here](examples.md).

## [Message Bus](message_bus.md)

```
<message-bus>
  <verbose>1</verbose>
  <pull-endpoint>tcp://127.0.0.1:1011</pull-endpoint>
  <pub-endpoint>tcp://127.0.0.1:1213</pub-endpoint>
</message-bus>
```

## [CPU Module](cpu.md)

```
<cpu>
  <module name="backplane">ot-sim-message-bus {{config_file}}</module>
  <module name="io">ot-sim-io-module {{config_file}}</module>
  <module name="logic">ot-sim-logic-module {{config_file}}</module>
  <module name="modbus">ot-sim-modbus-module {{config_file}}</module>
  <module name="dnp3">ot-sim-dnp3-module {{config_file}}</module>
  <module name="ground-truth">ot-sim-ground-truth-module {{config_file}}</module>
  <module name="node-red">ot-sim-node-red-module {{config_file}}</module>
</cpu>
```

## [Logic Module](logic.md)

```
<logic>
  <period>1s</period>
  <program>
    <![CDATA[
      counter = (counter + 1) * reset
      reset = counter == 50 ? 0 : 1
    ]]>
  </program>
  <variables>
    <counter>0</counter>
    <reset>1</reset>
  </variables>
</logic>
```

## [Ground Truth Module](ground_truth.md)

```
<ground-truth>
  <elastic>
    <endpoint>http://localhost:9200</endpoint>
    <index-base-name>ot-sim</index-base-name>
  </elastic>
</ground-truth>
```

## [Telnet Module](telnet.md)

```
<telnet>
  <endpoint>:23</endpoint>
  <banner>default</banner>
</telnet>
```

## [Node-RED Module](node_red.md)

```
<node-red>
  <executable>node-red</executable>
  <settings-path>/etc/node-red.js</settings-path>
  <theme>dark</theme>
  <flow-path></flow-path>
  <authentiation>
    <editor username="admin" password="admin"></editor>
    <ui username="admin" password="admin"></ui>
  </authentication>
  <endpoint host="0.0.0.0" port="1880"></endpoint>
</node-red>
```

## [Modbus Module](modbus.md)

```
<modbus name="outstation" mode="server">
  <endpoint>127.0.0.1:5502</endpoint>
  <register type="input">
    <address>30000</address>
    <tag>counter</tag>
  </register>
  <register type="input">
    <address>30001</address>
    <tag>bus-692.voltage</tag>
    <scaling>-2</scaling>
  </register>
  <register type="input">
    <address>30002</address>
    <tag>line-650632.kW</tag>
    <scaling>-2</scaling>
  </register>
  <register type="holding">
    <address>40000</address>
    <tag>reset</tag>
  </register>
  <register type="holding">
    <address>40001</address>
    <tag>line-650632.closed</tag>
  </register>
</modbus>
```

## [DNP3 Module](dnp3.md)

```
<dnp3 name="dnp3-outstation" mode="server">
  <endpoint>127.0.0.1:20001</endpoint>
  <cold-restart-delay>15</cold-restart-delay>
  <outstation name="outstation-1">
    <local-address>10</local-address>
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
  </outstation>
</dnp3>
```

## [I/O Module](io.md)

```
<io name="ot-sim-io">
  <pull-endpoint>tcp://127.0.0.1:1011</pull-endpoint>
  <pub-endpoint>tcp://127.0.0.1:1213</pub-endpoint>
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
    <key>OpenDSS/line-650632.kVAR</key>
    <type>double</type>
    <tag>line-650632.kVAR</tag>
  </subscription>
  <subscription>
    <key>OpenDSS/line-650632.closed</key>
    <type>boolean</type>
    <tag>line-650632.closed</tag>
  </subscription>
  <subscription>
    <key>OpenDSS/switch-671692.closed</key>
    <type>boolean</type>
    <tag>switch-671692.closed</tag>
  </subscription>
  <publication>
    <key>line-650632.closed</key>
    <type>boolean</type>
    <tag>line-650632.closed</tag>
  </publication>
</io>
```
