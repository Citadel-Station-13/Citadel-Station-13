/**
  * Called by SSmobs at an interval of 2 seconds.
  * Splits off into PhysicalLife() and BiologicalLife(). Override those instead of this.
  */
/mob/living/proc/Life(seconds, times_fired)
	SHOULD_NOT_SLEEP(TRUE)
	if(mob_transforming)
		return
	. = SEND_SIGNAL(src, COMSIG_LIVING_LIFE, seconds, times_fired)
	if(!(. & COMPONENT_INTERRUPT_LIFE_PHYSICAL))
		PhysicalLife(seconds, times_fired)
	if(!(. & COMPONENT_INTERRUPT_LIFE_BIOLOGICAL))
		BiologicalLife(seconds, times_fired)
	if(!(. & COMPONET_INTERRUPT_STATUS_EFFECTS))
		handle_status_effects() //all special effects, stun, knockdown, jitteryness, hallucination, sleeping, etc
	// CODE BELOW SHOULD ONLY BE THINGS THAT SHOULD HAPPEN NO MATTER WHAT AND CAN NOT BE SUSPENDED!
	// Otherwise, it goes into one of the two split Life procs!

	if (client)
		var/turf/T = get_turf(src)
		if(!T)
			for(var/obj/effect/landmark/error/E in GLOB.landmarks_list)
				forceMove(E.loc)
				break
			var/msg = "[key_name_admin(src)] [ADMIN_JMP(src)] was found to have no .loc with an attached client, if the cause is unknown it would be wise to ask how this was accomplished."
			message_admins(msg)
			INVOKE_ASYNC(GLOBAL_PROC, GLOBAL_PROC_REF(send2tgs_adminless_only), "Mob", msg, R_ADMIN)
			log_game("[key_name(src)] was found to have no .loc with an attached client.")

		// This is a temporary error tracker to make sure we've caught everything
		else if (registered_z != T.z)
#ifdef TESTING
			message_admins("[src] [ADMIN_FLW(src)] has somehow ended up in Z-level [T.z] despite being registered in Z-level [registered_z]. If you could ask them how that happened and notify coderbus, it would be appreciated.")
#endif
			log_game("Z-TRACKING: [src] has somehow ended up in Z-level [T.z] despite being registered in Z-level [registered_z].")
			update_z(T.z)
	else if (registered_z)
		log_game("Z-TRACKING: [src] of type [src.type] has a Z-registration despite not having a client.")
		update_z(null)

/**
  * Handles biological life processes like chemical metabolism, breathing, etc
  * Returns TRUE or FALSE based on if we were interrupted. This is used by overridden variants to check if they should stop.
  */
/mob/living/proc/BiologicalLife(delta_time, times_fired)
	SEND_SIGNAL(src,COMSIG_LIVING_BIOLOGICAL_LIFE, delta_time, times_fired)
	handle_diseases()// DEAD check is in the proc itself; we want it to spread even if the mob is dead, but to handle its disease-y properties only if you're not.

	handle_wounds()

	// Everything after this shouldn't process while dead (as of the time of writing)
	if(stat == DEAD)
		return FALSE

	//Mutations and radiation
	handle_mutations_and_radiation()

	//Breathing, if applicable
	handle_breathing(times_fired)

	if (QDELETED(src)) // diseases can qdel the mob via transformations
		return FALSE

	//Random events (vomiting etc)
	handle_random_events()

	//stuff in the stomach
	handle_stomach()

	handle_block_parry(delta_time)

	handle_traits() // eye, ear, brain damages

	return TRUE

/**
  * Handles physical life processes like being on fire. Don't ask why this is considered "Life".
  * Returns TRUE or FALSE based on if we were interrupted. This is used by overridden variants to check if they should stop.
  */
/mob/living/proc/PhysicalLife(seconds, times_fired)
	SEND_SIGNAL(src,COMSIG_LIVING_PHYSICAL_LIFE, seconds, times_fired)
	if(digitalinvis)
		handle_diginvis() //AI becomes unable to see mob

	if((movement_type & FLYING) && !(movement_type & FLOATING))	//TODO: Better floating
		INVOKE_ASYNC(src, TYPE_PROC_REF(/atom/movable, float), TRUE)

	if(!loc)
		return FALSE

	var/datum/gas_mixture/environment = loc.return_air()

	//Handle temperature/pressure differences between body and environment
	if(environment)
		handle_environment(environment)

	handle_fire()

	handle_gravity()

	if(machine)
		machine.check_eye(src)
	return TRUE

