/mob/living/simple_animal/pet/bumbles
	name = "Bumbles"
	desc = "Bumbles, the very humble bumblebee."
	icon_state = "bumbles"
	icon_living = "bumbles"
	icon_dead = "bumbles_dead"
	turns_per_move = 1
	response_help_continuous = "pets"
	response_help_simple = "pet"
	response_disarm_continuous = "brushes aside"
	response_help_simple = "brush aside"
	response_harm_continuous = "squashes"
	response_harm_simple = "squash"
	speak_emote = list("buzzes")
	maxHealth = 100
	health = 100
	harm_intent_damage = 1
	friendly_verb_continuous = "bzzs"
	friendly_verb_simple = "bzz"
	density = FALSE
	movement_type = FLYING
	pass_flags = PASSTABLE | PASSGRILLE | PASSMOB
	mob_size = MOB_SIZE_TINY
	mob_biotypes = MOB_ORGANIC|MOB_BEAST
	gold_core_spawnable = FRIENDLY_SPAWN
	verb_say = "buzzs"
	verb_ask = "buzzes inquisitively"
	verb_exclaim = "buzzes intensely"
	verb_yell = "buzzes intensely"
	emote_see = list("buzzes.", "makes a loud buzz.", "rolls several times.", "buzzes happily.")
	speak_chance = 1
	unique_name = FALSE

/mob/living/simple_animal/pet/bumbles/Initialize()
	. = ..()
	add_verb(src, /mob/living/proc/lay_down)
	AddElement(/datum/element/ventcrawling, given_tier = VENTCRAWLER_ALWAYS)

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

/mob/living/simple_animal/pet/bumbles/handle_automated_movement()
	. = ..()
	if(!isturf(loc) || buckled)
		return
	if(!resting && prob(1))
		emote("me", EMOTE_VISIBLE, pick("curls up on the surface below ", "is looking very sleepy.", "buzzes softly ", "looks around for a flower nap "))
		set_resting(TRUE)
	else if (resting && prob(1))
		emote("me", EMOTE_VISIBLE, pick("wakes up with a smiling buzz.", "rolls upside down before waking up.", "stops resting."))
		set_resting(FALSE)

/mob/living/simple_animal/pet/bumbles/update_mobility()
	. = ..()
	if(stat != DEAD)
		if(!CHECK_MOBILITY(src, MOBILITY_STAND))
			icon_state = "[icon_living]_rest"
		else
			icon_state = "[icon_living]"
		regenerate_icons()
