GLOBAL_LIST_EMPTY(electrochromatic_window_lookup)

/proc/do_electrochromatic_toggle(new_status, id)
	var/list/windows = GLOB.electrochromatic_window_lookup["[id]"]
	if(!windows)
		return
	var/obj/structure/window/W		//define outside for performance because obviously this matters.
	for(var/i in windows)
		W = i
		new_status? W.electrochromatic_dim() : W.electrochromatic_off()

/obj/structure/window
	name = "window"
	desc = "A window."
	icon_state = "window"
	density = TRUE
	layer = ABOVE_OBJ_LAYER //Just above doors
	pressure_resistance = 4*ONE_ATMOSPHERE
	anchored = TRUE //initially is 0 for tile smoothing
	max_integrity = 25
	var/ini_dir = null
	var/state = WINDOW_OUT_OF_FRAME
	var/reinf = FALSE
	var/extra_reinforced = FALSE
	var/heat_resistance = 800
	var/decon_speed = 30
	var/wtype = "glass"
	var/fulltile = FALSE
	var/obj/item/stack/sheet/glass_type = /obj/item/stack/sheet/glass
	var/cleanable_type = /obj/effect/decal/cleanable/glass
	var/glass_amount = 1
	can_be_unanchored = TRUE
	resistance_flags = ACID_PROOF
	armor = list("melee" = 0, "bullet" = 0, "laser" = 0, "energy" = 0, "bomb" = 0, "bio" = 0, "rad" = 0, "fire" = 80, "acid" = 100)
	CanAtmosPass = ATMOS_PASS_PROC
	var/real_explosion_block	//ignore this, just use explosion_block
	var/breaksound = "shatter"
	var/hitsound = 'sound/effects/Glasshit.ogg'
	rad_insulation = RAD_VERY_LIGHT_INSULATION
	rad_flags = RAD_PROTECT_CONTENTS
	flags_1 = ON_BORDER_1|DEFAULT_RICOCHET_1
	flags_ricochet =  RICOCHET_HARD
	ricochet_chance_mod = 0.4
	attack_hand_speed = CLICK_CD_MELEE
	attack_hand_is_action = TRUE

	explosion_flags = EXPLOSION_FLAG_HARD_OBSTACLE
	wave_explosion_block = EXPLOSION_BLOCK_WINDOW
	wave_explosion_multiply = EXPLOSION_DAMPEN_WINDOW

	/// Electrochromatic status
	var/electrochromatic_status = NOT_ELECTROCHROMATIC
	/// Electrochromatic ID. Set the first character to ! to replace with a SSmapping generated pseudorandom obfuscated ID for mapping purposes.
	var/electrochromatic_id

/obj/structure/window/examine(mob/user)
	. = ..()
	if(electrochromatic_status != NOT_ELECTROCHROMATIC)
		. += "<span class='notice'>The window has electrochromatic circuitry on it.</span>"
	if(reinf)
		if(anchored && state == WINDOW_SCREWED_TO_FRAME)
			. += "<span class='notice'>The window is <b>screwed</b> to the frame.</span>"
		else if(anchored && state == WINDOW_IN_FRAME)
			. += "<span class='notice'>The window is <i>unscrewed</i> but <b>pried</b> into the frame.</span>"
		else if(anchored && state == WINDOW_OUT_OF_FRAME)
			. += "<span class='notice'>The window is out of the frame, but could be <i>pried</i> in. It is <b>screwed</b> to the floor.</span>"
		else if(!anchored)
			. += "<span class='notice'>The window is <i>unscrewed</i> from the floor, and could be deconstructed by <b>wrenching</b>.</span>"
		switch(state)
			if(PRWINDOW_SECURE)
				if(extra_reinforced)
					. += "It's been screwed in with one way screws, you'd need to <b>heat their solder cover</b> to have any chance of backing them out."
				else
					. += "It's been screwed in with solid screws, you'd need to <b>screw them</b> out to unsecure the window."
			if(PRWINDOW_BOLTS_HEATED)
				. += "The solder cover melts away, and you'll likely be able to <b>unscrew them</b> now."
			if(PRWINDOW_BOLTS_OUT)
				. += "The screws have been removed, revealing a small gap you could fit a <b>prying tool</b> in."
			if(PRWINDOW_POPPED)
				. += "The main plate of the window has popped out of the frame, exposing some bars that look like they can be <b>cut</b>."
			if(PRWINDOW_BARS_CUT)
				. += "The main pane can be easily moved out of the way to reveal some <b>bolts</b> holding the frame in."
	else
		if(anchored)
			. += "<span class='notice'>The window is <b>screwed</b> to the floor.</span>"
		else
			. += "<span class='notice'>The window is <i>unscrewed</i> from the floor, and could be deconstructed by <b>wrenching</b>.</span>"

/obj/structure/window/Initialize(mapload, direct)
	. = ..()
	if(direct)
		setDir(direct)
	
	if(extra_reinforced && anchored)
		state = PRWINDOW_SECURE

	else if(reinf && anchored)
		state = WINDOW_SCREWED_TO_FRAME
	

	if(mapload && electrochromatic_id && electrochromatic_id[1] == "!")
		electrochromatic_id = SSmapping.get_obfuscated_id(electrochromatic_id)

	ini_dir = dir
	air_update_turf(1)

	if(fulltile)
		setDir()

	//windows only block while reinforced and fulltile, so we'll use the proc
	real_explosion_block = explosion_block
	explosion_block = EXPLOSION_BLOCK_PROC

	if(electrochromatic_status != NOT_ELECTROCHROMATIC)
		var/old = electrochromatic_status
		make_electrochromatic()
		if(old == ELECTROCHROMATIC_DIMMED)
			electrochromatic_dim()

