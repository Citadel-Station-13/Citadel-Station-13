///////////////////// Mob Living /////////////////////
/mob/living
	var/digestable = TRUE					// Can the mob be digested inside a belly?
	var/datum/belly/vore_selected		// Default to no vore capability.
	var/list/vore_organs = list()		// List of vore containers inside a mob
	var/devourable = FALSE					// Can the mob be vored at all?
//	var/feeding = FALSE					// Are we going to feed someone else?
	var/vore_taste = null				// What the character tastes like
	var/no_vore = FALSE 					// If the character/mob can vore.
	var/openpanel = 0					// Is the vore panel open?

//
// Hook for generic creation of stuff on new creatures
//
/hook/living_new/proc/vore_setup(mob/living/M)
	M.verbs += /mob/living/proc/escapeOOC
	M.verbs += /mob/living/proc/lick
	if(M.no_vore) //If the mob isn's supposed to have a stomach, let's not give it an insidepanel so it can make one for itself, or a stomach.
		M << "<span class='warning'>The creature that you are can not eat others.</span>"
		return TRUE
	M.verbs += /mob/living/proc/insidePanel

	//Tries to load prefs if a client is present otherwise gives freebie stomach
	if(!M.vore_organs || !M.vore_organs.len)
		spawn(20) //Wait a couple of seconds to make sure copy_to or whatever has gone
			if(!M) return

			if(M.client && M.client.prefs_vr)
				if(!M.copy_from_prefs_vr())
					M << "<span class='warning'>ERROR: You seem to have saved vore prefs, but they couldn't be loaded.</span>"
					return FALSE
				if(M.vore_organs && M.vore_organs.len)
					M.vore_selected = M.vore_organs[1]

			if(!M.vore_organs || !M.vore_organs.len)
				if(!M.vore_organs)
					M.vore_organs = list()
				var/datum/belly/B = new /datum/belly(M)
				B.immutable = TRUE
				B.name = "Stomach"
				B.inside_flavor = "It appears to be rather warm and wet. Makes sense, considering it's inside \the [M.name]"
				B.can_taste = TRUE
				M.vore_organs[B.name] = B
				M.vore_selected = B.name

				//Simple_animal gets emotes. move this to that hook instead?
				if(istype(src,/mob/living/simple_animal))
					B.emote_lists[DM_HOLD] = list(
						"The insides knead at you gently for a moment.",
						"The guts glorp wetly around you as some air shifts.",
						"Your predator takes a deep breath and sighs, shifting you somewhat.",
						"The stomach squeezes you tight for a moment, then relaxes.",
						"During a moment of quiet, breathing becomes the most audible thing.",
						"The warm slickness surrounds and kneads on you.")

					B.emote_lists[DM_DIGEST] = list(
						"The caustic acids eat away at your form.",
						"The acrid air burns at your lungs.",
						"Without a thought for you, the stomach grinds inwards painfully.",
						"The guts treat you like food, squeezing to press more acids against you.",
						"The onslaught against your body doesn't seem to be letting up; you're food now.",
						"The insides work on you like they would any other food.")

	//Return 1 to hook-caller
	return 1

//
// Handle being clicked, perhaps with something to devour
//

			// Refactored to use centralized vore code system - Leshana

			// Critical adjustments due to TG grab changes - Poojawa

/mob/living/proc/vore_attack(var/mob/living/user, var/mob/living/prey)
	if(!user || !prey)
		return

	if(prey == src && user.zone_selected == "mouth") //you click your target
//		if(!feeding(src))
//			return
		if(!is_vore_predator(prey))
			to_chat(user, "<span class='notice'>They aren't voracious enough.</span>")
			return
		feed_self_to_grabbed(user, src)

	if(user == src) //you click yourself
		if(!is_vore_predator(src))
			to_chat(user, "<span class='notice'>You aren't voracious enough.</span>")
			return
		user.feed_grabbed_to_self(src, prey)

	else // click someone other than you/prey
//		if(!feeding(src))
//			return
		if(!is_vore_predator(src))
			to_chat(user, "<span class='notice'>They aren't voracious enough.</span>")
			return
		feed_grabbed_to_other(user, prey, src)
