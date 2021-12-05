// Process the predator's effects upon the contents of its belly (i.e digestion/transformation etc)
/obj/belly/proc/process_belly(times_fired, wait) //Passed by controller
	if((times_fired < next_process) || !length(contents))
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
	HandleBellyReagents()	//CHOMP reagent belly stuff, here to jam it into subsystems and avoid too much cpu usage
	// VERY early exit
	if(!contents.len)
		return SSBELLIES_PROCESSED

	//CHOMPEdit: Autotransfer count moved here.
	if((!owner.client || autotransfer_enabled) && autotransferlocation && autotransferchance > 0)
		var/list/autotransferables = contents - autotransfer_queue
		if(LAZYLEN(autotransfer_queue) >= autotransfer_min_amount)
			var/obj/belly/dest_belly
			for(var/obj/belly/B in owner.vore_organs)
				if(B.name == autotransferlocation)
					dest_belly = B
					break
			if(dest_belly)
				for(var/atom/movable/M in autotransfer_queue)
					transfer_contents(M, dest_belly)
				autotransfer_queue.Cut()
		var/tally = 0
		for(var/atom/movable/M in autotransferables)
			if(isliving(M))
				var/mob/living/L = M
				if(L.vore_flags & ABSORBED)
					continue
			tally++
			M.belly_cycles++
			if(autotransfer_max_amount > 0 && tally > autotransfer_max_amount)
				continue
			if(M.belly_cycles >= autotransferwait / 60)
				check_autotransfer(M, autotransferlocation)

	var/play_sound //Potential sound to play at the end to avoid code duplication.
	var/to_update = FALSE //Did anything update worthy happen?

/////////////////////////// Exit Early ////////////////////////////
	var/list/touchable_atoms = contents - items_preserved
	for(var/mob/dead/G in touchable_atoms) //CHOMPEdit: don't bother trying to process ghosts.
		touchable_atoms -= G
	if(!length(touchable_atoms))
		return SSBELLIES_PROCESSED

/////////////////////////// Sound Selections ///////////////////////////
	var/digestion_noise_chance = 0

	////////////////////////// Sound vars /////////////////////////////
	var/sound/prey_digest = sound(get_sfx("digest_prey"))
	var/sound/pred_digest = sound(get_sfx("digest_pred"))

///////////////////// Early Non-Mode Handling /////////////////////

	var/datum/digest_mode/DM = GLOB.digest_modes["[digest_mode]"]
	if(!DM)
		log_runtime("Digest mode [digest_mode] didn't exist in the digest_modes list!!")
		return SSBELLIES_PROCESSED
	if(DM.handle_atoms(src, touchable_atoms))
		updateVRPanels()
		return SSBELLIES_PROCESSED

	var/list/touchable_mobs = null

	var/list/hta_returns = handle_touchable_atoms(touchable_atoms)
	if(islist(hta_returns))
		if(hta_returns["digestion_noise_chance"])
			digestion_noise_chance = hta_returns["digestion_noise_chance"]
		if(hta_returns["touchable_mobs"])
			touchable_mobs = hta_returns["touchable_mobs"]
		if(hta_returns["to_update"])
			to_update = hta_returns["to_update"]

	if(!digestion_noise_chance)
		digestion_noise_chance = DM.noise_chance

/////////////////////////// Make any noise ///////////////////////////
	if(digestion_noise_chance && prob(digestion_noise_chance))
		for(var/mob/M in contents)
			if(M && (M?.client?.prefs.cit_toggles & DIGESTION_NOISES))
				SEND_SOUND(M, prey_digest)
		play_sound = pred_digest

	if(!LAZYLEN(touchable_mobs))
		if(to_update)
			updateVRPanels()
		if(play_sound)
			for(var/mob/M in hearers(VORE_SOUND_RANGE, get_turf(owner))) //so we don't fill the whole room with the sound effect
				if(!(M?.client?.prefs.cit_toggles & DIGESTION_NOISES))
					continue
				if(isturf(M.loc) || (M.loc != src)) //to avoid people on the inside getting the outside sounds and their direct sounds + built in sound pref check
					M.playsound_local(get_turf(owner), play_sound, vol = 100, vary = 1, falloff_exponent = VORE_SOUND_FALLOFF)
					//these are all external sound triggers now, so it's ok.
		return SSBELLIES_PROCESSED

