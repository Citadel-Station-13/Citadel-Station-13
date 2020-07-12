// Process the predator's effects upon the contents of its belly (i.e digestion/transformation etc)
/obj/belly/proc/process_belly(var/times_fired,var/wait) //Passed by controller
	if((times_fired < next_process) || !length(contents))
		recent_sound = FALSE
		return SSBELLIES_IGNORED

	next_process = times_fired + (6 SECONDS/wait) //Set up our next process time.

	var/soundprob = 0
	switch(digest_mode)
		if(DM_HOLD)		//early exit
			return SSBELLIES_PROCESSED
		if(DM_NOISY)
			soundprob = 35
		if(DM_DIGEST)
			soundprob = 25
		if(DM_ABSORB)
			soundprob = 10
		if(DM_HEAL)
			soundprob = 25
		if(DM_DRAGON)
			soundprob = 55

	if(!length(contents - items_preserved))		// everything is handled, exit early
		return SSBELLIES_PROCESSED

	var/list/used_emote_list = emote_list[digest_mode]

	var/soundprob_met = prob(soundprob)
	var/panel_update = FALSE		// do we need to upadte our panel?
	var/sound/sound_to_play			// plays this at the end of the cycle to not need repetitive code

	var/emote = world.time >= next_emote
	if(emote)
		next_emote = times_fired + round(emote_time/wait,1)
	var/item_handled = FALSE

	for(var/i in contents)
		if(isitem(i))		// ITEM HANDLING
			if(item_handled)
				continue
			var/obj/item/I = i
			if((digest_mode != DM_DIGEST) && (digest_mode != DM_DRAGON))
				continue
			item_handled = TRUE
			if(istype(I, /obj/item/reagent_containers/food) || istype(I, /obj/item/organ))
				digest_item(I)
			continue
		// MOB HANDLING
		var/mob/living/L = i
		if(!istype(L))
			continue
		var/datum/component/vore/V = L.GetComponent(/datum/component/vore))
		if(!V)
			release_specific_contents(L, TRUE)
			continue		// WHY ARE THEY IN US?

		/// First, refresh prey loop.
		if((world.time > V.next_preyloop) && (is_wet && wet_loop))
			V.refresh_preyloop()

		/// Handle absorption
		if(V.vore_flags & ABSORBED)
			L.Stun(5)

		/// Handle digest mode
		switch(digest_mode)
			if(DM_DIGEST)
				if(HAS_TRAIT(owner, TRAIT_PACIFISM))
					digest_mode = DM_NOISY
					return

				// play sound
				if(soundprob_met)
					if(L.client?.prefs.cit_toggles & DIGESTION_NOISES)
						SEND_SOUND(L, parent.sound_prey_digest)
						sound_to_play = parent.sound_pred_digest

				// pref/absorb check
				if(!(V.vore_flags & DIGESTABLE) || (V.vore_flags & ABSORBED))
					continue

				to_chat(L,"<span class='notice'>[pick(used_emote_list)]</span>")

				// person died
				if(L.stat == DEAD)
					var/digest_alert_owner = pick(digest_messages_owner)
					var/digest_alert_prey = pick(digest_messages_prey)

					//Replace placeholder vars
					digest_alert_owner = replacetext(digest_alert_owner,"%pred", owner)
					digest_alert_owner = replacetext(digest_alert_owner,"%prey", L)
					digest_alert_owner = replacetext(digest_alert_owner,"%belly", lowertext(name))

					digest_alert_prey = replacetext(digest_alert_prey,"%pred", owner)
					digest_alert_prey = replacetext(digest_alert_prey,"%prey", L)
					digest_alert_prey = replacetext(digest_alert_prey,"%belly", lowertext(name))

					//Send messages
					to_chat(owner, "<span class='warning'>[digest_alert_owner]</span>")
					to_chat(L, "<span class='warning'>[digest_alert_prey]</span>")
					owner.visible_message("<span class='notice'>You watch as [owner]'s form loses its additions.</span>")
					owner.adjust_nutrition(400) // so eating dead mobs gives you *something*.
					sound_to_play = parent.sound_pred_death
					if(L.client?.prefs.cit_toggles & DIGESTION_NOISES)
						SEND_SOUND(L, prey_death)
					L.stop_sound_channel(CHANNEL_PREYLOOP)
					digestion_death(L)
					owner.update_icons()
					panel_update = TRUE
					continue

				// Deal digestion damage (and feed the pred)
				if(!(L.status_flags & GODMODE))
					L.adjustFireLoss(digest_burn)
					owner.adjust_nutrition(1)

			if(DM_HEAL)
				if(soundprob_met)
					if(L.client?.prefs.cit_toggles & DIGESTION_NOISES)
						SEND_SOUND(L, parent.prey_digest)
					sound_to_play = parent.pred_digest
				if(L.stat != DEAD)
					if(owner.nutrition >= NUTRITION_LEVEL_STARVING && (L.health < L.maxHealth))
						L.adjustBruteLoss(-3)
						L.adjustFireLoss(-3)
						owner.adjust_nutrition(-5)

			if(DM_NOISY)
				if(soundprob_met)
					if(L.client?.prefs.cit_toggles & DIGESTION_NOISES)
						SEND_SOUND(L, parent.prey_digest)
					sound_to_play = parent.pred_digest

			if(DM_ABSORB)
				if(L.vore_flags & ABSORBED)
					continue
				if(soundprob_met)
					if(L.client?.prefs.cit_toggles & DIGESTION_NOISES)
						SEND_SOUND(L, parent.prey_digest)
					sound_to_play = parent.prey_digest
				if(L.nutrition >= 100) //Drain them until there's no nutrients left. Slowly "absorb" them.
					var/oldnutrition = (L.nutrition * 0.05)
					M.set_nutrition(L.nutrition * 0.95)
					owner.adjust_nutrition(oldnutrition)
				else if(L.nutrition < 100) //When they're finally drained.
					absorb_living(L)
					panel_update = TRUE

			if(DM_UNABSORB)
				if((V.vore_flags & ABSORBED) && (owner.nutrition >= 100))
					V.vore_flags &= ~ABSORBED
					to_chat(L,"<span class='notice'>You suddenly feel solid again </span>")
					to_chat(owner,"<span class='notice'>You feel like a part of you is missing.</span>")
					owner.adjust_nutrition(-100)
					update_panel = TRUE

		//because dragons need snowflake guts
			if(DM_DRAGON)
				if(HAS_TRAIT(owner, TRAIT_PACIFISM)) //imagine var editing this when you're a pacifist. smh
					digest_mode = DM_NOISY
					return
				if(soundprob_met)
					if(L.client?.prefs.cit_toggles & DIGESTION_NOISES)
						SEND_SOUND(L, parent.sound_prey_digest)
					sound_to_play = parent.sound_pred_digest

			//No digestion protection for megafauna. // no.
				if(!(V.vore_flags & DIGESTABLE))
					release_specific_contents(L)

			//Person just died in guts!
				if(L.stat == DEAD)
					var/digest_alert_owner = pick(digest_messages_owner)
					var/digest_alert_prey = pick(digest_messages_prey)

					//Replace placeholder vars
					digest_alert_owner = replacetext(digest_alert_owner,"%pred", owner)
					digest_alert_owner = replacetext(digest_alert_owner,"%prey", L)
					digest_alert_owner = replacetext(digest_alert_owner,"%belly", lowertext(name))

					digest_alert_prey = replacetext(digest_alert_prey,"%pred", owner)
					digest_alert_prey = replacetext(digest_alert_prey,"%prey", L)
					digest_alert_prey = replacetext(digest_alert_prey,"%belly", lowertext(name))

					//Send messages
					to_chat(owner, "<span class='warning'>[digest_alert_owner]</span>")
					to_chat(L, "<span class='warning'>[digest_alert_prey]</span>")
					L.visible_message("<span class='notice'>You watch as [owner]'s guts loudly rumble as it finishes off a meal.</span>")
					sound_to_play = parent.pred_death
					if(L.client?.prefs.cit_toggles & DIGESTION_NOISES)
						SEND_SOUND(L, parent.prey_death)
					L.spill_organs(FALSE, TRUE, TRUE)
					L.stop_sound_channel(CHANNEL_PREYLOOP)
					digestion_death(L)
					owner.update_icons()
					panel_update = TRUE
					continue

				// Deal digestion damage (and feed the pred)
				if(!(L.status_flags & GODMODE))
					L.adjustFireLoss(digest_burn)
					L.adjustToxLoss(2) // something something plasma based acids
					L.adjustCloneLoss(1) // eventually this'll kill you if you're healing everything else, you nerds.

	/////////////////////////// Make any noise ///////////////////////////
	if(sound_to_play)
		if((world.time + NORMIE_HEARCHECK) > last_hearcheck)
			LAZYCLEARLIST(hearing_mobs)
			for(var/mob/M in hearers(VORE_SOUND_RANGE, owner))
				if(!M.client?.prefs.cit_toggles & DIGESTION_NOISES))
					continue
				LAZYADD(hearing_mobs, L)
				last_hearcheck = world.time
		for(var/mob/M in hearing_mobs) //so we don't fill the whole room with the sound effect
			if(!M.client || (M.loc == src))
				continue
			SEND_SOUND(M, sound_to_play)
				//these are all external sound triggers now, so it's ok.
	if(panel_update)
		for(var/mob/living/M in contents)
			SEND_SIGNAL(M, COMSIG_VORE_UPDATE_PANEL)
		parent.update_vore_panel(src)
	return SSBELLIES_PROCESSED
