/datum/element/area_adds_trait
    element_flags = ELEMENT_DETACH | ELEMENT_BESPOKE
    id_arg_index = 3
    var/trait
    var/trait_cause

/datum/element/area_adds_trait/Attach(datum/target,trait_type,cause)
    . = ..()
    if(!isarea(target))
        return ELEMENT_INCOMPATIBLE
    trait = trait_type
    trait_cause = cause
    RegisterSignal(target,COMSIG_AREA_ENTERED,.proc/add_trait)
    RegisterSignal(target,COMSIG_AREA_EXITED,.proc/remove_trait)

/datum/element/area_adds_trait/Detach(area/A)
    . = ..()
    UnregisterSignal(A,COMSIG_AREA_ENTERED)
    UnregisterSignal(A,COMSIG_AREA_EXITED)

/datum/element/area_adds_trait/proc/add_trait(datum/source, atom/movable/M)
    ADD_TRAIT(M,trait,trait_cause)

/datum/element/area_adds_trait/proc/remove_trait(datum/source,atom/movable/M)
    REMOVE_TRAIT(M,trait,trait_cause)