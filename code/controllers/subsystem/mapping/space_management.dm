/datum/controller/subsystem/mapping
	/// Ordered list of /datum/space_level - corrosponds to real z values!
	var/static/list/datum/space_level/space_levels = list()
	/// id to map level datum
	var/static/list/datum/space_level/level_by_id = list()
	/// Ordered lookup list for multiz up
	var/list/multiz_lookup_up
	/// Ordered lookup list for multiz down
	var/list/multiz_lookup_down
	/// Ordered lookup list for east transition
	var/list/transition_lookup_east
	/// Ordered lookup list for west transition
	var/list/transition_lookup_west
	/// Ordered lookup list for north transition
	var/list/transition_lookup_north
	/// Ordered lookup list for south transition
	var/list/transition_lookup_south
	/// 2d array for crosslink lookups
	var/list/crosslinking_grid
	/// Z access lookup - z = list() of zlevels it can access. For performance, this is currently only including bidirectional links, AND does not support looping.
	var/list/z_stack_lookup
	/// Z stack needs updating
	var/z_stack_dirty = TRUE
	/// Active world_structs
	var/static/list/datum/world_struct/structs = list()
	/// World struct lookup by level
	var/static/list/datum/world_struct/struct_by_z = list()

/**
 * Ensure all synchronized lists are valid
 */
/datum/controller/subsystem/mapping/proc/SynchronizeDatastructures()
#define SYNC(var) if(!var) { var = list() ; } ; if(var.len != world.maxz) { . = TRUE ; var.len = world.maxz; }
	. = FALSE
	SYNC(space_levels)
	SYNC(multiz_lookup_up)
	SYNC(multiz_lookup_down)
	SYNC(transition_lookup_east)
	SYNC(transition_lookup_west)
	SYNC(transition_lookup_north)
	SYNC(transition_lookup_south)
	SYNC(z_stack_lookup)
	SYNC(struct_by_z)
	z_stack_dirty = FALSE
	if(.)
		z_stack_dirty = TRUE
#undef SYNC

/**
 * Call whenever a zlevel's up/down is modified
 *
 * This does NOT rebuild turf graphics - call it on each level for that.
 */
/datum/controller/subsystem/mapping/proc/RebuildVerticality(datum/space_level/updated, datum/space_level/targeted, dir)
	if(!updated || !multiz_lookup_up || !multiz_lookup_down)
		// full rebuild
		z_stack_dirty = TRUE
		multiz_lookup_up = list()
		multiz_lookup_down = list()
		multiz_lookup_up.len = world.maxz
		multiz_lookup_down.len = world.maxz
		for(var/i in 1 to world.maxz)
			var/datum/space_level/level = space_levels[i]
			multiz_lookup_up[i] = level.GetLevelInDir(UP)?.z_value
			multiz_lookup_down[i] = level.GetLevelInDir(DOWN)?.z_value
	else
		// smart rebuild
		ASSERT(dir)
		if(!updated.instantiated)
			return
		z_stack_dirty = TRUE
		var/datum/space_level/level = updated
		switch(dir)
			if(UP)
				multiz_lookup_up[level.z_value] = level.GetLevelInDir(UP)?.z_value
			if(DOWN)
				multiz_lookup_down[level.z_value] = level.GetLevelInDir(DOWN)?.z_value
			else
				CRASH("Invalid dir: [dir]")
	SEND_GLOBAL_SIGNAL(COMSIG_GLOB_MULTIZ_UPDATE_VERTICAL)

/**
 * Call whenever a zlevel's east/west/north/south is modified
 *
 * This does NOT rebuild turf graphics - call it on each level for that.
 */
/datum/controller/subsystem/mapping/proc/RebuildTransitions(datum/space_level/updated, datum/space_level/targeted, dir)
	if(!updated || !transition_lookup_east || !transition_lookup_west || !transition_lookup_north || !transition_lookup_south)
		// full rebuild
		transition_lookup_east = list()
		transition_lookup_west = list()
		transition_lookup_north = list()
		transition_lookup_south = list()
		transition_lookup_east.len = transition_lookup_west.len = transition_lookup_north.len = transition_lookup_south.len = world.maxz
		for(var/i in 1 to world.maxz)
			var/datum/space_level/level = space_levels[i]
			transition_lookup_north[i] = level.GetLevelInDir(NORTH)?.z_value
			transition_lookup_south[i] = level.GetLevelInDir(SOUTH)?.z_value
			transition_lookup_east[i] = level.GetLevelInDir(EAST)?.z_value
			transition_lookup_west[i] = level.GetLevelInDir(WEST)?.z_value
	else
		// smart rebuild
		if(!updated.instantiated)
			return
		ASSERT(dir)
		var/datum/space_level/level = updated
		var/datum/space_level/other
		switch(dir)
			if(NORTH)
				transition_lookup_north[level.z_value] = level.GetLevelInDir(NORTH)?.z_value
			if(SOUTH)
				transition_lookup_south[level.z_value] = level.GetLevelInDir(SOUTH)?.z_value
			if(EAST)
				transition_lookup_east[level.z_value] = level.GetLevelInDir(EAST)?.z_value
			if(WEST)
				transition_lookup_west[level.z_value] = level.GetLevelInDir(WEST)?.z_value
			else
				CRASH("Invalid dir: [dir]")
	SEND_GLOBAL_SIGNAL(COMSIG_GLOB_MULTIZ_UPDATE_HORIZONTAL)

