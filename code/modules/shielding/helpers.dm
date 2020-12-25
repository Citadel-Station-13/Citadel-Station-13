//////// HELPER FILE FOR SHIELDING /////////

// HULL SHIELD GENERATION HELPERS
/**
  * Gets hull exterior adjacent tiles of a certain area
  * Area method.
  * EXPENSIVE.
  * If the area itself is already considered exterior, it'll find all tiles inside it that's next to an interior area.
  */
/proc/hull_shielding_get_tiles_around_area(area/instance, check_tick = FALSE)
	var/list/cache = list()
	var/area/A
	if(instance.considered_hull_exterior)
		for(var/turf/potential in instance)
			for(var/turf/looking in orange(1, potential))
				A = looking.loc
				if(!A.considered_hull_exterior)
					cache[potential] = TRUE			// we're the exterior area, grab the one that's reaching out
			if(check_tick)
				CHECK_TICK
	else
		for(var/turf/potential in instance)
			for(var/turf/looking in orange(1, potential))
				A = looking.loc
				if(A.considered_hull_exterior)
					cache[looking] = TRUE			// we're not the exterior area, grab the one that's being reached to
			if(check_tick)
				CHECK_TICK
	. = list()
	for(var/i in cache)
		. += i			// strip assoc value

/**
  * Gets hull adjacent exterior tiles of an entire zlevel
  * EXPENSIVE.
  * Gets the tiles in the exterior area touching to a non-exterior area
  */
/proc/hull_shielding_get_tiles_in_z(zlevel, check_tick = FALSE, recurse = FALSE, list/outlist = list(), list/scanned_zlevels = list())
	. = outlist
	if(zlevel in scanned_zlevels)
		return
	scanned_zlevels |= zlevel
	if(recurse)
		var/up = SSmapping.level_trait(zlevel, ZTRAIT_UP)
		var/down = SSmapping.level_trait(zlevel, ZTRAIT_DOWN)
		if(isnum(up) && (up != 0))
			hull_shielding_get_tiles_in_z(up, check_tick, recurse, outlist, scanned_zlevels)
		if(isnum(down) && (down != 0))
			hull_shielding_get_tiles_in_z(down, check_tick, recurse, outlist, scanned_zlevels)
	// sigh. why.
	var/turf/potential
	var/area/p_area
	var/area/l_area
	for(var/x in 1 to world.maxx)
		for(var/y in 1 to world.maxy)
			if(check_tick)
				CHECK_TICK
			potential = locate(x, y, zlevel)	
			p_area = potential.loc
			if(!p_area.considered_hull_exterior)
				continue
			for(var/turf/looking in orange(1, potential))
				l_area = looking.loc
				if(!l_area.considered_hull_exterior)
					outlist += potential
