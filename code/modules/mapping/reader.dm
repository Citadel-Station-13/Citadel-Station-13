///////////////////////////////////////////////////////////////
//SS13 Optimized Map loader
//////////////////////////////////////////////////////////////
/*
 * Notes:
 * This does NOT support map files where more than one Z is in each grid set, as defined in the file.
 * MultiZ map files ARE supported (however very much discouraged), as long as each gridset only contains one z.
 * This assumes that for the most part, map files are properly formed, either DMM or TGM standard formats. If you feed it bad data, expect to crash.
 */
#define SPACE_KEY "space"

/datum/grid_set
	var/xcrd
	var/ycrd
	var/zcrd
	var/gridLines

/datum/grid_set/proc/height(key_len)
	return length(gridLines)

/datum/grid_set/proc/width(key_len)
	return gridLines[1] / key_len

/datum/parsed_map
	var/original_path
	var/key_len = 0
	var/list/grid_models = list()
	var/list/gridSets = list()

	var/list/modelCache

	/// Unoffset bounds. Null on parse failure.
	var/list/parsed_bounds
	var/width
	var/height
	/// Offset bounds. Same as parsed_bounds until load().
	var/list/bounds

	var/datum/map_template/template_host

	// raw strings used to represent regexes more accurately
	// '' used to avoid confusing syntax highlighting
	var/static/regex/dmmRegex = new(@'"([a-zA-Z]+)" = \(((?:.|\n)*?)\)\n(?!\t)|\((\d+),(\d+),(\d+)\) = \{"([a-zA-Z\n]*)"\}', "g")
	var/static/regex/trimQuotesRegex = new(@'^[\s\n]+"?|"?[\s\n]+$|^"|"$', "g")
	var/static/regex/trimRegex = new(@'^[\s\n]+|[\s\n]+$', "g")

	#ifdef TESTING
	var/turfsSkipped = 0
	#endif

/// Shortcut function to parse a map and apply it to the world.
///
/// - `dmm_file`: A .dmm file to load (Required).
/// - `x_offset`, `y_offset`, `z_offset`: Positions representign where to load the map (Optional).
/// - `cropMap`: When true, the map will be cropped to fit the existing world dimensions (Optional).
/// - `measureOnly`: When true, no changes will be made to the world (Optional).
/// - `no_changeturf`: When true, [turf/AfterChange] won't be called on loaded turfs
/// - `x_lower`, `x_upper`, `y_lower`, `y_upper`: Coordinates (relative to the game world) to crop to (Optional).
/// - `placeOnTop`: Whether to use [turf/PlaceOnTop] rather than [turf/ChangeTurf] (Optional).
/proc/load_map(
	dmm_file as file,
	x_offset as num,
	y_offset as num,
	z_offset as num,
	cropMap as num,
	measureOnly as num,
	no_changeturf as num,
	x_lower = -INFINITY as num,
	x_upper = INFINITY as num,
	y_lower = -INFINITY as num,
	y_upper = INFINITY as num,
	placeOnTop = FALSE as num,
	orientation = SOUTH as num,
	annihilate_tiles = FALSE,
	crop_relative_to_game_world = TRUE
	)
	var/datum/parsed_map/parsed = new(dmm_file, measureOnly = measureOnly)
	if(parsed.bounds && !measureOnly)
		parsed.load(x_offset, y_offset, z_offset, cropMap, no_changeturf, x_lower, x_upper, y_lower, y_upper, placeOnTop, orientation, annihilate_tiles)
	return parsed

/**
  * Parse a map, possibly cropping it.
  * Do not use the crop function unless strictly necessary.
  * WARNING: Crop function crops based on the tiles you'd see in the map editor. If you're planning to load it in in a different orientation later, you better have done the math.
  * It's recommended that you do not crop using this at all.
  */
/datum/parsed_map/New(tfile, x_lower = -INFINITY, x_upper = INFINITY, y_lower = -INFINITY, y_upper = INFINITY, z_lower = -INFINITY, z_upper = INFINITY, measureOnly = FALSE)
	_parse(tfile, x_lower, x_upper, y_lower, y_upper, z_lower, z_upper, measureOnly)

