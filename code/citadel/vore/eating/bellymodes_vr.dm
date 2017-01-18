// Process the predator's effects upon the contents of its belly (i.e digestion/transformation etc)
// Called from /mob/living/Life() proc.
/datum/belly/proc/process_Life()

/////////////////////////// Auto-Emotes ///////////////////////////
	if((digest_mode in emote_lists) && !emotePend)
		emotePend = 1

		spawn(emoteTime)
			var/list/EL = emote_lists[digest_mode]
			for(var/mob/living/M in internal_contents)
				M << "<span class='notice'>[pick(EL)]</span>"
			src.emotePend = 0

///////////////////////////// DM_HOLD /////////////////////////////
	if(digest_mode == DM_HOLD)
		return //Pretty boring, huh

//////////////////////////// DM_DIGEST ////////////////////////////
	if(digest_mode == DM_DIGEST)

		if(prob(50))
			var/churnsound = pick(digestion_sounds)
			var/gurgsound = struggle_sounds[churnsound]
			for(var/mob/living/M in get_hearers_in_view(4,owner))
				playsound(owner, pick(gurgsound), 80, 1)

		for (var/mob/living/M in internal_contents)
			//Pref protection!
			if (!M.digestable)
				continue

			//Person just died in guts!
			if(M.stat == DEAD && M.getFireLoss() >= 150)
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
				owner << "<span class='notice'>" + digest_alert_owner + "</span>"
				M << "<span class='notice'>" + digest_alert_prey + "</span>"
				owner.nutrition += NUTRITION_LEVEL_FULL
				for(M in get_hearers_in_view(3,owner))
					playsound(owner.loc, pick(death_sounds), 100, 1)
				digestion_death(M)
				continue

			// Deal digestion damage (and feed the pred)
			if(!(M.status_flags & GODMODE))
				M.adjustFireLoss(1)
			//	owner.nutrition += 5
		recent_gurgle = world.time
		return

//////////////////////////// DM_DIGESTF ////////////////////////////
	if(digest_mode == DM_DIGESTF)

		if(prob(50))
			var/churnsound = pick(digestion_sounds)
			var/gurgsound = struggle_sounds[churnsound]
			for(var/mob/living/M in get_hearers_in_view(4,owner))
				playsound(owner, pick(gurgsound), 80, 1)

		for (var/mob/living/M in internal_contents)
			//Pref protection!
			if (!M.digestable)
				continue

			//Person just died in guts!
			if(M.stat == DEAD && M.getFireLoss() >= 150)
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
				owner << "<span class='notice'>" + digest_alert_owner + "</span>"
				M << "<span class='notice'>" + digest_alert_prey + "</span>"

				owner.nutrition += NUTRITION_LEVEL_FULL
				for(M in get_hearers_in_view(2,owner))
					playsound(owner.loc, pick(death_sounds), 70, 1)
				digestion_death(M)
				continue

			// Deal digestion damage (and feed the pred)
			if(!(M.status_flags & GODMODE))
				M.adjustBruteLoss(2)
				M.adjustFireLoss(3)
	//			owner.nutrition += 5
		recent_gurgle = world.time
		return

///////////////////////////// DM_HEAL /////////////////////////////
	if(digest_mode == DM_HEAL)
		if(prob(50)) //Wet heals!
			var/churnsound = pick(digestion_sounds)
			var/gurgsound = struggle_sounds[churnsound]
			for(var/mob/living/M in get_hearers_in_view(4,owner))
				playsound(owner, pick(gurgsound), 80, 1)

		for (var/mob/living/M in internal_contents)
			if(M.stat != DEAD)
				if(owner.nutrition >= NUTRITION_LEVEL_STARVING && (M.health < M.maxHealth))
					M.adjustBruteLoss(-1)
					M.adjustFireLoss(-1)
					owner.nutrition -= 10
		recent_gurgle = world.time
		return