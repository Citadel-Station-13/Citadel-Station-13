//Glorified teleporter that puts you in a new human body.
// it's """VR"""
/obj/machinery/vr_sleeper
	name = "virtual reality sleeper"
	desc = "A sleeper modified to alter the subconscious state of the user, allowing them to visit virtual worlds."
	icon = 'icons/obj/machines/sleeper.dmi'
	icon_state = "sleeper"
	state_open = TRUE
	occupant_typecache = list(/mob/living/carbon/human) // turned into typecache in Initialize
	circuit = /obj/item/circuitboard/machine/vr_sleeper
	var/you_die_in_the_game_you_die_for_real = FALSE
	var/datum/effect_system/spark_spread/sparks
	var/mob/living/vr_mob
	var/virtual_mob_type = /mob/living/carbon/human
	var/vr_category = "default" //Specific category of spawn points to pick from
	var/allow_creating_vr_mobs = TRUE //So you can have vr_sleepers that always spawn you as a specific person or 1 life/chance vr games
	var/only_current_user_can_interact = FALSE

/obj/machinery/vr_sleeper/Initialize()
	. = ..()
	sparks = new /datum/effect_system/spark_spread()
	sparks.set_up(2,0)
	sparks.attach(src)
	update_icon()
	new_occupant_dir = dir

/obj/machinery/vr_sleeper/setDir(newdir)
	. = ..()
	new_occupant_dir = dir

/obj/machinery/vr_sleeper/attackby(obj/item/I, mob/user, params)
	if(!state_open && !occupant)
		if(default_deconstruction_screwdriver(user, "[initial(icon_state)]-o", initial(icon_state), I))
			return
	if(default_change_direction_wrench(user, I))
		return
	if(default_pry_open(I))
		return
	if(default_deconstruction_crowbar(I))
		return
	return ..()

/obj/machinery/vr_sleeper/relaymove(mob/user)
	open_machine()

/obj/machinery/vr_sleeper/container_resist(mob/living/user)
	open_machine()

/obj/machinery/vr_sleeper/Destroy()
	open_machine()
	cleanup_vr_mob()
	QDEL_NULL(sparks)
	return ..()

/obj/machinery/vr_sleeper/hugbox
	desc = "A sleeper modified to alter the subconscious state of the user, allowing them to visit virtual worlds. Seems slightly more secure."
	flags_1 = NODECONSTRUCT_1
	only_current_user_can_interact = TRUE

/obj/machinery/vr_sleeper/emag_act(mob/user)
	. = ..()
	if(!(obj_flags & EMAGGED))
		return
	if(!only_current_user_can_interact)
		obj_flags |= EMAGGED
		you_die_in_the_game_you_die_for_real = TRUE
		sparks.start()
		addtimer(CALLBACK(src, .proc/emagNotify), 150)
		return TRUE

/obj/machinery/vr_sleeper/update_icon_state()
	icon_state = "[initial(icon_state)][state_open ? "-open" : ""]"

/obj/machinery/vr_sleeper/open_machine()
	if(state_open)
		return
	if(occupant)
		SStgui.close_user_uis(occupant, src)
	return ..()

/obj/machinery/vr_sleeper/MouseDrop_T(mob/target, mob/user)
	if(user.lying || !iscarbon(target) || !Adjacent(target) || !user.canUseTopic(src, BE_CLOSE, TRUE, NO_TK))
		return
	close_machine(target)

/obj/machinery/vr_sleeper/ui_interact(mob/user, ui_key = "main", datum/tgui/ui = null, force_open = FALSE, datum/tgui/master_ui = null, datum/ui_state/state = GLOB.default_state)
	ui = SStgui.try_update_ui(user, src, ui_key, ui, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "vr_sleeper", "VR Sleeper", 475, 340, master_ui, state)
		ui.open()

/obj/machinery/vr_sleeper/ui_act(action, params)
	if(..())
		return
	switch(action)
		if("vr_connect")
			var/mob/M = occupant
			if(M?.mind && M == usr)
				to_chat(M, "<span class='warning'>Transferring to virtual reality...</span>")
				var/datum/component/virtual_reality/VR
				if(vr_mob)
					VR = vr_mob.GetComponent(/datum/component/virtual_reality)
				if(!(VR?.connect(M)))
					if(allow_creating_vr_mobs)
						to_chat(occupant, "<span class='warning'>Virtual avatar [vr_mob ? "corrupted" : "missing"], attempting to create one...</span>")
						var/obj/effect/landmark/vr_spawn/V = get_vr_spawnpoint()
						var/turf/T = get_turf(V)
						if(T)
							new_player(occupant, T, V.vr_outfit)
						else
							to_chat(occupant, "<span class='warning'>Virtual world misconfigured, aborting transfer</span>")
					else
						to_chat(occupant, "<span class='warning'>The virtual world does not support the creation of new virtual avatars, aborting transfer</span>")
				else
					to_chat(vr_mob, "<span class='notice'>Transfer successful! You are now playing as [vr_mob] in VR!</span>")
			. = TRUE
		if("delete_avatar")
			if(!occupant || usr == occupant)
				if(vr_mob)
					cleanup_vr_mob()
			else
				to_chat(usr, "<span class='warning'>The VR Sleeper's safeties prevent you from doing that.</span>")
			. = TRUE
		if("toggle_open")
			if(state_open)
				close_machine()
			else if ((!occupant || usr == occupant) || !only_current_user_can_interact)
				open_machine()
			. = TRUE

