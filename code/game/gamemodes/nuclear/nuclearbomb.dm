#define NUKESTATE_INTACT		5
#define NUKESTATE_UNSCREWED		4
#define NUKESTATE_PANEL_REMOVED		3
#define NUKESTATE_WELDED		2
#define NUKESTATE_CORE_EXPOSED	1
#define NUKESTATE_CORE_REMOVED	0

#define NUKE_OFF_LOCKED		0
#define NUKE_OFF_UNLOCKED	1
#define NUKE_ON_TIMING		2
#define NUKE_ON_EXPLODING	3


/obj/machinery/nuclearbomb
	name = "nuclear fission explosive"
	desc = "You probably shouldn't stick around to see if this is armed."
	icon = 'icons/obj/machines/nuke.dmi'
	icon_state = "nuclearbomb_base"
	density = TRUE
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF

	var/timer_set = 90
	var/default_timer_set = 90
	var/minimum_timer_set = 90
	var/maximum_timer_set = 3600
	var/ui_style = "nanotrasen"

	var/numeric_input = ""
	var/timing = FALSE
	var/exploding = FALSE
	var/detonation_timer = null
	var/r_code = "ADMIN"
	var/yes_code = FALSE
	var/safety = TRUE
	var/obj/item/disk/nuclear/auth = null
	use_power = NO_POWER_USE
	var/previous_level = ""
	var/obj/item/nuke_core/core = null
	var/deconstruction_state = NUKESTATE_INTACT
	var/lights = ""
	var/interior = ""
	var/obj/effect/countdown/nuclearbomb/countdown
	var/static/bomb_set

/obj/machinery/nuclearbomb/Initialize()
	. = ..()
	countdown = new(src)
	GLOB.nuke_list += src
	core = new /obj/item/nuke_core(src)
	STOP_PROCESSING(SSobj, core)
	update_icon()
	GLOB.poi_list |= src
	previous_level = get_security_level()

/obj/machinery/nuclearbomb/Destroy()
	safety = FALSE
	if(!exploding)
		// If we're not exploding, set the alert level back to normal
		set_safety()
	GLOB.poi_list -= src
	GLOB.nuke_list -= src
	if(countdown)
		qdel(countdown)
	countdown = null
	. = ..()

/obj/machinery/nuclearbomb/examine(mob/user)
	. = ..()
	if(exploding)
		to_chat(user, "It is in the process of exploding. Perhaps reviewing your affairs is in order.")
	if(timing)
		to_chat(user, "There are [get_time_left()] seconds until detonation.")

/obj/machinery/nuclearbomb/selfdestruct
	name = "station self-destruct terminal"
	desc = "For when it all gets too much to bear. Do not taunt."
	icon = 'icons/obj/machines/nuke_terminal.dmi'
	icon_state = "nuclearbomb_base"
	anchored = TRUE //stops it being moved
	use_tag = TRUE

/obj/machinery/nuclearbomb/syndicate
	//ui_style = "syndicate" // actually the nuke op bomb is a stole nt bomb

/obj/machinery/nuclearbomb/syndicate/get_cinematic_type(off_station)
	var/datum/game_mode/nuclear/NM = SSticker.mode
	switch(off_station)
		if(0)
			if(istype(NM) && NM.syndies_didnt_escape)
				return CINEMATIC_ANNIHILATION
			else
				return CINEMATIC_NUKE_WIN
		if(1)
			return CINEMATIC_NUKE_MISS
		if(2)
			return CINEMATIC_NUKE_FAR
	return CINEMATIC_NUKE_FAR

/obj/machinery/nuclearbomb/syndicate/Initialize()
	. = ..()
	var/obj/machinery/nuclearbomb/existing = locate("syndienuke") in GLOB.nuke_list
	if(existing)
		stack_trace("Attempted to spawn a syndicate nuke while one already exists at [existing.loc.x],[existing.loc.y],[existing.loc.z]")
		return INITIALIZE_HINT_QDEL
	tag = "syndienuke"

