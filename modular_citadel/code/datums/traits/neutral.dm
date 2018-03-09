// Citadel-specific Neutral Traits

/datum/trait/libido
	name = "Nymphomania"
	desc = "You're always feeling a bit in heat. Also, you get aroused faster than usual."
	value = 0
	gain_text = "<span class='notice'>You are feeling extra wild.</span>"
	lose_text = "<span class='notice'>You don't feel that burning sensation anymore.</span>"

/datum/trait/libido/add()
	var/mob/living/M = trait_holder
	M.min_arousal = 16
	M.arousal_rate = 3

/datum/trait/libido/remove()
	var/mob/living/M = trait_holder
	M.min_arousal = initial(M.min_arousal)
	M.arousal_rate = initial(M.arousal_rate)

/datum/trait/libido/on_process()
	var/mob/living/M = trait_holder
	if(M.canbearoused == FALSE)
		to_chat(trait_holder, "<span class='notice'>Having high libido is useless when you can't feel arousal at all!</span>")
		qdel(src)
