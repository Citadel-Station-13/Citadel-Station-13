/datum/component/riding/human/Initialize()
	. = ..()
	RegisterSignal(parent, COMSIG_ATOM_DIR_CHANGE, .proc/update_dir)

/datum/component/riding/human/proc/update_dir(mob/source, dir, newdir)
	var/mob/living/carbon/human/H = source
	for(var/mob/living/L in H.buckled_mobs)
		L.setDir(newdir)
