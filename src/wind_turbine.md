# Wind Turbine

OT-sim includes rudimentary support for modeling the control aspects of a wind
turbine generator. It does so via the use of generic OT-sim modules like the
logic, Modbus, and DNP3 modules, as well as a few additional modules that are
specific to a wind turbine &mdash; the anemometer and power output modules.

The reference model OT-sim uses for modeling the control aspects of a wind
turbine include the following OT-sim devices, each including the specified
OT-sim modules.

* Main Controller
    * CPU Module
    * Logic Module
    * Modbus Module
    * DNP3 Module
    * Wind - Power Output Module
* Yaw Controller
    * CPU Module
    * Logic Module
    * Modbus Module
* Anemometer
    * CPU Module
    * Modbus Module
    * Wind - Anemometer Module
* Blade Controller (x3)
    * CPU Module
    * Modbus Module

As you can see from the above list of devices, the OT-sim model for a wind
turbine is made up of six (6) separate controllers, each controlling a specific
process (or processes) and some communicating with other controllers.

!!! note
    We are aware that it's uncommon for the Modbus protocol to be used within an
    actual wind turbine to communicate between controllers. The development of a
    protocol module that supports IEC 61400-25 (on top of IEC 61850) is on the
    roadmap. Once implemented, this reference implementation will be updated to
    support the use of either Modbus (legacy, backwards compatibility) or IEC
    61400-25.

## Wind Turbine Modules

### Anemometer

The OT-sim `anemometer` module supports the replay of weather data provided in a
CSV file. Once a second, this module publishes weather data from configured
columns to the message bus using the configured tag. Other OT-sim modules can
then subscribe to these tags like normal. For example, the Modbus module can use
the published tag data to update its internal register database to accurately
respond to incoming Modbus read requests.

### Power Output

The OT-sim `power-output` module supports the calculation of wind turbine power
output, based on current weather conditions, using the Python
[windpowerlib](https://windpowerlib.readthedocs.io/en/stable/index.html)
library. This library includes power curves for a large number of turbine makes
and models. Each time this module gets updated weather data from the message
bus, it recalculates the power output of the turbine, using the updated weather
data, and publishes the power output value to the message bus. Other OT-sim
modules can then subscribe to these tags like normal. For example, the I/O
module can use the published power output values to send updates to a power
system federate(s) running as part of a [HELICS](https://helics.org)
co-simulation.

## Configuration Example

```
<wind-turbine>
  <anemometer>
    <weather-data>
      <column name="Windspeed 58.2m">speed.high</column>
      <column name="Windspeed 36.6m">speed.med</column>
      <column name="Windspeed 15.0m">speed.low</column>
      <column name="Wind Direction 58.2m">dir.high</column>
      <column name="Wind Direction 36.6m">dir.med</column>
      <column name="Wind Direction 15.0m">dir.low</column>
      <column name="Temperature 58.2m">temp.high</column>
      <column name="Temperature 3.0m">temp.low</column>
      <column name="Barometric Pressure">pressure</column>
    </weather-data>
    <data-path>/etc/ot-sim/data/weather.csv</data-path>
  </anemometer>
  <power-output>
    <turbine-type>E-126/4200</turbine-type>
    <hub-height>135</hub-height>
    <roughness-length>0.15</roughness-length>
    <weather-data>
      <column name="wind_speed" height="58.2">speed.high</column>
      <column name="wind_speed" height="36.6">speed.med</column>
      <column name="wind_speed" height="15">speed.low</column>
      <column name="temperature" height="58.2">temp.high</column>
      <column name="temperature" height="3">temp.low</column>
      <column name="pressure" height="0">pressure</column>
    </weather-data>
    <tags>
      <cut-in>turbine.cut-in</cut-in>
      <cut-out>turbine.cut-out</cut-out>
      <output>turbine.mw-output</output>
      <emergency-stop>turbine.emergency-stop</emergency-stop>
    </tags>
  </power-output>
</wind-turbine>
```