/obj/structure/window/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/simple_rotation,ROTATION_ALTCLICK | ROTATION_CLOCKWISE | ROTATION_COUNTERCLOCKWISE | ROTATION_VERBS ,null,CALLBACK(src, .proc/can_be_rotated),CALLBACK(src,.proc/after_rotation))

/obj/structure/window/rcd_vals(mob/user, obj/item/construction/rcd/the_rcd)
	switch(the_rcd.mode)
		if(RCD_DECONSTRUCT)
			return list("mode" = RCD_DECONSTRUCT, "delay" = 20, "cost" = 5)
	return FALSE

/obj/structure/window/rcd_act(mob/user, var/obj/item/construction/rcd/the_rcd)
	switch(the_rcd.mode)
		if(RCD_DECONSTRUCT)
			to_chat(user, "<span class='notice'>You deconstruct the window.</span>")
			qdel(src)
			return TRUE
	return FALSE

/obj/structure/window/wave_explosion_damage(power, datum/wave_explosion/explosion)
	return EXPLOSION_POWER_STANDARD_SCALE_WINDOW_DAMAGE(power, explosion.window_shatter_mod)

/obj/structure/window/narsie_act()
	add_atom_colour(NARSIE_WINDOW_COLOUR, FIXED_COLOUR_PRIORITY)

/obj/structure/window/ratvar_act()
	if(!fulltile)
		new/obj/structure/window/reinforced/clockwork(get_turf(src), dir)
	else
		new/obj/structure/window/reinforced/clockwork/fulltile(get_turf(src))
	qdel(src)

/obj/structure/window/singularity_pull(S, current_size)
	..()
	if(current_size >= STAGE_FIVE)
		deconstruct(FALSE)

/obj/structure/window/setDir(direct)
	if(!fulltile)
		..()
	else
		..(FULLTILE_WINDOW_DIR)

/obj/structure/window/CanPass(atom/movable/mover, turf/target)
	if(istype(mover) && (mover.pass_flags & PASSGLASS))
		return 1
	if(dir == FULLTILE_WINDOW_DIR)
		return 0	//full tile window, you can't move into it!
	if(get_dir(loc, target) == dir)
		return !density
	if(istype(mover, /obj/structure/window))
		var/obj/structure/window/W = mover
		if(!valid_window_location(loc, W.ini_dir))
			return FALSE
	else if(istype(mover, /obj/structure/windoor_assembly))
		var/obj/structure/windoor_assembly/W = mover
		if(!valid_window_location(loc, W.ini_dir))
			return FALSE
	else if(istype(mover, /obj/machinery/door/window) && !valid_window_location(loc, mover.dir))
		return FALSE
	return 1

/obj/structure/window/CheckExit(atom/movable/O, turf/target)
	if(istype(O) && (O.pass_flags & PASSGLASS))
		return 1
	if(get_dir(O.loc, target) == dir)
		return 0
	return 1

/obj/structure/window/attack_tk(mob/user)
	user.DelayNextAction(CLICK_CD_MELEE)
	user.visible_message("<span class='notice'>Something knocks on [src].</span>")
	add_fingerprint(user)
	playsound(src, 'sound/effects/Glassknock.ogg', 50, 1)

/obj/structure/window/attack_hulk(mob/living/carbon/human/user, does_attack_animation = 0)
	if(!can_be_reached(user))
		return 1
	. = ..()

/obj/structure/window/on_attack_hand(mob/user, act_intent = user.a_intent, unarmed_attack_flags)
	if(!can_be_reached(user))
		return
	user.visible_message("[user] knocks on [src].")
	add_fingerprint(user)
	playsound(src, 'sound/effects/Glassknock.ogg', 50, 1)

/obj/structure/window/attack_paw(mob/user)
	user.DelayNextAction()
	return attack_hand(user)

/obj/structure/window/attack_generic(mob/user, damage_amount = 0, damage_type = BRUTE, damage_flag = 0, sound_effect = 1)	//used by attack_alien, attack_animal, and attack_slime
	if(!can_be_reached(user))
		return
	..()