///////////////////// Prey Loop Refresh/hack //////////////////////
	prey_loop()

///////////////////// Time to actually process mobs /////////////////////

	for(var/mob/living/L as anything in touchable_mobs)
		if(!istype(L))
			stack_trace("Touchable mobs had a nonmob: [L]")
			continue
		var/list/returns = DM.process_mob(src, L)
		if(istype(returns) && returns["to_update"])
			to_update = TRUE
		if(istype(returns) && returns["soundToPlay"] && !play_sound)
			play_sound = returns["soundToPlay"]

	if(play_sound)
		for(var/mob/M in hearers(VORE_SOUND_RANGE, get_turf(owner))) //so we don't fill the whole room with the sound effect
			if(!(M?.client?.prefs.cit_toggles & DIGESTION_NOISES))
				continue
			if(isturf(M.loc) || (M.loc != src)) //to avoid people on the inside getting the outside sounds and their direct sounds + built in sound pref check
				M.playsound_local(get_turf(owner), play_sound, vol = 100, vary = 1, falloff_exponent = VORE_SOUND_FALLOFF)
				//these are all external sound triggers now, so it's ok.

	if(emote_active)
		var/list/EL = emote_lists[digest_mode]
		if(LAZYLEN(EL) && next_emote <= world.time)
			var/living_count = 0
			for(var/mob/living/L in contents)
				living_count++
			next_emote = world.time + (emote_time SECONDS)
			for(var/mob/living/M in contents)
				if(digest_mode == DM_DIGEST && !(M.vore_flags & DIGESTABLE))
					continue // don't give digesty messages to indigestible people

				var/raw_message = pick(EL)
				var/formatted_message
				formatted_message = replacetext(raw_message, "%belly", lowertext(name))
				formatted_message = replacetext(formatted_message, "%pred", owner)
				formatted_message = replacetext(formatted_message, "%prey", english_list(contents))
				formatted_message = replacetext(formatted_message, "%countprey", living_count)
				formatted_message = replacetext(formatted_message, "%count", contents.len)
				to_chat(M, "<span class='notice'>[formatted_message]</span>")

	if(to_update)
		updateVRPanels()


/obj/belly/proc/handle_touchable_atoms(list/touchable_atoms)
	var/did_an_item = FALSE // Only do one item per cycle.
	var/to_update = FALSE
	var/digestion_noise_chance = 0
	var/list/touchable_mobs = list()
	var/touchable_amount = touchable_atoms.len  //CHOMPEdit start

	for(var/A in touchable_atoms)
		//Handle stray items
		if(isitem(A))
			if(item_digest_mode == IM_DIGEST_PARALLEL)
				did_an_item = handle_digesting_item(A, touchable_amount)
			else if(!did_an_item)
				did_an_item = handle_digesting_item(A, 1)
			if(did_an_item)
				to_update = TRUE

			//Less often than with normal digestion
			if((item_digest_mode == IM_DIGEST_FOOD || item_digest_mode == IM_DIGEST || item_digest_mode == IM_DIGEST_PARALLEL) && prob(25))
				// This is a little weird, but the point of it is that we don't want to repeat code
				// but we also want the prob(25) chance to run for -every- item we look at, not just once
				// More gurgles the better~
				digestion_noise_chance = 25
			continue  //CHOMPEdit end

		//Handle eaten mobs
		else if(isliving(A))
			var/mob/living/L = A
			touchable_mobs += L

			if(L.vore_flags & ABSORBED)
				L.Stun(5)

			// Fullscreen overlays
			vore_fx(L)

			//Handle 'human'
			if(ishuman(L))
				var/mob/living/carbon/human/H = L
