/datum/component/storage/concrete/emergency
	drop_all_on_break = TRUE
	unlock_on_break = TRUE
	locked = TRUE

/datum/component/storage/concrete/emergency/Initialize()
	. = ..()
	RegisterSignal(parent, COMSIG_ATOM_EMAG_ACT, .proc/unlock_me)

/datum/component/storage/concrete/emergency/signal_insertion_attempt(datum/source, obj/item/I, mob/M, silent = FALSE, force = FALSE)
	if(!silent && istype(I, /obj/item/card/emag))
		silent = TRUE // suppresses the message
	return ..()

/datum/component/storage/concrete/check_locked(datum/source, mob/user, message = FALSE)
	. = locked && GLOB.security_level < SEC_LEVEL_RED
	if(message && . && user)
		to_chat(user, "The storage unit will only unlock during a Red or Delta security alert.")

/datum/component/storage/concrete/emergency/proc/unlock_me(datum/source)
	if(locked)
		set_locked(source, FALSE)