/obj/structure/window/attackby(obj/item/I, mob/living/user, params)
	if(!can_be_reached(user))
		return 1 //skip the afterattack

	add_fingerprint(user)

	if(I.tool_behaviour == TOOL_WELDER && user.a_intent == INTENT_HELP)
		if(obj_integrity < max_integrity)
			if(!I.tool_start_check(user, amount=0))
				return

			to_chat(user, "<span class='notice'>You begin repairing [src]...</span>")
			if(I.use_tool(src, user, 40, volume=50))
				obj_integrity = max_integrity
				update_nearby_icons()
				to_chat(user, "<span class='notice'>You repair [src].</span>")
		else
			to_chat(user, "<span class='warning'>[src] is already in good condition!</span>")
		return

	if(istype(I, /obj/item/electronics/electrochromatic_kit) && user.a_intent == INTENT_HELP)
		var/obj/item/electronics/electrochromatic_kit/K = I
		if(electrochromatic_status != NOT_ELECTROCHROMATIC)
			to_chat(user, "<span class='warning'>[src] is already electrochromatic!</span>")
			return
		if(anchored)
			to_chat(user, "<span class='warning'>[src] must not be attached to the floor!</span>")
			return
		if(!K.id)
			to_chat(user, "<span class='warning'>[K] has no ID set!</span>")
			return
		if(!user.temporarilyRemoveItemFromInventory(K))
			to_chat(user, "<span class='warning'>[K] is stuck to your hand!</span>")
			return
		user.visible_message("<span class='notice'>[user] upgrades [src] with [I].</span>", "<span class='notice'>You upgrade [src] with [I].</span>")
		make_electrochromatic(K.id)
		qdel(K)

	if(!(flags_1 & NODECONSTRUCT_1) && !(state >= PRWINDOW_FRAME_BOLTED))
		if(I.tool_behaviour == TOOL_SCREWDRIVER)
			I.play_tool_sound(src, 75)
			if(state == WINDOW_SCREWED_TO_FRAME || state == WINDOW_IN_FRAME && anchored)
				to_chat(user, "<span class='notice'>You begin to [state == WINDOW_SCREWED_TO_FRAME ? "unscrew the window from":"screw the window to"] the frame...</span>")
				if(I.use_tool(src, user, decon_speed, extra_checks = CALLBACK(src, .proc/check_state_and_anchored, state, anchored)))
					if(extra_reinforced && state == WINDOW_IN_FRAME)
						state = PRWINDOW_SECURE
					else
						state = (state == WINDOW_IN_FRAME ? WINDOW_SCREWED_TO_FRAME : WINDOW_IN_FRAME)
					to_chat(user, "<span class='notice'>You [state == WINDOW_IN_FRAME ? "unfasten the window from":"fasten the window to"] the frame.</span>")
			else if(state == WINDOW_OUT_OF_FRAME)
				to_chat(user, "<span class='notice'>You begin to [anchored ? "unscrew the frame from":"screw the frame to"] the floor...</span>")
				if(I.use_tool(src, user, decon_speed, extra_checks = CALLBACK(src, .proc/check_state_and_anchored, state, anchored)))
					setAnchored(!anchored)
					to_chat(user, "<span class='notice'>You [anchored ? "fasten the frame to":"unfasten the frame from"] the floor.</span>")
			return


		else if(I.tool_behaviour == TOOL_CROWBAR && reinf && (state == WINDOW_OUT_OF_FRAME || state == WINDOW_IN_FRAME) && anchored)
			to_chat(user, "<span class='notice'>You begin to lever the window [state == WINDOW_OUT_OF_FRAME ? "into":"out of"] the frame...</span>")
			I.play_tool_sound(src, 75)
			if(I.use_tool(src, user, decon_speed, extra_checks = CALLBACK(src, .proc/check_state_and_anchored, state, anchored)))
				state = (state == WINDOW_OUT_OF_FRAME ? WINDOW_IN_FRAME : WINDOW_OUT_OF_FRAME)
				to_chat(user, "<span class='notice'>You pry the window [state == WINDOW_IN_FRAME ? "into":"out of"] the frame.</span>")
			return

		else if(I.tool_behaviour == TOOL_WRENCH && !anchored)
			I.play_tool_sound(src, 75)
			to_chat(user, "<span class='notice'> You begin to disassemble [src]...</span>")
			if(I.use_tool(src, user, decon_speed, extra_checks = CALLBACK(src, .proc/check_state_and_anchored, state, anchored)))
				var/obj/item/stack/sheet/G = new glass_type(user.loc, glass_amount)
				G.add_fingerprint(user)
				playsound(src, 'sound/items/Deconstruct.ogg', 50, 1)
				to_chat(user, "<span class='notice'>You successfully disassemble [src].</span>")
				qdel(src)
			return
	if(!reinf || !anchored)
		return ..()
	switch(state)
		if(PRWINDOW_SECURE)
			if(extra_reinforced)
				if(I.tool_behaviour == TOOL_WELDER && user.a_intent == INTENT_HARM)
					user.visible_message("<span class='notice'>[user] holds \the [I] to the security screws on \the [src]...</span>",
											"<span class='notice'>You begin heating the security screws on \the [src]...</span>")
					if(I.use_tool(src, user, 180, volume = 100))
						to_chat(user, "<span class='notice'>The security bolts are glowing white hot and look ready to be removed.</span>")
						state = PRWINDOW_BOLTS_HEATED
						addtimer(CALLBACK(src, .proc/cool_bolts), 300)
					return
			else
				if(I.tool_behaviour == TOOL_SCREWDRIVER)
					user.visible_message("<span class='notice'>[user] digs into the screws and starts removing them...</span>",
										"<span class='notice'>You dig into the screws hard and they start turning...</span>")
					if(I.use_tool(src, user, 80, volume = 50))
						state = PRWINDOW_BOLTS_OUT
						to_chat(user, "<span class='notice'>The screws come out, and a gap forms around the edge of the pane.</span>")
					return
		if(PRWINDOW_BOLTS_HEATED)
			if(I.tool_behaviour == TOOL_SCREWDRIVER)
				user.visible_message("<span class='notice'>[user] digs into the security screws and starts removing them...</span>",
										"<span class='notice'>You dig into the screws hard and they start turning...</span>")
				if(I.use_tool(src, user, 80, volume = 50))
					state = PRWINDOW_BOLTS_OUT
					to_chat(user, "<span class='notice'>The screws come out, and a gap forms around the edge of the pane.</span>")
				return
		if(PRWINDOW_BOLTS_OUT)
			if(I.tool_behaviour == TOOL_CROWBAR)
				user.visible_message("<span class='notice'>[user] wedges \the [I] into the gap in the frame and starts prying...</span>",
										"<span class='notice'>You wedge \the [I] into the gap in the frame and start prying...</span>")
				if(I.use_tool(src, user, 50, volume = 50))
					state = PRWINDOW_POPPED
					to_chat(user, "<span class='notice'>The panel pops out of the frame, exposing some thin metal bars that looks like they can be cut.</span>")
				return
		if(PRWINDOW_POPPED)
			if(I.tool_behaviour == TOOL_WIRECUTTER)
				user.visible_message("<span class='notice'>[user] starts cutting the exposed bars on \the [src]...</span>",
										"<span class='notice'>You start cutting the exposed bars on \the [src]</span>")
				if(I.use_tool(src, user, 30, volume = 50))
					state = PRWINDOW_BARS_CUT
					to_chat(user, "<span class='notice'>The panels falls out of the way exposing the frame bolts.</span>")
				return
		if(PRWINDOW_BARS_CUT)
			if(I.tool_behaviour == TOOL_WRENCH)
				user.visible_message("<span class='notice'>[user] starts unfastening \the [src] from the frame...</span>",
					"<span class='notice'>You start unfastening the bolts from the frame...</span>")
				if(I.use_tool(src, user, 50, volume = 50))
					to_chat(user, "<span class='notice'>You unscrew the bolts from the frame and the window pops loose.</span>")
					state = WINDOW_OUT_OF_FRAME
					setAnchored(FALSE)
				return
	return ..()

