// Citadel-specific Neutral Traits

/datum/quirk/libido
	name = "Nymphomania"
	desc = "You're always feeling a bit in heat. Also, you get aroused faster than usual."
	value = 0
	mob_trait = TRAIT_NYMPHO
	gain_text = "<span class='notice'>You are feeling extra wild.</span>"
	lose_text = "<span class='notice'>You don't feel that burning sensation anymore.</span>"

/datum/quirk/libido/add()
	var/mob/living/M = quirk_holder
	M.min_arousal = 16
	M.arousal_rate = 3

/datum/quirk/libido/remove()
	var/mob/living/M = quirk_holder
	M.min_arousal = initial(M.min_arousal)
	M.arousal_rate = initial(M.arousal_rate)

/datum/quirk/libido/on_process()
	var/mob/living/M = quirk_holder
	if(M.canbearoused == FALSE)
		to_chat(quirk_holder, "<span class='notice'>Having high libido is useless when you can't feel arousal at all!</span>")
		qdel(src)

/datum/quirk/maso
	name = "Masochism"
	desc = "You are aroused by pain."
	value = 0
	mob_trait = TRAIT_MASO
	gain_text = "<span class='notice'>You desire to be hurt.</span>"
	lose_text = "<span class='notice'>Pain has become less exciting for you.</span>"

/datum/quirk/pharmacokinesis //Prevents unwanted organ additions.
	name = "Acute hepatic pharmacokinesis"
	desc = "You've a rare genetic disorder that causes Incubus draft and Sucubus milk to be absorbed by your liver instead."
	value = 0
	mob_trait = TRAIT_PHARMA
	lose_text = "<span class='notice'>Your liver feels different.</span>"
	var/active = FALSE
	var/power = 0
	var/cachedmoveCalc = 1
