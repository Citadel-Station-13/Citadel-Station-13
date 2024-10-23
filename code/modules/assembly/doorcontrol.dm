/obj/item/assembly/control
	name = "blast door controller"
	desc = "A small electronic device able to control a blast door remotely."
	icon_state = "control"
	attachable = TRUE
	/// Our ID. Make the first character ! if you want to obfuscate it as a mapper via randomization.
	var/id
	/// Can the ID be changed if used in hand?
	var/can_change_id = FALSE
	/// Show ID?
	var/show_id = TRUE
	var/cooldown = FALSE //Door cooldowns

/obj/item/assembly/control/Initialize(mapload)
	if(mapload && id)
		if(copytext(id, 1, 2) == "!")
			id = SSmapping.get_obfuscated_id(id)
	return ..()

/obj/item/assembly/control/examine(mob/user)
	. = ..()
	if(id && show_id)
		. += span_notice("Its channel ID is '[id]'.")
	if(can_change_id)
		. += span_notice("Use in hand to change ID.")

/obj/item/assembly/control/attack_self(mob/living/user)
	. = ..()
	if(!can_change_id)
		return
	var/new_id
	new_id = input(user, "Set ID", "Set ID", show_id? id : null) as text|null
	if(!isnull(new_id))		//0/"" is considered !, so check null instead of just !.
		id = new_id

/obj/item/assembly/control/activate()
	cooldown = TRUE
	var/openclose
	for(var/obj/machinery/door/poddoor/M in GLOB.machines)
		if(M.id == src.id)
			if(openclose == null)
				openclose = M.density
			INVOKE_ASYNC(M, openclose ? TYPE_PROC_REF(/obj/machinery/door/poddoor, open) : TYPE_PROC_REF(/obj/machinery/door/poddoor, close))
	addtimer(VARSET_CALLBACK(src, cooldown, FALSE), 10)

/obj/item/assembly/control/airlock
	name = "airlock controller"
	desc = "A small electronic device able to control an airlock remotely."
	id = "badmin" // Set it to null for MEGAFUN.
	var/specialfunctions = OPEN
	/*
	Bitflag, 	1= open (OPEN)
				2= idscan (IDSCAN)
				4= bolts (BOLTS)
				8= shock (SHOCK)
				16= door safties (SAFE)
	*/

/obj/item/assembly/control/airlock/activate()
	cooldown = TRUE
	var/doors_need_closing = FALSE
	var/list/obj/machinery/door/airlock/open_or_close = list()
	for(var/obj/machinery/door/airlock/D in GLOB.airlocks)
		if(D.id_tag == src.id)
			if(specialfunctions & OPEN)
				open_or_close += D
				if(!D.density)
					doors_need_closing = TRUE
			if(specialfunctions & IDSCAN)
				D.aiDisabledIdScanner = !D.aiDisabledIdScanner
			if(specialfunctions & BOLTS)
				if(!D.wires.is_cut(WIRE_BOLTS) && D.hasPower())
					D.locked = !D.locked
					D.update_icon()
			if(specialfunctions & SHOCK)
				if(D.secondsElectrified)
					D.secondsElectrified = -1
					LAZYADD(D.shockedby, "\[[TIME_STAMP("hh:mm:ss", FALSE)]\] [key_name(usr)]")
					log_combat(usr, D, "electrified")
				else
					D.secondsElectrified = 0
			if(specialfunctions & SAFE)
				D.safe = !D.safe

	for(var/D in open_or_close)
		INVOKE_ASYNC(D, doors_need_closing ? TYPE_PROC_REF(/obj/machinery/door/airlock, close) : TYPE_PROC_REF(/obj/machinery/door/airlock, open))

	addtimer(VARSET_CALLBACK(src, cooldown, FALSE), 10)


/obj/item/assembly/control/massdriver
	name = "mass driver controller"
	desc = "A small electronic device able to control a mass driver."

/obj/item/assembly/control/massdriver/activate()
	cooldown = TRUE
	for(var/obj/machinery/door/poddoor/M in GLOB.machines)
		if (M.id == src.id)
			INVOKE_ASYNC(M, TYPE_PROC_REF(/obj/machinery/door/poddoor, open))

	sleep(10)

	for(var/obj/machinery/mass_driver/M in GLOB.machines)
		if(M.id == src.id)
			M.drive()

	sleep(60)

	for(var/obj/machinery/door/poddoor/M in GLOB.machines)
		if (M.id == src.id)
			INVOKE_ASYNC(M, TYPE_PROC_REF(/obj/machinery/door/poddoor, close))

	addtimer(VARSET_CALLBACK(src, cooldown, FALSE), 10)


