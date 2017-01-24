///////////////////// Mob Living /////////////////////
/mob/living
	var/digestable = 1					// Can the mob be digested inside a belly?
	var/datum/belly/vore_selected		// Default to no vore capability.
	var/list/vore_organs = list()		// List of vore containers inside a mob
	var/devourable = 0					// Can the mob be vored at all?
//	var/feeding = 0 					// Are we going to feed someone else?

//
// Handle being clicked, perhaps with something to devour
//

			// Refactored to use centralized vore code system - Leshana

			// Critical adjustments due to TG grab changes - Poojawa

/mob/living/proc/vore_attack(var/mob/living/user, var/mob/living/prey)
	if(!user)
		return
	if(!prey)
		return
	if(prey==user)
		return
	if(prey == src && user.zone_selected == "mouth") //you click your target
		if(!is_vore_predator(prey))
			user << "<span class='notice'>They aren't voracious enough.</span>"
		feed_self_to_grabbed(user)

	if(user == src) //you click yourself
		if(!is_vore_predator(src))
			user << "<span class='notice'>You aren't voracious enough.</span>"
		feed_grabbed_to_self(prey, user)

	else // click someone other than you/prey
		if(!is_vore_predator(src))
			user << "<span class='notice'>They aren't voracious enough.</span>"
			return
		feed_grabbed_to_other(user)
//
// Eating procs depending on who clicked what
//
/mob/living/proc/feed_grabbed_to_self(var/mob/living/user, var/mob/living/prey)
	var/belly = user.vore_selected
	return perform_the_nom(prey, user, prey, belly)
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

//
// Master vore proc that actually does vore procedures
//

/mob/living/proc/perform_the_nom(var/mob/living/user, var/mob/living/prey, var/mob/living/pred, var/belly, swallow_time = 100)
	//Sanity
	if(!user || !prey || !pred || !belly || !(belly in pred.vore_organs))
		return
	if (!prey.devourable)
		user << "This can't be eaten!"
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
		return 0 // Prey escaped (or user disabled) before timer expired.

	// If we got this far, nom successful! Announce it!
	user.visible_message(success_msg)
	playsound(user, belly_target.vore_sound, 100, 1)

	// Actually shove prey into the belly.
	belly_target.nom_mob(prey, user)
//	user.update_icons()
	stop_pulling()

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

//
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
	if(SSmob.times_fired%6==1)
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
		src << "<span class='alert'>You aren't inside anything, you clod.</span>"