/**
 * Call to create a new level using a map datum - the map datum should be setup beforehand!
 *
 * Returns the zlevel index used/created.
 */
/datum/controller/subsystem/mapping/proc/InstantiateMapLevel(datum/space_level/level, load_from_path = TRUE, rebuild_datastructures_immediately = TRUE, rebuild_turfs_immediately = TRUE)
	ASSERT(istype(level))

	// make new level
	var/new_z = GetInstantiationLevel()

	SynchronizeDatastructures()

	if(new_z in reusable_levels)
		reusable_levels -= new_z

	space_levels[new_z] = level

	var/list/datum/parsed_map/parsed_maps = list()

	// load path
	if(load_from_path)
		var/path = level.GetPath()
		// can be file or path, NO .DMM STRINGS I SWEAR TO GOD
		if(fexists(path) || isfile(path))
			var/datum/parsed_map/parsed = new(isfile(path)? path : file(level.GetPath()))
			var/width = parsed.width
			var/height = parsed.height
			var/x = level.center? max(round((world.maxx - width) / 2), 1) : 1
			var/y = level.center? max(round((world.maxy - height) / 2), 1) : 1
			parsed.load(x, y, new_z, TRUE, TRUE, null, null, null, null, FALSE, level.orientation, FALSE, null)
			parsed_maps += parsed
		else if(path)	// didn't find, vs non existant
			stack_trace("Invalid path [path] in [level]")

	var/baseturf = GetBaseturf(new_z)
	// for any turfs not changed,
	for(var/turf/T as anything in block(locate(1, 1, new_z), locate(world.maxx, world.maxy, new_z)))
		if(istype(T, world.turf))
			T.ChangeTurf(baseturf, null, CHANGETURF_SKIP)

	// init template bounds
	for(var/datum/parsed_map/parsed as anything in parsed_maps)
		parsed.initTemplateBounds()

	// instantiated
	level.instantiated = TRUE

	// call postload
	level.PostLoad(., load_from_path)

	// rebuild caches
	if(rebuild_datastructures_immediately)
		RebuildCrosslinking()
		RebuildTransitions()
		RebuildVerticality()

	if(rebuild_turfs_immediately)
		// we don't have to rebuild our own, because mapload should have done that for up/down, but we do have to do transitions
		level.RebuildTransitions()
		level.RebuildAdjacentLevels()
		level.RebuildVerticalLevels()

	return new_z

/**
 * Creates a naked level
 */
/datum/controller/subsystem/mapping/proc/InstantiateRawLevel(rebuild_immediately)
	var/datum/space_level/level = new
	return InstantiateMapLevel(level, FALSE, rebuild_immediately)

/**
 * Called to instantiate a /datum/map_config's physical levels.
 *
 * Returns an ordered list of zlevel indices used/created, or null if failed
 */
/datum/controller/subsystem/mapping/proc/InstantiateMapDatum(datum/map_config/config, load_from_path = TRUE, rebuild_datastructures_immediately = TRUE, rebuild_turfs_immediately = TRUE)
	loaded_levels += config

	var/list/indices = list()

	for(var/datum/space_level/L as anything in config.levels)
		if(!istype(L))
			stack_trace("Invalid level [L] in [config]")
			continue
		indices += InstantiateMapLevel(L, load_from_path, FALSE, FALSE)

	if(config.world_structs)
		for(var/list/L as anything in config.world_structs)
			if(!islist(L))
				stack_trace("Invalid struct [L] in [config]")
				continue
			var/datum/world_struct/struct = new
			struct.Construct(L, FALSE)

	config.PostLoad(indices)

	if(rebuild_datastructures_immediately)
		RebuildCrosslinking()
		RebuildTransitions()
		RebuildVerticality()

	if(rebuild_turfs_immediately)
		RebuildMapLevelTurfs(indices)

	return indices.len? indices : null

