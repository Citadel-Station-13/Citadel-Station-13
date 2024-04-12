//please store common type caches here.
//type caches should only be stored here if used in mutiple places or likely to be used in mutiple places.

//Note: typecache can only replace istype if you know for sure the thing is at least a datum.

GLOBAL_LIST_INIT(typecache_mob, typecacheof(/mob))

GLOBAL_LIST_INIT(typecache_living, typecacheof(/mob/living))

GLOBAL_LIST_INIT(typecache_stack, typecacheof(/obj/item/stack))

GLOBAL_LIST_INIT(typecache_machine_or_structure, typecacheof(list(/obj/machinery, /obj/structure)))

GLOBAL_LIST_INIT(freezing_objects, typecacheof(list(/obj/structure/closet/crate/freezer, /obj/structure/closet/secure_closet/freezer, /obj/structure/bodycontainer, /obj/item/autosurgeon, /obj/machinery/smartfridge/organ)))			//list of all cold objects, that freeze organs when inside

GLOBAL_LIST_EMPTY(typecaches)

/**
 * Makes a typecache of a single typecache
 * 
 * Obviously in BYOND we don't have the efficiency around here to have proper enforcement so
 * If you use this you better know what you're doing. The list you get back is globally cached and if it's modified, you might break multiple things.
 */
/proc/single_path_typecache_immutable(path)
	if(!GLOB.typecaches[path])
		GLOB.typecaches[path] = typecacheof(path)
	return GLOB.typecaches[path]