/obj/structure/window/proc/cool_bolts()
	if(state == PRWINDOW_BOLTS_HEATED)
		state = PRWINDOW_SECURE
		visible_message("<span class='notice'>The bolts on \the [src] look like they've cooled off...</span>")

/obj/structure/window/setAnchored(anchorvalue)
	..()
	air_update_turf(TRUE)
	update_nearby_icons()

/obj/structure/window/proc/electrochromatic_dim()
	if(electrochromatic_status == ELECTROCHROMATIC_DIMMED)
		return
	electrochromatic_status = ELECTROCHROMATIC_DIMMED
	var/current = color
	add_atom_colour("#222222", FIXED_COLOUR_PRIORITY)
	var/newcolor = color
	if(color != current)
		color = current
		animate(src, color = newcolor, time = 2)

/obj/structure/window/proc/electrochromatic_off()
	if(electrochromatic_status == ELECTROCHROMATIC_OFF)
		return
	electrochromatic_status = ELECTROCHROMATIC_OFF
	var/current = color
	remove_atom_colour(FIXED_COLOUR_PRIORITY, "#222222")
	var/newcolor = color
	if(color != current)
		color = current
		animate(src, color = newcolor, time = 2)

/obj/structure/window/proc/remove_electrochromatic()
	electrochromatic_off()
	electrochromatic_status = NOT_ELECTROCHROMATIC
	if(!electrochromatic_id)
		return
	var/list/L = GLOB.electrochromatic_window_lookup["[electrochromatic_id]"]
	if(L)
		L -= src
	electrochromatic_id = null

/obj/structure/window/vv_edit_var(var_name, var_value)
	var/check_status
	if(var_name == NAMEOF(src, electrochromatic_id))
		if(electrochromatic_id && GLOB.electrochromatic_window_lookup["[electrochromatic_id]"])
			GLOB.electrochromatic_window_lookup[electrochromatic_id] -= src
	if(var_name == NAMEOF(src, electrochromatic_status))
		check_status = TRUE
	. = ..()		//do this first incase it runtimes.
	if(var_name == NAMEOF(src, electrochromatic_id))
		if((electrochromatic_status != NOT_ELECTROCHROMATIC) && electrochromatic_id)
			LAZYINITLIST(GLOB.electrochromatic_window_lookup[electrochromatic_id])
			GLOB.electrochromatic_window_lookup[electrochromatic_id] += src
	if(check_status)
		if(electrochromatic_status == NOT_ELECTROCHROMATIC)
			remove_electrochromatic()
			return
		else if(electrochromatic_status == ELECTROCHROMATIC_OFF)
			if(!electrochromatic_id)
				return
			else
				make_electrochromatic()
			electrochromatic_off()
			return
		else if(electrochromatic_status == ELECTROCHROMATIC_DIMMED)
			if(!electrochromatic_id)
				return
			else
				make_electrochromatic()
			electrochromatic_dim()
			return
		else
			remove_electrochromatic()

/obj/structure/window/proc/make_electrochromatic(new_id = electrochromatic_id)
	remove_electrochromatic()
	if(!new_id)
		CRASH("Attempted to make electrochromatic with null ID.")
	electrochromatic_id = new_id
	electrochromatic_status = ELECTROCHROMATIC_OFF
	LAZYINITLIST(GLOB.electrochromatic_window_lookup["[electrochromatic_id]"])
	GLOB.electrochromatic_window_lookup[electrochromatic_id] |= src

/obj/structure/window/update_atom_colour()
	. = ..()
	if(electrochromatic_status == ELECTROCHROMATIC_DIMMED || (color && (color_hex2num(color) < 255)))
		set_opacity(TRUE)
	else
		set_opacity(FALSE)

/obj/structure/window/proc/check_state(checked_state)
	if(state == checked_state)
		return TRUE

/obj/structure/window/proc/check_anchored(checked_anchored)
	if(anchored == checked_anchored)
		return TRUE

/obj/structure/window/proc/check_state_and_anchored(checked_state, checked_anchored)
	return check_state(checked_state) && check_anchored(checked_anchored)

/obj/structure/window/mech_melee_attack(obj/mecha/M)
	if(!can_be_reached())
		return
	..()

