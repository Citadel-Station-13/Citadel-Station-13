#define TIME_LEFT (SSshuttle.emergency.timeLeft())
#define ENGINES_START_TIME 100
#define ENGINES_STARTED (SSshuttle.emergency.mode == SHUTTLE_IGNITING)
#define IS_DOCKED (SSshuttle.emergency.mode == SHUTTLE_DOCKED || (ENGINES_STARTED))
#define MAX_AUTH_INPUTS 6

#define NOT_BEGUN 0
#define STAGE_1 1
#define STAGE_2 2
#define STAGE_3 3
#define STAGE_4 4
#define HIJACKED 5

/obj/machinery/computer/emergency_shuttle
	name = "emergency shuttle console"
	desc = "For shuttle control."
	icon_screen = "shuttle"
	icon_keyboard = "tech_key"
	resistance_flags = INDESTRUCTIBLE
	var/auth_need = 3
	var/list/authorized = list()
	var/auth_cooldown //these two vars are used to quell spam.
	var/auth_combo = 0

	var/hijack_last_stage_increase = 0
	var/hijack_stage_time = 50
	var/hijack_stage_cooldown = 50
	var/hijack_flight_time_increase = 300
	var/hijack_completion_flight_time_set = 100		//How long in deciseconds to set shuttle's timer after hijack is done.
	var/hijack_hacking = FALSE
	var/hijack_announce = TRUE

/obj/machinery/computer/emergency_shuttle/examine(mob/user)
	. = ..()
	if(hijack_announce)
		. += "<span class='danger'>Security systems present on console. Any unauthorized tampering will result in an emergency announcement.</span>"
	if(user?.mind?.get_hijack_speed())
		. += "<span class='danger'>Alt click on this to attempt to hijack the shuttle. This will take multiple tries (current: stage [SSshuttle.emergency.hijack_status]/[HIJACKED]).</span>"
		. += "<span class='notice'>It will take you [(hijack_stage_time * user.mind.get_hijack_speed()) / 10] seconds to reprogram a stage of the shuttle's navigational firmware, and the console will undergo automated timed lockout for [hijack_stage_cooldown/10] seconds after each stage.</span>"
		if(hijack_announce)
			. += "<span class='warning'>It is probably best to fortify your position as to be uninterrupted during the attempt, given the automatic announcements..</span>"

/obj/machinery/computer/emergency_shuttle/attackby(obj/item/I, mob/user,params)
	if(istype(I, /obj/item/card/id))
		say("Please equip your ID card into your ID slot to authenticate.")
	. = ..()

/obj/machinery/computer/emergency_shuttle/ui_interact(mob/user, ui_key = "main", datum/tgui/ui = null, force_open = FALSE, datum/tgui/master_ui = null, datum/ui_state/state = GLOB.human_adjacent_state)

	ui = SStgui.try_update_ui(user, src, ui_key, ui, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "emergency_shuttle_console", name,
			400, 350, master_ui, state)
		ui.open()

/obj/machinery/computer/emergency_shuttle/ui_data()
	var/list/data = list()

	data["timer_str"] = SSshuttle.emergency.getTimerStr()
	data["engines_started"] = ENGINES_STARTED
	data["authorizations_remaining"] = max((auth_need - authorized.len), 0)
	var/list/A = list()
	for(var/i in authorized)
		var/obj/item/card/id/ID = i
		var/name = ID.registered_name
		var/job = ID.assignment

		if(obj_flags & EMAGGED)
			name = Gibberish(name, 0)
			job = Gibberish(job, 0)
		A += list(list("name" = name, "job" = job))
	data["authorizations"] = A

	data["enabled"] = (IS_DOCKED && !ENGINES_STARTED)
	data["emagged"] = obj_flags & EMAGGED ? 1 : 0
	return data

