//funniest shit i've ever seen

/mob/living/simple_animal/pickle
	name = "pickle"
	desc = "It's a pickle. It might just be the funniest thing you have ever seen."
	health = 100
	maxHealth = 100
	icon = 'icons/mob/32x64.dmi'
	icon_state = "pickle"
	del_on_death = TRUE
	deathmessage = "The pickle implodes into its own existential dread and disappears!"
	friendly_verb_continuous = "tickles"
	friendly_verb_simple = "tickle"
	var/mob/living/original_body

/mob/living/simple_animal/pickle/UnarmedAttack(atom/A)
	..() //we want the tickle emote to go before the laugh
	if(ismob(A))
		var/mob/laugher = A
		laugher.emote("laugh")

/mob/living/simple_animal/pickle/Destroy(force, kill_body = TRUE)
	if(original_body)
		if(kill_body)
			original_body.adjustOrganLoss(ORGAN_SLOT_BRAIN, 200) //to be fair, you have to have a very high iq to understand-
		original_body.forceMove(get_turf(src))
		if(mind)
			mind.transfer_to(original_body)
	..()
