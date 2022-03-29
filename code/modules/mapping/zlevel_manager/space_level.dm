/**
 * Map level datums
 *
 * Used by the zlevel manager, contains all data about a zlevel.
 */
/datum/space_level
	// Basic information
	/// Name
	var/name
	/// Our z value
	var/z_value
	/// Are we physically made yet?
	var/instantiated = FALSE
	/// ID - defaults to null
	var/id
	/// Loaded JSON data
	var/list/raw_json
	/// Path to .dmm - this must be relative to the folder the .json was loaded from.
	/// Yeah, this means you can't link outside of nested directories, only deeper, but frankly, sue me.
	/// Use path_absolute to path from execution directory.
	var/map_path
	/// load orientation
	var/orientation = SOUTH
	/// load centered?
	var/center = FALSE
	/// load "void" tiles for blank areas when we're smaller than the world zlevel size?
	var/fill_void = TRUE

	#warn hook these into load process and generation
	// bounds - for when we had to fill void.
	/// start x
	var/lowerleft_x
	/// start y
	var/lowerleft_y
	/// end x
	var/topright_x
	/// end y
	var/topright_y

	// Linkage/MultiZ - what zlevels are where. References by ID, or direct ref to a space_level datum
	VAR_PRIVATE/up
	VAR_PRIVATE/down
	// Linkage - what zlevels are where - cardinals. Visual and movement transitions are automatically applied. References by ID, or direct ref to a space_level datum.
	VAR_PRIVATE/east
	VAR_PRIVATE/west
	VAR_PRIVATE/north
	VAR_PRIVATE/south

	/// Linkage mode
	var/linkage_mode = Z_LINKAGE_NORMAL

	/// Traits - binary yes/no's
	var/list/traits = list()
	/// Attributes - key-value lists, value can be string/number/null only. Recursing lists are supported.
	var/list/attributes = list()
	/// baseturf - path
	var/baseturf

	// TRANSIENT VARIABLES
	/// Current crosslinking x in grid
	var/tmp/cl_x
	/// Current crosslinking y in grid
	var/tmp/cl_y
	/// The world_struct we're in, if any
	var/tmp/datum/world_struct/struct
	/// x value in struct
	var/tmp/struct_x
	/// y value in struct
	var/tmp/struct_y
	/// z value in struct
	var/tmp/struct_z
	/// how many times we rebuilt turfs
	var/tmp/turfs_rebuild_count = 0
	/// how many times we rebuilt transitions
	var/tmp/transitions_rebuild_count = 0

/datum/space_level/New(id, list/traits, list/attributes, map_path)
	if(id)
		src.id = id
	if(!src.id)
		src.id = "[GUID()]"
	if(map_path)
		src.map_path = map_path
	if(traits)
		for(var/trait in traits)
			AddTrait(trait)
	if(attributes)
		for(var/key in attributes)
			SetAttribute(key, attributes[key])

/datum/space_level/Destroy(force)
	if(instantiated && !force)
		. = QDEL_HINT_LETMELIVE
		CRASH("Attempted to destroy an instantiated space level datum.")
	traits = null
	attributes = null
	// don't rebuild the level, if we're instantiated and this is happening shit's fucked anyways
	up = down = east = west = north = south = null
	return ..()

/**
 * Builds data from a decoded JSON list
 *
 * @param
 * - data - data list passed in by subsystem during mapload
 * - pathroot - root path of the .json
 */
/datum/space_level/proc/ParseJSONList(list/data, pathroot)
	if(!islist(data))
		CRASH("Invalid data list")
	raw_json = data
	if(data["name"])
		name = data["name"]
	if(data["id"])
		SetID(data["id"])
	if(data["path_absolute"])
		map_path = data["path_absolute"]
	else if(data["path"])
		map_path = pathroot + data["path"]
	if(data["orientation"])
		orientation = data["orientation"]
		if(istext(orientation))
			switch(lowertext(orientation))
				if("north")
					orientation = NORTH
				if("south")
					orientation = SOUTH
				if("east")
					orientation = EAST
				if("west")
					orientation = WEST
				else
					orientation = SOUTH
		else if(isnum(orientation))
			if(!(orientation in GLOB.cardinals))
				orientation = SOUTH
	if(data["center"])
		center = data["center"]
	if(data["fill_void"])
		fill_void = data["fill_void"]
	// This part links us based on index.
	if(data["up"])
		up = data["up"]
	if(data["down"])
		down = data["down"]
	if(data["east"])
		east = data["east"]
	if(data["west"])
		west = data["west"]
	if(data["north"])
		north = data["north"]
	if(data["south"])
		south = data["south"]
	if(data["baseturf"])
		baseturf = text2path(data["baseturf"])
		if(!ispath(baseturf))
			baseturf = down? /turf/open/openspace : world.turf
			stack_trace("Invalid baseturf [data["baseturf"]].")
	if(data["traits"])
		for(var/i in data["traits"])
			AddTrait(i)
	if(data["attributes"])
		for(var/key in data["attributes"])
			SetAttribute(key, data["attributes"][key])
	if(data["linkage_mode"])
		linkage_mode = data["linkage_mode"]

/**
 * Called after the level is physically created.
 *
 * @param
 * - z_index - physical z value
 * - maploaded - did our map_path get used to create us or are we a bare level at time of call?
 */
/datum/space_level/proc/PostLoad(z_index, maploaded)
	if(isnull(name))
		name = "Unknown Level [z_index]"

/**
 * Gets DMM path
 */
/datum/space_level/proc/GetPath()
	return map_path

