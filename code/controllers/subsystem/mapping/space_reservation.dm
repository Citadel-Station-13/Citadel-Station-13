/**
 * Space reservation system
 * Allows for dynamically allocating a portion of space in an isolated zlevel
 *
 * The only time this should be used in a player-facing way is for hilbert hotel and shuttle short-jumps.
 * Nothing, including telecomms/teleports, should work in the reserved level.
 */
/datum/controller/subsystem/mapping
	/// Number of levels used for space reservations. For a 255x255 map, this probably shouldn't be above 1.
	var/static/reserved_level_count = 0
	/// Free reserved turfs - kept so allocation can be fast. "[zlevel]" = list(turfs)
	var/static/list/free_reserve_turfs = list()
	/// Allocated space reservations
	var/static/list/datum/space_reservation/space_reservations
	/// Allocated reserved turfs - list(turf = space reservation datum reference)
	var/static/list/allocated_reserve_turfs = list()
	/// List of reserved zlevels
	var/static/list/reserve_levels = list()
	/// Currently doing an operation on reserved turfs that should block
	var/static/reformatting_reserved_turfs = FALSE
	/// Currently clearing reserved turfs
	var/static/clearing_reserved_turfs = TRUE
	/// Singleton area holding all unreserved turfs
	var/static/area/unused_reservation_area/unallocated_reserve_area = new

/datum/controller/subsystem/mapping/proc/WipeSpaceReservations(wipe_safety_delay = 100)
	if(clearing_reserved_turfs || !initialized)		// unneeded if so
		return
	UNTIL(!reformatting_reserved_turfs)
	reformatting_reserved_turfs = TRUE
	clearing_reserved_turfs = TRUE
	message_admins("Clearing dynamic reservation space.")
	ClearReservations(timeout = wipe_safety_delay)
	DoWipeSpaceReservations()
	reformatting_reserved_turfs = FALSE
	clearing_reserved_turfs = FALSE

/**
 * Tries to "safely" clear out reservations
 *
 * Return TRUE if no failures
 */
/datum/controller/subsystem/mapping/proc/ClearReservations(timeout = 100)
	var/go_ahead = world.time + timeout
	message_admins("Attempting to clear space reservations. Timeout is [timeout / 10] seconds.")
	subsystem_log("ClearReservations() called withh timeout [timeout]")
	// collect shuttles
	var/list/obj/docking_port/stationary/transit/in_transit = list()
	for(var/obj/docking_port/stationary/transit/T in SSshuttle.transit)
		in_transit[T] = T.get_docked()
	// clear shuttles
	if(in_transit.len)
		message_admins("[in_transit.len] shuttles in transit detected. Attempting to fast travel.")
		subsystem_log("Attempting to fast travel [in_transit.len] shuttles.")
	var/list/out_transit = list()
	for(var/i in in_transit)
		INVOKE_ASYNC(src, .proc/safely_clear_transit_dock, i, in_transit[i], out_transit)
	UNTIL((go_ahead < world.time) || (out_transit.len == in_transit.len))
	var/transit_failures = in_transit.len - out_transit.len
	message_admins("ClearReservations() exited with [transit_failures] transit failures.")
	subsystem_log("ClearReservations() exiting with [transit_failures] transit failures.")
	return !transit_failures

/datum/controller/subsystem/mapping/proc/safely_clear_transit_dock(obj/docking_port/stationary/transit/T, obj/docking_port/mobile/M, list/returning)
	M.setTimer(0)
	var/error = M.initiate_docking(M.destination, M.preferred_direction)
	if(!error)
		returning += M
		qdel(T, TRUE)

/**
 * Requests a block reservation of a certain size and type
 */
