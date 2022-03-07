/**
 * # World Structs
 *
 * WARNING: Advanced structure, only use if you know what you're doing
 * Used in seamless zlevel wrapping, like on Z-gridded planets
 * Needed until BYOND can natively support this.
 */
/datum/world_struct
	/// Z grid - list("x,y,z" = level). Spaces are allowed.
	var/list/z_grid
	/// Horizontally loop
	var/loop_horizontal = FALSE
	/// Vertically loop
	var/loop_vertical = FALSE
	/// Distance in meters between zlevels
	var/z_canonical_dist = 0

	// Transient variables
	/// Constructed?
	var/tmp/constructed = FALSE
	/// space_level datums in us
	var/tmp/list/datum/space_level/levels
	/// Width - x
	var/tmp/width
	/// Height - y
	var/tmp/height
	/// Depth - z
	var/tmp/depth
	/// Real zlevel indices - ordered same as levels in z_grid!
	var/tmp/list/real_indices
	/// Planes - generated at runtime, lowest to highest - lists are unordered z-indices in a plane
	var/tmp/list/planes
	/// ZStacks - generated at runtime, unordered - the lists are ordered z-indices
	var/tmp/list/stacks
	/// z plane lookup - ordered same as levels in z_grid
	var/tmp/list/plane_lookup
	/// z stack lookup - ordered same as levels in z_grid
	var/tmp/list/stack_lookup
	/// Regex
	var/static/regex/grid_parser = new(@"([\n]+),([\n)]+,([\n]+)", "g")

/datum/world_struct/Destroy()
	if(constructed)
		Deconstruct()
	return ..()

// The below code is a monstrosity.
// I am so sorry.

/datum/world_struct/proc/Construct(list/z_grid = src.z_grid, rebuild = TRUE)
	if(constructed)
		CRASH("Attempted to construct a constructed struct. This is pretty much universally a bad idea.")
	src.z_grid = z_grid
	if(!length(z_grid))
		CRASH("No zlevels")
	if(!Verify())
		CRASH("World struct failed verification")
	// determine dimensions and link + mark real zlevels
	planes = list()
	real_indices = list()
	width = 0
	height = 0
	depth = 0
	// first build x/y/z data and planes
	var/min_x
	var/min_y
	var/min_z
	var/max_x
	var/max_y
	var/max_z
	var/list/plane_cache = list()
	for(var/key in z_grid)
		var/id = z_grid[key]
		var/datum/space_level/L = SSmapping.level_by_id[id]
		real_indices += L.z_value
		grid_parser.Find(key)
		var/x = L.struct_x = text2num(grid_parser.group[1])
		var/y = L.struct_y = text2num(grid_parser.group[2])
		var/z = L.struct_z = text2num(grid_parser.group[3])
		if(!plane_cache["[z]"])
			plane_cache["[z]"] = list(z)
		else
			plane_cache["[z]"] |= z
		if(key == z_grid[1])
			min_x = max_x = x
			min_y = max_y = y
			min_z = max_z = z
		else
			min_x = min(min_x, x)
			max_x = max(max_x, x)
			min_y = min(min_y, y)
			max_y = max(max_y, y)
			min_z = min(min_z, z)
			max_z = max(max_z, z)
		var/datum/space_level/them
		var/has_up_down = FALSE
		var/has_adjacent = FALSE
		// we can build horizontals now, since they aren't as complicated
		them = _scan_dir(z_grid, x, y, z, EAST)
		if(them)
			L.SetEast(them)
			has_adjacent = TRUE
		them = _scan_dir(z_grid, x, y, z, WEST)
		if(them)
			L.SetWest(them)
			has_adjacent = TRUE
		them = _scan_dir(z_grid, x, y, z, NORTH)
		if(them)
			L.SetNorth(them)
			has_adjacent = TRUE
		them = _scan_dir(z_grid, x, y, z, SOUTH)
		if(them)
			L.SetSouth(them)
			has_adjacent = TRUE
		// build verticals too
		them = _scan_dir(z_grid, x, y, z, UP)
		if(them)
			L.SetUp(them)
			has_up_down = TRUE
		them = _scan_dir(z_grid, x, y, z, DOWN)
		if(them)
			L.SetDown(them)
			has_up_down = TRUE
		if(rebuild)
			if(has_adjacent)
				L.RebuildTransitions()
			if(has_up_down)
				L.RebuildTurfs()
	for(var/z_text in plane_cache)
		planes += plane_cache[z_text]
	width = max_x - min_x + 1
	height = max_y - min_y + 1
	depth = max_z - min_z + 1
	// now to build the vertical linkages and stacks
	// oh god this is going to be messy
	var/list/bottom_keys = get_bottom_level_keys(z_grid)
	stacks = build_stacks(z_grid, bottom_keys)
	// lastly, build plane and stack lookups
	ASSERT(real_indices.len == z_grid.len)
	plane_lookup = list()
	plane_lookup.len = real_indices.len
	for(var/i in 1 to real_indices.len)
		var/z = real_indices[i]
		var/list/found
		for(var/j in 1 to planes)
			var/list/L = planes[j]
			if(L.Find(z))
				plane_lookup[i] = L
				break
	stack_lookup = list()
	stack_lookup.len = real_indices.len
	for(var/i in 1 to real_indices.len)
		var/z = real_indices[i]
		var/list/found
		for(var/j in 1 to stacks)
			var/list/L = stacks[j]
			if(L.Find(z))
				plane_lookup[i] = L
				break
	// register
	Register()
	constructed = TRUE