/obj/machinery/computer/emergency_shuttle/ui_act(action, params, datum/tgui/ui)
	if(..())
		return
	if(ENGINES_STARTED) // past the point of no return
		return
	if(!IS_DOCKED) // shuttle computer only has uses when onstation
		return

	var/mob/user = usr
	. = FALSE

	var/obj/item/card/id/ID = user.get_idcard(TRUE)

	if(!ID)
		to_chat(user, "<span class='warning'>You don't have an ID.</span>")
		return

	if(!(ACCESS_HEADS in ID.access))
		to_chat(user, "<span class='warning'>The access level of your card is not high enough.</span>")
		return

	if(auth_cooldown <= world.time)
		auth_combo = 0

	else if(auth_combo >= MAX_AUTH_INPUTS)
		to_chat(user, "<span class='warning'>Authorizations controller lockdown engaged, please wait [CEILING(auth_cooldown - world.time, 1)] before trying again.</span>")
		return

	var/old_len = authorized.len

	switch(action)
		if("authorize")
			. = authorize(user)

		if("repeal")
			authorized -= ID

		if("abort")
			if(authorized.len)
				// Abort. The action for when heads are fighting over whether
				// to launch early.
				authorized.Cut()
				. = TRUE

	if((old_len != authorized.len) && !ENGINES_STARTED)
		var/alert = (authorized.len > old_len)
		var/repeal = (authorized.len < old_len)
		var/remaining = max(0, auth_need - authorized.len)
		if(authorized.len && remaining)
			minor_announce("[remaining] authorizations needed until shuttle is launched early", null, alert)
		if(repeal)
			minor_announce("Early launch authorization revoked, [remaining] authorizations needed")
		auth_cooldown = world.time + 15 SECONDS
		if(++auth_combo == MAX_AUTH_INPUTS) //C-c-combo breaker!
			say("Authorization controller abuse detected, lockdown engaged.")
			playsound(src, 'sound/machines/buzz-sigh.ogg', 50, 0)

/obj/machinery/computer/emergency_shuttle/proc/authorize(mob/user, source)
	var/obj/item/card/id/ID = user.get_idcard(TRUE)

	if(ID in authorized)
		return FALSE
	for(var/i in authorized)
		var/obj/item/card/id/other = i
		if(other.registered_name == ID.registered_name)
			return FALSE // No using IDs with the same name

	authorized += ID

	message_admins("[ADMIN_LOOKUPFLW(user)] has authorized early shuttle launch")
	log_game("[key_name(user)] has authorized early shuttle launch in [COORD(src)]")
	// Now check if we're on our way
	. = TRUE
	process()

/obj/machinery/computer/emergency_shuttle/process()
	// Launch check is in process in case auth_need changes for some reason
	// probably external.
	. = FALSE
	if(!SSshuttle.emergency)
		return

	if(SSshuttle.emergency.mode == SHUTTLE_STRANDED)
		authorized.Cut()
		obj_flags &= ~EMAGGED

	if(ENGINES_STARTED || (!IS_DOCKED))
		return .

	// Check to see if we've reached criteria for early launch
	if((authorized.len >= auth_need) || (obj_flags & EMAGGED))
		// shuttle timers use 1/10th seconds internally
		SSshuttle.emergency.setTimer(ENGINES_START_TIME)
		var/system_error = obj_flags & EMAGGED ? "SYSTEM ERROR:" : null
		minor_announce("The emergency shuttle will launch in \
			[TIME_LEFT] seconds", system_error, alert=TRUE)
		. = TRUE

/obj/machinery/computer/emergency_shuttle/proc/increase_hijack_stage()
	var/obj/docking_port/mobile/emergency/shuttle = SSshuttle.emergency
	shuttle.hijack_status++
	if(hijack_announce)
		announce_hijack_stage()
	hijack_last_stage_increase = world.time
	say("Navigational protocol error! Rebooting systems.")
	if(shuttle.mode == SHUTTLE_ESCAPE)
		if(shuttle.hijack_status == HIJACKED)
			shuttle.setTimer(hijack_completion_flight_time_set)
		else
			shuttle.setTimer(shuttle.timeLeft(1) + hijack_flight_time_increase)		//give the guy more time to hijack if it's already in flight.
	return shuttle.hijack_status

/obj/machinery/computer/emergency_shuttle/AltClick(user)
	attempt_hijack_stage(user)

