// For full modularity, a lot of these are on the component itself rather than the mob, and we use black magic to make it work.
/datum/component/vore/proc/verb_preyloop_refresh()
	set name = "Internal loop refresh"
	set category = "Vore"
	SEND_SIGNAL(usr, COMSIG_VORE_REFRESH_PREYLOOP, TRUE)

/// SRC in this case will be the living mob parent!
/datum/component/vore/proc/verb_ooc_escape()
	set name = "OOC Escape"
	set category = "Vore"
	SEND_SIGNAL(usr, COMSIG_VORE_OOC_ESCAPE, TRUE)