/obj/structure/window/proc/can_be_reached(mob/user)
	if(!fulltile)
		if(get_dir(user,src) & dir)
			for(var/obj/O in loc)
				if(!O.CanPass(user, user.loc, 1))
					return 0
	return 1

/obj/structure/window/take_damage(damage_amount, damage_type = BRUTE, damage_flag = 0, sound_effect = 1)
	. = ..()
	if(.) //received damage
		update_nearby_icons()

/obj/structure/window/play_attack_sound(damage_amount, damage_type = BRUTE, damage_flag = 0)
	switch(damage_type)
		if(BRUTE)
			if(damage_amount)
				playsound(src, hitsound, 75, 1)
			else
				playsound(src, 'sound/weapons/tap.ogg', 50, 1)
		if(BURN)
			playsound(src, 'sound/items/Welder.ogg', 100, 1)

/obj/structure/window/deconstruct(disassembled = TRUE)
	if(QDELETED(src))
		return
	if(!disassembled)
		playsound(src, breaksound, 70, 1)
		if(!(flags_1 & NODECONSTRUCT_1))
			for(var/obj/item/shard/debris in spawnDebris(drop_location()))
				transfer_fingerprints_to(debris) // transfer fingerprints to shards only
	if(electrochromatic_status != NOT_ELECTROCHROMATIC)		//eh fine keep your kit.
		new /obj/item/electronics/electrochromatic_kit(drop_location())
		// Intentionally not setting the ID so you can't decon one to know all of the IDs.
	qdel(src)
	update_nearby_icons()

/obj/structure/window/proc/spawnDebris(location)
	. = list()
	var/shard = initial(glass_type.shard_type)
	if(shard)
		. += new shard(location)
		if (fulltile)
			. += new shard(location)
	if(cleanable_type)
		. += new cleanable_type(location)
	if (reinf)
		. += new /obj/item/stack/rods(location, (fulltile ? 2 : 1))

/obj/structure/window/proc/can_be_rotated(mob/user,rotation_type)
	if (get_dist(src,user) > 1)
		if (iscarbon(user))
			var/mob/living/carbon/H = user
			if (!(H.dna && H.dna.check_mutation(TK) && tkMaxRangeCheck(src,H)))
				return FALSE
		else
			return FALSE
	if(anchored)
		to_chat(user, "<span class='warning'>[src] cannot be rotated while it is fastened to the floor!</span>")
		return FALSE

	var/target_dir = turn(dir, rotation_type == ROTATION_CLOCKWISE ? -90 : 90)

	if(!valid_window_location(loc, target_dir))
		to_chat(user, "<span class='warning'>[src] cannot be rotated in that direction!</span>")
		return FALSE
	return TRUE

/obj/structure/window/proc/after_rotation(mob/user,rotation_type)
	air_update_turf(1)
	ini_dir = dir
	add_fingerprint(user)

/obj/structure/window/Destroy()
	density = FALSE
	air_update_turf(1)
	update_nearby_icons()
	remove_electrochromatic()
	return ..()

/obj/structure/window/Move()
	var/turf/T = loc
	. = ..()
	setDir(ini_dir)
	move_update_air(T)

/obj/structure/window/CanAtmosPass(turf/T)
	if(!anchored || !density)
		return TRUE
	return !(FULLTILE_WINDOW_DIR == dir || dir == get_dir(loc, T))

//This proc is used to update the icons of nearby windows.
/obj/structure/window/proc/update_nearby_icons()
	update_icon()
	if(smooth)
		queue_smooth_neighbors(src)

//merges adjacent full-tile windows into one
/obj/structure/window/update_overlays()
	. = ..()
	if(QDELETED(src) || !fulltile)
		return
	var/ratio = obj_integrity / max_integrity
	ratio = CEILING(ratio*4, 1) * 25

	if(smooth)
		queue_smooth(src)

	if(ratio > 75)
		return
	. += mutable_appearance('icons/obj/structures.dmi', "damage[ratio]", -(layer+0.1))

/obj/structure/window/temperature_expose(datum/gas_mixture/air, exposed_temperature, exposed_volume)

	if(exposed_temperature > (T0C + heat_resistance))
		take_damage(round(exposed_volume / 100), BURN, 0, 0)
	..()

/obj/structure/window/get_dumping_location(obj/item/storage/source,mob/user)
	return null

/obj/structure/window/CanAStarPass(ID, to_dir)
	if(!density)
		return 1
	if((dir == FULLTILE_WINDOW_DIR) || (dir == to_dir))
		return 0

	return 1

/obj/structure/window/GetExplosionBlock()
	return reinf && fulltile ? real_explosion_block : 0

/obj/structure/window/spawner/east
	dir = EAST

/obj/structure/window/spawner/west
	dir = WEST

/obj/structure/window/spawner/north
	dir = NORTH

/obj/structure/window/unanchored
	anchored = FALSE

/obj/structure/window/reinforced
	name = "reinforced window"
	desc = "A window that is reinforced with metal rods."
	icon_state = "rwindow"
	reinf = TRUE
	heat_resistance = 1600
	armor = list("melee" = 50, "bullet" = 0, "laser" = 0, "energy" = 0, "bomb" = 25, "bio" = 100, "rad" = 100, "fire" = 80, "acid" = 100)
	max_integrity = 50
	explosion_block = 1
	wave_explosion_block = EXPLOSION_BLOCK_REINFORCED_WINDOW
	wave_explosion_multiply = EXPLOSION_DAMPEN_REINFORCED_WINDOW
	glass_type = /obj/item/stack/sheet/rglass
	rad_insulation = RAD_HEAVY_INSULATION
	ricochet_chance_mod = 0.8