//
// Eating procs depending on who clicked what
//
/mob/living/proc/feed_grabbed_to_self(var/mob/living/user, var/mob/living/prey)
	var/belly = user.vore_selected
	return perform_the_nom(user, prey, user, belly)
/*
/mob/living/proc/eat_held_mob(var/mob/living/user, var/mob/living/prey, var/mob/living/pred)
	var/belly
	if(user != pred)
		belly = input("Choose Belly") in pred.vore_organs
	else
		belly = pred.vore_selected
	return perform_the_nom(user, prey, pred, belly)*/

/mob/living/proc/feed_self_to_grabbed(var/mob/living/user, var/mob/living/pred)
	var/belly = input("Choose Belly") in pred.vore_organs
	return perform_the_nom(user, user, pred, belly)

/mob/living/proc/feed_grabbed_to_other(var/mob/living/user, var/mob/living/prey, var/mob/living/pred)
	return//disabled until I can make that toggle work
	var/belly = input("Choose Belly") in pred.vore_organs
	return perform_the_nom(user, prey, pred, belly)

//Dragon noms need to be faster
/mob/living/proc/dragon_feeding(var/mob/living/user, var/mob/living/prey)
	var/belly = user.vore_selected
	return perform_dragon(user, prey, user, belly)

/mob/living/proc/perform_dragon(var/mob/living/user, var/mob/living/prey, var/mob/living/pred, var/belly, swallow_time = 20)
	//Sanity
	if(!user || !prey || !pred || !belly || !(belly in pred.vore_organs))
		return

	// The belly selected at the time of noms
	var/datum/belly/belly_target = pred.vore_organs[belly]
	var/attempt_msg = "ERROR: Vore message couldn't be created. Notify a dev. (at)"
	var/success_msg = "ERROR: Vore message couldn't be created. Notify a dev. (sc)"

		// Prepare messages
	if(user == pred) //Feeding someone to yourself
		attempt_msg = text("<span class='warning'>[] starts to [] [] into their []!</span>",pred,lowertext(belly_target.vore_verb),prey,lowertext(belly_target.name))
		success_msg = text("<span class='warning'>[] manages to [] [] into their []!</span>",pred,lowertext(belly_target.vore_verb),prey,lowertext(belly_target.name))

	// Announce that we start the attempt!
	user.visible_message(attempt_msg)

	if(!do_mob(src, user, swallow_time)) // one second should be good enough, right?
		return FALSE // Prey escaped (or user disabled) before timer expired.

	// If we got this far, nom successful! Announce it!
	user.visible_message(success_msg)
	playsound(get_turf(user), belly_target.vore_sound,75,0,-6,0)

	// Actually shove prey into the belly.
	belly_target.nom_mob(prey, user)
	if (pred == user)
		message_admins("[key_name(pred)] ate [key_name(prey)].")
		log_attack("[key_name(pred)] ate [key_name(prey)]")
	return TRUE
//
// Master vore proc that actually does vore procedures
//

/mob/living/proc/perform_the_nom(var/mob/living/user, var/mob/living/prey, var/mob/living/pred, var/belly, swallow_time = 100)
	//Sanity
	if(!user || !prey || !pred || !belly || !(belly in pred.vore_organs))
		return
	if (!prey.devourable)
		to_chat(user, "This can't be eaten!")
		return
	// The belly selected at the time of noms
	var/datum/belly/belly_target = pred.vore_organs[belly]
	var/attempt_msg = "ERROR: Vore message couldn't be created. Notify a dev. (at)"
	var/success_msg = "ERROR: Vore message couldn't be created. Notify a dev. (sc)"

	// Prepare messages
	if(user == pred) //Feeding someone to yourself
		attempt_msg = text("<span class='warning'>[] is attemping to [] [] into their []!</span>",pred,lowertext(belly_target.vore_verb),prey,lowertext(belly_target.name))
		success_msg = text("<span class='warning'>[] manages to [] [] into their []!</span>",pred,lowertext(belly_target.vore_verb),prey,lowertext(belly_target.name))
	else //Feeding someone to another person
		attempt_msg = text("<span class='warning'>[] is attempting to make [] [] [] into their []!</span>",user,pred,lowertext(belly_target.vore_verb),prey,lowertext(belly_target.name))
		success_msg = text("<span class='warning'>[] manages to make [] [] [] into their []!</span>",user,pred,lowertext(belly_target.vore_verb),prey,lowertext(belly_target.name))

	// Announce that we start the attempt!
	user.visible_message(attempt_msg)

	// Now give the prey time to escape... return if they did

	if(!do_mob(src, user, swallow_time))
		return FALSE // Prey escaped (or user disabled) before timer expired.

	// If we got this far, nom successful! Announce it!
	user.visible_message(success_msg)
	playsound(get_turf(user), belly_target.vore_sound,75,0,-6,0)

	// Actually shove prey into the belly.
	belly_target.nom_mob(prey, user)
