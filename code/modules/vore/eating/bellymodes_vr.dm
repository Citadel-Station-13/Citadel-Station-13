// Process the predator's effects upon the contents of its belly (i.e digestion/transformation etc)
// Called from /mob/living/Life() proc.
/datum/belly/proc/process_Life()

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
			if(prob(50))
				M.stop_sound_channel(CHANNEL_PRED)
				playsound(get_turf(owner),"digest_pred",75,0,-6,0,channel=CHANNEL_PRED)
				M.stop_sound_channel(CHANNEL_PRED)
				M.playsound_local("digest_prey",60)

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
				M.visible_message("<span class='notice'>You watch as [owner]'s form loses its additions.</span>", "<span class='warning'>[digest_alert_prey]</span>")

				owner.nutrition += 400 // so eating dead mobs gives you *something*.
				M.stop_sound_channel(CHANNEL_PRED)
				playsound(get_turf(owner),"death_pred",50,0,-6,0,channel=CHANNEL_PRED)
				M.stop_sound_channel(CHANNEL_PRED)
				M.playsound_local("death_prey",60)
				digestion_death(M)
				owner.update_icons()
				continue


			// Deal digestion damage (and feed the pred)
			if(!(M.status_flags & GODMODE))
				M.adjustFireLoss(1)
				owner.nutrition += 1
		return

///////////////////////////// DM_HEAL /////////////////////////////
	if(digest_mode == DM_HEAL)
		for (var/mob/living/M in internal_contents)
			if(prob(50))
				M.stop_sound_channel(CHANNEL_PRED)
				playsound(get_turf(owner),"digest_pred",50,0,-6,0,channel=CHANNEL_PRED)
				M.stop_sound_channel(CHANNEL_PRED)
				M.playsound_local("digest_prey",60)

			if(M.stat != DEAD)
				if(owner.nutrition >= NUTRITION_LEVEL_STARVING && (M.health < M.maxHealth))
					M.adjustBruteLoss(-1)
					M.adjustFireLoss(-1)
					owner.nutrition -= 10
		return