/datum/controller/subsystem/mapping/proc/RequestBlockReservation(width, height, z, type = /datum/space_reservation, turf_type_override, border_type_override, area_type_override)
	UNTIL(!reformatting_reserved_turfs)
	ASSERT(ispath(type, /datum/space_reservation))
	var/datum/space_reservation/reserve = new type
	if(turf_type_override)
		reserve.turf_type = turf_type_override
	if(border_type_override)
		reserve.borderturf = border_type_override
	if(area_type_override)
		reserve.area_type = area_type_override
	for(var/z in reserve_levels)
		if(reserve.Reserve(width, height, z))
			return reserve
	//If we didn't return at this point, theres a good chance we ran out of room on the exisiting reserved z levels, so lets try a new one
	var/datum/space_level/L = CreateReservedLevel()
	if(!L.instantiated)
		CRASH("Failed to instance new reserved level")
	if(!L.z_value)
		CRASH("Could not find z value for new reserved level")
	if(reserve.Reserve(width, height, L.z_value))
		return reserve
	stack_trace("Somehow could not reserve a reservation even on a new level. Something is horribly wrong!")
	message_admins("WARNING: Space reservation system failed to reserve a [width]x[height] area even with a new reserve level. Something is wrrong.")
	QDEL_NULL(reserve)

/**
 * Creates and initializes a new reserved level
 */
/datum/controller/subsystem/mapping/proc/CreateReservedLevel()
	var/datum/space_level/L = new
	InstantiateMapLevel(L)
	InitializeReservedLevel(L.z_value)
	return L

/**
 * Initializes and registers a reserved level
 */
/datum/controller/subsystem/mapping/proc/InitializeReservedLevel(z)
	if(!z)
		CRASH("invalid Z")
	if(z in reserve_levels)
		CRASH("[z] is already in reserve_levels")
	reformatting_reserved_turfs = TRUE
	var/datum/space_level/L = space_levels[z]
	for(var/trait in L.traits)
		L.RemoveTrait(trait)
	for(var/key in L.attributes)
		L.SetAttribute(key, null)
	L.AddTrait(ZTRAIT_RESERVED)
	++reserved_level_count
	var/list/turfs = block(
		locate(1, 1, z),
		locate(world.maxx, world.maxy, z)
	)
	ReserveTurfs(turfs)
	free_reserve_turfs["[z]"] = turfs
	reserve_levels |= z
	reformatting_reserved_turfs = FALSE

/datum/controller/subsystem/mapping/proc/ReserveTurfs(list/turfs)
	for(var/i in turfs)
		var/turf/T = i
		T.empty(RESERVED_TURF_TYPE, RESERVED_TURF_TYPE, null, TRUE)
		LAZYINITLIST(free_reserve_turfs["[T.z]"])
		free_reserve_turfs["[T.z]"] |= T
		T.flags_1 |= UNUSED_RESERVATION_TURF_1
		unallocated_reserve_area.contents += T
		CHECK_TICK

/**
 * Do not call this proc directly
 *
 * Does the actual reservation wipe, immediately.
 */
/datum/controller/subsystem/mapping/proc/DoWipeSpaceReservations()
	if(!initialized)		// but why?
		return
	for(var/datum/space_reservation/R as anything in space_reservations)
		if(!QDELETED(R))
			qdel(R, TRUE)
	if(!istype(unallocated_reserve_area))
		unallocated_reserve_area = new
	space_reservations = list()
	var/list/clearing = list()
	for(var/z in free_reserve_turfs)
		if(islist(free_reserve_turfs[z]))
			clearing |= free_reserve_turfs[z]
	clearing |= allocated_reserve_turfs
	if(length(allocated_reserve_turfs))
		subsystem_log("[allocated_reserve_turfs] failed to deallocate on DoWipeSpaceReservations().")
	free_reserve_turfs = list()
	allocated_reserve_turfs = list()
	ReserveTurfs(clearing)

/area/unused_reservation_area
	name = "Unused Reservation Area"
	area_flags = UNIQUE_AREA
	always_unpowered = TRUE
	has_gravity = FALSE
