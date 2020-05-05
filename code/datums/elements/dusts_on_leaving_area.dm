/datum/element/dusts_on_leaving_area
	element_flags = ELEMENT_DETACH | ELEMENT_BESPOKE
	id_arg_index = 2
	var/list/area_types = list()

/datum/element/dusts_on_leaving_area/Attach(datum/target,types)
	. = ..()
	if(!ismob(target))
		return ELEMENT_INCOMPATIBLE
	area_types = types
	RegisterSignal(target,COMSIG_AREA_ENTERED,.proc/check_dust)

/datum/element/dusts_on_leaving_area/Detach(mob/M)
	. = ..()
	UnregisterSignal(M,COMSIG_AREA_ENTERED)

/datum/element/dusts_on_leaving_area/proc/check_dust(area/A, mob/M)
	if(!(A.type in area_types))
		M.dust(force = TRUE)