//	user.update_icons()
	stop_pulling()

	// Inform Admins
	var/prey_braindead
	var/prey_stat
	if(prey.ckey)
		prey_stat = prey.stat//only return this if they're not an unmonkey or whatever
		if(!prey.client)//if they disconnected, tell us
			prey_braindead = 1
	if (pred == user)
		message_admins("[ADMIN_LOOKUPFLW(pred)] ate [ADMIN_LOOKUPFLW(prey)][!prey_braindead ? "" : " (BRAINDEAD)"][prey_stat ? " (DEAD/UNCONSCIOUS)" : ""].")
		log_attack("[key_name(pred)] ate [key_name(prey)]")
	else
		message_admins("[ADMIN_LOOKUPFLW(user)] forced [ADMIN_LOOKUPFLW(pred)] to eat [ADMIN_LOOKUPFLW(prey)].")
		log_attack("[key_name(user)] forced [key_name(pred)] to eat [key_name(prey)].")
	return TRUE

//
//End vore code.
/*
	//Handle case: /obj/item/holder
		if(/obj/item/holder/micro)
			var/obj/item/holder/H = I

			if(!isliving(user)) return 0 // Return 0 to continue upper procs
			var/mob/living/attacker = user  // Typecast to living

			if (is_vore_predator(src))
				for (var/mob/living/M in H.contents)
					attacker.eat_held_mob(attacker, M, src)
				return 1 //Return 1 to exit upper procs
			else
				log_attack("[attacker] attempted to feed [H.contents] to [src] ([src.type]) but it failed.")

 // I just can't imagine this not being complained about
	//Handle case: /obj/item/device/radio/beacon
		if(/obj/item/device/radio/beacon)
			var/confirm = alert(user, "[src == user ? "Eat the beacon?" : "Feed the beacon to [src]?"]", "Confirmation", "Yes!", "Cancel")
			if(confirm == "Yes!")
				var/bellychoice = input("Which belly?","Select A Belly") in src.vore_organs
				var/datum/belly/B = src.vore_organs[bellychoice]
				src.visible_message("<span class='warning'>[user] is trying to stuff a beacon into [src]'s [bellychoice]!</span>","<span class='warning'>[user] is trying to stuff a beacon into you!</span>")
				if(do_after(user,30,src))
					user.drop_item()
					I.loc = src
					B.internal_contents += I
					src.visible_message("<span class='warning'>[src] is fed the beacon!</span>","You're fed the beacon!")
					playsound(get_turf(src), B.vore_sound,50,0,-6,0)
					return 1
				else
					return 1 //You don't get to hit someone 'later'

	return 0
*/
//
// Custom resist catches for /mob/living
//
/mob/living/proc/vore_process_resist()

	//Are we resisting from inside a belly?
	var/datum/belly/B = check_belly(src)
	if(B)
		spawn()	B.relay_resist(src)
		return TRUE //resist() on living does this TRUE thing.

	//Other overridden resists go here


	return FALSE

//
//	Proc for updating vore organs and digestion/healing/absorbing
//
/mob/living/proc/handle_internal_contents()
	if(SSmobs.times_fired%6==1)
		return //The accursed timer

	for (var/I in vore_organs)
		var/datum/belly/B = vore_organs[I]
		if(B.internal_contents.len)
			B.process_Life() //AKA 'do bellymodes_vr.dm'

	for (var/I in vore_organs)
		var/datum/belly/B = vore_organs[I]
		if(B.internal_contents.len)
			listclearnulls(B.internal_contents)
			for(var/atom/movable/M in B.internal_contents)
				if(M.loc != src)
					B.internal_contents.Remove(M)