/*
				//Numbing flag
				if(mode_flags & DM_FLAG_NUMBING)
					if(H.bloodstr.get_reagent_amount("numbenzyme") < 2)
						H.bloodstr.add_reagent("numbenzyme",4)

				//Thickbelly flag
				if((mode_flags & DM_FLAG_THICKBELLY) && !H.muffled)
					H.muffled = TRUE
*/
				//Worn items flag
				if(mode_flags & DM_FLAG_AFFECTWORN)
					for(var/slot in GLOB.slots)
						var/obj/item/I = H.get_item_by_slot(GLOB.slot2slot[slot])
						if(I)
							if(handle_digesting_item(I))
								digestion_noise_chance = 25
								to_update = TRUE
								break

				//Stripping flag
				if(mode_flags & DM_FLAG_STRIPPING)
					for(var/slot in GLOB.slots)
						var/obj/item/I = H.get_item_by_slot(GLOB.slot2slot[slot])
						if(I && H.transferItemToLoc(I, src))
							handle_digesting_item(I)
							digestion_noise_chance = 25
							to_update = TRUE
							break // Digest off one by one, not all at once

				if(mode_flags & DM_FLAG_JAMSENSORS)
					var/obj/item/clothing/under/to_jam = H.get_item_by_slot(SLOT_W_UNIFORM)
					if(to_jam && to_jam.has_sensor != NO_SENSORS)
						var/oldstate = to_jam.has_sensor
						if(to_jam.sensordamage < to_jam.sensormaxintegrity)
							to_jam.sensordamage += 1
						var/newstate = to_jam.sensorintegrity()
						if(oldstate != newstate)
							switch(to_jam.has_sensor)
								if(DAMAGED_SENSORS_VITALS)
									to_chat(H,"<span class='warning'>Your tracking beacon on your suit sensors have shorted out!</span>")
								if(DAMAGED_SENSORS_LIVING)
									to_chat(H,"<span class='warning'>Your vital tracker on your suit sensors have shorted out!</span>")
								else
									to_chat(H,"<span class='userdanger'>Your suit sensors have shorted out completely!</span>")
							to_jam.updatesensorintegrity(newstate)

		//get rid of things like blood drops and gibs that end up in there
		else if(istype(A, /obj/effect/decal/cleanable))
			qdel(A)

	return list("to_update" = to_update, "touchable_mobs" = touchable_mobs, "digestion_noise_chance" = digestion_noise_chance)

/obj/belly/proc/prey_loop()
	for(var/mob/living/M in contents)
		//We don't bother executing any other code if the prey doesn't want to hear the noises.
		if(!(M?.client?.prefs.cit_toggles & DIGESTION_NOISES))
			M.stop_sound_channel(CHANNEL_PREYLOOP) // sanity just in case, because byond is whack and you can't trust it
			continue

		// We don't want the sounds to overlap, but we do want them to steadily replay.
		// We also don't want the sounds to play if the pred hasn't marked this belly as fleshy, or doesn't
		// have the right sounds to play.
		if(isbelly(M.loc) && is_wet && wet_loop && (world.time > M.next_preyloop))
			M.stop_sound_channel(CHANNEL_PREYLOOP)
			var/sound/preyloop = sound(get_sfx("digest_prey"))
			M.playsound_local(get_turf(src), preyloop, 80, 0, channel = CHANNEL_PREYLOOP)
			M.next_preyloop = (world.time + (52 SECONDS))

/obj/belly/proc/handle_digesting_item(obj/item/I, touchable_amount) //CHOMPEdit
	var/did_an_item = FALSE
	// We always contaminate IDs.
//	if(contaminates || istype(I, /obj/item/card/id))
//		I.gurgle_contaminate(src, contamination_flavor, contamination_color)

	switch(item_digest_mode)
		if(IM_HOLD)
			items_preserved |= I
		if(IM_DIGEST_FOOD)
			if(istype(I,/obj/item/reagent_containers/food) || istype(I, /obj/item/organ))
				did_an_item = digest_item(I, touchable_amount) //CHOMPEdit
			else
				items_preserved |= I
		if(IM_DIGEST,IM_DIGEST_PARALLEL)
			did_an_item = digest_item(I, touchable_amount) //CHOMPEdit
	return did_an_item

