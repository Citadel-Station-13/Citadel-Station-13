How to code fermichem reactions:
First off, probably read though the readme for standard reagent mechanisms, this builds on top of that.

#bitflags
for `datum/reagent/` you have the following options with `var/chemical_flags`:

```
REAGENT_DEAD_PROCESS		calls on_mob_dead() if present in a dead body
REAGENT_DONOTSPLIT		    Do not split the chem at all during processing
REAGENT_ONLYINVERSE		    Only invert chem, no splitting
REAGENT_ONMOBMERGE		    Call on_mob_life proc when reagents are merging.
REAGENT_INVISIBLE		    Doesn't appear on handheld health analyzers.
REAGENT_FORCEONNEW		    Forces a on_new() call without a data overhead
REAGENT_SNEAKYNAME          When inverted, the inverted chem uses the name of the original chem
REAGENT_SPLITRETAINVOL      Retains initial volume of chem when splitting
```

for `datum/chemical_reaction/` under `var/clear_conversion`

```
REACTION_CLEAR_IMPURE       Convert into impure/pure on reaction completion
REACTION_CLEAR_INVERSE      Convert into inverse on reaction completion when purity is low enough
```