/obj/machinery/nuclearbomb/attackby(obj/item/I, mob/user, params)
	if (istype(I, /obj/item/disk/nuclear))
		if(!user.transferItemToLoc(I, src))
			return
		auth = I
		add_fingerprint(user)
		return

	switch(deconstruction_state)
		if(NUKESTATE_INTACT)
			if(istype(I, /obj/item/screwdriver/nuke))
				playsound(loc, I.usesound, 100, 1)
				to_chat(user, "<span class='notice'>You start removing [src]'s front panel's screws...</span>")
				if(do_after(user, 60*I.toolspeed,target=src))
					deconstruction_state = NUKESTATE_UNSCREWED
					to_chat(user, "<span class='notice'>You remove the screws from [src]'s front panel.</span>")
					update_icon()
				return

		if(NUKESTATE_PANEL_REMOVED)
			if(istype(I, /obj/item/weldingtool))
				var/obj/item/weldingtool/welder = I
				playsound(loc, I.usesound, 100, 1)
				to_chat(user, "<span class='notice'>You start cutting [src]'s inner plate...</span>")
				if(welder.remove_fuel(1,user))
					if(do_after(user,80*I.toolspeed,target=src))
						to_chat(user, "<span class='notice'>You cut [src]'s inner plate.</span>")
						deconstruction_state = NUKESTATE_WELDED
						update_icon()
				return
		if(NUKESTATE_CORE_EXPOSED)
			if(istype(I, /obj/item/nuke_core_container))
				var/obj/item/nuke_core_container/core_box = I
				to_chat(user, "<span class='notice'>You start loading the plutonium core into [core_box]...</span>")
				if(do_after(user,50,target=src))
					if(core_box.load(core, user))
						to_chat(user, "<span class='notice'>You load the plutonium core into [core_box].</span>")
						deconstruction_state = NUKESTATE_CORE_REMOVED
						update_icon()
						core = null
					else
						to_chat(user, "<span class='warning'>You fail to load the plutonium core into [core_box]. [core_box] has already been used!</span>")
				return
			if(istype(I, /obj/item/stack/sheet/metal))
				var/obj/item/stack/sheet/metal/M = I
				if(M.amount >= 20)
					to_chat(user, "<span class='notice'>You begin repairing [src]'s inner metal plate...</span>")
					if(do_after(user, 100, target=src))
						if(M.use(20))
							to_chat(user, "<span class='notice'>You repair [src]'s inner metal plate. The radiation is contained.</span>")
							deconstruction_state = NUKESTATE_PANEL_REMOVED
							STOP_PROCESSING(SSobj, core)
							update_icon()
						else
							to_chat(user, "<span class='warning'>You need more metal to do that!</span>")
				else
					to_chat(user, "<span class='warning'>You need more metal to do that!</span>")
				return
	. = ..()

/obj/machinery/nuclearbomb/crowbar_act(mob/user, obj/item/tool)
	. = FALSE
	switch(deconstruction_state)
		if(NUKESTATE_UNSCREWED)
			to_chat(user, "<span class='notice'>You start removing [src]'s front panel...</span>")
			playsound(loc, tool.usesound, 100, 1)
			if(do_after(user, 30 * tool.toolspeed, target = src))
				to_chat(user, "<span class='notice'>You remove [src]'s front panel.</span>")
				deconstruction_state = NUKESTATE_PANEL_REMOVED
				update_icon()
			return TRUE
		if(NUKESTATE_WELDED)
			to_chat(user, "<span class='notice'>You start prying off [src]'s inner plate...</span>")
			playsound(loc, tool.usesound, 100, 1)
			if(do_after(user, 50 * tool.toolspeed, target = src))
				to_chat(user, "<span class='notice'>You pry off [src]'s inner plate. You can see the core's green glow!</span>")
				deconstruction_state = NUKESTATE_CORE_EXPOSED
				update_icon()
				START_PROCESSING(SSobj, core)
			return TRUE

/obj/machinery/nuclearbomb/proc/get_nuke_state()
	if(exploding)
		return NUKE_ON_EXPLODING
	if(timing)
		return NUKE_ON_TIMING
	if(safety)
		return NUKE_OFF_LOCKED
	else
		return NUKE_OFF_UNLOCKED

/obj/machinery/nuclearbomb/update_icon()
	if(deconstruction_state == NUKESTATE_INTACT)
		switch(get_nuke_state())
			if(NUKE_OFF_LOCKED, NUKE_OFF_UNLOCKED)
				icon_state = "nuclearbomb_base"
				update_icon_interior()
				update_icon_lights()
			if(NUKE_ON_TIMING)
				cut_overlays()
				icon_state = "nuclearbomb_timing"
			if(NUKE_ON_EXPLODING)
				cut_overlays()
				icon_state = "nuclearbomb_exploding"
	else
		icon_state = "nuclearbomb_base"
		update_icon_interior()
		update_icon_lights()