/obj/machinery/computer/emergency_shuttle/proc/attempt_hijack_stage(mob/living/user)
	if(!user.CanReach(src))
		return
	if(!user?.mind?.get_hijack_speed())
		to_chat(user, "<span class='warning'>You manage to open a user-mode shell on [src], and hundreds of lines of debugging output fly through your vision. It is probably best to leave this alone.</span.")
		return
	if(hijack_hacking == TRUE)
		return
	if(SSshuttle.emergency.hijack_status >= HIJACKED)
		to_chat(user, "<span class='warning'>The emergency shuttle is already loaded with a corrupt navigational payload. What more do you want from it?</span>")
		return
	if(hijack_last_stage_increase >= world.time + hijack_stage_cooldown)
		say("Error - Catastrophic software error detected. Input is currently on timeout.")
		return
	hijack_hacking = TRUE
	to_chat(user, "<span class='boldwarning'>You [SSshuttle.emergency.hijack_status == NOT_BEGUN? "begin" : "continue"] to override [src]'s navigational protocols.</span>")
	say("Software override initiated.")
	. = FALSE
	if(do_after(user, hijack_stage_time * (1 / user.mind.get_hijack_speed()), target = src))
		increase_hijack_stage()
		. = TRUE
		to_chat(user, "<span class='notice'>You reprogram some of [src]'s programming, putting it on timeout for [hijack_stage_cooldown/10] seconds.</span>")
	hijack_hacking = FALSE

/obj/machinery/computer/emergency_shuttle/proc/announce_hijack_stage()
	var/msg
	switch(SSshuttle.emergency.hijack_status)
		if(NOT_BEGUN)
			return
		if(STAGE_1)
			var/datum/species/S = new
			msg = "AUTHENTICATING - FAIL. AUTHENTICATING - FAIL. AUTHENTICATING - FAI###### Welcome, technician JOHN DOE."
			qdel(S)
		if(STAGE_2)
			msg = "Warning: Navigational route fails \"IS_AUTHORIZED\". Please try againNN[scramble_message_replace_chars("againagainagainagainagain", 70)]."
		if(STAGE_3)
			var/hex = ""
			for(var/i in 1 to 8)
				hex += num2hex(rand(1,16))
			msg = "CRC mismatch at 0x[hex] in calculated route buffer. Full reset initiated of FTL_NAVIGATION_SERVICES. Memory decrypted for automatic repair."
		if(STAGE_4)
			msg = "~ACS_directive module_load(cyberdyne.exploit.nanotrasen.shuttlenav)... NT key mismatch. Confirm load? Y...###Reboot complete. $SET transponder_state = 0; System link initiated with connected engines..."
		if(HIJACKED)
			msg = "<font color='red'>SYSTEM OVERRIDE - Resetting course to \[[scramble_message_replace_chars("###########", 100)]\] \
			([scramble_message_replace_chars("#######", 100)]/[scramble_message_replace_chars("#######", 100)]/[scramble_message_replace_chars("#######", 100)]) \
			{AUTH - ROOT (uid: 0)}.</font>[SSshuttle.emergency.mode == SHUTTLE_ESCAPE? "Diverting from existing route - Bluespace exit in [hijack_completion_flight_time_set/10] seconds." : ""]"
	minor_announce(scramble_message_replace_chars(msg, replaceprob = 10), "Emergency Shuttle", TRUE)