/datum/world_struct/proc/build_stacks(list/z_grid, list/bottom_keys)
	. = list()
	for(var/bottom in bottom_keys)
		var/datum/space_level/B = SSmapping.level_by_id[bottom]
		var/list/constructed = list()
		do
			constructed += B.z_value
			B = _scan_dir(z_grid, B.struct_x, B.struct_y, B.struct_z, UP)
		while(B)
		. += constructed

/datum/world_struct/proc/get_bottom_level_keys(list/z_grid)
	. = list()
	var/list/possible = z_grid.Copy()
	var/list/reverse = list()
	for(var/key in z_grid)
		reverse[z_grid[key]] = key
	do
		// pop one
		var/key = possible[1]
		var/id = z_grid[key]
		var/datum/space_level/L = SSmapping.level_by_id[id]
		possible.Cut(1,2)
		grid_parser.Find(key)
		var/x = L.struct_x = text2num(grid_parser.group[1])
		var/y = L.struct_y = text2num(grid_parser.group[2])
		var/z = L.struct_z = text2num(grid_parser.group[3])
		// continually cut everything above us
		var/datum/space_level/L2 = _scan_dir(z_grid, x, y, z, UP)
		if(reverse[L2.id] in possible)
			do
				possible -= reverse[L2.id]
				L2 = _scan_dir(z_grid, L2.struct_x, L2.struct_y, L2.struct_z, UP)
			while(L2)
		// if this is bottom
		var/datum/space_level/L2 = _scan_dir(z_grid, x, y, z, DOWN)
		if(!L2)
			. += key
	while(possible.len)

/datum/world_struct/proc/_scan_dir(list/grid, x, y, z, dir)
	switch(dir)
		if(UP)
			. = grid["[x],[y],[z+1]"]
		if(DOWN)
			. = grid["[x],[y],[z-1]"]
		if(EAST)
			. = grid["[x-1],[y],[z]"]
		if(WEST)
			. = grid["[x+1],[y],[z]"]
		if(NORTH)
			. = grid["[x],[y+1],[z]"]
		if(SOUTH)
			. = grid["[x],[y-1],[z]"]
	return SSmapping.level_by_id[.]

/datum/world_struct/proc/Deconstruct(rebuild = TRUE)
	if(!constructed)
		CRASH("Tried to deconstruct a world_struct that isn't constructed.")
	for(var/datum/space_level/L as anything in levels)
		var/had_up_down = L.GetLevelInDir(UP) || L.GetLevelInDir(DOWN)
		var/had_adjacent = L.GetLevelInDir(NORTH) || L.GetLevelInDir(SOUTH) || L.GetLevelInDir(EAST) || L.GetLevelInDir(WEST)
		L.struct = null
		L.SetDown(null)
		L.SetEast(null)
		L.SetWest(null)
		L.SetSouth(null)
		L.SetNorth(null)
		L.SetUp(null)
		L.struct_x = 0
		L.struct_y = 0
		L.struct_z = 0
		if(rebuild)
			if(had_adjacent)
				INVOKE_ASYNC(L, /datum/space_level/proc/RebuildTransitions)
			if(had_up_down)
				INVOKE_ASYNC(L, /datum/space_level/proc/RebuildTurfs)
	Unregister(rebuild)
	constructed = FALSE

/datum/world_struct/proc/Register(rebuild = TRUE)
	SSmapping.structs += src
	SSmapping.z_stack_dirty = TRUE
	if(rebuild)
		SSmapping.RebuildStructLookup()
		SSmapping.RebuildVerticality()
		SSmapping.RebuildTransitions()
		SSmapping.RebuildCrosslinking()

/datum/world_struct/proc/Unregister(rebuild = TRUE)
	SSmapping.structs -= src
	SSmapping.z_stack_dirty = TRUE
	if(rebuild)
		SSmapping.RebuildStructLookup()
		SSmapping.RebuildVerticality()
		SSmapping.RebuildTransitions()
		SSmapping.RebuildCrosslinking()

/**
 * Ensures all level IDs exist as currently instantiated levels,
 * and also ensures there's no dupe keys/IDs
 */
/datum/world_struct/proc/Verify()
	. = TRUE
	var/list/keymap = list()
	var/list/idmap = list()
	for(var/key in z_grid)
		if(keymap[key])
			stack_trace("Duplicate key [key].")
			. = FALSE
		keymap[key] = TRUE
		grid_parser.Find(key)
		if(key != "[grid_parser.group[1]],[grid_parser.group[2]],[grid_parser.group[3]]")
			stack_trace("Invalid key [key].")
			. = FALSE
		var/id = z_grid[key]
		if(!SSmapping.level_by_id[id])
			stack_trace("Couldn't locate level id [id] in SSmapping level_by_id list.")
			. = FALSE
		if(SSmapping.level_by_id[id].struct)
			stack_trace("Level id [id] was already in a struct.")
			. = FALSE
		if(idmap[id])
			stack_trace("Duplicate level ID [id]")
			. = FALSE
		idmap[id] = TRUE
