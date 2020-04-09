/datum/component/storage/concrete/emergency
	drop_all_on_break = TRUE
	unlock_on_break = TRUE
	locked = TRUE

/datum/component/storage/concrete/emergency/Initialize()
	. = ..()
	RegisterSignal(parent, COMSIG_ATOM_EMAG_ACT, .proc/unlock_me)

/datum/component/storage/concrete/emergency/on_attack_hand(datum/source, mob/user)
	var/atom/A = parent
	if(!attack_hand_interact)
		return
	if(user.active_storage == src && A.loc == user) //if you're already looking inside the storage item
		user.active_storage.close(user)
		close(user)
		. = COMPONENT_NO_ATTACK_HAND
		return
	. = COMPONENT_NO_ATTACK_HAND
	if(!check_locked(source, user, TRUE))
		ui_show(user)
		A.do_jiggle()
		if(rustle_sound)
			playsound(A, "rustle", 50, 1, -5)

/datum/component/storage/concrete/emergency/signal_insertion_attempt(datum/source, obj/item/I, mob/M, silent = FALSE, force = FALSE)
	if(!silent && istype(I, /obj/item/card/emag))
		silent = TRUE // suppresses the message
	return ..()

/datum/component/storage/concrete/emergency/check_locked(datum/source, mob/user, message = FALSE)
	. = locked && GLOB.security_level < SEC_LEVEL_RED
	if(message && . && user)
		to_chat(user, "The storage unit will only unlock during a Red or Delta security alert.")

/datum/component/storage/concrete/emergency/proc/unlock_me(datum/source)
	if(locked)
		set_locked(source, FALSE)
		return TRUE