/**
 * Automatically rebuilds the transitions and multiz of any zlevel that has them.
 * Usually called on world load.
 *
 * Can specify a list of zlevels to check (indices, not datums!), otherwise rebuilds all
 */
/datum/controller/subsystem/mapping/proc/RebuildMapLevelTurfs(list/indices, turfs, transitions)
	if(!indices)
		indices = list()
		for(var/i in 1 to world.maxz)
			indices += i
	for(var/number in indices)
		var/datum/space_level/L = space_levels[number]
		if(transitions)
			L.RebuildTransitions()
		if(turfs)
			L.RebuildTurfs()
		CHECK_TICK

#define CL_GRID(x, y, size) ((y - 1) * size + x)
/**
 * Rebuild crosslinking
 *
 * WARNING: Shuffles on every call.
 */
/datum/controller/subsystem/mapping/proc/RebuildCrosslinking()
	// gather levels
	var/list/datum/space_level/linking = list()
	for(var/datum/space_level/potential as anything in space_levels)
		if(potential.linkage_mode == Z_LINKAGE_CROSSLINKED)
			linking += potential
	// lay levels out in a 2d grid, the smallest square that can fit them all
	var/size
	for(size in 1 to 10)
		if((size * size) > linking)
			break
	crosslinking_grid = list()
	crosslinking_grid.len = size * size
	linking = shuffle(linking)
	for(var/i in 1 to size)
		for(var/j in 1 to size)
			var/level = CL_GRID(j, i, size)
			var/datum/space_level/L = linking[level]
			crosslinking_grid[level] = linking[L]
			// store the x/y too while we're at it
			L.cl_x = j
			L.cl_y = i
	// link based on this, wrapping around when we reach an edge or null
	if(size == 1)
		// wew
		var/datum/space_level/L = linking[1]
		L.SetEast(L)
		L.SetWest(L)
		L.SetNorth(L)
		L.SetSouth(L)
		return
	for(var/i in 1 to linking.len)
		var/datum/space_level/L = linking[i]
		L._CrosslinkGridScan(crosslinking_grid, size)

/**
 * Internal proc
 *
 * Scans for our neighbors from a grid.
 */
/datum/space_level/proc/_CrosslinkGridScan(list/grid, size)
	// current pos
	var/x
	var/y
	// scan left
	x = cl_x - 1
	y = cl_y
	do
		// wrap
		if(x == 0)
			x = size
		if(grid[CL_GRID(x, y, size)])
			SetWest(grid[CL_GRID(x, y, size)])
		--x
	while(x != cl_x)
	// scan right
	x = cl_x + 1
	y = cl_y
	do
		// wrap
		if(x == size)
			x = 1
		if(grid[CL_GRID(x, y, size)])
			SetWest(grid[CL_GRID(x, y, size)])
		++x
	while(x != cl_x)
	// scan up
	x = cl_x
	y = cl_y + 1
	do
		// wrap
		if(y == size)
			y = 1
		if(grid[CL_GRID(x, y, size)])
			SetWest(grid[CL_GRID(x, y, size)])
		++y
	while(y != cl_y)
	// scan down
	x = cl_x
	y = cl_y - 1
	do
		// wrap
		if(y == 0)
			y = size
		if(grid[CL_GRID(x, y, size)])
			SetWest(grid[CL_GRID(x, y, size)])
		++y
	while(y != cl_y)
	ASSERT(east)
	ASSERT(west)
	ASSERT(north)
	ASSERT(south)

#undef CL_GRID

/**
 * Gets the /datum/space_level of a zlevel
 */
/datum/controller/subsystem/mapping/proc/GetLevelDatum(z)
	if(z < 1 || z > world.maxz)
		CRASH("Z out of bounds")
	return space_levels[z]

/**
 * Gets the sorted Z stack list of a level - the levels accessible from a single level, in multiz
 */
/datum/controller/subsystem/mapping/proc/GetZStack(z)
	if(z_stack_dirty)
		RecalculateZStack()
	var/list/L = z_stack_lookup[z]
	return L.Copy()

/**
 * Recalculates Z stack
 *
 * **Warning**: RebuildVerticality must be called to recalculate up/down lookups,
 * as this proc uses them for speed!
 */