/obj/machinery/computer/emergency_shuttle/emag_act(mob/user)
	. = ..()

	// How did you even get on the shuttle before it go to the station?
	if(!IS_DOCKED)
		return

	if((obj_flags & EMAGGED) || ENGINES_STARTED)	//SYSTEM ERROR: THE SHUTTLE WILL LA-SYSTEM ERROR: THE SHUTTLE WILL LA-SYSTEM ERROR: THE SHUTTLE WILL LAUNCH IN 10 SECONDS
		to_chat(user, "<span class='warning'>The shuttle is already about to launch!</span>")
		return

	var/time = TIME_LEFT
	message_admins("[ADMIN_LOOKUPFLW(user.client)] has emagged the emergency shuttle [time] seconds before launch.")
	log_game("[key_name(user)] has emagged the emergency shuttle in [COORD(src)] [time] seconds before launch.")
	obj_flags |= EMAGGED
	SSshuttle.emergency.movement_force = list("KNOCKDOWN" = 60, "THROW" = 20)//YOUR PUNY SEATBELTS can SAVE YOU NOW, MORTAL
	var/datum/species/S = new
	for(var/i in 1 to 10)
		// the shuttle system doesn't know who these people are, but they
		// must be important, surely
		var/obj/item/card/id/ID = new(src)
		var/datum/job/J = pick(SSjob.occupations)
		ID.registered_name = S.random_name(pick(MALE, FEMALE))
		ID.assignment = J.title

		authorized += ID

	process()
	return TRUE

/obj/machinery/computer/emergency_shuttle/Destroy()
	// Our fake IDs that the emag generated are just there for colour
	// They're not supposed to be accessible

	for(var/obj/item/card/id/ID in src)
		qdel(ID)
	if(authorized && authorized.len)
		authorized.Cut()
	authorized = null

	. = ..()

/obj/docking_port/mobile/emergency
	name = "emergency shuttle"
	id = "emergency"

	dwidth = 9
	width = 22
	height = 11
	dir = EAST
	port_direction = WEST
	var/sound_played = 0 //If the launch sound has been sent to all players on the shuttle itself
	var/hijack_status = NOT_BEGUN

/obj/docking_port/mobile/emergency/canDock(obj/docking_port/stationary/S)
	return SHUTTLE_CAN_DOCK //If the emergency shuttle can't move, the whole game breaks, so it will force itself to land even if it has to crush a few departments in the process

/obj/docking_port/mobile/emergency/register()
	. = ..()
	SSshuttle.emergency = src

/obj/docking_port/mobile/emergency/Destroy(force)
	if(force)
		// This'll make the shuttle subsystem use the backup shuttle.
		if(src == SSshuttle.emergency)
			// If we're the selected emergency shuttle
			SSshuttle.emergencyDeregister()

	. = ..()

/obj/docking_port/mobile/emergency/request(obj/docking_port/stationary/S, area/signalOrigin, reason, redAlert, set_coefficient=null, silent = FALSE)
	if(!isnum(set_coefficient))
		var/security_num = seclevel2num(get_security_level())
		switch(security_num)
			if(SEC_LEVEL_GREEN)
				set_coefficient = 2
			if(SEC_LEVEL_BLUE)
				set_coefficient = 1.2
			if(SEC_LEVEL_AMBER)
				set_coefficient = 0.8
			else
				set_coefficient = 0.5
	var/call_time = SSshuttle.emergencyCallTime * set_coefficient * engine_coeff
	switch(mode)
		// The shuttle can not normally be called while "recalling", so
		// if this proc is called, it's via admin fiat
		if(SHUTTLE_RECALL, SHUTTLE_IDLE, SHUTTLE_CALL)
			mode = SHUTTLE_CALL
			setTimer(call_time)
		else
			return

	SSshuttle.emergencyCallAmount++

	if(prob(70))
		SSshuttle.emergencyLastCallLoc = signalOrigin
	else
		SSshuttle.emergencyLastCallLoc = null

	if(!silent)
		priority_announce("The emergency shuttle has been called. [redAlert ? "Red Alert state confirmed: Dispatching priority shuttle. " : "" ]It will arrive in [timeLeft(600)] minutes.[reason][SSshuttle.emergencyLastCallLoc ? "\n\nCall signal traced. Results can be viewed on any communications console." : "" ]", null, "shuttlecalled", "Priority")

/obj/docking_port/mobile/emergency/cancel(area/signalOrigin)
	if(mode != SHUTTLE_CALL)
		return
	if(SSshuttle.emergencyNoRecall)
		return

	invertTimer()
	mode = SHUTTLE_RECALL

	if(prob(70))
		SSshuttle.emergencyLastCallLoc = signalOrigin
	else
		SSshuttle.emergencyLastCallLoc = null
	priority_announce("The emergency shuttle has been recalled.[SSshuttle.emergencyLastCallLoc ? " Recall signal traced. Results can be viewed on any communications console." : "" ]", null, "shuttlerecalled", "Priority")

