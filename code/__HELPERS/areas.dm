#define BP_MAX_ROOM_SIZE 300

// Gets an atmos isolated contained space
// Returns an associative list of turf|dirs pairs
// The dirs are connected turfs in the same space
// break_if_found is a typecache of turf types to return false if found
/proc/detect_room(turf/origin, list/break_if_found)
	if(origin.blocks_air)
		return list(origin)

	. = list()
	var/list/checked_turfs = list()
	var/list/found_turfs = list(origin)
	while(found_turfs.len)
		var/turf/sourceT = found_turfs[1]
		if(break_if_found[sourceT.type])
			return FALSE
		found_turfs.Cut(1, 2)
		var/dir_flags = checked_turfs[sourceT]
		for(var/dir in GLOB.alldirs)
			if(dir_flags & dir) // This means we've checked this dir before, probably from the other turf
				continue
			var/turf/checkT = get_step(sourceT, dir)
			if(!checkT)
				continue
			checked_turfs[sourceT] |= dir
			checked_turfs[checkT] |= turn(dir, 180)
			.[sourceT] |= dir
			.[checkT] |= turn(dir, 180)
			var/static/list/cardinal_cache = list("[NORTH]"=TRUE, "[EAST]"=TRUE, "[SOUTH]"=TRUE, "[WEST]"=TRUE)
			if(!cardinal_cache["[dir]"] || checkT.blocks_air || !CANATMOSPASS(sourceT, checkT))
				continue
			found_turfs += checkT // Since checkT is connected, add it to the list to be processed

/proc/create_area(mob/creator)
	var/static/blacklisted_turfs = typecacheof(/turf/open/space)
	var/static/blacklisted_areas = typecacheof(/area/space)
	var/list/turfs = detect_room(get_turf(creator), blacklisted_turfs)
	if(!turfs)
		to_chat(creator, "<span class='warning'>The new area must be completely airtight.</span>")
		return
	if(turfs.len > BP_MAX_ROOM_SIZE)
		to_chat(creator, "<span class='warning'>The room you're in is too big. It is [((turfs.len / BP_MAX_ROOM_SIZE)-1)*100]% larger than allowed.</span>")
		return
	// This will fuck up shuttles that use the base area type but we need to fix those anyway
	var/list/areas = list("New Area" = /area, "New Shuttle Area" = /area/shuttle/custom)
	for(var/i in 1 to turfs.len)
		var/area/place = get_area(turfs[i])
		if(blacklisted_areas[place.type])
			continue
		areas[place.name] = place
	var/area_choice = input(creator, "Choose an area to expand or make a new area.", "Area Expansion") as null|anything in areas
	area_choice = areas[area_choice]

	if(!area_choice)
		to_chat(creator, "<span class='warning'>No choice selected. The area remains undefined.</span>")
		return
	var/area/newA
	var/area/oldA = get_area(get_turf(creator))
	if(!isarea(area_choice))
		var/str = trim(stripped_input(creator,"New area name:", "Blueprint Editing", "", MAX_NAME_LEN))
		if(!str || !length(str)) //cancel
			return
		if(length(str) > 50)
			to_chat(creator, "<span class='warning'>The given name is too long. The area remains undefined.</span>")
			return
		newA = new area_choice
		newA.setup(str)
		newA.set_dynamic_lighting()
		newA.has_gravity = oldA.has_gravity
	else
		newA = area_choice

	for(var/i in 1 to turfs.len)
		var/turf/thing = turfs[i]
		var/area/old_area = thing.loc
		newA.contents += thing
		thing.change_area(old_area, newA)

	var/list/related_areas = oldA.related
	for(var/i in 1 to related_areas.len)
		var/area/place = related_areas[i]
		var/list/firedoors = place.firedoors
		if(!LAZYLEN(firedoors))
			continue
		for(var/k in 1 to firedoors.len)
			var/obj/machinery/door/firedoor/FD = firedoors[k]
			FD.CalculateAffectingAreas()

	to_chat(creator, "<span class='notice'>You have created a new area, named [newA.name]. It is now weather proof, and constructing an APC will allow it to be powered.</span>")
	return TRUE

#undef BP_MAX_ROOM_SIZE