/mob/living/proc/handle_breathing(times_fired)
	return

/mob/living/proc/handle_mutations_and_radiation()
	radiation = 0 //so radiation don't accumulate in simple animals
	return

/mob/living/proc/handle_diseases()
	return

/mob/living/proc/handle_wounds()
	return

/mob/living/proc/handle_diginvis()
	if(!digitaldisguise)
		src.digitaldisguise = image(loc = src)
	src.digitaldisguise.override = 1
	for(var/mob/living/silicon/ai/AI in GLOB.player_list)
		AI.client.images |= src.digitaldisguise


/mob/living/proc/handle_random_events()
	return

/mob/living/proc/handle_environment(datum/gas_mixture/environment)
	return

/mob/living/proc/handle_fire()
	if(fire_stacks < 0) //If we've doused ourselves in water to avoid fire, dry off slowly
		fire_stacks = min(0, fire_stacks + 1)//So we dry ourselves back to default, nonflammable.
	if(!on_fire)
		return TRUE
	if(fire_stacks > 0)
		adjust_fire_stacks(-0.1) //the fire is slowly consumed
	else
		ExtinguishMob()
		return
	var/datum/gas_mixture/G = loc.return_air() // Check if we're standing in an oxygenless environment
	if(!G.get_moles(GAS_O2, 1))
		ExtinguishMob() //If there's no oxygen in the tile we're on, put out the fire
		return
	var/turf/location = get_turf(src)
	location.hotspot_expose(700, 10, 1)

/mob/living/proc/handle_stomach()
	return

/*
 * this updates some effects: mostly old stuff such as drunkness, druggy, stuttering, etc.
 * that should be converted to status effect datums one day.
 */
/mob/living/proc/handle_status_effects()
	if(confused)
		confused = max(0, confused - 1)

	if(stuttering)
		stuttering = max(stuttering-1, 0)

	if(slurring)
		slurring = max(slurring-1,0)

	if(cultslurring)
		cultslurring = max(cultslurring-1, 0)

	if(clockcultslurring)
		clockcultslurring = max(clockcultslurring-1, 0)

/mob/living/proc/handle_traits()
	//Eyes
	if(eye_blind)			//blindness, heals slowly over time
		if(!stat && !(HAS_TRAIT(src, TRAIT_BLIND)))
			eye_blind = max(eye_blind-1,0)
			if(client && !eye_blind)
				clear_alert("blind")
				clear_fullscreen("blind")
		else
			eye_blind = max(eye_blind-1,1)
	else if(eye_blurry)			//blurry eyes heal slowly
		eye_blurry = max(eye_blurry-1, 0)
		if(client)
			if(!eye_blurry)
				remove_eyeblur()
			else
				update_eyeblur()

/mob/living/proc/update_damage_hud()
	return

/mob/living/proc/handle_gravity()
	var/gravity = mob_has_gravity()
	update_gravity(gravity)

	if(gravity > STANDARD_GRAVITY)
		gravity_animate()
		handle_high_gravity(gravity)

/mob/living/proc/gravity_animate()
	if(!get_filter("gravity"))
		add_filter("gravity",1, GRAVITY_MOTION_BLUR)
	INVOKE_ASYNC(src, PROC_REF(gravity_pulse_animation))

/mob/living/proc/gravity_pulse_animation()
	animate(get_filter("gravity"), y = 1, time = 10)
	sleep(10)
	animate(get_filter("gravity"), y = 0, time = 10)

/mob/living/proc/handle_high_gravity(gravity)
	if(gravity >= GRAVITY_DAMAGE_TRESHOLD) //Aka gravity values of 3 or more
		var/grav_stregth = gravity - GRAVITY_DAMAGE_TRESHOLD
		adjustBruteLoss(min(grav_stregth,3))