/obj/structure/window/reinforced/spawner/east
	dir = EAST

/obj/structure/window/reinforced/spawner/west
	dir = WEST

/obj/structure/window/reinforced/spawner/north
	dir = NORTH

/obj/structure/window/reinforced/unanchored
	anchored = FALSE

/obj/structure/window/plasma
	name = "plasma window"
	desc = "A window made out of a plasma-silicate alloy. It looks insanely tough to break and burn through."
	icon_state = "plasmawindow"
	reinf = FALSE
	heat_resistance = 25000
	armor = list("melee" = 75, "bullet" = 5, "laser" = 0, "energy" = 0, "bomb" = 45, "bio" = 100, "rad" = 100, "fire" = 99, "acid" = 100)
	max_integrity = 150
	explosion_block = 1
	wave_explosion_block = EXPLOSION_BLOCK_BOROSILICATE_WINDOW
	wave_explosion_multiply = EXPLOSION_DAMPEN_BOROSILICATE_WINDOW
	glass_type = /obj/item/stack/sheet/plasmaglass
	cleanable_type = /obj/effect/decal/cleanable/glass/plasma
	rad_insulation = RAD_NO_INSULATION

/obj/structure/window/plasma/spawner/east
	dir = EAST

/obj/structure/window/plasma/spawner/west
	dir = WEST

/obj/structure/window/plasma/spawner/north
	dir = NORTH

/obj/structure/window/plasma/unanchored
	anchored = FALSE

/obj/structure/window/plasma/reinforced
	name = "reinforced plasma window"
	desc = "A window made out of a plasma-silicate alloy and a rod matrix. It looks hopelessly tough to break and is most likely nigh fireproof."
	icon_state = "plasmarwindow"
	reinf = TRUE
	extra_reinforced = TRUE
	heat_resistance = 50000
	armor = list("melee" = 85, "bullet" = 20, "laser" = 0, "energy" = 0, "bomb" = 60, "bio" = 100, "rad" = 100, "fire" = 99, "acid" = 100)
	max_integrity = 500
	explosion_block = 2
	wave_explosion_block = EXPLOSION_BLOCK_EXTREME
	wave_explosion_multiply = EXPLOSION_BLOCK_EXTREME
	glass_type = /obj/item/stack/sheet/plasmarglass

/obj/structure/window/plasma/reinforced/spawner/east
	dir = EAST

/obj/structure/window/plasma/reinforced/spawner/west
	dir = WEST

/obj/structure/window/plasma/reinforced/spawner/north
	dir = NORTH

/obj/structure/window/plasma/reinforced/unanchored
	anchored = FALSE

/obj/structure/window/plasma/reinforced/BlockSuperconductivity()
	return TRUE

/obj/structure/window/reinforced/tinted
	name = "tinted window"
	icon_state = "twindow"
	opacity = 1
/obj/structure/window/reinforced/tinted/frosted
	name = "frosted window"
	icon_state = "fwindow"

/* Full Tile Windows (more obj_integrity) */

/obj/structure/window/fulltile
	icon = 'icons/obj/smooth_structures/window.dmi'
	icon_state = "window"
	dir = FULLTILE_WINDOW_DIR
	max_integrity = 50
	fulltile = TRUE
	flags_1 = PREVENT_CLICK_UNDER_1
	smooth = SMOOTH_TRUE
	canSmoothWith = list(/obj/structure/window/fulltile, /obj/structure/window/reinforced/fulltile, /obj/structure/window/reinforced/tinted/fulltile, /obj/structure/window/plasma/fulltile, /obj/structure/window/plasma/reinforced/fulltile)
	glass_amount = 2

/obj/structure/window/fulltile/unanchored
	anchored = FALSE

/obj/structure/window/plasma/fulltile
	icon = 'icons/obj/smooth_structures/plasma_window.dmi'
	icon_state = "plasmawindow"
	dir = FULLTILE_WINDOW_DIR
	max_integrity = 300
	fulltile = TRUE
	flags_1 = PREVENT_CLICK_UNDER_1
	smooth = SMOOTH_TRUE
	canSmoothWith = list(/obj/structure/window/fulltile, /obj/structure/window/reinforced/fulltile, /obj/structure/window/reinforced/tinted/fulltile, /obj/structure/window/plasma/fulltile, /obj/structure/window/plasma/reinforced/fulltile)
	glass_amount = 2

/obj/structure/window/plasma/fulltile/unanchored
	anchored = FALSE

/obj/structure/window/plasma/reinforced/fulltile
	icon = 'icons/obj/smooth_structures/rplasma_window.dmi'
	icon_state = "rplasmawindow"
	dir = FULLTILE_WINDOW_DIR
	state = PRWINDOW_SECURE
	max_integrity = 1000
	fulltile = TRUE
	flags_1 = PREVENT_CLICK_UNDER_1
	smooth = SMOOTH_TRUE
	glass_amount = 2

/obj/structure/window/plasma/reinforced/fulltile/unanchored
	anchored = FALSE

/obj/structure/window/reinforced/fulltile
	icon = 'icons/obj/smooth_structures/reinforced_window.dmi'
	icon_state = "r_window"
	dir = FULLTILE_WINDOW_DIR
	max_integrity = 100
	fulltile = TRUE
	flags_1 = PREVENT_CLICK_UNDER_1
	smooth = SMOOTH_TRUE
	canSmoothWith = list(/obj/structure/window/fulltile, /obj/structure/window/reinforced/fulltile, /obj/structure/window/reinforced/tinted/fulltile, /obj/structure/window/plasma/fulltile, /obj/structure/window/plasma/reinforced/fulltile)
	level = 3
	glass_amount = 2

