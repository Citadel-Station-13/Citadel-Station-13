/obj/vehicle
	name = "generic vehicle"
	desc = "Yell at coderbus."
	icon = 'icons/obj/vehicles.dmi'
	icon_state = "fuckyou"
	max_integrity = 300
	armor = list(MELEE = 30, BULLET = 30, LASER = 30, ENERGY = 0, BOMB = 30, BIO = 0, RAD = 0, FIRE = 60, ACID = 60)
	density = TRUE
	anchored = FALSE
	COOLDOWN_DECLARE(cooldown_vehicle_move)
	/// mob = bitflags of their control level.
	var/list/mob/occupants
	var/max_occupants = 1
	/// Maximum amount of drivers
	var/max_drivers = 1
	var/movedelay = 2
	var/lastmove = 0
	/**
	  * If the driver needs a certain item in hand (or inserted, for vehicles) to drive this. For vehicles, this must be duplicated on their riding component subtype
	  * [/datum/component/riding/var/keytype] variable because only a few specific checks are handled here with this var, and the majority of it is on the riding component
	  * Eventually the remaining checks should be moved to the component and this var removed.
	  */
	var/key_type
	/// The inserted key, needed on some vehicles to start the engine
	var/obj/item/key/inserted_key
	/// Can subtypes of this key work
	var/key_type_exact = TRUE
	/// Whether the vehicle is currently able to move
	var/canmove = TRUE
	/// When bumping a door try to make occupants bump them to open them.
	var/emulate_door_bumps = TRUE
	/// Handle driver movement instead of letting something else do it like riding datums.
	var/default_driver_move = TRUE
	/// Is the rider protected from bullets? assume no
	var/enclosed = FALSE
	/// Plain list of typepaths
	var/list/autogrant_actions_passenger
	/// Assoc list "[bitflag]" = list(typepaths)
	var/list/autogrant_actions_controller
	/// Assoc list mob = list(type = action datum assigned to mob)
	var/list/mob/occupant_actions
	/// This vehicle will follow us when we move (like atrailer duh)
	var/obj/vehicle/trailer
	/// Do we have a special mouse
	var/mouse_pointer

/obj/vehicle/Initialize(mapload)
	. = ..()
	occupants = list()
	autogrant_actions_passenger = list()
	autogrant_actions_controller = list()
	occupant_actions = list()
	generate_actions()

/obj/vehicle/examine(mob/user)
	. = ..()
	if(resistance_flags & ON_FIRE)
		. += span_warning("It's on fire!")
	. += generate_integrity_message()

/// Returns a readable string of the vehicle's health for examining. Overridden by subtypes who want to be more verbose with their health messages.
/obj/vehicle/proc/generate_integrity_message()
	var/examine_text = ""
	var/integrity = obj_integrity/max_integrity * 100
	switch(integrity)
		if(50 to 99)
			examine_text = "It looks slightly damaged."
		if(25 to 50)
			examine_text = "It appears heavily damaged."
		if(0 to 25)
			examine_text = span_warning("It's falling apart!")

	return examine_text

/obj/vehicle/proc/is_key(obj/item/possible_key)
	if(possible_key)
		if(key_type_exact)
			return possible_key.type == key_type
		return istype(possible_key, key_type)
	return FALSE

/obj/vehicle/proc/return_occupants()
	return occupants

/obj/vehicle/proc/occupant_amount()
	return LAZYLEN(occupants)

/obj/vehicle/proc/return_amount_of_controllers_with_flag(flag)
	. = 0
	for(var/i in occupants)
		if(occupants[i] & flag)
			.++

/obj/vehicle/proc/return_controllers_with_flag(flag)
	RETURN_TYPE(/list/mob)
	. = list()
	for(var/i in occupants)
		if(occupants[i] & flag)
			. += i

/obj/vehicle/proc/return_drivers()
	return return_controllers_with_flag(VEHICLE_CONTROL_DRIVE)

/obj/vehicle/proc/driver_amount()
	return return_amount_of_controllers_with_flag(VEHICLE_CONTROL_DRIVE)

/obj/vehicle/proc/is_driver(mob/M)
	return is_occupant(M) && occupants[M] & VEHICLE_CONTROL_DRIVE

/obj/vehicle/proc/is_occupant(mob/M)
	return !isnull(LAZYACCESS(occupants, M))