/obj/machinery/nuclearbomb/proc/update_icon_interior()
	cut_overlay(interior)
	switch(deconstruction_state)
		if(NUKESTATE_UNSCREWED)
			interior = "panel-unscrewed"
		if(NUKESTATE_PANEL_REMOVED)
			interior = "panel-removed"
		if(NUKESTATE_WELDED)
			interior = "plate-welded"
		if(NUKESTATE_CORE_EXPOSED)
			interior = "plate-removed"
		if(NUKESTATE_CORE_REMOVED)
			interior = "core-removed"
		if(NUKESTATE_INTACT)
			return
	add_overlay(interior)

/obj/machinery/nuclearbomb/proc/update_icon_lights()
	if(lights)
		cut_overlay(lights)
	switch(get_nuke_state())
		if(NUKE_OFF_LOCKED)
			lights = ""
			return
		if(NUKE_OFF_UNLOCKED)
			lights = "lights-safety"
		if(NUKE_ON_TIMING)
			lights = "lights-timing"
		if(NUKE_ON_EXPLODING)
			lights = "lights-exploding"
	add_overlay(lights)

/obj/machinery/nuclearbomb/process()
	if(timing && !exploding)
		bomb_set = TRUE
		if(detonation_timer < world.time)
			explode()
		else
			var/volume = (get_time_left() <= 20 ? 30 : 5)
			playsound(loc, 'sound/items/timer.ogg', volume, 0)

/obj/machinery/nuclearbomb/attack_paw(mob/user)
	return attack_hand(user)

/obj/machinery/nuclearbomb/ui_interact(mob/user, ui_key="main", datum/tgui/ui=null, force_open=0, datum/tgui/master_ui=null, datum/ui_state/state=GLOB.default_state)
	ui = SStgui.try_update_ui(user, src, ui_key, ui, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "nuclear_bomb", name, 500, 600, master_ui, state)
		ui.set_style(ui_style)
		ui.open()

/obj/machinery/nuclearbomb/ui_data(mob/user)
	var/list/data = list()
	data["disk_present"] = auth
	data["code_approved"] = yes_code
	var/first_status
	if(auth)
		if(yes_code)
			first_status = timing ? "Func/Set" : "Functional"
		else
			first_status = "Auth S2."
	else
		if(timing)
			first_status = "Set"
		else
			first_status = "Auth S1."
	var/second_status = safety ? "Safe" : "Engaged"
	data["status1"] = first_status
	data["status2"] = second_status
	data["anchored"] = anchored
	data["safety"] = safety
	data["timing"] = timing
	data["time_left"] = get_time_left()

	data["timer_set"] = timer_set
	data["timer_is_not_default"] = timer_set != default_timer_set
	data["timer_is_not_min"] = timer_set != minimum_timer_set
	data["timer_is_not_max"] = timer_set != maximum_timer_set

	var/message = "AUTH"
	if(auth)
		message = "[numeric_input]"
		if(yes_code)
			message = "*****"
	data["message"] = message

	return data

/obj/machinery/nuclearbomb/ui_act(action, params)
	if(..())
		return
	switch(action)
		if("eject_disk")
			if(auth && auth.loc == src)
				auth.forceMove(get_turf(src))
				auth = null
				. = TRUE
		if("insert_disk")
			if(!auth)
				var/obj/item/I = usr.is_holding_item_of_type(/obj/item/disk/nuclear)
				if(I && usr.transferItemToLoc(I, src))
					auth = I
					. = TRUE
		if("keypad")
			if(auth)
				var/digit = params["digit"]
				switch(digit)
					if("R")
						numeric_input = ""
						yes_code = FALSE
						. = TRUE
					if("E")
						if(numeric_input == r_code)
							numeric_input = ""
							yes_code = TRUE
							. = TRUE
						else
							numeric_input = "ERROR"
					if("0","1","2","3","4","5","6","7","8","9")
						if(numeric_input != "ERROR")
							numeric_input += digit
							if(length(numeric_input) > 5)
								numeric_input = "ERROR"
							. = TRUE
		if("timer")
			if(auth && yes_code)
				var/change = params["change"]
				if(change == "reset")
					timer_set = default_timer_set
				else if(change == "decrease")
					timer_set = max(minimum_timer_set, timer_set - 10)
				else if(change == "increase")
					timer_set = min(maximum_timer_set, timer_set + 10)
				else if(change == "input")
					var/user_input = input(usr, "Set time to detonation.", name) as null|num
					if(!user_input)
						return
					var/N = text2num(user_input)
					if(!N)
						return
					timer_set = Clamp(N,minimum_timer_set,maximum_timer_set)
				. = TRUE
		if("safety")
			if(auth && yes_code)
				set_safety()
		if("anchor")
			if(auth && yes_code)
				set_anchor()
		if("toggle_timer")
			if(auth && yes_code && !safety)
				set_active()