/obj/belly/proc/handle_digestion_death(mob/living/M)
	var/digest_alert_owner = pick(digest_messages_owner)
	var/digest_alert_prey = pick(digest_messages_prey)
	var/compensation = M.maxHealth / 5 //Dead body bonus.
	if(ishuman(M))
		compensation += M.getOxyLoss() //How much of the prey's damage was caused by passive crit oxyloss to compensate the lost nutrition.

	var/living_count = 0
	for(var/mob/living/L in contents)
		living_count++

	//Replace placeholder vars
	digest_alert_owner = replacetext(digest_alert_owner, "%pred", owner)
	digest_alert_owner = replacetext(digest_alert_owner, "%prey", M)
	digest_alert_owner = replacetext(digest_alert_owner, "%belly", lowertext(name))
	digest_alert_owner = replacetext(digest_alert_owner, "%countprey", living_count)
	digest_alert_owner = replacetext(digest_alert_owner, "%count", contents.len)

	digest_alert_prey = replacetext(digest_alert_prey, "%pred", owner)
	digest_alert_prey = replacetext(digest_alert_prey, "%prey", M)
	digest_alert_prey = replacetext(digest_alert_prey, "%belly", lowertext(name))
	digest_alert_prey = replacetext(digest_alert_prey, "%countprey", living_count)
	digest_alert_prey = replacetext(digest_alert_prey, "%count", contents.len)

	//Send messages
	to_chat(owner, "<span class='notice'>[digest_alert_owner]</span>")
	to_chat(M, "<span class='notice'>[digest_alert_prey]</span>")

	if((mode_flags & DM_FLAG_LEAVEREMAINS) && (M.vore_flags & LEAVE_REMAINS))
		handle_remains_leaving(M)
	digestion_death(M)
	if(!ishuman(owner))
		owner.update_icons()
	if(issilicon(owner))
		var/mob/living/silicon/robot/R = owner
		if(reagent_mode_flags & DM_FLAG_REAGENTSDIGEST && reagents.total_volume < reagents.maximum_volume) //CHOMPedit: digestion producing reagents
			R.cell.charge += (nutrition_percent / 100) * compensation * 15
			GenerateBellyReagents_digested()
		else
			R.cell.charge += (nutrition_percent / 100) * compensation * 25
	else
		if(reagent_mode_flags & DM_FLAG_REAGENTSDIGEST && reagents.total_volume < reagents.maximum_volume) //CHOMP digestion producing reagents
			owner.adjust_nutrition((nutrition_percent / 100) * compensation * 3)
			GenerateBellyReagents_digested()
		else
			owner.adjust_nutrition((nutrition_percent / 100) * compensation * 4.5) //CHOMPedit end

/obj/belly/proc/steal_nutrition(mob/living/L)
	if(L.nutrition >= 100)
		var/oldnutrition = (L.nutrition * 0.05)
		L.nutrition = (L.nutrition * 0.95)
		if(reagent_mode_flags & DM_FLAG_REAGENTSDRAIN && reagents.total_volume < reagents.maximum_volume)   //CHOMPedit: draining reagent production //Added to this proc now since it's used for draining
			owner.adjust_nutrition(oldnutrition * 0.75) //keeping the price static, due to how much nutrition can flunctuate
			GenerateBellyReagents_absorbing() //Dont need unique proc so far
		else
			owner.adjust_nutrition(oldnutrition) //CHOMPedit end

/obj/belly/proc/updateVRPanels()
	for(var/mob/living/M in contents)
		if(M.client)
			M.updateVRPanel()
	if(owner.client)
		owner.updateVRPanel()
	if(isanimal(owner))
		owner.update_icon()