/obj/docking_port/mobile/emergency/proc/is_hijacked()
	return hijack_status == HIJACKED

/obj/docking_port/mobile/emergency/proc/ShuttleDBStuff()
	set waitfor = FALSE
	if(!SSdbcore.Connect())
		return
	var/datum/DBQuery/query_round_shuttle_name = SSdbcore.NewQuery("UPDATE [format_table_name("round")] SET shuttle_name = '[name]' WHERE id = [GLOB.round_id]")
	query_round_shuttle_name.Execute()
	qdel(query_round_shuttle_name)

/obj/docking_port/mobile/emergency/check()
	if(!timer)
		return
	var/time_left = timeLeft(1)

	// The emergency shuttle doesn't work like others so this
	// ripple check is slightly different
	if(!ripples.len && (time_left <= SHUTTLE_RIPPLE_TIME) && ((mode == SHUTTLE_CALL) || (mode == SHUTTLE_ESCAPE)))
		var/destination
		if(mode == SHUTTLE_CALL)
			destination = SSshuttle.getDock("emergency_home")
		else if(mode == SHUTTLE_ESCAPE)
			destination = SSshuttle.getDock("emergency_away")
		create_ripples(destination)

	switch(mode)
		if(SHUTTLE_RECALL)
			if(time_left <= 0)
				mode = SHUTTLE_IDLE
				timer = 0
		if(SHUTTLE_CALL)
			if(time_left <= 0)
				//move emergency shuttle to station
				if(initiate_docking(SSshuttle.getDock("emergency_home")) != DOCKING_SUCCESS)
					setTimer(20)
					return
				mode = SHUTTLE_DOCKED
				setTimer(SSshuttle.emergencyDockTime)
				send2irc("Server", "The Emergency Shuttle has docked with the station.")
				priority_announce("The Emergency Shuttle has docked with the station. You have [timeLeft(600)] minutes to board the Emergency Shuttle.", null, "shuttledock", "Priority")
				ShuttleDBStuff()


		if(SHUTTLE_DOCKED)
			if(time_left <= ENGINES_START_TIME)
				mode = SHUTTLE_IGNITING
				SSshuttle.checkHostileEnvironment()
				if(mode == SHUTTLE_STRANDED)
					return
				for(var/A in SSshuttle.mobile)
					var/obj/docking_port/mobile/M = A
					if(M.launch_status == UNLAUNCHED) //Pods will not launch from the mine/planet, and other ships won't launch unless we tell them to.
						M.check_transit_zone()

		if(SHUTTLE_IGNITING)
			var/success = TRUE
			SSshuttle.checkHostileEnvironment()
			if(mode == SHUTTLE_STRANDED)
				return

			success &= (check_transit_zone() == TRANSIT_READY)
			for(var/A in SSshuttle.mobile)
				var/obj/docking_port/mobile/M = A
				if(M.launch_status == UNLAUNCHED)
					success &= (M.check_transit_zone() == TRANSIT_READY)
			if(!success)
				setTimer(ENGINES_START_TIME)

			if(time_left <= 50 && !sound_played) //4 seconds left:REV UP THOSE ENGINES BOYS. - should sync up with the launch
				sound_played = 1 //Only rev them up once.
				var/list/areas = list()
				for(var/area/shuttle/escape/E in GLOB.sortedAreas)
					areas += E
				hyperspace_sound(HYPERSPACE_WARMUP, areas)

			if(time_left <= 0 && !SSshuttle.emergencyNoEscape)
				//move each escape pod (or applicable spaceship) to its corresponding transit dock
				for(var/A in SSshuttle.mobile)
					var/obj/docking_port/mobile/M = A
					M.on_emergency_launch()

				//now move the actual emergency shuttle to its transit dock
				var/list/areas = list()
				for(var/area/shuttle/escape/E in GLOB.sortedAreas)
					areas += E
				hyperspace_sound(HYPERSPACE_LAUNCH, areas)
				enterTransit()
				mode = SHUTTLE_ESCAPE
				launch_status = ENDGAME_LAUNCHED
				setTimer(SSshuttle.emergencyEscapeTime * engine_coeff)
				priority_announce("The Emergency Shuttle has left the station. Estimate [timeLeft(600)] minutes until the shuttle docks at Central Command.", null, null, "Priority")

		if(SHUTTLE_STRANDED)
			SSshuttle.checkHostileEnvironment()

		if(SHUTTLE_ESCAPE)
			if(sound_played && time_left <= HYPERSPACE_END_TIME)
				var/list/areas = list()
				for(var/area/shuttle/escape/E in GLOB.sortedAreas)
					areas += E
				hyperspace_sound(HYPERSPACE_END, areas)
			if(time_left <= PARALLAX_LOOP_TIME)
				var/area_parallax = FALSE
				for(var/place in shuttle_areas)
					var/area/shuttle/shuttle_area = place
					if(shuttle_area.parallax_movedir)
						area_parallax = TRUE
						break
				if(area_parallax)
					parallax_slowdown()
					for(var/A in SSshuttle.mobile)
						var/obj/docking_port/mobile/M = A
						if(M.launch_status == ENDGAME_LAUNCHED)
							if(istype(M, /obj/docking_port/mobile/pod))
								M.parallax_slowdown()

			if(time_left <= 0)
				//move each escape pod to its corresponding escape dock
				for(var/A in SSshuttle.mobile)
					var/obj/docking_port/mobile/M = A
					M.on_emergency_dock()

				// now move the actual emergency shuttle to centcom
				// unless the shuttle is "hijacked"
				var/destination_dock = "emergency_away"
				if(is_hijacked())
					destination_dock = "emergency_syndicate"
					minor_announce("Corruption detected in \
						shuttle navigation protocols. Please contact your \
						supervisor.", "SYSTEM ERROR:", alert=TRUE)

				dock_id(destination_dock)
				mode = SHUTTLE_ENDGAME
				timer = 0