/obj/structure/window/reinforced/fulltile/unanchored
	anchored = FALSE

/obj/structure/window/reinforced/tinted/fulltile
	icon = 'icons/obj/smooth_structures/tinted_window.dmi'
	icon_state = "tinted_window"
	dir = FULLTILE_WINDOW_DIR
	fulltile = TRUE
	flags_1 = PREVENT_CLICK_UNDER_1
	smooth = SMOOTH_TRUE
	canSmoothWith = list(/obj/structure/window/fulltile, /obj/structure/window/reinforced/fulltile, /obj/structure/window/reinforced/tinted/fulltile, /obj/structure/window/plasma/fulltile, /obj/structure/window/plasma/reinforced/fulltile)
	level = 3
	glass_amount = 2

/obj/structure/window/reinforced/fulltile/ice
	icon = 'icons/obj/smooth_structures/rice_window.dmi'
	icon_state = "ice_window"
	max_integrity = 150
	canSmoothWith = list(/obj/structure/window/fulltile, /obj/structure/window/reinforced/fulltile, /obj/structure/window/reinforced/tinted/fulltile, /obj/structure/window/plasma/fulltile, /obj/structure/window/plasma/reinforced/fulltile)
	level = 3
	glass_amount = 2

/obj/structure/window/shuttle
	name = "shuttle window"
	desc = "A reinforced, air-locked pod window."
	icon = 'icons/obj/smooth_structures/shuttle_window.dmi'
	icon_state = "shuttle_window"
	dir = FULLTILE_WINDOW_DIR
	max_integrity = 100
	wtype = "shuttle"
	fulltile = TRUE
	flags_1 = PREVENT_CLICK_UNDER_1
	reinf = TRUE
	heat_resistance = 1600
	armor = list("melee" = 50, "bullet" = 0, "laser" = 0, "energy" = 0, "bomb" = 50, "bio" = 100, "rad" = 100, "fire" = 80, "acid" = 100)
	smooth = SMOOTH_TRUE
	canSmoothWith = null
	explosion_block = 3
	level = 3
	glass_type = /obj/item/stack/sheet/titaniumglass
	glass_amount = 2
	ricochet_chance_mod = 0.9

/obj/structure/window/shuttle/narsie_act()
	add_atom_colour("#3C3434", FIXED_COLOUR_PRIORITY)

/obj/structure/window/shuttle/tinted
	opacity = TRUE

/obj/structure/window/shuttle/unanchored
	anchored = FALSE

/obj/structure/window/plastitanium
	name = "plastitanium window"
	desc = "An evil looking window of plasma and titanium."
	icon = 'icons/obj/smooth_structures/plastitanium_window.dmi'
	icon_state = "plastitanium_window"
	dir = FULLTILE_WINDOW_DIR
	max_integrity = 100
	wtype = "shuttle"
	fulltile = TRUE
	flags_1 = PREVENT_CLICK_UNDER_1
	reinf = TRUE
	extra_reinforced = TRUE
	heat_resistance = 1600
	armor = list("melee" = 50, "bullet" = 0, "laser" = 0, "energy" = 0, "bomb" = 50, "bio" = 100, "rad" = 100, "fire" = 80, "acid" = 100)
	smooth = SMOOTH_TRUE
	canSmoothWith = null
	explosion_block = 3
	level = 3
	glass_type = /obj/item/stack/sheet/plastitaniumglass
	glass_amount = 2

/obj/structure/window/plastitanium/unanchored
	anchored = FALSE

//pirate ship windows
/obj/structure/window/plastitanium/pirate
	desc = "Yarr this window be explosion proof!"
	explosion_block = 30

/obj/structure/window/plastitanium/pirate/unanchored
	anchored = FALSE

/obj/structure/window/reinforced/clockwork
	name = "brass window"
	desc = "A paper-thin pane of translucent yet reinforced brass."
	icon = 'icons/obj/smooth_structures/clockwork_window.dmi'
	icon_state = "clockwork_window_single"
	resistance_flags = FIRE_PROOF | ACID_PROOF
	max_integrity = 80
	armor = list("melee" = 60, "bullet" = 25, "laser" = 0, "energy" = 0, "bomb" = 25, "bio" = 100, "rad" = 100, "fire" = 80, "acid" = 100)
	explosion_block = 2 //fancy AND hard to destroy. the most useful combination.
	wave_explosion_block = EXPLOSION_BLOCK_BOROSILICATE_WINDOW
	wave_explosion_multiply = EXPLOSION_DAMPEN_BOROSILICATE_WINDOW
	decon_speed = 40
	extra_reinforced = TRUE
	glass_type = /obj/item/stack/tile/brass
	glass_amount = 1
	reinf = FALSE
	var/made_glow = FALSE

/obj/structure/window/reinforced/clockwork/Initialize(mapload, direct)
	. = ..()
	change_construction_value(fulltile ? 2 : 1)

/obj/structure/window/reinforced/clockwork/spawnDebris(location)
	. = list()
	var/gearcount = fulltile ? 4 : 2
	for(var/i in 1 to gearcount)
		. += new /obj/item/clockwork/alloy_shards/medium/gear_bit(location)

/obj/structure/window/reinforced/clockwork/setDir(direct)
	if(!made_glow)
		var/obj/effect/E = new /obj/effect/temp_visual/ratvar/window/single(get_turf(src))
		E.setDir(direct)
		made_glow = TRUE
	..()

