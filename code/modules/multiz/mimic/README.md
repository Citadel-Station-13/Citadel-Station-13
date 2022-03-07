# ZMimic Module

Ported from Nebula

WARNING WARNING WARNING
This file has been minimally refactored, to preserve some semblence of parity with Nebula's implementation.
Things may break frequently, we can't fully convert everything to our code designs unless we decide to stop updating this from Nebula!

Notably:
- Lighting doesn't passthrough - the object graphics do, but the actual luminosity does not
- Multiz air support is removed from the module, as we use our own code for multiz atmos
- We use more planes than Nebula, and there might need to be some tinkering to make this work.