/obj/docking_port/mobile/emergency/transit_failure()
	..()
	message_admins("Moving emergency shuttle directly to centcom dock to prevent deadlock.")

	mode = SHUTTLE_ESCAPE
	launch_status = ENDGAME_LAUNCHED
	setTimer(SSshuttle.emergencyEscapeTime)
	priority_announce("The Emergency Shuttle is preparing for direct jump. Estimate [timeLeft(600)] minutes until the shuttle docks at Central Command.", null, null, "Priority")


/obj/docking_port/mobile/pod
	name = "escape pod"
	id = "pod"
	dwidth = 1
	width = 3
	height = 4
	launch_status = UNLAUNCHED

/obj/docking_port/mobile/pod/request(obj/docking_port/stationary/S)
	var/obj/machinery/computer/shuttle/C = getControlConsole()
	if(!istype(C, /obj/machinery/computer/shuttle/pod))
		return ..()
	if(GLOB.security_level >= SEC_LEVEL_RED || (C && (C.obj_flags & EMAGGED)))
		if(launch_status == UNLAUNCHED)
			launch_status = EARLY_LAUNCHED
			return ..()
	else
		to_chat(usr, "<span class='warning'>Escape pods will only launch during \"Code Red\" security alert.</span>")
		return TRUE

/obj/docking_port/mobile/pod/cancel()
	return

/obj/machinery/computer/shuttle/pod
	name = "pod control computer"
	admin_controlled = 1
	possible_destinations = "pod_asteroid"
	icon = 'icons/obj/terminals.dmi'
	icon_state = "dorm_available"
	light_color = LIGHT_COLOR_BLUE
	density = FALSE
	clockwork = TRUE //it'd look weird

/obj/machinery/computer/shuttle/pod/ComponentInitialize()
	. = ..()
	AddElement(/datum/element/update_icon_blocker)

