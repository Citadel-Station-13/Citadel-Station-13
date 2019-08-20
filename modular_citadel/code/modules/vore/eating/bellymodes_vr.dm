// Process the predator's effects upon the contents of its belly (i.e digestion/transformation etc)
/obj/belly/proc/process_belly(var/times_fired,var/wait) //Passed by controller
	if((times_fired < next_process) || !contents.len)
		recent_sound = FALSE
		return SSBELLIES_IGNORED

	if(!owner)
		qdel(src)
		SSbellies.belly_list -= src
		return SSBELLIES_PROCESSED

	if(loc != owner)
		if(isliving(owner)) //we don't have machine based bellies. (yet :honk:)
			forceMove(owner)
		else
			SSbellies.belly_list -= src
			qdel(src)
			return SSBELLIES_PROCESSED

	next_process = times_fired + (6 SECONDS/wait) //Set up our next process time.

/////////////////////////// Auto-Emotes ///////////////////////////
	if(contents.len && next_emote <= times_fired)
		next_emote = times_fired + round(emote_time/wait,1)
		var/list/EL = emote_lists[digest_mode]
		for(var/mob/living/M in contents)
			if(M.digestable || !(digest_mode == DM_DIGEST)) // don't give digesty messages to indigestible people
				to_chat(M,"<span class='notice'>[pick(EL)]</span>")

///////////////////// Prey Loop Refresh/hack //////////////////////
	for(var/mob/living/M in contents)
		if(isbelly(M.loc))
			if(world.time > M.next_preyloop)
				if(is_wet)
					if(!M.client)
						continue
					M.stop_sound_channel(CHANNEL_PREYLOOP) // sanity just in case
					if(M.client.prefs.cit_toggles & DIGESTION_NOISES)
						var/sound/preyloop = sound('sound/vore/prey/loop.ogg', repeat = TRUE)
						M.playsound_local(get_turf(src),preyloop, 80,0, channel = CHANNEL_PREYLOOP)
						M.next_preyloop = (world.time + 52 SECONDS)


/////////////////////////// Exit Early ////////////////////////////
	var/list/touchable_items = contents - items_preserved
	if(!length(touchable_items))
		return SSBELLIES_PROCESSED

//////////////////////// Absorbed Handling ////////////////////////
	for(var/mob/living/M in contents)
		if(M.absorbed)
			M.Stun(5)

////////////////////////// Sound vars /////////////////////////////
	var/sound/prey_digest = sound(get_sfx("digest_prey"))
	var/sound/prey_death = sound(get_sfx("death_prey"))
	var/sound/pred_digest = sound(get_sfx("digest_pred"))
	var/sound/pred_death = sound(get_sfx("death_pred"))
	var/turf/source = get_turf(owner)

///////////////////////////// DM_HOLD /////////////////////////////
	if(digest_mode == DM_HOLD)
		return SSBELLIES_PROCESSED

