//Strained Muscles: Temporary speed boost at the cost of rapid damage
//Limited because of hardsuits and such; ideally, used for a quick getaway

/datum/action/changeling/strained_muscles
	name = "Strained Muscles"
	desc = "We evolve the ability to reduce the acid buildup in our muscles, allowing us to move much faster."
	helptext = "The strain will make us tired, and we will rapidly become fatigued. Standard weight restrictions, like hardsuits, still apply. Our chemical generation is drastically slowed while this is active. Cannot be used in lesser form."
	button_icon_state = "strained_muscles"
	dna_cost = 1
	req_human = TRUE
	var/stacks = 0 //Increments every 5 seconds; damage increases over time
	active = FALSE //Whether or not you are a hedgehog

/datum/action/changeling/strained_muscles/sting_action(mob/living/carbon/user)
	..()
	var/datum/antagonist/changeling/changeling = user.mind.has_antag_datum(/datum/antagonist/changeling)
	active = !active
	if(active)
		to_chat(user, "<span class='notice'>Our muscles tense and strengthen.</span>")
		changeling.chem_recharge_slowdown += 0.8 // stacking this with other abilities will cause you to actively lose chemicals
	else
		user.remove_movespeed_modifier(/datum/movespeed_modifier/strained_muscles)
		to_chat(user, "<span class='notice'>Our muscles relax.</span>")
		changeling.chem_recharge_slowdown -= 0.8
		if(stacks >= 10)
			to_chat(user, "<span class='danger'>We collapse in exhaustion.</span>")
			user.DefaultCombatKnockdown(60)
			user.emote("gasp")

	INVOKE_ASYNC(src, PROC_REF(muscle_loop), user)

	return TRUE

/datum/action/changeling/strained_muscles/proc/muscle_loop(mob/living/carbon/user)
	var/datum/antagonist/changeling/changeling = user.mind.has_antag_datum(/datum/antagonist/changeling)
	while(active)
		user.add_movespeed_modifier(/datum/movespeed_modifier/strained_muscles)
		if(user.stat != CONSCIOUS || user.staminaloss >= 90)
			active = !active
			to_chat(user, "<span class='notice'>Our muscles relax without the energy to strengthen them.</span>")
			user.DefaultCombatKnockdown(40)
			user.remove_movespeed_modifier(/datum/movespeed_modifier/strained_muscles)
			changeling.chem_recharge_slowdown -= 0.8
			break

		stacks++
		//user.take_bodypart_damage(stacks * 0.03, 0)
		user.adjustStaminaLoss(stacks*1.5) //At first the changeling may regenerate stamina fast enough to nullify fatigue, but it will stack

		if(stacks == 5) //Warning message that the stacks are getting too high
			to_chat(user, "<span class='warning'>Our legs are really starting to hurt...</span>")

		sleep(40)

	while(!active && stacks) //Damage stacks decrease slowly while not in sanic mode
		stacks--
		sleep(100)