// OOC Escape code for pref-breaking or AFK preds
//
/mob/living/proc/escapeOOC()
	set name = "Animal Escape"
	set category = "Vore"

	//You're in an animal!
	if(istype(src.loc,/mob/living/simple_animal))
		var/mob/living/simple_animal/pred = src.loc
		var/confirm = alert(src, "You're in a mob. Use this as a trick to get out of hostile animals. If you are in more than one pred, use this more than once.", "Confirmation", "Okay", "Cancel")
		if(confirm == "Okay")
			for(var/I in pred.vore_organs)
				var/datum/belly/B = pred.vore_organs[I]
				B.release_specific_contents(src)

			for(var/mob/living/simple_animal/SA in range(10))
				SA.prey_excludes += src
				spawn(18000)
					if(src && SA)
						SA.prey_excludes -= src

			pred.update_icons()

	else
		to_chat(src, "<span class='alert'>You aren't inside anything, you clod.</span>")

//
//	Verb for saving vore preferences to save file
//
/mob/living/proc/save_vore_prefs()
	if(!(client || client.prefs_vr))
		return FALSE
	if(!copy_to_prefs_vr())
		return FALSE
	if(!client.prefs_vr.save_vore())
		return FALSE

	return TRUE

/mob/living/proc/apply_vore_prefs()
	if(!(client || client.prefs_vr))
		return FALSE
	if(!client.prefs_vr.load_vore())
		return FALSE
	if(!copy_from_prefs_vr())
		return FALSE

	return TRUE

/mob/living/proc/copy_to_prefs_vr()
	if(!client || !client.prefs_vr)
		src << "<span class='warning'>You attempted to save your vore prefs but somehow you're in this character without a client.prefs_vr variable. Tell a dev.</span>"
		return FALSE

	var/datum/vore_preferences/P = client.prefs_vr

	P.digestable = src.digestable
	P.devourable = src.devourable
	P.belly_prefs = src.vore_organs
	P.vore_taste = src.vore_taste

	return TRUE

//
//	Proc for applying vore preferences, given bellies
//
/mob/living/proc/copy_from_prefs_vr()
	if(!client || !client.prefs_vr)
		src << "<span class='warning'>You attempted to apply your vore prefs but somehow you're in this character without a client.prefs_vr variable. Tell a dev.</span>"
		return FALSE

	var/datum/vore_preferences/P = client.prefs_vr

	src.digestable = P.digestable
	src.devourable = P.devourable
	src.vore_organs = list()
	src.vore_taste = P.vore_taste

	for(var/I in P.belly_prefs)
		var/datum/belly/Bp = P.belly_prefs[I]
		src.vore_organs[Bp.name] = Bp.copy(src)

	return TRUE
//
// Clearly super important. Obviously.
//
/mob/living/proc/lick(var/mob/living/tasted in oview(1))
	set name = "Lick Someone"
	set category = "Vore"
	set desc = "Lick someone nearby!"

	if(!istype(tasted))
		return

	if(src == stat)
		return

	src.setClickCooldown(50)

	src.visible_message("<span class='warning'>[src] licks [tasted]!</span>","<span class='notice'>You lick [tasted]. They taste rather like [tasted.get_taste_message()].</span>","<b>Slurp!</b>")


/mob/living/proc/get_taste_message(allow_generic = TRUE, datum/species/mrace)
	if(!vore_taste && !allow_generic)
		return FALSE

	var/taste_message = ""
	if(vore_taste && (vore_taste != ""))
		taste_message += "[vore_taste]"
	else
		if(ishuman(src))
			taste_message += "normal, like a critter should"
		else
			taste_message += "a plain old normal [src]"

/*	if(ishuman(src))
		var/mob/living/carbon/human/H = src
		if(H.touching.reagent_list.len) //Just the first one otherwise I'll go insane.
			var/datum/reagent/R = H.touching.reagent_list[1]
			taste_message += " You also get the flavor of [R.taste_description] from something on them"*/
	return taste_message