/**
 * Sets a multiz/transition point to another level.
 *
 * WARNING: As with all core map/zlevel management backend procs, this is a dangerous proc to use.
 * Do not use this unless you know what you are doing.
 *
 * This proc does NOT automatically rebuild/update multiz and transitions - YOU have to do this.
 * SSmapping will also not update its lookups automatically.
 *
 * @param
 * - other - map level id to set this to link to, or direct reference
 */
/datum/space_level/proc/SetEast(other)
	if(struct)
		CRASH("Attempted to set transition while in world_struct.")
	ASSERT(istext(other) || istype(other, /datum/space_level))
	east = other

/datum/space_level/proc/SetWest(other)
	if(struct)
		CRASH("Attempted to set transition while in world_struct.")
	ASSERT(istext(other) || istype(other, /datum/space_level))
	west = other

/datum/space_level/proc/SetNorth(other)
	if(struct)
		CRASH("Attempted to set transition while in world_struct.")
	ASSERT(istext(other) || istype(other, /datum/space_level))
	north = other

/datum/space_level/proc/SetSouth(other)
	if(struct)
		CRASH("Attempted to set transition while in world_struct.")
	ASSERT(istext(other) || istype(other, /datum/space_level))
	south = other

/datum/space_level/proc/SetUp(other)
	if(struct)
		CRASH("Attempted to set transition while in world_struct.")
	ASSERT(istext(other) || istype(other, /datum/space_level))
	up = other

/datum/space_level/proc/SetDown(other)
	if(struct)
		CRASH("Attempted to set transition while in world_struct.")
	ASSERT(istext(other) || istype(other, /datum/space_level))
	down = other

/datum/space_level/proc/SetID(id)
	SSmapping.level_by_id -= src.id
	src.id = id
	SSmapping.level_by_id[src.id] = src

/**
 * call to rebuild all turfs for vertical multiz
 *
 * this will sleep
 */
/datum/space_level/proc/RebuildTurfs()
	for(var/turf/T as anything in block(locate(1,1,z_value), locate(world.maxx, world.maxy, z_value)))
		T.UpdateMultiZ()
		CHECK_TICK
	turfs_rebuild_count = TRUE

/**
 * call to rebuild all turfs for horizontal transitions
 *
 * this will sleep
 */
/datum/space_level/proc/RebuildTransitions()
	var/list/checking = list()
	#warn support less-than-world-size levels
	checking += block(locate(1, 1, z_value), locate(world.maxx, 1, z_value))
	checking += block(locate(1, world.maxy, z_value), locate(world.maxx, world.maxy, z_value))
	checking += block(locate(1, 2, z_value), locate(1, world.maxy - 1, z_value))
	checking += block(locate(world.maxx, 2, z_value), locate(world.maxx, world.maxy - 1, z_value))
	for(var/turf/T in checking)
		T.UpdateTransitions()
		CHECK_TICK
	transitions_rebuild_count = TRUE

/**
 * Rebuild turfs up/down of us
 */
/datum/space_level/proc/RebuildVerticalLevels()
	for(var/datum/space_level/L in list(
		GetLevelInDir(UP),
		GetLevelInDir(DOWN)
	))
		L.RebuildTurfs()

/**
 * Rebuild turfs adjacent of us
 */
/datum/space_level/proc/RebuildAdjacentLevels()
	for(var/datum/space_level/L in list(
		GetLevelInDir(NORTH),
		GetLevelInDir(SOUTH),
		GetLevelInDir(EAST),
		GetLevelInDir(WEST)
	))
		L.RebuildTransitions()

/**
 * Do we have a certain trait?
 */
/datum/space_level/proc/HasTrait(trait)
	return trait in traits

/**
 * Removes a trait
 */
/datum/space_level/proc/RemoveTrait(trait)
	traits -= trait
	SSmapping.OnTraitDel(src, trait)

/**
 * Adds a trait
 */
/datum/space_level/proc/AddTrait(trait)
	traits |= trait
	SSmapping.OnTraitAdd(src, trait)

/**
 * Get value of attribute
 */
/datum/space_level/proc/GetAttribute(attr)
	return attributes[attr]

/**
 * Set value of attribute
 */
/datum/space_level/proc/SetAttribute(attr, val)
	attributes[attr] = val
	SSmapping.OnAttributeSet(src, attr, val)

/**
 * Gets neighbor in dir
 */
/datum/space_level/proc/GetLevelInDir(dir)
	RETURN_TYPE(/datum/space_level)
	// diagonal
	if(dir & (dir - 1))
		var/datum/space_level/NS = GetLevelInDir(NSCOMPONENT(dir))
		var/datum/space_level/EW = GetLevelInDir(EWCOMPONENT(dir))
		if(!NS || !EW)
			return null
		// both exist, check for "agreement"
		var/datum/space_level/potential = NS.GetLevelInDir(EWCOMPONENT(dir))
		return (EW.GetLevelInDir(NSCOMPONENT(dir)) == potential) && potential
	// cardinal
	else
		switch(dir)
			if(NORTH)
				return istype(north, /datum/space_level)? north : SSmapping.level_by_id[north]
			if(SOUTH)
				return istype(south, /datum/space_level)? south : SSmapping.level_by_id[south]
			if(EAST)
				return istype(east, /datum/space_level)? east : SSmapping.level_by_id[east]
			if(WEST)
				return istype(west, /datum/space_level)? west : SSmapping.level_by_id[west]
			if(UP)
				return istype(up, /datum/space_level)? up : SSmapping.level_by_id[up]
			if(DOWN)
				return istype(down, /datum/space_level)? down : SSmapping.level_by_id[down]
			else
				CRASH("Invalid dir: [dir]")

/**
 * expand the level to fill the entire level, wiping void turfs on the way
 */
/datum/space_level/proc/RemoveVoid()
	#warn impl
