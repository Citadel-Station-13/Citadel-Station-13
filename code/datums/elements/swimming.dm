/// Just for marking when someone's swimming.
/datum/element/swimming
	element_flags = ELEMENT_DETACH

/datum/element/swimming/Attach(datum/target)
	if((. = ..()) == ELEMENT_INCOMPATIBLE)
		return
	if(!isliving(target))
		return ELEMENT_INCOMPATIBLE
	RegisterSignal(target, COMSIG_MOVABLE_MOVED, PROC_REF(check_valid))
	ADD_TRAIT(target, TRAIT_SWIMMING, TRAIT_SWIMMING)		//seriously there's only one way to get this

/datum/element/swimming/Detach(datum/target)
	. = ..()
	UnregisterSignal(target, COMSIG_MOVABLE_MOVED)
	REMOVE_TRAIT(target, TRAIT_SWIMMING, TRAIT_SWIMMING)

/datum/element/swimming/proc/check_valid(datum/source)
	var/mob/living/L = source
	if(!istype(L.loc, /turf/open/pool))
		source.RemoveElement(/datum/element/swimming)