/datum/parsed_map/proc/_parse(tfile, x_lower, x_upper, y_lower, y_upper, z_lower, z_upper, measureOnly)
	var/static/parsing = FALSE
	UNTIL(!parsing)
	// do not multithread this or bad things happen
	parsing = TRUE
	_do_parse(tfile, x_lower, x_upper, y_lower, y_upper, z_lower, z_upper, measureOnly)
	parsing = FALSE

/datum/parsed_map/proc/_do_parse(tfile, x_lower, x_upper, y_lower, y_upper, z_lower, z_upper, measureOnly)
	if(isfile(tfile))
		original_path = "[tfile]"
		tfile = file2text(tfile)
	else if(isnull(tfile))
		// create a new datum without loading a map
		return
	bounds = parsed_bounds = list(1.#INF, 1.#INF, 1.#INF, -1.#INF, -1.#INF, -1.#INF)
	ASSERT(x_upper >= x_lower)
	ASSERT(y_upper >= y_lower)
	ASSERT(z_upper >= z_lower)
	var/stored_index = 1

	//multiz lool
	while(dmmRegex.Find(tfile, stored_index))
		stored_index = dmmRegex.next

		// "aa" = (/type{vars=blah})
		if(dmmRegex.group[1]) // Model
			var/key = dmmRegex.group[1]
			if(grid_models[key]) // Duplicate model keys are ignored in DMMs
				continue
			if(key_len != length(key))
				if(!key_len)
					key_len = length(key)
				else
					CRASH("Inconsistent key length in DMM")
			if(!measureOnly)
				grid_models[key] = dmmRegex.group[2]

		// (1,1,1) = {"aaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"}
		else if(dmmRegex.group[3]) // Coords
			if(!key_len)
				CRASH("Coords before model definition in DMM")

			// NOTE: We are assuming each coordset only contains one z.
			var/curr_z = text2num(dmmRegex.group[5])
			if(curr_z < z_lower || curr_z > z_upper)
				continue
						
			var/curr_x = text2num(dmmRegex.group[3])
			var/curr_y = text2num(dmmRegex.group[4])

			var/datum/grid_set/gridSet = new

			gridSet.xcrd = curr_x
			gridSet.ycrd = curr_y
			gridSet.zcrd = curr_z

			var/list/gridLines = splittext(dmmRegex.group[6], "\n")
			gridSet.gridLines = gridLines

			var/leadingBlanks = 0
			while(leadingBlanks < gridLines.len && gridLines[++leadingBlanks] == "")
			if(leadingBlanks > 1)
				gridLines.Cut(1, leadingBlanks) // Remove all leading blank lines.

			var/lines = length(gridLines)
			if(lines && gridLines[lines] == "")
				// remove one trailing blank line
				gridLines.len--
				lines--
			// y crop
			var/right_length = y_upper - curr_y + 1
			if(lines > right_length)
				lines = gridLines.len = right_length
			if(!lines)			// blank
				continue

			var/width = length(gridLines[1]) / key_len
			// x crop
			var/right_width = x_upper - curr_x + 1
			if(width > right_width)
				for(var/i in 1 to lines)
					gridLines[i] = copytext(gridLines[i], 1, key_len * right_width)
			
			// during the actual load we're starting at the top and working our way down
			gridSet.ycrd += lines - 1

			// Safe to proceed, commit gridset to list and record coords.
			gridSets += gridSet
			bounds[MAP_MINX] = min(bounds[MAP_MINX], curr_x)
			bounds[MAP_MAXX] = max(bounds[MAP_MAXX], curr_x + width - 1)
			bounds[MAP_MINY] = min(bounds[MAP_MINY], curr_y)
			bounds[MAP_MAXY] = max(bounds[MAP_MAXY], curr_y + lines - 1)
			bounds[MAP_MINZ] = min(bounds[MAP_MINZ], curr_z)
			bounds[MAP_MAXZ] = max(bounds[MAP_MAXZ], curr_z)
		CHECK_TICK

	// Indicate failure to parse any coordinates by nulling bounds
	if(bounds[1] == 1.#INF)
		bounds = null
	else
		width = bounds[MAP_MAXX] - bounds[MAP_MINX] + 1
		height = bounds[MAP_MAXY] - bounds[MAP_MINY] + 1
	parsed_bounds = bounds

/datum/parsed_map/Destroy()
	if(template_host && template_host.cached_map == src)
		template_host.cached_map = null
	. = ..()
	return QDEL_HINT_HARDDEL_NOW

/// Load the parsed map into the world. See [/proc/load_map] for arguments.
/datum/parsed_map/proc/load(x_offset, y_offset, z_offset, cropMap, no_changeturf, x_lower, x_upper, y_lower, y_upper, placeOnTop, orientation, annihilate_tiles, datum/map_orientation_pattern/forced_pattern)
	//How I wish for RAII
	Master.StartLoadingMap()
	. = _load_impl(x_offset, y_offset, z_offset, cropMap, no_changeturf, x_lower, x_upper, y_lower, y_upper, placeOnTop, orientation, annihilate_tiles, forced_pattern)
	Master.StopLoadingMap()

// Do not call except via load() above.
// Lower/upper here refers to the actual map template's parsed coordinates, NOT ACTUAL COORDINATES! Figure it out yourself my head hurts too much to implement that too.
/datum/parsed_map/proc/_load_impl(x_offset = 1, y_offset = 1, z_offset = world.maxz + 1, cropMap = FALSE, no_changeturf = FALSE, x_lower = -INFINITY, x_upper = INFINITY, y_lower = -INFINITY, y_upper = INFINITY, placeOnTop = FALSE, orientation = SOUTH, annihilate_tiles = FALSE, datum/map_orientation_pattern/forced_pattern)
	var/list/areaCache = list()
	var/list/modelCache = build_cache(no_changeturf)
	var/space_key = modelCache[SPACE_KEY]
	var/list/bounds
	var/did_expand = FALSE
	src.bounds = bounds = list(1.#INF, 1.#INF, 1.#INF, -1.#INF, -1.#INF, -1.#INF)
	var/datum/map_orientation_pattern/mode = forced_pattern || GLOB.map_orientation_patterns["[orientation]"] || GLOB.map_orientation_patterns["[SOUTH]"]
	var/invert_y = mode.invert_y
	var/invert_x = mode.invert_x
	var/swap_xy = mode.swap_xy
	var/xi = mode.xi
	var/yi = mode.yi
	var/turn_angle = round(SIMPLIFY_DEGREES(mode.turn_angle), 90)
	var/delta_swap = x_offset - y_offset
	// less checks later
	var/do_crop = x_lower > -INFINITY || x_upper < INFINITY || y_lower > -INFINITY || y_upper < INFINITY

	for(var/__I in gridSets)
		var/datum/grid_set/gridset = __I
		var/parsed_z = gridset.zcrd + z_offset - 1
		var/zexpansion = parsed_z > world.maxz
		if(zexpansion)
			if(cropMap)
				continue
			else
				while(parsed_z > world.maxz)
					world.incrementMaxZ()
					did_expand = TRUE
			if(!no_changeturf)
				WARNING("Z-level expansion occurred without no_changeturf set, this may cause problems when /turf/AfterChange is called")
		//these values are the same until a new gridset is reached.
		var/edge_dist_x = gridset.xcrd - 1											//from left side, 0 is right on the x_offset
		var/edge_dist_y = gridset.ycrd - length(gridset.gridLines)					//from bottom, 0 is right on the y_offset
		var/actual_x_starting = invert_x? (x_offset + width - edge_dist_x - 1) : (x_offset + edge_dist_x)		//this value is not changed, cache.
		//this value is changed
		var/actual_y = invert_y? (y_offset + edge_dist_y) : (y_offset + gridset.ycrd - 1)
		for(var/line in gridset.gridLines)
			var/actual_x = actual_x_starting
			for(var/pos = 1 to (length(line) - key_len + 1) step key_len)
				var/placement_x = swap_xy? (actual_y + delta_swap) : actual_x
				var/placement_y = swap_xy? (actual_x - delta_swap) : actual_y
				if(do_crop && ((placement_x < x_lower) || (placement_x > x_upper) || (placement_y < y_lower) || (placement_y > y_upper)))
					continue
				if(placement_x > world.maxx)
					if(cropMap)
						actual_x += xi
						continue
					else
						world.maxx = placement_x
						did_expand = TRUE
				if(placement_y > world.maxy)
					if(cropMap)
						break
					else
						world.maxy = placement_y
						did_expand = TRUE
				if(placement_x < 1)
					actual_x += xi
					continue
				if(placement_y < 1)
					break
				var/model_key = copytext(line, pos, pos + key_len)
				var/no_afterchange = no_changeturf || zexpansion
				if(!no_afterchange || (model_key != space_key))
					var/list/cache = modelCache[model_key]
					if(!cache)
						CRASH("Undefined model key in DMM: [model_key]")
					build_coordinate(areaCache, cache, locate(placement_x, placement_y, parsed_z), no_afterchange, placeOnTop, turn_angle, annihilate_tiles, swap_xy, invert_y, invert_x)

					// only bother with bounds that actually exist
					bounds[MAP_MINX] = min(bounds[MAP_MINX], placement_x)
					bounds[MAP_MINY] = min(bounds[MAP_MINY], placement_y)
					bounds[MAP_MINZ] = min(bounds[MAP_MINZ], parsed_z)
					bounds[MAP_MAXX] = max(bounds[MAP_MAXX], placement_x)
					bounds[MAP_MAXY] = max(bounds[MAP_MAXY], placement_y)
					bounds[MAP_MAXZ] = max(bounds[MAP_MAXZ], parsed_z)
				#ifdef TESTING
				else
					++turfsSkipped
				#endif
				actual_x += xi
				CHECK_TICK
			actual_y += yi
			CHECK_TICK

	if(!no_changeturf)
		for(var/t in block(locate(bounds[MAP_MINX], bounds[MAP_MINY], bounds[MAP_MINZ]), locate(bounds[MAP_MAXX], bounds[MAP_MAXY], bounds[MAP_MAXZ])))
			var/turf/T = t
			//we do this after we load everything in. if we don't; we'll have weird atmos bugs regarding atmos adjacent turfs
			T.AfterChange(CHANGETURF_IGNORE_AIR)

	#ifdef TESTING
	if(turfsSkipped)
		testing("Skipped loading [turfsSkipped] default turfs")
	#endif

	if(did_expand)
		world.refresh_atmos_grid()

	return TRUE

/datum/parsed_map/proc/build_cache(no_changeturf, bad_paths=null)
	if(modelCache && !bad_paths)
		return modelCache
	. = modelCache = list()
	var/list/grid_models = src.grid_models
	for(var/model_key in grid_models)
		var/model = grid_models[model_key]
		var/list/members = list() //will contain all members (paths) in model (in our example : /turf/unsimulated/wall and /area/mine/explored)
		var/list/members_attributes = list() //will contain lists filled with corresponding variables, if any (in our example : list(icon_state = "rock") and list())

		/////////////////////////////////////////////////////////
		//Constructing members and corresponding variables lists
		////////////////////////////////////////////////////////

		var/index = 1
		var/old_position = 1
		var/dpos

		while(dpos != 0)
			//finding next member (e.g /turf/unsimulated/wall{icon_state = "rock"} or /area/mine/explored)
			dpos = find_next_delimiter_position(model, old_position, ",", "{", "}") //find next delimiter (comma here) that's not within {...}

			var/full_def = trim_text(copytext(model, old_position, dpos)) //full definition, e.g : /obj/foo/bar{variables=derp}
			var/variables_start = findtext(full_def, "{")
			var/path_text = trim_text(copytext(full_def, 1, variables_start))
			var/atom_def = text2path(path_text) //path definition, e.g /obj/foo/bar
			if(dpos)
				old_position = dpos + length(model[dpos])

			if(!ispath(atom_def, /atom)) // Skip the item if the path does not exist.  Fix your crap, mappers!
				if(bad_paths)
					LAZYOR(bad_paths[path_text], model_key)
				continue
			members.Add(atom_def)

			//transform the variables in text format into a list (e.g {var1="derp"; var2; var3=7} => list(var1="derp", var2, var3=7))
			var/list/fields = list()

			if(variables_start)//if there's any variable
				full_def = copytext(full_def, variables_start + length(full_def[variables_start]), -length(copytext_char(full_def, -1))) //removing the last '}'
				fields = readlist(full_def, ";")
				if(fields.len)
					if(!trim(fields[fields.len]))
						--fields.len
					for(var/I in fields)
						var/value = fields[I]
						if(istext(value))
							fields[I] = apply_text_macros(value)

			//then fill the members_attributes list with the corresponding variables
			members_attributes.len++
			members_attributes[index++] = fields

			CHECK_TICK

		//check and see if we can just skip this turf
		//So you don't have to understand this horrid statement, we can do this if
		// 1. no_changeturf is set
		// 2. the space_key isn't set yet
		// 3. there are exactly 2 members
		// 4. with no attributes
		// 5. and the members are world.turf and world.area
		// Basically, if we find an entry like this: "XXX" = (/turf/default, /area/default)
		// We can skip calling this proc every time we see XXX
		if(no_changeturf \
			&& !(.[SPACE_KEY]) \
			&& members.len == 2 \
			&& members_attributes.len == 2 \
			&& length(members_attributes[1]) == 0 \
			&& length(members_attributes[2]) == 0 \
			&& (world.area in members) \
			&& (world.turf in members))

			.[SPACE_KEY] = model_key
			continue


		.[model_key] = list(members, members_attributes)

/datum/parsed_map/proc/build_coordinate(list/areaCache, list/model, turf/crds, no_changeturf as num, placeOnTop as num, turn_angle as num, annihilate_tiles = FALSE, swap_xy, invert_y, invert_x)
	var/index
	var/list/members = model[1]
	var/list/members_attributes = model[2]

	////////////////
	//Instanciation
	////////////////

	//The next part of the code assumes there's ALWAYS an /area AND a /turf on a given tile
	//first instance the /area and remove it from the members list
	index = members.len
	if(annihilate_tiles && crds)
		crds.empty(null)
	if(members[index] != /area/template_noop)
		var/atype = members[index]
		world.preloader_setup(members_attributes[index], atype)//preloader for assigning  set variables on atom creation
		var/atom/instance = areaCache[atype]
		if (!instance)
			instance = GLOB.areas_by_type[atype]
			if (!instance)
				instance = new atype(null)
			areaCache[atype] = instance
		if(crds)
			instance.contents.Add(crds)

		if(GLOB.use_preloader && instance)
			world.preloader_load(instance)

	//then instance the /turf and, if multiple tiles are presents, simulates the DMM underlays piling effect

	var/first_turf_index = 1
	while(!ispath(members[first_turf_index], /turf)) //find first /turf object in members
		first_turf_index++

	//turn off base new Initialization until the whole thing is loaded
	SSatoms.map_loader_begin()
	//instanciate the first /turf
	var/turf/T
	if(members[first_turf_index] != /turf/template_noop)
		T = instance_atom(members[first_turf_index],members_attributes[first_turf_index],crds,no_changeturf,placeOnTop,turn_angle, swap_xy, invert_y, invert_x)

	if(T)
		//if others /turf are presents, simulates the underlays piling effect
		index = first_turf_index + 1
		while(index <= members.len - 1) // Last item is an /area
			var/underlay = T.appearance
			T = instance_atom(members[index],members_attributes[index],crds,no_changeturf,placeOnTop,turn_angle, swap_xy, invert_y, invert_x)//instance new turf
			T.underlays += underlay
			index++

	//finally instance all remainings objects/mobs
	for(index in 1 to first_turf_index-1)
		instance_atom(members[index],members_attributes[index],crds,no_changeturf,placeOnTop,turn_angle, swap_xy, invert_y, invert_x)
	//Restore initialization to the previous value
	SSatoms.map_loader_stop()

////////////////
//Helpers procs
////////////////

//Instance an atom at (x,y,z) and gives it the variables in attributes
/datum/parsed_map/proc/instance_atom(path,list/attributes, turf/crds, no_changeturf, placeOnTop, turn_angle = 0, swap_xy, invert_y, invert_x)
	world.preloader_setup(attributes, path, turn_angle, invert_x, invert_y, swap_xy)

	if(crds)
		if(ispath(path, /turf))
			if(placeOnTop)
				. = crds.PlaceOnTop(null, path, CHANGETURF_DEFER_CHANGE | (no_changeturf ? CHANGETURF_SKIP : NONE))
			else if(!no_changeturf)
				. = crds.ChangeTurf(path, null, CHANGETURF_DEFER_CHANGE)
			else
				. = create_atom(path, crds)//first preloader pass
		else
			. = create_atom(path, crds)//first preloader pass

	if(GLOB.use_preloader && .)//second preloader pass, for those atoms that don't ..() in New()
		world.preloader_load(.)

	//custom CHECK_TICK here because we don't want things created while we're sleeping to not initialize
	if(TICK_CHECK)
		SSatoms.map_loader_stop()
		stoplag()
		SSatoms.map_loader_begin()

/datum/parsed_map/proc/create_atom(path, crds)
	set waitfor = FALSE
	. = new path (crds)

//text trimming (both directions) helper proc
//optionally removes quotes before and after the text (for variable name)
/datum/parsed_map/proc/trim_text(what as text,trim_quotes=0)
	if(trim_quotes)
		return trimQuotesRegex.Replace(what, "")
	else
		return trimRegex.Replace(what, "")


//find the position of the next delimiter,skipping whatever is comprised between opening_escape and closing_escape
//returns 0 if reached the last delimiter
/datum/parsed_map/proc/find_next_delimiter_position(text as text,initial_position as num, delimiter=",",opening_escape="\"",closing_escape="\"")
	var/position = initial_position
	var/next_delimiter = findtext(text,delimiter,position,0)
	var/next_opening = findtext(text,opening_escape,position,0)

	while((next_opening != 0) && (next_opening < next_delimiter))
		position = findtext(text,closing_escape,next_opening + 1,0)+1
		next_delimiter = findtext(text,delimiter,position,0)
		next_opening = findtext(text,opening_escape,position,0)

	return next_delimiter


//build a list from variables in text form (e.g {var1="derp"; var2; var3=7} => list(var1="derp", var2, var3=7))
//return the filled list
/datum/parsed_map/proc/readlist(text as text, delimiter=",")
	. = list()
	if (!text)
		return

	var/position
	var/old_position = 1

	while(position != 0)
		// find next delimiter that is not within  "..."
		position = find_next_delimiter_position(text,old_position,delimiter)

		// check if this is a simple variable (as in list(var1, var2)) or an associative one (as in list(var1="foo",var2=7))
		var/equal_position = findtext(text,"=",old_position, position)

		var/trim_left = trim_text(copytext(text,old_position,(equal_position ? equal_position : position)))
		var/left_constant = delimiter == ";" ? trim_left : parse_constant(trim_left)
		if(position)
			old_position = position + length(text[position])

		if(equal_position && !isnum(left_constant))
			// Associative var, so do the association.
			// Note that numbers cannot be keys - the RHS is dropped if so.
			var/trim_right = trim_text(copytext(text, equal_position + length(text[equal_position]), position))
			var/right_constant = parse_constant(trim_right)
			.[left_constant] = right_constant

		else  // simple var
			. += list(left_constant)

/datum/parsed_map/proc/parse_constant(text)
	// number
	var/num = text2num(text)
	if(isnum(num))
		return num

	// string
	if(text[1] == "\"")
		return copytext(text, length(text[1]) + 1, findtext(text, "\"", length(text[1]) + 1))

	// list
	if(copytext(text, 1, 6) == "list(")//6 == length("list(") + 1
		return readlist(copytext(text, 6, -1))

	// typepath
	var/path = text2path(text)
	if(ispath(path))
		return path

	// file
	if(text[1] == "'")
		return file(copytext_char(text, 2, -1))

	// null
	if(text == "null")
		return null

	// not parsed:
	// - pops: /obj{name="foo"}
	// - new(), newlist(), icon(), matrix(), sound()

	// fallback: string
	return text

/datum/parsed_map/vv_edit_var(var_name, var_value)
	if(var_name == NAMEOF(src, dmmRegex) || var_name == NAMEOF(src, trimQuotesRegex) || var_name == NAMEOF(src, trimRegex))
		return FALSE
	return ..()