/obj/item/assembly/control/igniter
	name = "ignition controller"
	desc = "A remote controller for a mounted igniter."

/obj/item/assembly/control/igniter/activate()
	cooldown = TRUE
	for(var/obj/machinery/sparker/M in GLOB.machines)
		if (M.id == src.id)
			INVOKE_ASYNC(M, TYPE_PROC_REF(/obj/machinery/sparker, ignite))

	for(var/obj/machinery/igniter/M in GLOB.machines)
		if(M.id == src.id)
			M.use_power(50)
			M.on = !M.on
			M.icon_state = "igniter[M.on]"

	addtimer(VARSET_CALLBACK(src, cooldown, FALSE), 30)

/obj/item/assembly/control/flasher
	name = "flasher controller"
	desc = "A remote controller for a mounted flasher."

/obj/item/assembly/control/flasher/activate()
	cooldown = TRUE
	for(var/obj/machinery/flasher/M in GLOB.machines)
		if(M.id == src.id)
			INVOKE_ASYNC(M, TYPE_PROC_REF(/obj/machinery/flasher, flash))

	addtimer(VARSET_CALLBACK(src, cooldown, FALSE), 50)

/obj/item/assembly/control/crematorium
	name = "crematorium controller"
	desc = "An evil-looking remote controller for a crematorium."

/obj/item/assembly/control/crematorium/activate()
	cooldown = TRUE
	for (var/obj/structure/bodycontainer/crematorium/C in GLOB.crematoriums)
		if (C.id == id)
			C.cremate(usr)

	addtimer(VARSET_CALLBACK(src, cooldown, FALSE), 50)

/obj/item/assembly/control/electrochromatic
	name = "electrochromatic window controller"
	desc = "Toggles linked electrochromatic windows."
	can_change_id = TRUE
	/// Stores our status to prevent windows from desyncing.
	var/on = FALSE

/obj/item/assembly/control/electrochromatic/activate()
	on = !on
	do_electrochromatic_toggle(on, id)

//how long it spends on each floor when moving somewhere, so it'd take 4 seconds to reach you if it had to travel up 2 floors
#define FLOOR_TRAVEL_TIME 2 SECONDS
/obj/item/assembly/control/elevator
	name = "elevator controller"
	desc = "A small device used to call elevators to the current floor."

/obj/item/assembly/control/elevator/activate()
	if(cooldown)
		return
	cooldown = TRUE
	var/obj/structure/industrial_lift/lift
	for(var/l in GLOB.lifts)
		var/obj/structure/industrial_lift/possible_lift = l
		if(possible_lift.id != id || possible_lift.z == z || possible_lift.controls_locked)
			continue
		lift = possible_lift
		break
	if(!lift)
		addtimer(VARSET_CALLBACK(src, cooldown, FALSE), 2 SECONDS)
		return
	lift.visible_message(span_notice("[src] clinks and whirrs into automated motion, locking controls."))
	lift.lift_master_datum.set_controls(LOCKED)
	///The z level to which the elevator should travel
	var/targetZ = (abs(loc.z)) //The target Z (where the elevator should move to) is not our z level (we are just some assembly in nullspace) but actually the Z level of whatever we are contained in (e.g. elevator button)
	///The amount of z levels between the our and targetZ
	var/difference = abs(targetZ - lift.z)
	///Direction (up/down) needed to go to reach targetZ
	var/direction = lift.z < targetZ ? UP : DOWN
	///How long it will/should take us to reach the target Z level
	var/travel_duration = FLOOR_TRAVEL_TIME * difference //100 / 2 floors up = 50 seconds on every floor, will always reach destination in the same time
	addtimer(VARSET_CALLBACK(src, cooldown, FALSE), travel_duration)
	for(var/i in 1 to difference)
		sleep(FLOOR_TRAVEL_TIME)//hey this should be alright... right?
		if(QDELETED(lift) || QDELETED(src))//elevator control or button gone = don't go up anymore
			return
		lift.lift_master_datum.MoveLift(direction, null)
	lift.visible_message(span_notice("[src] clicks, ready to be manually operated again."))
	lift.lift_master_datum.set_controls(UNLOCKED)

#undef FLOOR_TRAVEL_TIME
