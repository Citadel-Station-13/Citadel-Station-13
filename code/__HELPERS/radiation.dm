// A special GetAllContents that doesn't search past things with rad insulation
// Components which return COMPONENT_BLOCK_RADIATION prevent further searching into that object's contents. The object itself will get returned still.
// The ignore list makes those objects never return at all
/proc/get_rad_contents(atom/location)
	var/static/list/ignored_things = typecacheof(list(
		/mob/dead,
		/mob/camera,
		/obj/effect,
		/obj/docking_port,
		/atom/movable/lighting_object,
		/obj/item/projectile,
		))
	var/list/processing_list = list(location)
	. = list()
	var/i = 0
	var/lim = 1
	while(i < lim)
		var/atom/thing = processing_list[++i]
		if(ignored_things[thing.type])
			continue
		. += thing
		if((thing.rad_flags & RAD_PROTECT_CONTENTS) || (SEND_SIGNAL(thing, COMSIG_ATOM_RAD_PROBE) & COMPONENT_BLOCK_RADIATION))
			continue
		processing_list += thing.contents
		lim = processing_list.len

/proc/radiation_pulse(atom/source, intensity, range_modifier, log=FALSE, can_contaminate=TRUE)
	if(!SSradiation.can_fire)
		return
	var/turf/open/pool/PL = get_turf(source)
	if(istype(PL))
		if(PL.filled == TRUE)
			intensity *= 0.15
	var/area/A = get_area(source)
	var/atom/nested_loc = source.loc
	var/spawn_waves = TRUE
	while(nested_loc != A)
		if(nested_loc.rad_flags & RAD_PROTECT_CONTENTS)
			spawn_waves = FALSE
			break
		nested_loc = nested_loc.loc
	if(spawn_waves)
		for(var/dir in GLOB.cardinals)
			new /datum/radiation_wave(source, dir, intensity, range_modifier, can_contaminate)

		var/static/last_huge_pulse = 0
		if(intensity > 3000 && world.time > last_huge_pulse + 200)
			last_huge_pulse = world.time
			log = TRUE

	var/list/things = get_rad_contents(source) //copypasta because I don't want to put special code in waves to handle their origin
	for(var/k in 1 to things.len)
		var/atom/thing = things[k]
		if(!thing)
			continue
		thing.rad_act(intensity)

	if(log)
		log_game("Radiation pulse with intensity: [intensity] and range modifier: [range_modifier] in [loc_name(PL)][spawn_waves ? "" : " (contained by [nested_loc.name])"]")
	return TRUE
