///////////////////// Mob Living /////////////////////
/mob/living
	var/digestable = 1					// Can the mob be digested inside a belly?
	var/datum/belly/vore_selected		// Default to no vore capability.
	var/list/vore_organs = list()		// List of vore containers inside a mob
	var/recent_struggle = 0
//
// Hook for generic creation of stuff on new creatures
//
/hook/living_new/proc/vore_setup(mob/living/M)
	M.verbs += /mob/living/proc/insidePanel
	M.verbs += /mob/living/proc/escapeOOC

	//Tries to load prefs if a client is present otherwise gives freebie stomach
	if(!M.vore_organs || !M.vore_organs.len)
		spawn(20) //Wait a couple of seconds to make sure copy_to or whatever has gone
			if(!M) return

		/*	if(M.client && M.client.prefs)
				if(!M.load_vore_preferences)
					M << "<span class='warning'>ERROR: You seem to have saved prefs, but they couldn't be loaded.</span>"
					return 0
				if(M.vore_organs && M.vore_organs.len)
					M.vore_selected = M.vore_organs[1] */

			if(!M.vore_organs || !M.vore_organs.len)
				if(!M.vore_organs)
					M.vore_organs = list()
				var/datum/belly/B = new /datum/belly(M)
				B.immutable = 1
				B.name = "Stomach"
				B.inside_flavor = "It appears to be rather warm and wet. Makes sense, considering it's inside \the [M.name]."
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

/mob/living/proc/vore_attack(mob/living/user, mob/M, var/mob/living/prey, var/mob/living/pred)
	var/mob/affecting = null
	var/mob/assailant = null
	if(!affecting)
		return

	if((ishuman(user) && !issilicon(affecting)) || (isalien(user) && !issilicon(affecting)))
		var/mob/living/attacker = user  // Typecast to human


		if((user == assailant) && (is_vore_predator(src)))
			if(!(is_vore_predator(user)))
				user.visible_message("<span class='notice'>You can't eat this.</span>")
				log_attack("[attacker] attempted to feed [affecting] to [user] ([user.type]) but it is not predator-capable")
				return

			else
				var/belly = user.vore_selected
				return perform_the_nom(user, prey, user, belly)

						// If you click yourself...

		///// If grab clicked on grabbed
		else if((user == affecting) && (attacker.a_intent == "grab") && (is_vore_predator(affecting)))
			if(!(is_vore_predator(affecting)))
				user.visible_message("<span class='notice'>[affecting] can't eat that</span>")
				log_attack("[attacker] attempted to feed [user] to [affecting] ([affecting.type]) but it is not predator-capable")
				return

			else
				var/belly = input("Choose Belly") in pred.vore_organs
				return perform_the_nom(user, user, pred, belly)



		///// If grab clicked on anyone else
		else if((src != affecting) && (src != assailant) && (is_vore_predator(M)))
			if(!(is_vore_predator(M)))
				user.visible_message("<span class='notice'>[M] can't eat that.</span>")
				log_attack("[attacker] attempted to feed [affecting] to [M] ([M.type]) but it is not predator-capable")
			else
				var/belly = input("Choose Belly") in pred.vore_organs
				return perform_the_nom(user, prey, pred, belly)