/datum/controller/subsystem/mapping/proc/RecalculateZStack()
	ValidateNoLoops()
	z_stack_lookup = list()
	z_stack_lookup.len = world.maxz
	var/list/left = list()
	for(var/z in 1 to world.maxz)
		if(struct_by_z[z])
			var/datum/world_struct/struct = struct_by_z[z]
			z_stack_lookup[z] = struct.stack_lookup[struct.real_indices.Find(z)]
		else
			left += z
	var/list/datum/space_level/bottoms = list()
	// let's sing the bottom song
	for(var/z in left)
		if(multiz_lookup_down[z])
			continue
		bottoms += z
	for(var/datum/space_level/bottom as anything in bottoms)
		// register us
		var/list/stack = list(bottom.z_value)
		z_stack_lookup[bottom.z_value] = stack
		// let's sing the list manipulation song
		var/datum/space_level/next = space_levels[multiz_lookup_up[bottom.z_value]]
		while(next)
			stack += next.z_value
			z_stack_lookup[next.z_value] = stack
			next = space_levels[multiz_lookup_up[next.z_value]]

/**
 * Ensures there's no up/down infinite loops
 */
/datum/controller/subsystem/mapping/proc/ValidateNoLoops()
	var/list/loops = list()
	for(var/z in 1 to world.maxz)
		var/list/found
		found = list(z)
		var/next = z
		while(next)
			next = multiz_lookup_up[next]
			if(next in found)
				loops += next
				break
			if(next)
				found += next
		next = z
		while(next)
			next = multiz_lookup_down[next]
			if(next in found)
				loops += next
				break
			if(next)
				found += next
	if(!loops.len)
		return
	for(var/z in loops)
		var/datum/space_level/level = space_levels[z]
		level.SetUp(null)
		level.SetDown(null)
		if(struct_by_z[z])
			var/datum/world_struct/struct = struct_by_z[z]
			struct.Deconstruct()
			qdel(struct)
	stack_trace("WARNING: Up/Down loops found in zlevels [english_list(loops)]. This is not allowed and will cause both falling and zcopy to infinitely loop. All zlevels involved have been disconnected, and any structs involved have been destroyed.")
	RebuildVerticality()

/**
 * Gets the list of Z indices on the same horizontal plane as a zlevel in a world_struct
 *
 * Returns list(itself) if not in struct
 */
/datum/controller/subsystem/mapping/proc/LevelsInPlane(z)
	if(!struct_by_z[z])
		return list(z)
	var/datum/world_struct/struct = struct_by_z[z]
	return struct.plane_lookup[struct.real_indices.Find(z)]

/**
 * Gets the full list of Z indices in the same world_struct as another z level
 *
 * Returns list(itself) if not in struct
 */
/datum/controller/subsystem/mapping/proc/LevelsInStruct(z)
	if(!struct_by_z[z])
		return list(z)
	return struct_by_z[z].real_indices

/**
 * Rebuilds world struct lookup
 */
/datum/controller/subsystem/mapping/proc/RebuildStructLookup()
	struct_by_z = list()
	struct_by_z.len = world.maxz
	for(var/datum/world_struct/struct as anything in structs)
		for(var/z in struct.real_indices)
			struct_by_z[z] = struct

/**
 * Get a coordinate set of list(x, y, z) of virtual coordinates for an atom.
 *
 * Note: Z should be interpreted as DEPTH here, not real sector Z. Every world_struct starts at z = 1.
 * Also, x, y, and z can all be negative here.
 */
/datum/controller/subsystem/mapping/proc/GetVirtualCoords(atom/A)
	A = get_turf(A)
	if(!struct_by_z[A.z])
		return list(A.x, A.y, A.z)
	var/datum/world_struct/struct = struct_by_z[A.z]
	var/datum/space_level/S = space_levels[A.z]
	return list((S.struct_x * world.maxx) + A.x , (S.struct_y * world.maxy) + A.y, S.struct_z)

/**
 * Get virtual distance between two atoms
 *
 * If the atoms aren't in managed space, acts ilke get_dist
 *
 * z_dist refers to the distance that zlevels count for - defaults to the z_canonical_dist of a struct, or 0 otherwise.
 *
 * Returns -1 for unreachable,
 * If A is in managed and B isn't, or vice versa,
 * OR if they both aren't and they aren't the same zlevel,
 * Or if they both are and aren't in the same struct.
 */
/datum/controller/subsystem/mapping/proc/GetVirtualDist(atom/A, atom/B, z_dist)
	A = get_turf(A)
	B = get_turf(B)
	if(A.z == B.z)
		return get_dist(A, B)
	if(!IsManagedLevel(A) || !IsManagedLevel(B))
		return -1
	if(struct_by_z[A.z] != struct_by_z[B.z])
		return -1
	var/datum/space_level/S1 = space_levels[A.z]
	var/datum/space_level/S2 = space_levels[B.z]
	return sqrt(((S2.struct_x * world.maxx + B.x) - (S1.struct_x * world.maxx + A.x)) ** 2 + ((S2.struct_y * world.maxy + B.y) - (S1.struct_y * world.maxy + A.y)) ** 2 + ((S2.struct_z - S1.struct_z) * z_dist) ** 2)