/obj/vehicle/proc/add_occupant(mob/M, control_flags)
	if(!istype(M) || is_occupant(M))
		return FALSE

	LAZYSET(occupants, M, NONE)
	add_control_flags(M, control_flags)
	after_add_occupant(M)
	grant_passenger_actions(M)
	return TRUE

/obj/vehicle/proc/after_add_occupant(mob/M)
	auto_assign_occupant_flags(M)

/obj/vehicle/proc/auto_assign_occupant_flags(mob/M) //override for each type that needs it. Default is assign driver if drivers is not at max.
	if(driver_amount() < max_drivers)
		add_control_flags(M, VEHICLE_CONTROL_DRIVE)

/obj/vehicle/proc/remove_occupant(mob/M)
	SHOULD_CALL_PARENT(TRUE)
	if(!istype(M))
		return FALSE
	remove_control_flags(M, ALL)
	remove_passenger_actions(M)
	LAZYREMOVE(occupants, M)
	cleanup_actions_for_mob(M)
	after_remove_occupant(M)
	return TRUE

/obj/vehicle/proc/after_remove_occupant(mob/M)

/obj/vehicle/relaymove(mob/user, direction)
	if(!canmove)
		return FALSE
	if(is_driver(user))
		return driver_move(user, direction)
	return FALSE

/obj/vehicle/proc/driver_move(mob/user, direction)
	if(key_type && !is_key(inserted_key))
		to_chat(user, span_warning("[src] has no key inserted!"))
		return FALSE
	if(!default_driver_move)
		return
	vehicle_move(direction)

/obj/vehicle/proc/vehicle_move(direction)
	if(!COOLDOWN_FINISHED(src, cooldown_vehicle_move))
		return FALSE
	COOLDOWN_START(src, cooldown_vehicle_move, movedelay)

	if(trailer)
		var/dir_to_move = get_dir(trailer.loc, loc)
		var/did_move = step(src, direction)
		if(did_move)
			step(trailer, dir_to_move)
		return did_move
	after_move(direction)
	return step(src, direction)

/obj/vehicle/proc/after_move(direction)
	return

/obj/vehicle/proc/add_control_flags(mob/controller, flags)
	if(!is_occupant(controller) || !flags)
		return FALSE
	occupants[controller] |= flags
	for(var/i in GLOB.bitflags)
		if(flags & i)
			grant_controller_actions_by_flag(controller, i)
	return TRUE

/obj/vehicle/proc/remove_control_flags(mob/controller, flags)
	if(!is_occupant(controller) || !flags)
		return FALSE
	occupants[controller] &= ~flags
	for(var/i in GLOB.bitflags)
		if(flags & i)
			remove_controller_actions_by_flag(controller, i)
	return TRUE

/obj/vehicle/Bump(atom/movable/M)
	. = ..()
	if(emulate_door_bumps)
		if(istype(M, /obj/machinery/door))
			for(var/m in occupants)
				M.Bumped(m)

/// To add a trailer to the vehicle in a manner that allows safe qdels
/obj/vehicle/proc/add_trailer(obj/vehicle/added_vehicle)
	trailer = added_vehicle
	RegisterSignal(trailer, COMSIG_PARENT_QDELETING, PROC_REF(remove_trailer))

/// To remove a trailer from the vehicle in a manner that allows safe qdels
/obj/vehicle/proc/remove_trailer()
	SIGNAL_HANDLER
	UnregisterSignal(trailer, COMSIG_PARENT_QDELETING)
	trailer = null

/obj/vehicle/Move(newloc, dir)
	// It is unfortunate, but this is the way to make it not mess up
	var/atom/old_loc = loc
	// When we do this, it will set the loc to the new loc
	. = ..()
	if(trailer && .)
		var/dir_to_move = get_dir(trailer.loc, old_loc)
		step(trailer, dir_to_move)

/obj/vehicle/bullet_act(obj/item/projectile/Proj) //wrapper
	if (!enclosed && length(occupants) && !Proj.force_hit && (Proj.def_zone == BODY_ZONE_HEAD || Proj.def_zone == BODY_ZONE_CHEST)) //allows bullets to hit drivers
		occupants[1].bullet_act(Proj) // driver dinkage
		return BULLET_ACT_HIT
	. = ..()
