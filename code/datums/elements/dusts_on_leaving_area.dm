/datum/element/dusts_on_leaving_area
	element_flags = ELEMENT_DETACH | ELEMENT_BESPOKE
	id_arg_index = 2
	var/list/attached_mobs = list()
	var/list/area_types = list()

/datum/element/dusts_on_leaving_area/Attach(datum/target,types)
	. = ..()
	if(!ismob(target))
		return ELEMENT_INCOMPATIBLE
	attached_mobs += target
	area_types = types
	START_PROCESSING(SSprocessing,src)

/datum/element/dusts_on_leaving_area/Detach(mob/M)
	. = ..()
	if(M in attached_mobs)
		attached_mobs -= M
	if(!attached_mobs.len)
		STOP_PROCESSING(SSprocessing,src)

/datum/element/dusts_on_leaving_area/process()
	for(var/m in attached_mobs)
		var/mob/M = m
		var/area/A = get_area(M)
		if(!(A.type in area_types))
			M.dust(force = TRUE)
			Detach(M)
