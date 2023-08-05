#define SHORT 4/5
#define TALL 5/4

///Very similar to squish, but for dwarves and shorties
/datum/element/dwarfism
	element_flags = ELEMENT_DETACH|ELEMENT_BESPOKE
	id_arg_index = 2
	var/comsig
	var/list/attached_targets = list()

/datum/element/dwarfism/Attach(datum/target, comsig, comsig_target)
	. = ..()
	if(!isliving(target))
		return ELEMENT_INCOMPATIBLE

	src.comsig = comsig

	var/mob/living/L = target
	if(L.lying != 0)
		L.transform = L.transform.Scale(SHORT, 1)
	else
		L.transform = L.transform.Scale(1, SHORT)
	attached_targets[target] = comsig_target
	RegisterSignal(target, comsig, .proc/check_loss) //Second arg of the signal will be checked against the comsig_target.

/datum/element/dwarfism/proc/check_loss(mob/living/L, comsig_target)
	if(attached_targets[L] == comsig_target)
		Detach(L)

/datum/element/dwarfism/Detach(mob/living/L)
	. = ..()
	attached_targets -= L
	UnregisterSignal(L, comsig)
	if(QDELETED(L))
		return
	if(L.lying != 0)
		L.transform = L.transform.Scale(TALL, 1)
	else
		L.transform = L.transform.Scale(1, TALL)
		L.transform = L.transform.Translate(0, 16*(TALL-1)) //Makes sure you stand on the tile no matter the size - sand

#undef SHORT
#undef TALL
