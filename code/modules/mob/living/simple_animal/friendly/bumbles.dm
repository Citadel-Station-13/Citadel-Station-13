/mob/living/simple_animal/pet/bumbles
	name = "Bumbles"
	desc = "Bumbles, the very humble bumblebee."
	icon_state = "bumbles"
	icon_living = "bumbles"
	icon_dead = "bumbles_dead"
	turns_per_move = 1
	response_help = "pets"
	response_disarm = "brushes aside"
	response_harm = "squashes"
	speak_emote = list("bzzes")
	maxHealth = 100
	health = 100
	harm_intent_damage = 1
	friendly = "bzzs"
	density = FALSE
	movement_type = FLYING
	pass_flags = PASSTABLE | PASSGRILLE | PASSMOB
	ventcrawler = VENTCRAWLER_ALWAYS
	mob_size = MOB_SIZE_TINY
	mob_biotypes = MOB_ORGANIC|MOB_BEAST
	gold_core_spawnable = FRIENDLY_SPAWN
	verb_say = "bzzs"
	verb_ask = "bzzes inquisitively"
	verb_exclaim = "bzzes intensely"
	verb_yell = "bzzes intensely"

/mob/living/simple_animal/pet/bumbles/Initialize()
	. = ..()
	verbs += /mob/living/proc/lay_down

/mob/living/simple_animal/pet/bumbles/ComponentInitialize()
	. = ..()
	AddElement(/datum/element/wuv, "bzzs!")

/mob/living/simple_animal/pet/bumbles/update_mobility()
	. = ..()
	if(client && stat != DEAD)
		if (resting)
			icon_state = "[icon_living]_rest"
		else
			icon_state = "[icon_living]"
	regenerate_icons()

/mob/living/simple_animal/pet/bumbles/bee_friendly()
	return TRUE //treaty signed at the Beeneeva convention

/mob/living/simple_animal/pet/bumbles/Life()
	if(!stat && !buckled && !client)
		if(prob(1))
			emote("me", EMOTE_VISIBLE, pick("curls up on the surface below ", "is looking very sleepy.", "buzzes softly ", "looks around for a flower nap "))
			icon_state = "[icon_living]_rest"
			collar_type = "[initial(collar_type)]_rest"
			set_resting(TRUE)
		else if (prob(1))
			if (resting)
				emote("me", EMOTE_VISIBLE, pick("wakes up with a smiling buzz.", "rolls upside down before waking up.", "stops resting."))
				icon_state = "[icon_living]"
				collar_type = "[initial(collar_type)]"
				set_resting(FALSE)
			else
				emote("me", EMOTE_VISIBLE, pick("buzzes.", "makes a loud buzz.", "rolls several times.", "buzzes happily "))