//Strained Muscles: Temporary speed boost at the cost of rapid damage
//Limited because of hardsuits and such; ideally, used for a quick getaway

/obj/effect/proc_holder/changeling/strained_muscles
	name = "Strained Muscles"
	desc = "We evolve the ability to reduce the acid buildup in our muscles, allowing us to move much faster."
	helptext = "The strain will make us tired, and we will rapidly become fatigued. Standard weight restrictions, like hardsuits, still apply. Cannot be used in lesser form."
	dna_cost = 1
	req_human = 1
	var/stacks = 0 //Increments every 5 seconds; damage increases over time
	active = 0 //Whether or not you are a hedgehog
	action_icon = 'icons/obj/implants.dmi'
	action_icon_state = "adrenal"
	action_background_icon_state = "bg_ling"

/obj/effect/proc_holder/changeling/strained_muscles/sting_action(mob/living/carbon/user)
	active = !active
	if(active)
		to_chat(user, "<span class='notice'>Our muscles tense and strengthen.</span>")
	else
		user.remove_movespeed_modifier(/datum/movespeed_modifier/strained_muscles)
		to_chat(user, "<span class='notice'>Our muscles relax.</span>")
		if(stacks >= 10)
			to_chat(user, "<span class='danger'>We collapse in exhaustion.</span>")
			user.DefaultCombatKnockdown(60)
			user.emote("gasp")

	INVOKE_ASYNC(src, .proc/muscle_loop, user)

	return TRUE

/obj/effect/proc_holder/changeling/strained_muscles/proc/muscle_loop(mob/living/carbon/user)
	while(active)
		user.add_movespeed_modifier(/datum/movespeed_modifier/strained_muscles)
		if(user.stat != CONSCIOUS || user.staminaloss >= 90)
			active = !active
			to_chat(user, "<span class='notice'>Our muscles relax without the energy to strengthen them.</span>")
			user.DefaultCombatKnockdown(40)
			user.remove_movespeed_modifier(/datum/movespeed_modifier/strained_muscles)
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