/obj/machinery/nuclearbomb/proc/set_anchor()
	if(!isinspace())
		anchored = !anchored
	else
		to_chat(usr, "<span class='warning'>There is nothing to anchor to!</span>")

/obj/machinery/nuclearbomb/proc/set_safety()
	safety = !safety
	if(safety)
		if(timing)
			set_security_level(previous_level)
			for(var/obj/item/pinpointer/nuke/syndicate/S in GLOB.pinpointer_list)
				S.switch_mode_to(initial(S.mode))
				S.alert = FALSE
		timing = FALSE
		bomb_set = TRUE
		detonation_timer = null
		countdown.stop()
	update_icon()

/obj/machinery/nuclearbomb/proc/set_active()
	if(safety && !bomb_set)
		to_chat(usr, "<span class='danger'>The safety is still on.</span>")
		return
	timing = !timing
	if(timing)
		previous_level = get_security_level()
		bomb_set = TRUE
		set_security_level("delta")
		detonation_timer = world.time + (timer_set * 10)
		for(var/obj/item/pinpointer/nuke/syndicate/S in GLOB.pinpointer_list)
			S.switch_mode_to(TRACK_INFILTRATOR)
		countdown.start()
	else
		bomb_set = FALSE
		detonation_timer = null
		set_security_level(previous_level)
		for(var/obj/item/pinpointer/nuke/syndicate/S in GLOB.pinpointer_list)
			S.switch_mode_to(initial(S.mode))
			S.alert = FALSE
		countdown.stop()
	update_icon()

/obj/machinery/nuclearbomb/proc/get_time_left()
	if(timing)
		. = round(max(0, detonation_timer - world.time) / 10, 1)
	else
		. = timer_set

/obj/machinery/nuclearbomb/blob_act(obj/structure/blob/B)
	if(exploding)
		return
	qdel(src)

/obj/machinery/nuclearbomb/tesla_act(power, explosive)
	..()
	if(explosive)
		qdel(src)//like the singulo, tesla deletes it. stops it from exploding over and over

#define NUKERANGE 127
/obj/machinery/nuclearbomb/proc/explode()
	if(safety)
		timing = FALSE
		return

	exploding = TRUE
	yes_code = FALSE
	safety = TRUE
	update_icon()
	sound_to_playing_players('sound/machines/alarm.ogg')
	if(SSticker && SSticker.mode)
		SSticker.roundend_check_paused = TRUE
	addtimer(CALLBACK(src, .proc/actually_explode), 100)

/obj/machinery/nuclearbomb/proc/actually_explode()
	if(!core)
		Cinematic(CINEMATIC_NUKE_NO_CORE,world)
		SSticker.roundend_check_paused = FALSE
		return

	GLOB.enter_allowed = FALSE

	var/off_station = 0
	var/turf/bomb_location = get_turf(src)
	var/area/A = get_area(bomb_location)
	if(bomb_location && (bomb_location.z in GLOB.station_z_levels))
		if(istype(A, /area/space))
			off_station = NUKE_NEAR_MISS
		if((bomb_location.x < (128-NUKERANGE)) || (bomb_location.x > (128+NUKERANGE)) || (bomb_location.y < (128-NUKERANGE)) || (bomb_location.y > (128+NUKERANGE)))
			off_station = NUKE_NEAR_MISS
	else if((istype(A, /area/syndicate_mothership) || (istype(A, /area/shuttle/syndicate)) && bomb_location.z == ZLEVEL_CENTCOM))
		off_station = NUKE_SYNDICATE_BASE
	else
		off_station = NUKE_MISS_STATION

	if(off_station < 2)
		SSshuttle.registerHostileEnvironment(src)
		SSshuttle.lockdown = TRUE

	//Cinematic
	SSticker.mode.OnNukeExplosion(off_station)
	var/bombz = z
	Cinematic(get_cinematic_type(off_station),world,CALLBACK(SSticker,/datum/controller/subsystem/ticker/proc/station_explosion_detonation,src))
	INVOKE_ASYNC(GLOBAL_PROC,.proc/KillEveryoneOnZLevel,bombz)
	SSticker.roundend_check_paused = FALSE

