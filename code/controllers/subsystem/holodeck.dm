SUBSYSTEM_DEF(holodeck)
	name = "Holodeck"
	init_order = INIT_ORDER_HOLODECK
	flags = SS_NO_FIRE
	var/list/program_cache = list() //list of safe holodeck programs.
	var/list/emag_program_cache = list() //like above, but dangerous.
	var/list/offline_programs = list() //default when offline.
	var/list/target_holodeck_area = list()
	var/list/rejected_areas = list()

/datum/controller/subsystem/holodeck/Initialize()
	. = ..()
	//generates the list of available holodeck programs.
	for(var/path in subtypesof(/datum/holodeck_cache))
		new path
	for(var/path in typesof(/obj/machinery/computer/holodeck)) //The istances will be handled by SSatoms.
		var/obj/machinery/computer/holodeck/H = path
		offline_programs[path] = pop(get_areas(initial(H.offline_program)), FALSE)
		target_holodeck_area[path] = pop(get_areas(initial(H.holodeck_type)), FALSE)


 /*
  * The sole scope of this datum is to generate lists of holodeck programs caches per holodeck computer type.
  */

/datum/holodeck_cache
	var/area/holodeck/master_type //the /area/holodeck typepath we'll be using for typesof loop.
	var/skip_types //Areas that won't be added to the global list category.
	var/list/compatible_holodeck_comps //list of typepaths of holodeck computers that can access this category.

/datum/holodeck_cache/New()
	if(!master_type || !compatible_holodeck_comps)
		return
	var/list/to_add = typesof(master_type) - skip_types
	var/list/programs
	var/list/emag_programs
	for(var/typekey in to_add)
		var/area/holodeck/A = GLOB.areas_by_type[typekey]
		if(!A || !A.contents.len)
			LAZYOR(SSholodeck.rejected_areas[typekey], compatible_holodeck_comps)
			continue
		var/list/info_this = list("name" = A.name, "type" = A.type)
		if(A.restricted)
			LAZYADD(emag_programs, list(info_this))
		else
			LAZYADD(programs, list(info_this))
	for(var/comp in compatible_holodeck_comps)
		if(programs)
			LAZYADD(SSholodeck.program_cache[comp], programs)
		if(emag_programs)
			LAZYADD(SSholodeck.emag_program_cache[comp], emag_programs)

/datum/holodeck_cache/standard
	master_type = /area/holodeck/rec_center
	skip_types = /area/holodeck/rec_center
	compatible_holodeck_comps = list(/obj/machinery/computer/holodeck)
