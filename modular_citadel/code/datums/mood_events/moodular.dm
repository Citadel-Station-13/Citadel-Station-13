// Modular stuff to use with Citadel-specific moods.

// box of hugs
/obj/item/storage/box/hug/attack_self(mob/user)
	. = ..()
	SEND_SIGNAL(user, COMSIG_ADD_MOOD_EVENT,"hugbox", /datum/mood_event/hugbox)

//Removed headpats here, duplicate code?

// plush petting
/obj/item/toy/plush/attack_self(mob/user)
	. = ..()
	if(stuffed || grenade)
		SEND_SIGNAL(user, COMSIG_ADD_MOOD_EVENT,"plushpet", /datum/mood_event/plushpet)
	else
		SEND_SIGNAL(user, COMSIG_ADD_MOOD_EVENT,"plush_nostuffing", /datum/mood_event/plush_nostuffing)

// Jack the Ripper starring plush
/obj/item/toy/plush/attackby(obj/item/I, mob/living/user, params)
	. = ..()
	if(I.is_sharp())
		if(!grenade)
			SEND_SIGNAL(user, COMSIG_ADD_MOOD_EVENT,"plushjack", /datum/mood_event/plushjack)

// plush playing (plush-on-plush action)
	if(istype(I, /obj/item/toy/plush))
		SEND_SIGNAL(user, COMSIG_ADD_MOOD_EVENT,"plushplay", /datum/mood_event/plushplay)
