
/datum/element/wuv //D'awwwww
	element_flags = ELEMENT_BESPOKE|ELEMENT_DETACH
	id_arg_index = 2
	//the for the me emote proc call when petted.
	var/pet_emote
	//whether the emote is visible or audible
	var/pet_type
	//same as above, except when harmed. "You are going into orbit, you stupid mutt!"
	var/punt_emote
	//same as pet_type
	var/punt_type
	//mood typepath for the moodlet signal when petted.
	var/pet_moodlet
	//same as above but for harm
	var/punt_moodlet

/datum/element/wuv/Attach(datum/target, pet, pet_t, pet_mood, punt, punt_t, punt_mood)
	. = ..()

	if(!isliving(target))
		return ELEMENT_INCOMPATIBLE

	pet_emote = pet
	pet_type = pet_t
	punt_emote = punt
	punt_type = punt_t
	pet_moodlet = pet_mood
	punt_moodlet = punt_mood

	RegisterSignal(target, COMSIG_MOB_ATTACK_HAND, PROC_REF(on_attack_hand))

/datum/element/wuv/Detach(datum/source, force)
	. = ..()
	UnregisterSignal(source, COMSIG_MOB_ATTACK_HAND)

/datum/element/wuv/proc/on_attack_hand(datum/source, mob/user, act_intent)
	var/mob/living/L = source

	if(L.stat == DEAD)
		return
	//we want to delay the effect to be displayed after the mob is petted, not before.
	switch(act_intent)
		if(INTENT_HARM)
			addtimer(CALLBACK(src, PROC_REF(kick_the_dog), source, user), 1)
		if(INTENT_HELP)
			addtimer(CALLBACK(src, PROC_REF(pet_the_dog), source, user), 1)

/datum/element/wuv/proc/pet_the_dog(mob/target, mob/user)
	if(QDELETED(target) || QDELETED(user) || target.stat != CONSCIOUS)
		return
	new /obj/effect/temp_visual/heart(target.loc)
	if(pet_emote)
		target.emote("me", pet_type, pet_emote)
	if(pet_moodlet && !(target.flags_1 & HOLOGRAM_1)) //prevents unlimited happiness petting park exploit.
		SEND_SIGNAL(user, COMSIG_ADD_MOOD_EVENT, target, pet_moodlet, target)

/datum/element/wuv/proc/kick_the_dog(mob/target, mob/user)
	if(QDELETED(target) || QDELETED(user) || target.stat != CONSCIOUS)
		return
	if(punt_emote)
		target.emote("me", punt_type, punt_emote)
	if(punt_moodlet && !(target.flags_1 & HOLOGRAM_1))
		SEND_SIGNAL(user, COMSIG_ADD_MOOD_EVENT, target, punt_moodlet, target)
