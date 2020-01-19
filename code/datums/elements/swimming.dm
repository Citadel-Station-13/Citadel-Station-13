/// Just for marking when someone's swimming.
/datum/element/swimming
	element_flags = ELEMENT_DETACH

/datum/element/swimming/Attach(datum/target)
	if(!isliving(target))
		return ELEMENT_INCOMPATIBLE
	if((. = ..()) == ELEMENT_INCOMPATIBLE)
		return
	RegisterSignal(target, COMSIG_IS_SWIMMING, .proc/is_swimming)
	RegisterSignal(target, COMSIG_MOVABLE_MOVED, .proc/check_valid)

/datum/element/swimming/Detach(datum/target)
	. = ..()
	UnregisterSignal(target, COMSIG_IS_SWIMMING)

/datum/element/swimming/proc/is_swimming()
	return IS_SWIMMING

/datum/element/swimming/proc/check_valid(datum/source)
	var/mob/living/L = source
	if(!istype(L.loc, /turf/open/pool))
		source.RemoveElement(/datum/elemtn/swimming)