/obj/structure/window/reinforced/clockwork/Destroy()
	change_construction_value(fulltile ? -2 : -1)
	return ..()

/obj/structure/window/reinforced/clockwork/ratvar_act()
	if(GLOB.ratvar_awakens)
		obj_integrity = max_integrity
		update_icon()

/obj/structure/window/reinforced/clockwork/narsie_act()
	take_damage(rand(25, 75), BRUTE)
	if(!QDELETED(src))
		var/previouscolor = color
		color = "#960000"
		animate(src, color = previouscolor, time = 8)
		addtimer(CALLBACK(src, /atom/proc/update_atom_colour), 8)

/obj/structure/window/reinforced/clockwork/unanchored
	anchored = FALSE

/obj/structure/window/reinforced/clockwork/fulltile
	icon_state = "clockwork_window"
	smooth = SMOOTH_TRUE
	canSmoothWith = null
	fulltile = TRUE
	flags_1 = PREVENT_CLICK_UNDER_1
	dir = FULLTILE_WINDOW_DIR
	max_integrity = 120
	level = 3
	glass_amount = 2

/obj/structure/window/reinforced/clockwork/Initialize(mapload, direct)
	made_glow = TRUE
	new /obj/effect/temp_visual/ratvar/window(get_turf(src))
	return ..()


/obj/structure/window/reinforced/clockwork/fulltile/unanchored
	anchored = FALSE

/obj/structure/window/paperframe
	name = "paper frame"
	desc = "A fragile separator made of thin wood and paper."
	icon = 'icons/obj/smooth_structures/paperframes.dmi'
	icon_state = "frame"
	dir = FULLTILE_WINDOW_DIR
	opacity = TRUE
	max_integrity = 15
	fulltile = TRUE
	flags_1 = PREVENT_CLICK_UNDER_1
	smooth = SMOOTH_TRUE
	canSmoothWith = list(/obj/structure/window/paperframe, /obj/structure/mineral_door/paperframe)
	glass_amount = 2
	glass_type = /obj/item/stack/sheet/paperframes
	heat_resistance = 233
	decon_speed = 10
	CanAtmosPass = ATMOS_PASS_YES
	resistance_flags = FLAMMABLE
	armor = list("melee" = 0, "bullet" = 0, "laser" = 0, "energy" = 0, "bomb" = 0, "bio" = 0, "rad" = 0, "fire" = 0, "acid" = 0)
	breaksound = 'sound/items/poster_ripped.ogg'
	hitsound = 'sound/weapons/slashmiss.ogg'
	var/static/mutable_appearance/torn = mutable_appearance('icons/obj/smooth_structures/paperframes.dmi',icon_state = "torn", layer = ABOVE_OBJ_LAYER - 0.1)
	var/static/mutable_appearance/paper = mutable_appearance('icons/obj/smooth_structures/paperframes.dmi',icon_state = "paper", layer = ABOVE_OBJ_LAYER - 0.1)

/obj/structure/window/paperframe/Initialize()
	. = ..()
	update_icon()

/obj/structure/window/paperframe/spawnDebris(location)
	. = list(new /obj/item/stack/sheet/mineral/wood(location))
	for (var/i in 1 to rand(1,4))
		. += new /obj/item/paper/natural(location)

/obj/structure/window/paperframe/on_attack_hand(mob/user, act_intent = user.a_intent, unarmed_attack_flags)
	add_fingerprint(user)
	if(user.a_intent != INTENT_HARM)
		user.visible_message("[user] knocks on [src].")
		playsound(src, "pageturn", 50, 1)
	else
		take_damage(4,BRUTE,"melee", 0)
		playsound(src, hitsound, 50, 1)
		if(!QDELETED(src))
			user.visible_message("<span class='danger'>[user] tears a hole in [src].</span>")
			update_icon()

/obj/structure/window/paperframe/update_icon()
	if(obj_integrity < max_integrity)
		cut_overlay(paper)
		add_overlay(torn)
		set_opacity(FALSE)
	else
		cut_overlay(torn)
		add_overlay(paper)
		set_opacity(TRUE)
	queue_smooth(src)

/obj/structure/window/paperframe/attackby(obj/item/W, mob/user)
	if(W.get_temperature())
		fire_act(W.get_temperature())
		return
	if(user.a_intent == INTENT_HARM)
		return ..()
	if(istype(W, /obj/item/paper) && obj_integrity < max_integrity)
		user.visible_message("[user] starts to patch the holes in \the [src].")
		if(do_after(user, 20, target = src))
			obj_integrity = min(obj_integrity+4,max_integrity)
			qdel(W)
			user.visible_message("[user] patches some of the holes in \the [src].")
			if(obj_integrity == max_integrity)
				update_icon()
			return
	..()
	update_icon()

/obj/structure/window/bronze
	name = "brass window"
	desc = "A paper-thin pane of translucent yet reinforced brass. Nevermind, this is just weak bronze!"
	icon = 'icons/obj/smooth_structures/clockwork_window.dmi'
	icon_state = "clockwork_window_single"
	glass_type = /obj/item/stack/tile/bronze

/obj/structure/window/bronze/unanchored
	anchored = FALSE

/obj/structure/window/bronze/fulltile
	icon_state = "clockwork_window"
	canSmoothWith = null
	smooth = SMOOTH_TRUE
	fulltile = TRUE
	flags_1 = PREVENT_CLICK_UNDER_1
	dir = FULLTILE_WINDOW_DIR
	max_integrity = 50
	glass_amount = 2

/obj/structure/window/bronze/fulltile/unanchored
	anchored = FALSE