//////////////////////////// DM_DIGEST ////////////////////////////
	else if(digest_mode == DM_DIGEST)
		if(HAS_TRAIT(owner, TRAIT_PACIFISM)) //obvious.
			digest_mode = DM_NOISY
			return

		for (var/mob/living/M in contents)
			if(prob(25))
				if((world.time - NORMIE_HEARCHECK) > last_hearcheck)
					LAZYCLEARLIST(hearing_mobs)
					for(var/mob/living/H in get_hearers_in_view(3, source))
						if(!H.client || !(H.client.prefs.cit_toggles & DIGESTION_NOISES))
							continue
						LAZYADD(hearing_mobs, H)
					last_hearcheck = world.time
				for(var/mob/living/H in hearing_mobs)
					if(!isbelly(H.loc))
						H.playsound_local(source, null, 45, falloff = 0, S = pred_digest)
					else if(H in contents)
						H.playsound_local(source, null, 65, falloff = 0, S = prey_digest)

			//Pref protection!
			if (!M.digestable || M.absorbed)
				continue

			//Person just died in guts!
			if(M.stat == DEAD)
				var/digest_alert_owner = pick(digest_messages_owner)
				var/digest_alert_prey = pick(digest_messages_prey)

				//Replace placeholder vars
				digest_alert_owner = replacetext(digest_alert_owner,"%pred",owner)
				digest_alert_owner = replacetext(digest_alert_owner,"%prey",M)
				digest_alert_owner = replacetext(digest_alert_owner,"%belly",lowertext(name))

				digest_alert_prey = replacetext(digest_alert_prey,"%pred",owner)
				digest_alert_prey = replacetext(digest_alert_prey,"%prey",M)
				digest_alert_prey = replacetext(digest_alert_prey,"%belly",lowertext(name))

				//Send messages
				to_chat(owner, "<span class='warning'>[digest_alert_owner]</span>")
				to_chat(M, "<span class='warning'>[digest_alert_prey]</span>")
				M.visible_message("<span class='notice'>You watch as [owner]'s form loses its additions.</span>")

				owner.nutrition += 400 // so eating dead mobs gives you *something*.
				if((world.time - NORMIE_HEARCHECK) > last_hearcheck)
					LAZYCLEARLIST(hearing_mobs)
					for(var/mob/living/H in get_hearers_in_view(3, source))
						if(!H.client || !(H.client.prefs.cit_toggles & DIGESTION_NOISES))
							continue
						LAZYADD(hearing_mobs, H)
					last_hearcheck = world.time
				for(var/mob/living/H in hearing_mobs)
					if(!isbelly(H.loc))
						H.playsound_local(source, null, 45, falloff = 0, S = pred_death)
					else if(H in contents)
						H.playsound_local(source, null, 65, falloff = 0, S = prey_death)
				M.stop_sound_channel(CHANNEL_PREYLOOP)
				digestion_death(M)
				owner.update_icons()
				continue


			// Deal digestion damage (and feed the pred)
			if(!(M.status_flags & GODMODE))
				M.adjustFireLoss(digest_burn)
				owner.nutrition += 1

		//Contaminate or gurgle items
		var/obj/item/T = pick(touchable_items)
		if(istype(T))
			if(istype(T,/obj/item/reagent_containers/food) || istype(T,/obj/item/organ))
				digest_item(T)

		owner.updateVRPanel()

///////////////////////////// DM_HEAL /////////////////////////////
	if(digest_mode == DM_HEAL)
		for (var/mob/living/M in contents)
			if(prob(25))
				if((world.time - NORMIE_HEARCHECK) > last_hearcheck)
					LAZYCLEARLIST(hearing_mobs)
					for(var/mob/living/H in get_hearers_in_view(3, source))
						if(!H.client || !(H.client.prefs.cit_toggles & DIGESTION_NOISES))
							continue
						LAZYADD(hearing_mobs, H)
					last_hearcheck = world.time
				for(var/mob/living/H in hearing_mobs)
					if(!isbelly(H.loc))
						H.playsound_local(source, null, 45, falloff = 0, S = pred_digest)
					else if(H in contents)
						H.playsound_local(source, null, 65, falloff = 0, S = prey_digest)

			if(M.stat != DEAD)
				if(owner.nutrition >= NUTRITION_LEVEL_STARVING && (M.health < M.maxHealth))
					M.adjustBruteLoss(-3)
					M.adjustFireLoss(-3)
					owner.nutrition -= 5
		return

////////////////////////// DM_NOISY /////////////////////////////////
//for when you just want people to squelch around
	if(digest_mode == DM_NOISY)
		if(prob(35))
			if((world.time - NORMIE_HEARCHECK) > last_hearcheck)
				LAZYCLEARLIST(hearing_mobs)
				for(var/mob/living/H in get_hearers_in_view(3, source))
					if(!H.client || !(H.client.prefs.cit_toggles & DIGESTION_NOISES))
						continue
					LAZYADD(hearing_mobs, H)
				last_hearcheck = world.time
			for(var/mob/living/H in hearing_mobs)
				if(!isbelly(H.loc))
					H.playsound_local(source, null, 45, falloff = 0, S = pred_digest)
				else if(H in contents)
					H.playsound_local(source, null, 65, falloff = 0, S = prey_digest)


//////////////////////////// DM_ABSORB ////////////////////////////
	else if(digest_mode == DM_ABSORB)

		for (var/mob/living/M in contents)

			if(prob(10))//Less often than gurgles. People might leave this on forever.
				if((world.time - NORMIE_HEARCHECK) > last_hearcheck)
					LAZYCLEARLIST(hearing_mobs)
					for(var/mob/living/H in get_hearers_in_view(3, source))
						if(!H.client || !(H.client.prefs.cit_toggles & DIGESTION_NOISES))
							continue
						LAZYADD(hearing_mobs, H)
					last_hearcheck = world.time
				for(var/mob/living/H in hearing_mobs)
					if(!isbelly(H.loc))
						H.playsound_local(source, null, 45, falloff = 0, S = pred_digest)
					else if(H in contents)
						H.playsound_local(source, null, 65, falloff = 0, S = prey_digest)

			if(M.absorbed)
				continue

			if(M.nutrition >= 100) //Drain them until there's no nutrients left. Slowly "absorb" them.
				var/oldnutrition = (M.nutrition * 0.05)
				M.nutrition = (M.nutrition * 0.95)
				owner.nutrition += oldnutrition
			else if(M.nutrition < 100) //When they're finally drained.
				absorb_living(M)