/**
 * Gets virual direction between two atoms
 *
 * If the atoms aren't in managed space, acts like get_dir_multiz - works on zstacks only or same level.
 *
 * Returns NONE for unreachable,
 * if A is in managed space and B isn't or vice versa,
 * OR if they both aren't and aren't in the same zlevel or zstack,
 * OR if hey both are and aren't in the same struct
 */
/datum/controller/subsystem/mapping/proc/GetVirtualDir(atom/A, atom/B)
	A = get_turf(A)
	B = get_turf(B)
	if(A.z == B.z)
		return get_dir(A, B)
	if(!IsManagedLevel(A) || !IsManagedLevel(B))
		// last ditch - check stacks
		var/list/stack = z_stack_lookup
		var/pos = stack.Find(B.z)
		if(!pos)
			return NONE		// couldn't find
		// found, old get_dir_multiz
		. = get_dir(A, B)
		if(stack.Find(A.z) < pos)
			. |= UP
		else
			. |= DOWN
		return
	if(struct_by_z[A.z] != struct_by_z[B.z])
		return NONE
	var/datum/space_level/S1 = space_levels[A.z]
	var/datum/space_level/S2 = space_levels[B.z]
	. = NONE
	if(S1.struct_z > S2.struct_z)
		. |= DOWN
	else if(S1.struct_z < S2.struct_z)
		. |= UP
	if(S1.struct_x == S2.struct_x)
		return . | (S1.struct_y > S2.struct_y? SOUTH : NORTH)
	else if(S1.struct_y == S2.struct_y)
		return . | (S1.struct_x > S2.struct_x? WEST : EAST)
	else
		. |= (S1.struct_y > S2.struct_y)? SOUTH : NORTH
		. |= (S1.struct_x > S2.struct_x)? WEST : EAST

/**
 * Gets virual angle between two angles in horizontal terms
 * IGNORES STRUCT Z DEPTH!
 *
 * If the atoms aren't in managed space, acts like GetAngle
 *
 * Returns null for unreachable,
 * if A is in managed space and B isn't or vice versa,
 * OR if they both aren't and aren't in the same zlevel,
 * OR if hey both are and aren't in the same struct
 */
/datum/controller/subsystem/mapping/proc/GetVirtualAngle(atom/A, atom/B)
	A = get_turf(A)
	B = get_turf(B)
	if(A.z == B.z)
		return get_physics_angle(A, B)
	if(!IsManagedLevel(A) || !IsManagedLevel(B))
		return null
	if(struct_by_z[A.z] != struct_by_z[B.z])
		return null
	var/datum/space_level/S1 = space_levels[A.z]
	var/datum/space_level/S2 = space_levels[B.z]
	return get_angle_direct(S1.struct_x * world.maxx + A.x, S1.struct_y * world.maxy + A.y, S2.struct_x * world.maxx + B.x, S2.struct_y * world.maxy + B.y)

/**
 * GAME PROC: GetAccessibleLevels()
 * Default implementation of bidirectionally accessible Zlevels
 *
 * Three behaviors:
 * If a zlevel is crosslinked, all crosslinked zlevels are returned
 * Otherwise, if a zlevel is in a world_struct, all levels in said world struct are returned
 * Otherwise, the zstack is returned.
 */
/datum/controller/subsystem/mapping/proc/GetAccessibleLevels(z, allow_crosslink = TRUE)
	var/datum/space_level/L = space_levels[z]
	if(L.struct)
		. = LevelsInStruct(z)
	. = GetZStack(z)
	if(allow_crosslink && (L.linkage_mode == Z_LINKAGE_CROSSLINKED))
		. |= GetCrosslinked()

/**
 * GAME PROC: IsManagedLevel(z)
 * Checks if we should use GetVirtualCoords or similar for things like GPSes, radios
 *
 * Returns TRUE if:
 * z is in a world_struct
 */
/datum/controller/subsystem/mapping/proc/IsManagedLevel(z)
	if(struct_by_z[z])
		return TRUE
	return FALSE

/**
 * Get logical step in dir
 */
/datum/controller/subsystem/mapping/proc/GetVirtualStep(atom/A, dir)
	#warn impl also make sure border is 2 from edge aka 1 from edge is hte teleport loc
