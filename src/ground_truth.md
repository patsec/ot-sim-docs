# Ground Truth Module

## Configuration Example

Example section from [configuration](configuration.md) file:

```
<ground-truth>
  <elastic>
    <endpoint>http://localhost:9200</endpoint>
    <index-base-name>ot-sim</index-base-name>
  </elastic>
</ground-truth>
```

## Overview

The ground truth module is a simple module that sends any points it sees
published to the message bus to ElasticSearch as a document.

By default, it sends the documents to an index named `ot-sim-YYYY.mm.dd`, but
this can be configured via the `<index-base-name>` configuration setting.

The default mapping for the index used looks like the following:

```
{
  "mappings": {
    "properties": {
      "@timestamp": {
        "type": "date"
      },
      "source": {
        "type": "keyword"
      },
      "field": {
        "type": "text"
      },
      "value": {
        "type": "double"
      }
    }
  }
}
```

When documents are sent to the index, `source` maps to the hostname of the
machine ot-sim is running on and `field` maps to the point's `tag`. If the point
has a non-zero `ts` value it's used for `@timestamp`, otherwise the current time
is used.