//////////////////////////// DM_UNABSORB ////////////////////////////
	else if(digest_mode == DM_UNABSORB)

		for (var/mob/living/M in contents)
			if(M.absorbed && owner.nutrition >= 100)
				M.absorbed = 0
				to_chat(M,"<span class='notice'>You suddenly feel solid again </span>")
				to_chat(owner,"<span class='notice'>You feel like a part of you is missing.</span>")
				owner.nutrition -= 100

//////////////////////////DM_DRAGON /////////////////////////////////////
//because dragons need snowflake guts
	if(digest_mode == DM_DRAGON)
		if(HAS_TRAIT(owner, TRAIT_PACIFISM)) //imagine var editing this when you're a pacifist. smh
			digest_mode = DM_NOISY
			return

		for (var/mob/living/M in contents)
			if(prob(55)) //if you're hearing this, you're a vore ho anyway.
				if((world.time - NORMIE_HEARCHECK) > last_hearcheck)
					LAZYCLEARLIST(hearing_mobs)
					for(var/mob/living/H in get_hearers_in_view(3, source))
						if(!H.client || !(H.client.prefs.cit_toggles & DIGESTION_NOISES))
							continue
						LAZYADD(hearing_mobs, H)
					last_hearcheck = world.time
				for(var/mob/living/H in hearing_mobs)
					if(!isbelly(H.loc))
						H.playsound_local(source, null, 45, falloff = 0, S = pred_digest)
					else if(H in contents)
						H.playsound_local(source, null, 65, falloff = 0, S = prey_digest)

		//No digestion protection for megafauna.

		//Person just died in guts!
			if(M.stat == DEAD)
				var/digest_alert_owner = pick(digest_messages_owner)
				var/digest_alert_prey = pick(digest_messages_prey)

				//Replace placeholder vars
				digest_alert_owner = replacetext(digest_alert_owner,"%pred",owner)
				digest_alert_owner = replacetext(digest_alert_owner,"%prey",M)
				digest_alert_owner = replacetext(digest_alert_owner,"%belly",lowertext(name))

				digest_alert_prey = replacetext(digest_alert_prey,"%pred",owner)
				digest_alert_prey = replacetext(digest_alert_prey,"%prey",M)
				digest_alert_prey = replacetext(digest_alert_prey,"%belly",lowertext(name))

				//Send messages
				to_chat(owner, "<span class='warning'>[digest_alert_owner]</span>")
				to_chat(M, "<span class='warning'>[digest_alert_prey]</span>")
				M.visible_message("<span class='notice'>You watch as [owner]'s guts loudly rumble as it finishes off a meal.</span>")
				if((world.time - NORMIE_HEARCHECK) > last_hearcheck)
					LAZYCLEARLIST(hearing_mobs)
					for(var/mob/living/H in get_hearers_in_view(3, source))
						if(!H.client || !(H.client.prefs.cit_toggles & DIGESTION_NOISES))
							continue
						LAZYADD(hearing_mobs, H)
					last_hearcheck = world.time
				for(var/mob/living/H in hearing_mobs)
					if(!isbelly(H.loc))
						H.playsound_local(source, null, 45, falloff = 0, S = pred_death)
					else if(H in contents)
						H.playsound_local(source, null, 65, falloff = 0, S = prey_death)
				M.spill_organs(FALSE,TRUE,TRUE)
				M.stop_sound_channel(CHANNEL_PREYLOOP)
				digestion_death(M)
				owner.update_icons()
				continue


			// Deal digestion damage (and feed the pred)
			if(!(M.status_flags & GODMODE))
				M.adjustFireLoss(digest_burn)
				M.adjustToxLoss(2) // something something plasma based acids
				M.adjustCloneLoss(1) // eventually this'll kill you if you're healing everything else, you nerds.
			//Contaminate or gurgle items
		var/obj/item/T = pick(touchable_items)
		if(istype(T))
			if(istype(T,/obj/item/reagent_containers/food) || istype(T,/obj/item/organ))
				digest_item(T)

		owner.updateVRPanel()