/obj/machinery/nuclearbomb/proc/get_cinematic_type(off_station)
	if(off_station < 2)
		return CINEMATIC_SELFDESTRUCT
	else
		return CINEMATIC_SELFDESTRUCT_MISS

/proc/KillEveryoneOnZLevel(z)
	if(!z)
		return
	for(var/mob/M in GLOB.mob_list)
		if(M.stat != DEAD && M.z == z)
			M.gib()

/*
This is here to make the tiles around the station mininuke change when it's armed.
*/

/obj/machinery/nuclearbomb/selfdestruct/set_anchor()
	return

/obj/machinery/nuclearbomb/selfdestruct/set_active()
	..()
	if(timing)
		SSmapping.add_nuke_threat(src)
	else
		SSmapping.remove_nuke_threat(src)

/obj/machinery/nuclearbomb/selfdestruct/set_safety()
	..()
	if(timing)
		SSmapping.add_nuke_threat(src)
	else
		SSmapping.remove_nuke_threat(src)

//==========DAT FUKKEN DISK===============
/obj/item/disk
	icon = 'icons/obj/module.dmi'
	w_class = WEIGHT_CLASS_TINY
	item_state = "card-id"
	lefthand_file = 'icons/mob/inhands/equipment/idcards_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/idcards_righthand.dmi'
	icon_state = "datadisk0"

/obj/item/disk/nuclear
	name = "nuclear authentication disk"
	desc = "Better keep this safe."
	icon_state = "nucleardisk"
	persistence_replacement = /obj/item/disk/fakenucleardisk
	max_integrity = 250
	armor = list(melee = 0, bullet = 0, laser = 0, energy = 0, bomb = 30, bio = 0, rad = 0, fire = 100, acid = 100)
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | ACID_PROOF

/obj/item/disk/nuclear/New()
	..()
	GLOB.poi_list |= src
	set_stationloving(TRUE, inform_admins=TRUE)

/obj/item/disk/nuclear/attackby(obj/item/I, mob/living/user, params)
	if(istype(I, /obj/item/claymore/highlander))
		var/obj/item/claymore/highlander/H = I
		if(H.nuke_disk)
			to_chat(user, "<span class='notice'>Wait... what?</span>")
			qdel(H.nuke_disk)
			H.nuke_disk = null
			return
		user.visible_message("<span class='warning'>[user] captures [src]!</span>", "<span class='userdanger'>You've got the disk! Defend it with your life!</span>")
		forceMove(H)
		H.nuke_disk = src
		return TRUE
	return ..()

/obj/item/disk/nuclear/Destroy(force=FALSE)
	// respawning is handled in /obj/Destroy()
	if(force)
		GLOB.poi_list -= src
	. = ..()

/obj/item/disk/nuclear/suicide_act(mob/user)
	user.visible_message("<span class='suicide'>[user] is going delta! It looks like [user.p_theyre()] trying to commit suicide!</span>")
	playsound(user.loc, 'sound/machines/alarm.ogg', 50, -1, 1)
	for(var/i in 1 to 100)
		addtimer(CALLBACK(user, /atom/proc/add_atom_colour, (i % 2)? "#00FF00" : "#FF0000", ADMIN_COLOUR_PRIORITY), i)
	addtimer(CALLBACK(user, /atom/proc/remove_atom_colour, ADMIN_COLOUR_PRIORITY), 101)
	addtimer(CALLBACK(user, /atom/proc/visible_message, "<span class='suicide'>[user] was destroyed by the nuclear blast!</span>"), 101)
	addtimer(CALLBACK(user, /mob/living/proc/adjustOxyLoss, 200), 101)
	addtimer(CALLBACK(user, /mob/proc/death, 0), 101)
	return MANUAL_SUICIDE

/obj/item/disk/fakenucleardisk
	name = "cheap plastic imitation of the nuclear authentication disk"
	desc = "Broken dreams and a faint odor of cheese."
	icon_state = "nucleardisk"
