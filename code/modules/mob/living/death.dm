/mob/living/gib(no_brain, no_organs, no_bodyparts, datum/explosion/was_explosion)
	var/prev_lying = lying
	if(stat != DEAD)
		death(1)

	if(!prev_lying)
		gib_animation()

	spill_organs(no_brain, no_organs, no_bodyparts, was_explosion)

	if(!no_bodyparts)
		spread_bodyparts(no_brain, no_organs, was_explosion)

	for(var/X in implants)
		var/obj/item/implant/I = X
		qdel(I)

	spawn_gibs(no_bodyparts, null, was_explosion)
	qdel(src)

/mob/living/proc/gib_animation()
	return

/mob/living/proc/spawn_gibs(with_bodyparts, atom/loc_override, datum/explosion/was_explosion)
	var/location = loc_override ? loc_override.drop_location() : drop_location()
	if(mob_biotypes & MOB_ROBOTIC)
		new /obj/effect/gibspawner/robot(location, src, get_static_viruses())
	else
		new /obj/effect/gibspawner/generic(location, src, get_static_viruses())

/mob/living/proc/spill_organs()
	return

/mob/living/proc/spread_bodyparts(no_brain, no_organs, datum/explosion/was_explosion)
	return

/mob/living/dust(just_ash, drop_items, force)
	death(TRUE)

	if(drop_items)
		unequip_everything()

	if(buckled)
		buckled.unbuckle_mob(src, force = TRUE)

	dust_animation()
	spawn_dust(just_ash)
	QDEL_IN(src,5) // since this is sometimes called in the middle of movement, allow half a second for movement to finish, ghosting to happen and animation to play. Looks much nicer and doesn't cause multiple runtimes.

/mob/living/proc/dust_animation()
	return

/mob/living/proc/spawn_dust(just_ash = FALSE)
	new /obj/effect/decal/cleanable/ash(loc)


/mob/living/death(gibbed)
	SEND_SIGNAL(src, COMSIG_LIVING_PREDEATH, gibbed)

	stat = DEAD
	unset_machine()
	timeofdeath = world.time
	tod = STATION_TIME_TIMESTAMP("hh:mm:ss", world.time)
	for(var/obj/item/I in contents)
		I.on_mob_death(src, gibbed)
	if(mind)
		mind.store_memory("Time of death: [tod]", 0)
	GLOB.alive_mob_list -= src
	if(!gibbed)
		GLOB.dead_mob_list += src
	if(ckey)
		var/datum/preferences/P = GLOB.preferences_datums[ckey]
		if(P)
			P.respawn_time_of_death = world.time
	set_drugginess(0)
	set_disgust(0)
	SetSleeping(0, 0)
	blind_eyes(1)
	reset_perspective(null)
	reload_fullscreen()
	update_action_buttons_icon()
	update_damage_hud()
	update_health_hud()
	update_mobility()
	med_hud_set_health()
	med_hud_set_status()
	clear_typing_indicator()
	if(!gibbed && !QDELETED(src))
		addtimer(CALLBACK(src, .proc/med_hud_set_status), (DEFIB_TIME_LIMIT * 10) + 1)
	stop_pulling()

	var/signal = SEND_SIGNAL(src, COMSIG_MOB_DEATH, gibbed) | SEND_GLOBAL_SIGNAL(COMSIG_GLOB_MOB_DEATH, src, gibbed)

	var/turf/T = get_turf(src)
	if(mind && mind.name && mind.active && !istype(T.loc, /area/ctf) && !(signal & COMPONENT_BLOCK_DEATH_BROADCAST))
		var/rendered = "<span class='deadsay'><b>[mind.name]</b> has died at <b>[get_area_name(T)]</b>.</span>"
		deadchat_broadcast(rendered, follow_target = src, turf_target = T, message_type=DEADCHAT_DEATHRATTLE)
	if (client && client.prefs && client.prefs.auto_ooc)
		if (!(client.prefs.chat_toggles & CHAT_OOC))
			client.prefs.chat_toggles ^= CHAT_OOC
	if (client)
		client.move_delay = initial(client.move_delay)

	for(var/s in ownedSoullinks)
		var/datum/soullink/S = s
		S.ownerDies(gibbed)
	for(var/s in sharedSoullinks)
		var/datum/soullink/S = s
		S.sharerDies(gibbed)
	release_vore_contents(silent = TRUE)
	return TRUE
