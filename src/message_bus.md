# Message Bus

## Configuration Example

Example section from [configuration](configuration.md) file:

```
<message-bus>
	<verbose>1</verbose>
	<pull-endpoint>tcp://127.0.0.1:1011</pull-endpoint>
	<pub-endpoint>tcp://127.0.0.1:1213</pub-endpoint>
</message-bus>
```

The `pull-` and `pub-endpoint`(s) are required for the `message-bus` configuration keys. It is possible to define an alternative internal message bus if you want to talk to a different one; this can be configured in the [I/O Module](io.md). If you want to break out each module to a separate configuration file, you will need to specify the `pull-` and `pub-endpoint`(s) as set in the Message Bus configuration.

## Message Bus Overview

The Message Bus is how all of the modules communicate with each other. It uses [ZeroMQ](https://zeromq.org/) in two ways:

1. Push and pull
1. Publication and Subscribe (pub/sub)

There are three main topics with pub/sub:

1. `RUNTIME`
1. `LOG`
1. `HEALTH`

### RUNTIME

`RUNTIME` is the primary topic: it is where modules will push their status and update messages for other modules to consume. There are different message formats and accompanied schemas. The first is published _statuses_ &mdash; these are point status updates. The second is published _updates_.

!!! tip
    See an example [here](modules.md#message-schemas) for status, updates, and envelope schemas, followed by a message example. 

#### Status Message

An example of a _status_ message would be where an I/O module receives a message from another federate and then publishes a point status message onto the message bus for others to consume. In this case, another federate running OpenDSS, for example, is configured to publish data about line flows and breaker status. The I/O module can subscribe to line flow published by OpenDSS, and when it receives a published update it takes the value and publishes a point status message onto the message bus.

#### Update Message

An _update_ message includes a value mapped to a tag on a module. For example, an I/O module is configured to look for a message and then publish it to other federates. Other modules may respond with their update.

#### Commonalities and Differences

- All modules receive all messages. But only those with the tag(s) in the message are configured to process the message. An update to their databases follows this.
- Both message formats include "who" they were created by.
- Update messages can also include the destination module and a request for confirmation from the destination module once the update is processed.

### LOG

Log messages pushed to the `LOG` topic should &mdash; at the moment &mdash; be simple string messages &mdash; no outer envelope is needed. The `LOG` topic is processed by the `CPU` module, which will then copy any logs written to the topic to the logs the `CPU` module generates verbatim.

!!! note
    The `CPU` module will not prepend log messages with the name of the module that generated them, so it is recommended that the module generating the log message include its name as part of the message.

### HEALTH

Currently, the `HEALTH` topic is used for reporting metrics from modules for the `CPU` module to process and make available via a [Prometheus](https://prometheus.io) HTTP exporter listening on port 9100.

OT-sim supports two types of metrics at the moment: counters and gauges. Each metric has a name, and modules generating metrics are required to ensure metric names are namespaced to avoid name collisions with metrics from other modules. Namespacing a metric name is typically done by prepending the metric name with the module name.

!!! note
    Refer to the [Prometheus Documentation](https://prometheus.io/docs/concepts/metric_types/) to learn more about counters and gauges.