/obj/machinery/computer/shuttle/pod/emag_act(mob/user)
	. = SEND_SIGNAL(src, COMSIG_ATOM_EMAG_ACT)
	if(obj_flags & EMAGGED)
		return
	obj_flags |= EMAGGED
	to_chat(user, "<span class='warning'>You fry the pod's alert level checking system.</span>")
	return TRUE

/obj/machinery/computer/shuttle/pod/connect_to_shuttle(obj/docking_port/mobile/port, obj/docking_port/stationary/dock, idnum, override=FALSE)
	. = ..()
	if(possible_destinations == initial(possible_destinations) || override)
		possible_destinations = "pod_lavaland[idnum]"

/obj/docking_port/stationary/random
	name = "escape pod"
	id = "pod"
	dwidth = 1
	width = 3
	height = 4
	var/target_area = /area/lavaland/surface/outdoors
	var/edge_distance = 16
	// Minimal distance from the map edge, setting this too low can result in shuttle landing on the edge and getting "sliced"

/obj/docking_port/stationary/random/Initialize(mapload)
	. = ..()
	if(!mapload)
		return

	var/list/turfs = get_area_turfs(target_area)
	var/turf/T = pick(turfs)

	while(turfs.len)
		if(T.x<edge_distance || T.y<edge_distance || (world.maxx+1-T.x)<edge_distance || (world.maxy+1-T.y)<edge_distance)
			turfs -= T
			T = pick(turfs)
		else
			forceMove(T)
			break

//Pod suits/pickaxes


/obj/item/clothing/head/helmet/space/orange
	name = "emergency space helmet"
	icon_state = "syndicate-helm-orange"
	item_state = "syndicate-helm-orange"

/obj/item/clothing/suit/space/orange
	name = "emergency space suit"
	icon_state = "syndicate-orange"
	item_state = "syndicate-orange"
	slowdown = 3

/obj/item/pickaxe/emergency
	name = "emergency disembarkation tool"
	desc = "For extracting yourself from rough landings."

/obj/item/storage/pod
	name = "emergency space suits"
	desc = "A wall mounted safe containing space suits. Will only open in emergencies."
	anchored = TRUE
	icon = 'icons/obj/storage.dmi'
	icon_state = "safe"
	integrity_failure = 0.2
	component_type = /datum/component/storage/concrete/emergency

/obj/item/storage/pod/PopulateContents()
	new /obj/item/clothing/head/helmet/space/orange(src)
	new /obj/item/clothing/head/helmet/space/orange(src)
	new /obj/item/clothing/suit/space/orange(src)
	new /obj/item/clothing/suit/space/orange(src)
	new /obj/item/clothing/mask/gas(src)
	new /obj/item/clothing/mask/gas(src)
	new /obj/item/tank/internals/oxygen/red(src)
	new /obj/item/tank/internals/oxygen/red(src)
	new /obj/item/pickaxe/emergency(src)
	new /obj/item/pickaxe/emergency(src)
	new /obj/item/survivalcapsule(src)
	new /obj/item/storage/toolbox/emergency(src)

/obj/docking_port/mobile/emergency/backup
	name = "backup shuttle"
	id = "backup"
	dwidth = 2
	width = 8
	height = 8
	dir = EAST

/obj/docking_port/mobile/emergency/backup/Initialize()
	// We want to be a valid emergency shuttle
	// but not be the main one, keep whatever's set
	// valid.
	// backup shuttle ignores `timid` because THERE SHOULD BE NO TOUCHING IT
	var/current_emergency = SSshuttle.emergency
	. = ..()
	SSshuttle.emergency = current_emergency
	SSshuttle.backup_shuttle = src

/obj/docking_port/mobile/emergency/shuttle_build/register()
	. = ..()
	initiate_docking(SSshuttle.getDock("emergency_home"))

#undef TIME_LEFT
#undef ENGINES_START_TIME
#undef ENGINES_STARTED
#undef IS_DOCKED
#undef MAX_AUTH_INPUTS
#undef NOT_BEGUN
#undef STAGE_1
#undef STAGE_2
#undef STAGE_3
#undef STAGE_4
#undef HIJACKED
