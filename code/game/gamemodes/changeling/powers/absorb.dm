/obj/effect/proc_holder/changeling/absorbDNA
	name = "Absorb DNA"
	desc = "Absorb the DNA of our victim."
	chemical_cost = 0
	dna_cost = 0
	req_human = 1
	max_genetic_damage = 100

/obj/effect/proc_holder/changeling/absorbDNA/can_sting(mob/living/carbon/user)
	if(!..())
		return

	var/datum/changeling/changeling = user.mind.changeling
	if(changeling.isabsorbing)
		user << "<span class='warning'>We are already absorbing!</span>"
		return

	if(!user.pulling || !iscarbon(user.pulling))
		user << "<span class='warning'>We must be grabbing a creature to absorb them!</span>"
		return
	if(user.grab_state <= GRAB_NECK)
		user << "<span class='warning'>We must have a tighter grip to absorb this creature!</span>"
		return

	var/mob/living/carbon/target = user.pulling
	return changeling.can_absorb_dna(user,target)



/obj/effect/proc_holder/changeling/absorbDNA/sting_action(mob/user)
	var/datum/changeling/changeling = user.mind.changeling
	var/mob/living/carbon/human/target = user.pulling
	changeling.isabsorbing = 1
	for(var/stage = 1, stage<=3, stage++)
		switch(stage)
			if(1)
				user << "<span class='notice'>This creature is compatible. We must hold still...</span>"
			if(2)
				user.visible_message("<span class='warning'>[user] extends a proboscis!</span>", "<span class='notice'>We extend a proboscis.</span>")
			if(3)
				user.visible_message("<span class='danger'>[user] stabs [target] with the proboscis!</span>", "<span class='notice'>We stab [target] with the proboscis.</span>")
				target << "<span class='userdanger'>You feel a sharp stabbing pain!</span>"
				target.take_overall_damage(40)

		feedback_add_details("changeling_powers","A[stage]")
		if(!do_mob(user, target, 150))
			user << "<span class='warning'>Our absorption of [target] has been interrupted!</span>"
			changeling.isabsorbing = 0
			return

	user.visible_message("<span class='danger'>[user] sucks the fluids from [target]!</span>", "<span class='notice'>We have absorbed [target].</span>")
	target << "<span class='userdanger'>You are absorbed by the changeling!</span>"

	if(!changeling.has_dna(target.dna))
		changeling.add_new_profile(target, user)

	if(user.nutrition < NUTRITION_LEVEL_WELL_FED)
		user.nutrition = min((user.nutrition + target.nutrition), NUTRITION_LEVEL_WELL_FED)

	if(target.mind)//if the victim has got a mind

		target.mind.show_memory(user, 0) //I can read your mind, kekeke. Output all their notes.

		//Some of target's recent speech, so the changeling can attempt to imitate them better.
		//Recent as opposed to all because rounds tend to have a LOT of text.
		var/list/recent_speech = list()

		if(target.say_log.len > LING_ABSORB_RECENT_SPEECH)
			recent_speech = target.say_log.Copy(target.say_log.len-LING_ABSORB_RECENT_SPEECH+1,0) //0 so len-LING_ARS+1 to end of list
		else
			for(var/spoken_memory in target.say_log)
				if(recent_speech.len >= LING_ABSORB_RECENT_SPEECH)
					break
				recent_speech += spoken_memory

		if(recent_speech.len)
			user.mind.store_memory("<B>Some of [target]'s speech patterns, we should study these to better impersonate them!</B>")
			user << "<span class='boldnotice'>Some of [target]'s speech patterns, we should study these to better impersonate them!</span>"
			for(var/spoken_memory in recent_speech)
				user.mind.store_memory("\"[spoken_memory]\"")
				user << "<span class='notice'>\"[spoken_memory]\"</span>"
			user.mind.store_memory("<B>We have no more knowledge of [target]'s speech patterns.</B>")
			user << "<span class='boldnotice'>We have no more knowledge of [target]'s speech patterns.</span>"

		if(target.mind.changeling)//If the target was a changeling, suck out their extra juice and objective points!
			changeling.chem_charges += min(target.mind.changeling.chem_charges, changeling.chem_storage)
			changeling.absorbedcount += (target.mind.changeling.absorbedcount)

			target.mind.changeling.stored_profiles.len = 1
			target.mind.changeling.absorbedcount = 0


	changeling.chem_charges=min(changeling.chem_charges+10, changeling.chem_storage)

	changeling.isabsorbing = 0
	changeling.canrespec = 1

	target.death(0)
	target.Drain()
	return 1



//Absorbs the target DNA.
//datum/changeling/proc/absorb_dna(mob/living/carbon/T, mob/user)

//datum/changeling/proc/store_dna(datum/dna/new_dna, mob/user)




/obj/effect/proc_holder/changeling/swap_form
	name = "Swap Forms"
	desc = "We force ourselves into the body of another form, pushing their consciousness into the form we left behind."
	helptext = "We will bring all our abilities with us, but we will lose our old form DNA in exchange for the new one. The process will seem suspicious to any observers."
	chemical_cost = 40
	dna_cost = 1
	req_human = 1 //Monkeys can't grab

/obj/effect/proc_holder/changeling/swap_form/can_sting(mob/living/carbon/user)
	if(!..())
		return
	if(!user.pulling || !iscarbon(user.pulling) || user.grab_state < GRAB_AGGRESSIVE)
		user << "<span class='warning'>We must have an aggressive grab on creature to do this!</span>"
		return
	var/mob/living/carbon/target = user.pulling
	if((target.disabilities & NOCLONE) || (target.disabilities & HUSK))
		user << "<span class='warning'>DNA of [target] is ruined beyond usability!</span>"
		return
	if(!ishuman(target))
		user << "<span class='warning'>[target] is not compatible with this ability.</span>"
		return
	return 1


/obj/effect/proc_holder/changeling/swap_form/sting_action(mob/living/carbon/user)
	var/mob/living/carbon/target = user.pulling
	var/datum/changeling/changeling = user.mind.changeling

	user << "<span class='notice'>We tighen our grip. We must hold still....</span>"
	target.do_jitter_animation(500)
	user.do_jitter_animation(500)

	if(!do_mob(user,target,20))
		user << "<span class='warning'>The body swap has been interrupted!</span>"
		return

	target << "<span class='userdanger'>[user] tightens their grip as a painful sensation invades your body.</span>"

	if(!changeling.has_dna(target.dna))
		changeling.add_new_profile(target, user)
	changeling.remove_profile(user)

	var/mob/dead/observer/ghost = target.ghostize(0)
	user.mind.transfer_to(target)
	if(ghost)
		ghost.mind.transfer_to(user)
		if(ghost.key)
			user.key = ghost.key

	user.Paralyse(2)
	target << "<span class='warning'>Our genes cry out as we swap our [user] form for [target].</span>"
