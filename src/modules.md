# Module Development

OT-sim's modular architecture allows for the use of various programming languages for module development. As long as the programming language has a ZeroMQ implementation, programmers can use it to develop an OT-sim module.

Currently, the core OT-sim project leverages four separate programming languages: C, C++, Go, and Python. It also includes implementations of an interface to access the message bus in C++, Go, and Python, all of which are structured and operate similarly.

Custom OT-sim modules do not have to be developed within the framework of the core OT-sim project. As long as they are executables, can talk to the message bus using ZeroMQ, and can parse and generate the message schemas currently used by OT-sim, they should work as a module.

## Message Bus Interfaces

As mentioned above, the core OT-sim project implements message bus utilities in C++, Go, and Python to simplify the development of custom OT-sim modules. These utilities include a message bus pusher, a message bus subscriber, and a metrics pusher.

### Message Bus Pusher

This straightforward utility connects to the message bus using the `PUSH` socket type and pushes messages to a given topic. The goal of this utility is to cleanly manage the ZeroMQ socket used to interact with the message bus.

### Message Bus Subscriber

This utility connects to the message bus using the `SUB` socket type, setting the topic to subscribe to and running as a separate thread to receive and process messages pushed to the message bus by other modules. In addition, users of this utility register a callback function for status and update messages to be called anytime the subscriber thread receives a message. The goal of this utility is to cleanly manage the ZeroMQ socket used to interact with the message bus and run as a separate thread without the developer having to worry about implementing the thread specifics.

### Metrics Pusher

This utility provides methods for registering and updating metrics and periodically pushing registered metrics to the `HEALTH` topic on the message bus. This utility aims to provide an easily accessible metrics registry and create and manage a separate thread that periodically publishes metrics without the developer having to worry about implementing the thread specifics.

## Module Execution and Logging

The CPU module provided by the core OT-sim project is capable of, but not required to, starting other OT-sim modules, monitoring them, and restarting them if they happen to die. If a developer anticipates always letting the CPU module start and monitor their custom OT-sim module, they can generate logs by simply writing to STDOUT or STDERR. The CPU module will monitor STDOUT and STDERR for the process and copy anything written to the logs it generates.

Suppose a developer does not anticipate always letting the CPU module start their custom module. In that case, they can push log messages to the `LOG` message bus topic, and the CPU will copy anything pushed to this topic to the logs it is generating. Log messages pushed to the `LOG` topic should, at the moment, be simple string messages &mdash; i.e., no outer envelope is needed.

## Module Metrics

Module developers that wish to expose metrics for their module can use the metrics pusher utility to register and update metrics and periodically push registered metrics to the message bus for the `CPU` module to process. Metrics must be registered prior to being updated, but can be registered before or after starting the thread that will periodically push them.

!!! example
    Examples of registering metrics can be found [here (C++)](https://github.com/patsec/ot-sim/blob/v1.0.0/src/c%2B%2B/dnp3/outstation.cpp#L15), [here (Go)](https://github.com/patsec/ot-sim/blob/v1.0.0/src/go/modbus/server/server.go#L130), and [here (Python)](https://github.com/patsec/ot-sim/blob/v1.0.0/src/python/otsim/io/io.py#L95).

    Examples of updating metrics can be found [here (C++)](https://github.com/patsec/ot-sim/blob/v1.0.0/src/c%2B%2B/dnp3/outstation.cpp#L220), [here (Go)](https://github.com/patsec/ot-sim/blob/v1.0.0/src/go/modbus/server/server.go#L161), and [here (Python)](https://github.com/patsec/ot-sim/blob/v1.0.0/src/python/otsim/io/io.py#L116).

## Message Exchange

Modules exchange messages via the message bus using a limited number of message types or schemas encoded as JSON strings. Each message exchanged is contained within a message envelope whose schema is known by all modules and identifies the type of message included. Each module can determine how to decode the message within the envelope with this information. Modules should push these messages to the `RUNTIME` message bus topic.

The current approach to message generation is as follows:

- Status messages are generated and published to let other modules know about the device's current state or the system it is monitoring.

- Update messages are generated and published when a module needs another module to actively modify the current state of the device or system it monitors.

For example, the I/O module, a HELICS federate, generates status messages whenever it gets updates from other HELICS federates. It subscribes only to update messages from other modules and propagates any updates received out to other HELICS federates.

Similarly, the DNP3 module, when running in server mode, subscribes only to status messages from other modules and updates its internal DNP3 register database when new status messages are received. In addition, it generates update messages for additional modules to react to when a DNP3 client sends a control request.

## Message Schemas

The envelope schema exchanges messages between modules via the `RUNTIME` and `HEALTH` topics.

#### Envelope Schema

```
type: object
required:
  - version
  - kind
  - metadata
  - contents
properties:
  version:
    type: string
    default: v1
    enum:
      - v1
  kind:
    type: string
    enum:
      - Status
      - Update
      - Metric
  metadata:
    type: object
    required:
      - sender
    additionalProperties:
      type: string
  contents:
    oneOf:
      - Status
      - Update
```

### RUNTIME

Currently, only two types of messages are exchanged via the `RUNTIME` topic within the well-known envelope schema: `Status` and `Update`.

#### Status Schema

```
type: object
required:
  - measurements
properties:
  measurements:
    type: array
    items:
      type: object
      required:
        - tag
        - value
        - ts
      properties:
        tag:
          type: string
        value:
          type: number
          format: double
        ts:
          type: integer
          format: uint64
```

#### Update Schema

```
type: object
required:
  - updates
properties:
  updates:
    type: array
    items:
      type: object
      required:
        - tag
        - value
        - ts
      properties:
        tag:
          type: string
        value:
          type: number
          format: double
        ts:
          type: integer
          format: uint64
  recipient:
    type: string
  confirm:
    type: string
```

#### Example Status Message

```
{
  "version": "v1",
  "kind": "Status",
  "metadata": {
    "sender": "ot-sim-io"
  },
  "contents": {
    "measurements": [
      {
        "tag": "bus-692.voltage",
        "value": 1.046,
        "ts": 1657226316
      },
      {
        "tag": "line-650632.closed",
        "value": 1.0,
        "ts": 1657226316
      }
    ]
  }
}
```

### HEALTH

Currently, only one type of message is exchanged via the `HEALTH` topic within the well-known envelope schema: `Metric`.

#### Metric Schema

```
type: object
required:
  - kind
  - name
  - desc
  - value
properties:
  kind:
    type: string
    enum:
      - Counter
      - Gauge
  name:
    type: string
  desc:
    type: string
  value:
    type: number
    format: double
```
