# Modbus Module

## Configuration Example

Example section from [configuration](configuration.md) file:

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

These configuration keys are described [below](#modbus-module-overview).

!!! note
    Please refer to the [Modbus Organization](https://modbus.org) for more information on the spec.

## Modbus Module Overview

OT-sim supports four Modbus types (`register type=` above);

1. `input` &mdash; analog, read-only

1. `holding` &mdash; analog, read-write

1. `discrete` &mdash; binary, read-only

1. `coil` &mdash; binary, read-write

It is possible to configure 10,000 registers per type. In addition, the types `input` and `holdings` support `scaling`. Because Modbus only supports integers, scaling is used to "move the decimal" to the right or left.

- `-` and an integer moves the decimal to the right
    - For example, the value `98.6` on a server with scaling of `-1` will send `986` to the client
- `+` and an integer moves the decimal to the left
    - For example, the value `986` from a server with scaling of `1` on the client will result in `98.6` on the client


!!! note
    `scaling` must be the same absolute value for both server and client configurations. On the server it should be negative and on the client it should be positive.

!!! note
    When running as a Modbus client (`<modbus mode="client">`), a developer can provide the `<period>` element to configure how often the Modbus client queries the remote Modbus slave for updated values. If not provided, the period defaults to `5s`.
