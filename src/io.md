# I/O Module

## Configuration Example

Example section from [configuration](configuration.md) file:

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

## HELICS Federate

The OT-sim I/O Module is always a [HELICS](https://helics.org/) federate. In the example [above](#configuration-example), the I/O Module subscribes to data published out of an OpenDSS federate in a HELIC co-simulation. The HELICS `type`(s) supported in this module is `boolean` and `double` (the latter is synonymous with float). The `tag` key is OT-sim's term and is used on the internal message bus. The `tag` is similar to HELIC's term `topic`. If a `tag` is not specified, then OT-sim will use the `key`. The HELICS `key` is what HELICS will use to process the message.

The `pull-` and `pub-endpoint`(s) are optional for the `io` configuration keys. It is possible to define an alternative internal message bus if you want to talk to a different one from the default in the [Message Bus](message_bus.md). The `federate-name` key is optional; if not provided, the `name` value in the `io` key will be used.

