//Builds networks like power cables/atmos lines/etc
//Just a holder parent type for now..
/obj/effect/mapping_helpers/network_builder
	/// set var to true to not del on lateload
	var/custom_spawned = FALSE

	icon = 'icons/effects/mapping_helpers.dmi'

	late = TRUE
	/// what directions we know connections are in
	var/list/network_directions = list()

/obj/effect/mapping_helpers/network_builder/Initialize(mapload)
	. = ..()
	var/conflict = check_duplicates()
	if(conflict)
		stack_trace("WARNING: [type] network building helper found check_duplicates() conflict [conflict] in its location.!")
		return INITIALIZE_HINT_QDEL
	if(!mapload)
		if(GLOB.Debug2)
			custom_spawned = TRUE
			return INITIALIZE_HINT_NORMAL
		else
			return INITIALIZE_HINT_QDEL
	return INITIALIZE_HINT_LATELOAD

/// How this works: On LateInitialize, detect all directions that this should be applicable to, and do what it needs to do, and then inform all network builders in said directions that it's been around since it won't be around afterwards.
/obj/effect/mapping_helpers/network_builder/LateInitialize()
	scan_directions()
	build_network()
	if(!custom_spawned)
		qdel(src)

/obj/effect/mapping_helpers/network_builder/proc/check_duplicates()
	CRASH("Base abstract network builder tried to check duplicates.")

/obj/effect/mapping_helpers/network_builder/proc/scan_directions()
	CRASH("Base abstract network builder tried to scan directions.")

/obj/effect/mapping_helpers/network_builder/proc/build_network()
	CRASH("Base abstract network builder tried to build network.")