/obj/machinery/vr_sleeper/ui_data(mob/user)
	var/list/data = list()
	if(vr_mob && !QDELETED(vr_mob))
		data["can_delete_avatar"] = TRUE
		data["vr_avatar"] = list("name" = vr_mob.name)
		data["isliving"] = istype(vr_mob)
		if(data["isliving"])
			var/status
			switch(vr_mob.stat)
				if(CONSCIOUS)
					status = "Conscious"
				if(DEAD)
					status = "Dead"
				if(UNCONSCIOUS)
					status = "Unconscious"
				if(SOFT_CRIT)
					status = "Barely Conscious"
			data["vr_avatar"] += list("status" = status, "health" = vr_mob.health, "maxhealth" = vr_mob.maxHealth)
	data["toggle_open"] = state_open
	data["emagged"] = you_die_in_the_game_you_die_for_real
	data["isoccupant"] = (user == occupant)
	return data

/obj/machinery/vr_sleeper/proc/get_vr_spawnpoint() //proc so it can be overridden for team games or something
	return safepick(GLOB.vr_spawnpoints[vr_category])

/obj/machinery/vr_sleeper/proc/build_spawnpoints() // used to rebuild the list for admins if need be
	GLOB.vr_spawnpoints = list()
	for(var/obj/effect/landmark/vr_spawn/V in GLOB.landmarks_list)
		GLOB.vr_spawnpoints[V.vr_category] = V

/obj/machinery/vr_sleeper/proc/new_player(mob/M, location, datum/outfit/outfit, transfer = TRUE)
	if(!M)
		return
	cleanup_vr_mob()
	vr_mob = new virtual_mob_type(location)
	if(vr_mob.build_virtual_character(M, outfit) && iscarbon(vr_mob))
		var/mob/living/carbon/C = vr_mob
		C.updateappearance(TRUE, TRUE, TRUE)
	var/datum/component/virtual_reality/VR = vr_mob.AddComponent(/datum/component/virtual_reality, you_die_in_the_game_you_die_for_real)
	if(VR.connect(M))
		RegisterSignal(VR, COMSIG_COMPONENT_UNREGISTER_PARENT, .proc/unset_vr_mob)
		RegisterSignal(VR, COMSIG_COMPONENT_REGISTER_PARENT, .proc/set_vr_mob)
		if(!only_current_user_can_interact)
			VR.RegisterSignal(src, COMSIG_ATOM_EMAG_ACT, /datum/component/virtual_reality.proc/you_only_live_once)
		VR.RegisterSignal(src, COMSIG_MACHINE_EJECT_OCCUPANT, /datum/component/virtual_reality.proc/revert_to_reality)
		VR.RegisterSignal(src, COMSIG_PARENT_QDELETING, /datum/component/virtual_reality.proc/machine_destroyed)
		to_chat(vr_mob, "<span class='notice'>Transfer successful! You are now playing as [vr_mob] in VR!</span>")
	else
		to_chat(M, "<span class='notice'>Transfer failed! virtual reality data likely corrupted!</span>")

/obj/machinery/vr_sleeper/proc/unset_vr_mob(datum/component/virtual_reality/VR)
	vr_mob = null

/obj/machinery/vr_sleeper/proc/set_vr_mob(datum/component/virtual_reality/VR)
	vr_mob = VR.parent

/obj/machinery/vr_sleeper/proc/cleanup_vr_mob()
	if(vr_mob)
		QDEL_NULL(vr_mob)

/obj/machinery/vr_sleeper/proc/emagNotify()
	if(vr_mob)
		vr_mob.Dizzy(10)

/obj/effect/landmark/vr_spawn //places you can spawn in VR, auto selected by the vr_sleeper during get_vr_spawnpoint()
	var/vr_category = "default" //So we can have specific sleepers, eg: "Basketball VR Sleeper", etc.
	var/vr_outfit = /datum/outfit/vr

/obj/effect/landmark/vr_spawn/Initialize()
	. = ..()
	LAZYADD(GLOB.vr_spawnpoints[vr_category], src)

/obj/effect/landmark/vr_spawn/Destroy()
	LAZYREMOVE(GLOB.vr_spawnpoints[vr_category], src)
	return ..()

/obj/effect/landmark/vr_spawn/team_1
	vr_category = "team_1"

/obj/effect/landmark/vr_spawn/team_2
	vr_category = "team_2"

/obj/effect/landmark/vr_spawn/admin
	vr_category = "event"

/obj/effect/landmark/vr_spawn/syndicate // Multiple missions will use syndicate gear
	vr_outfit = /datum/outfit/vr/syndicate

/obj/effect/vr_clean_master // Will keep VR areas that have this relatively clean.
	icon = 'icons/mob/screen_gen.dmi'
	icon_state = "x2"
	color = "#00FF00"
	invisibility = INVISIBILITY_ABSTRACT
	var/area/vr_area
	var/list/corpse_party

/obj/effect/vr_clean_master/Initialize()
	. = ..()
	vr_area = get_base_area(src)
	if(!vr_area)
		return INITIALIZE_HINT_QDEL
	addtimer(CALLBACK(src, .proc/clean_up), 3 MINUTES, TIMER_LOOP)

/obj/effect/vr_clean_master/proc/clean_up()
	if (!vr_area)
		qdel(src)
		return
	var/list/contents = get_sub_areas_contents(vr_area)
	for (var/obj/item/ammo_casing/casing in contents)
		qdel(casing)
	for(var/obj/effect/decal/cleanable/C in contents)
		qdel(C)
	for (var/A in corpse_party)
		var/mob/M = A
		if(!QDELETED(M) && (M in contents) && M.stat == DEAD)
			qdel(M)
		corpse_party -= M
	addtimer(CALLBACK(src, .proc/clean_up), 3 MINUTES)
