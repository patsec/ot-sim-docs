# Logic Module

## Configuration Example

Example section from [configuration](configuration.md) file:

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

In this example, we run a simple counter incrementing from `0` to `50` and then resetting and starting over. There are three keys in this particular configuration:

1. `period` is the time between each program execution

1. `program` is the program code

1. `variables` is where variables in the program code are defined

!!! note
    Variable names used in logic program code have limitations in terms of characters they can contain that may prevent users from referencing tags published by other modules. Therefore, variable definitions can include a `tag` attribute to reference what tag should be mapped to the variable.

!!! note
    Please visit the Expr package [Language Definition](https://github.com/antonmedv/expr/blob/master/docs/Language-Definition.md) page for information on all of the possible syntaxes available in Logic Modules. In addition, various functions and calculations are available for configuration.

## Logic Module Overview

!!! todo "Additional Documentation Required"
    This page requires additional content to be added to properly document the
    logic module. Specifically, additional functions included above and beyond
    what's available by default in the `Expr` package need to be documented, as
    well as a description of the known capabilities and limitations.

!!! hint
    Until additional content is added here, take a look at the [ Example
    Devices](examples.md) page for examples of how the logic module can be used.
