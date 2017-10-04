// Process the predator's effects upon the contents of its belly (i.e digestion/transformation etc)
// Called from /mob/living/Life() proc.
/datum/belly/proc/process_Life()
	var/sound/prey_gurgle = sound(get_sfx("digest_prey"))
	var/sound/prey_digest = sound(get_sfx("death_prey"))

/////////////////////////// Auto-Emotes ///////////////////////////
	if((digest_mode in emote_lists) && !emotePend)
		emotePend = TRUE

		spawn(emoteTime)
			var/list/EL = emote_lists[digest_mode]
			for(var/mob/living/M in internal_contents)
				M << "<span class='notice'>[pick(EL)]</span>"
			src.emotePend = FALSE

///////////////////////////// DM_HOLD /////////////////////////////
	if(digest_mode == DM_HOLD)
		return //Pretty boring, huh

//////////////////////////// DM_DIGEST ////////////////////////////
	if(digest_mode == DM_DIGEST)
		for (var/mob/living/M in internal_contents)
			if(prob(25))
				M.stop_sound_channel(CHANNEL_PRED)
				playsound(get_turf(owner),"digest_pred",50,0,-6,0,channel=CHANNEL_PRED)
				M.stop_sound_channel(CHANNEL_PRED)
				M.playsound_local(get_turf(M), null, 45, S = prey_gurgle)

			//Pref protection!
			if (!M.digestable)
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
				M.stop_sound_channel(CHANNEL_PRED)
				playsound(get_turf(owner),"death_pred",45,0,-6,0,channel=CHANNEL_PRED)
				M.stop_sound_channel(CHANNEL_PRED)
				M.playsound_local(get_turf(M), null, 45, S = prey_digest)
				digestion_death(M)
				owner.update_icons()
				continue


			// Deal digestion damage (and feed the pred)
			if(!(M.status_flags & GODMODE))
				M.adjustFireLoss(digest_burn)
				owner.nutrition += 1
		return

///////////////////////////// DM_HEAL /////////////////////////////
	if(digest_mode == DM_HEAL)
		for (var/mob/living/M in internal_contents)
			if(prob(25))
				M.stop_sound_channel(CHANNEL_PRED)
				playsound(get_turf(owner),"digest_pred",35,0,-6,0,channel=CHANNEL_PRED)
				M.stop_sound_channel(CHANNEL_PRED)
				M.playsound_local(get_turf(M), null, 45, S = prey_gurgle)

			if(M.stat != DEAD)
				if(owner.nutrition >= NUTRITION_LEVEL_STARVING && (M.health < M.maxHealth))
					M.adjustBruteLoss(-1)
					M.adjustFireLoss(-1)
					owner.nutrition -= 10
		return

////////////////////////// DM_NOISY /////////////////////////////////
//for when you just want people to squelch around
	if(digest_mode == DM_NOISY)
		for (var/mob/living/M in internal_contents)
			if(prob(35))
				M.stop_sound_channel(CHANNEL_PRED)
				playsound(get_turf(owner),"digest_pred",35,0,-6,0,channel=CHANNEL_PRED)
				M.stop_sound_channel(CHANNEL_PRED)
				M.playsound_local(get_turf(M), null, 45, S = prey_gurgle)


//////////////////////////DM_DRAGON /////////////////////////////////////
//because dragons need snowflake guts
	if(digest_mode == DM_DRAGON)
		for (var/mob/living/M in internal_contents)
			if(prob(25))
				M.stop_sound_channel(CHANNEL_PRED)
				playsound(get_turf(owner),"digest_pred",50,0,-6,0,channel=CHANNEL_PRED)
				M.stop_sound_channel(CHANNEL_PRED)
				M.playsound_local(get_turf(M), null, 45, S = prey_gurgle)

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

				M.stop_sound_channel(CHANNEL_PRED)
				playsound(get_turf(owner),"death_pred",45,0,-6,0,channel=CHANNEL_PRED)
				M.stop_sound_channel(CHANNEL_PRED)
				M.playsound_local(get_turf(M), null, 45, S = prey_digest)
				M.spill_organs(FALSE,TRUE,TRUE)
				M << sound(null, repeat = 0, wait = 0, volume = 80, channel = CHANNEL_PREYLOOP)
				digestion_death(M)
				owner.update_icons()
				continue


			// Deal digestion damage (and feed the pred)
			if(!(M.status_flags & GODMODE))
				M.adjustFireLoss(digest_burn)
				M.adjustToxLoss(4) // something something plasma based acids
				M.adjustCloneLoss(3) // eventually this'll kill you if you're healing everything else, you nerds.
		return