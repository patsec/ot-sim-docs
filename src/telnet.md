# Telnet Module

## Configuration Example

Example section from [configuration](configuration.md) file:

```
<telnet>
  <endpoint>:23</endpoint>
  <banner>default</banner>
</telnet>
```

## Telnet Module Overview

The Telnet Module adds a Telnet server to the OT-sim message bus that
automatically subscribes to all status updates published by other modules to the
backplane. It adds all published tags and values to internal memory and makes
them available via the `query` command. Tag values, even ones not yet known by
the Telnet Module, can also be updated via the `write` command.

In addition, the Telnet Module includes a `modules` command that will list all
the OT-sim modules managed by the CPU module. It also includes an `enable`
command and a `disable` command for enabling and disabling modules managed by
the CPU module.
