//Hulk turns your skin green, and allows you to punch through walls.
/datum/mutation/human/hulk
	name = "Hulk"
	desc = "A poorly understood genome that causes the holder's muscles to expand, inhibit speech and gives the person a bad skin condition."
	quality = POSITIVE
	locked = TRUE
	difficulty = 16
	text_gain_indication = "<span class='notice'>Your muscles hurt!</span>"
	species_allowed = list("fly")
	health_req = 25
	synchronizer_coeff = 1
	instability = 40

/datum/mutation/human/hulk/on_acquiring(mob/living/carbon/human/owner)
	if(..())
		return
	ADD_TRAIT(owner, TRAIT_STUNIMMUNE, GENETIC_MUTATION)
	ADD_TRAIT(owner, TRAIT_PUSHIMMUNE, GENETIC_MUTATION)
	owner.update_body_parts()
	if(IS_GENETIC_MUTATION(src))
		SEND_SIGNAL(owner, COMSIG_ADD_MOOD_EVENT, "hulk", /datum/mood_event/hulk)

/datum/mutation/human/hulk/on_attack_hand(atom/target, proximity)
	if(proximity) //no telekinetic hulk attack
		return target.attack_hulk(owner)

/datum/mutation/human/hulk/on_life()
	if(owner.InCritical() || (IS_GENETIC_MUTATION(src) && !IS_MUT_SYNCHRONIZED(src) && prob(GET_DNA_INSTABILITY(dna) * 0.008)))
		on_losing(owner)
		to_chat(owner, "<span class='danger'>You suddenly feel very weak.</span>")

/datum/mutation/human/hulk/on_losing(mob/living/carbon/human/owner)
	if(..())
		return
	REMOVE_TRAIT(owner, TRAIT_STUNIMMUNE, GENETIC_MUTATION)
	REMOVE_TRAIT(owner, TRAIT_PUSHIMMUNE, GENETIC_MUTATION)
	owner.update_body_parts()
	SEND_SIGNAL(owner, COMSIG_CLEAR_MOOD_EVENT, "hulk")


/datum/mutation/human/hulk/say_mod(message)
	if(message)
		message = "[uppertext(replacetext(message, ".", "!"))]!!"
	return message
