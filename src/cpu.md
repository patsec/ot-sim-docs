# CPU Module

## Configuration Example

Example section from [configuration](configuration.md) file:

```
<cpu>
  <api-endpoint>127.0.0.1:9101</api-endpoint>
  <module name="backplane">ot-sim-message-bus {{config_file}}</module>
  <module name="io">ot-sim-io-module {{config_file}}</module>
  <module name="logic">ot-sim-logic-module {{config_file}}</module>
  <module name="modbus">ot-sim-modbus-module {{config_file}}</module>
  <module name="dnp3">ot-sim-dnp3-module {{config_file}}</module>
</cpu>
```

## CPU Module Overview

The CPU Module is the core module; in the [example above](#configuration-example), there are five separate modules configured for the CPU Module. The CPU Module starts and monitors all other modules. When other modules quit unexpectedly, they are restarted by the CPU. The CPU Module is the primary collection point for logs from other modules. The logs are written to the message bus for the CPU Module to collect; this is also true for health checks. Each module has an independent schema, which the CPU Module is not concerned with.

There are three main functions for the CPU module:

1. Start and stop other modules
1. Collect and manage logs, which are currently written to the CPU module's STDOUT
1. Collect and expose metrics, which are currently exposed at `http://localhost:9100/metrics`

## HTTP API

The example above also includes `<api-endpoint>`, which, when provided, enables an API for interacting with the CPU module over HTTP. The API makes the following paths available.

```
# list of all points currently known by the CPU module
GET  /api/v1/query

# get WebSocket that will receive a list of points every 5s
GET  /api/v1/query/ws

# get a specific point by tag name
GET  /api/v1/query/{tag}

# send one or more points to be updated via JSON
POST /api/v1/write

# update specific point by tag name
POST /api/v1/write/{tag}/{value}
```

!!! tip
    The schema used to send and receive points is the same as what is used to send points over the message bus, documented [here](modules.md#update-schema).

### TLS

The CPU module can use Secure HTTP (HTTPS) to identify the CPU API server and encrypt the HTTP traffic by providing paths to an existing SSL certificate and key for the server. To do this, replace the `<api-endpoint>` element in the example above with the following configuration.

```
<api>
  <endpoint>127.0.0.1:9100</endpoint>
  <tls-key>/path/to/tls.key</tls-key>
  <tls-certificate>/path/to/tls.crt</tls-certificate>
</api>
```

### Mutual TLS

It is also possible to require clients to authenticate with the CPU API server using TLS by adding an element to the `<api>` configuration example above. This element points to an existing SSL CA certificate used to sign the SSL certificate clients will use when connecting to the server.

```
<api>
  <endpoint>127.0.0.1:9100</endpoint>
  <tls-key>/path/to/tls.key</tls-key>
  <tls-certificate>/path/to/tls.crt</tls-certificate>
  <ca-certificate>/path/to/ca.crt</ca-certificate>
</api>
```