//End vore code.
/*
	//Handle case: /obj/item/weapon/holder
		if(/obj/item/weapon/holder/micro)
			var/obj/item/weapon/holder/H = I

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
					playsound(src, B.vore_sound, 100, 1)
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


	return 0


//
//	Proc for updating vore organs and digestion/healing/absorbing
//
/mob/living/proc/handle_internal_contents()
	if(SSair.times_fired%3 != 1)
		return //The accursed timer

	for (var/I in vore_organs)
		var/datum/belly/B = vore_organs[I]
		if(B.internal_contents.len)
			B.process_Life() //AKA 'do bellymodes_vr.dm'

	if(SSair.times_fired%3 != 1) return //Occasionally do supercleanups.
	for (var/I in vore_organs)
		var/datum/belly/B = vore_organs[I]
		if(B.internal_contents.len)
			for(var/atom/movable/M in B.internal_contents)
				if(M.loc != src)
					B.internal_contents -= M
					log_attack("Had to remove [M] from belly [B] in [src]")
/*
//
//	Verb for saving vore preferences to save file
//
/mob/living/proc/save_vore_prefs()
	if(!(client || client.prefs_vr))
		return 0
	if(!copy_to_prefs_vr())
		return 0
	if(!client.prefs_vr.save_vore())
		return 0

	return 1

/mob/living/proc/apply_vore_prefs()
	if(!(client || client.prefs_vr))
		return 0
	if(!client.prefs_vr.load_vore())
		return 0
	if(!copy_from_prefs_vr())
		return 0

	return 1

/mob/living/proc/copy_to_prefs_vr()
	if(!client || !client.prefs_vr)
		src << "<span class='warning'>You attempted to save your vore prefs but somehow you're in this character without a client.prefs_vr variable. Tell a dev.</span>"
		return 0

	var/datum/vore_preferences/P = client.prefs_vr

	P.digestable = src.digestable
	P.belly_prefs = src.vore_organs

	return 1

//
//	Proc for applying vore preferences, given bellies
//
/mob/living/proc/copy_from_prefs_vr()
	if(!client || !client.prefs_vr)
		src << "<span class='warning'>You attempted to apply your vore prefs but somehow you're in this character without a client.prefs_vr variable. Tell a dev.</span>"
		return 0

	var/datum/vore_preferences/P = client.prefs_vr

	src.digestable = P.digestable
	src.vore_organs = list()

	for(var/I in P.belly_prefs)
		var/datum/belly/Bp = P.belly_prefs[I]
		src.vore_organs[Bp.name] = Bp.copy(src)

	return 1
*/
//
//	Verb for saving vore preferences to save file
//
/mob/living/proc/save_vore_prefs()
	set name = "Save Vore Prefs"
	set category = "Vore"

	var/result = 0

	if(client.prefs)
		result = client.prefs.save_vore_preferences()
	else
		src << "<span class='warning'>You attempted to save your vore prefs but somehow you're in this character without a client.prefs variable. Tell a dev.</span>"
		log_admin("[src] tried to save vore prefs but lacks a client.prefs var.")

	return result

//
//	Proc for applying vore preferences, given bellies
//
/mob/living/proc/apply_vore_prefs(var/list/bellies)
	if(!bellies || bellies.len == 0)
		log_admin("Tried to apply bellies to [src] and failed.")


//
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
		src << "<span class='alert'>You aren't inside anything, you clod.</span>"

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
	return perform_the_nom(user, prey, pred, belly) */

/mob/living/proc/feed_self_to_grabbed(var/mob/living/user, var/mob/living/pred)
	var/belly = input("Choose Belly") in pred.vore_organs
	return perform_the_nom(user, user, pred, belly)

/mob/living/proc/feed_grabbed_to_other(var/mob/living/user, var/mob/living/prey, var/mob/living/pred)
	var/belly = input("Choose Belly") in pred.vore_organs
	return perform_the_nom(user, prey, pred, belly)

//
// Master vore proc that actually does vore procedures
//
/mob/living/proc/perform_the_nom(var/mob/living/user, var/mob/living/prey, var/mob/living/pred, var/belly)
	//Sanity
	if(!user || !prey || !pred || !belly || !(belly in pred.vore_organs))
		log_attack("[user] attempted to feed [prey] to [pred], via [belly] but it went wrong.")
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
	var/swallow_time = istype(prey, /mob/living/carbon/human) ? belly_target.human_prey_swallow_time : belly_target.nonhuman_prey_swallow_time
	/* POLARISTODO - Unnecessary?
	if (!do_mob(user, prey))
		return 0; // User is not able to act upon prey
	*/
	if(!do_after(user, swallow_time))
		return 0 // Prey escpaed (or user disabled) before timer expired.

	// If we got this far, nom successful! Announce it!
	user.visible_message(success_msg)
	stop_pulling()
	playsound(user, belly_target.vore_sound, 100, 1)

	// Actually shove prey into the belly.
	belly_target.nom_mob(prey, user)
	user.update_icons()

	// Inform Admins
	if (pred == user)
		message_admins("[key_name(pred)] ate [key_name(prey)]. ([pred ? "<a href='?_src_=holder;adminplayerobservecoodjump=1;X=[pred.x];Y=[pred.y];Z=[pred.z]'>JMP</a>" : "null"])")
		log_attack("[key_name(pred)] ate [key_name(prey)]")
	else if (prey == !client && stat != DEAD)
		message_admins("[key_name(pred)] ate [key_name(prey)] (braindead) ([pred ? "<a href='?_src_=holder;adminplayerobservecoodjump=1;X=[pred.x];Y=[pred.y];Z=[pred.z]'>JMP</a>" : "null"])")
		log_attack("[key_name(pred)] ate [key_name(prey)] (braindead)")
	else
		message_admins("[key_name(user)] forced [key_name(pred)] to eat [key_name(prey)]. ([pred ? "<a href='?_src_=holder;adminplayerobservecoodjump=1;X=[pred.x];Y=[pred.y];Z=[pred.z]'>JMP</a>" : "null"])")
		log_attack("[key_name(user)] forced [key_name(pred)] to eat [key_name(prey)].")
	return 1