
/obj/effect/domain_expansion
	anchored = TRUE
	name = "infinite void"
	desc = "Once inside, the user's cursed techniques are improved and cannot be avoided."
	layer = FLY_LAYER
	pixel_x = -64
	pixel_y = -64
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	var/list/immune = list() // the one who creates the domain_expansion is immune, which includes wizards and the dead slime you murdered to make this chronofield
	var/turf/target
	var/freezerange = 2
	var/duration = 140
	var/datum/proximity_monitor/advanced/domain_expansion/chronofield
	alpha = 125
	var/check_anti_magic = FALSE
	var/check_holy = FALSE

/obj/effect/domain_expansion/Initialize(mapload, radius, time, list/immune_atoms, start = TRUE)	//Immune atoms assoc list atom = TRUE
	. = ..()
	if(!isnull(time))
		duration = time
	if(!isnull(radius))
		freezerange = radius
	for(var/A in immune_atoms)
		immune[A] = TRUE
	for(var/mob/living/L in GLOB.player_list)
		if(locate(/obj/effect/proc_holder/spell/aoe_turf/domain_expansion) in L.mind.spell_list) //People who can stop time are immune to its effects
			immune[L] = TRUE
	for(var/mob/living/simple_animal/hostile/guardian/G in GLOB.parasites)
		if(G.summoner && locate(/obj/effect/proc_holder/spell/aoe_turf/domain_expansion) in G.summoner.mind.spell_list) //It would only make sense that a person's stand would also be immune.
			immune[G] = TRUE
	if(start)
		INVOKE_ASYNC(src, PROC_REF(domain_expansion))

/obj/effect/domain_expansion/Destroy()
	qdel(chronofield)
	return ..()

/obj/effect/domain_expansion/proc/domain_expansion()
	target = get_turf(src)
	chronofield = make_field(/datum/proximity_monitor/advanced/domain_expansion, list("current_range" = freezerange, "host" = src, "immune" = immune, "check_anti_magic" = check_anti_magic, "check_holy" = check_holy))
	QDEL_IN(src, duration)

/obj/effect/domain_expansion/magic
	check_anti_magic = TRUE

/datum/proximity_monitor/advanced/domain_expansion
	name = "chronofield"
	setup_field_turfs = TRUE
	field_shape = FIELD_SHAPE_RADIUS_SQUARE
	requires_processing = TRUE
	var/list/immune = list()
	var/list/frozen_things = list()
	var/list/frozen_mobs = list() //cached separately for processing
	var/list/frozen_structures = list() //Also machinery, and only frozen aestethically
	var/list/frozen_turfs = list() //Only aesthetically
	var/check_anti_magic = FALSE
	var/check_holy = FALSE

	var/static/list/global_frozen_atoms = list()

/datum/proximity_monitor/advanced/domain_expansion/Destroy()
	unfreeze_all()
	return ..()

/datum/proximity_monitor/advanced/domain_expansion/field_turf_crossed(atom/movable/AM)
	freeze_atom(AM)

/datum/proximity_monitor/advanced/domain_expansion/proc/freeze_atom(atom/movable/A)
	if(immune[A] || global_frozen_atoms[A] || !istype(A))
		return FALSE
	if(ismob(A))
		var/mob/M = A
		if(M.anti_magic_check(check_anti_magic, check_holy))
			immune[A] = TRUE
			return
	var/frozen = TRUE
	if(isliving(A))
		freeze_mob(A)
	else if((ismachinery(A) && !istype(A, /obj/machinery/light)) || isstructure(A)) //Special exception for light fixtures since recoloring causes them to change light
		freeze_structure(A)
	else
		frozen = FALSE
	if(A.throwing)
		freeze_throwing(A)
		frozen = TRUE
	if(!frozen)
		return

	frozen_things[A] = A.move_resist
	A.move_resist = INFINITY
	global_frozen_atoms[A] = src
	into_the_negative_zone(A)
	RegisterSignal(A, COMSIG_MOVABLE_PRE_MOVE, PROC_REF(unfreeze_atom))
	RegisterSignal(A, COMSIG_ITEM_PICKUP, PROC_REF(unfreeze_atom))

	return TRUE

/datum/proximity_monitor/advanced/domain_expansion/proc/unfreeze_all()
	for(var/i in frozen_things)
		unfreeze_atom(i)
	for(var/T in frozen_turfs)
		unfreeze_turf(T)

/datum/proximity_monitor/advanced/domain_expansion/proc/unfreeze_atom(atom/movable/A)
	SIGNAL_HANDLER

	if(A.throwing)
		unfreeze_throwing(A)
	if(isliving(A))
		unfreeze_mob(A)

	UnregisterSignal(A, COMSIG_MOVABLE_PRE_MOVE)
	UnregisterSignal(A, COMSIG_ITEM_PICKUP)
	escape_the_negative_zone(A)
	A.move_resist = frozen_things[A]
	frozen_things -= A
	global_frozen_atoms -= A

/datum/proximity_monitor/advanced/domain_expansion/proc/freeze_throwing(atom/movable/AM)
	var/datum/thrownthing/T = AM.throwing
	T.paused = TRUE

/datum/proximity_monitor/advanced/domain_expansion/proc/unfreeze_throwing(atom/movable/AM)
	var/datum/thrownthing/T = AM.throwing
	if(T)
		T.paused = FALSE

/datum/proximity_monitor/advanced/domain_expansion/proc/freeze_turf(turf/T)
	into_the_negative_zone(T)
	frozen_turfs += T

/datum/proximity_monitor/advanced/domain_expansion/proc/unfreeze_turf(turf/T)
	escape_the_negative_zone(T)

/datum/proximity_monitor/advanced/domain_expansion/proc/freeze_structure(obj/O)
	into_the_negative_zone(O)
	frozen_structures += O

/datum/proximity_monitor/advanced/domain_expansion/proc/unfreeze_structure(obj/O)
	escape_the_negative_zone(O)

/datum/proximity_monitor/advanced/domain_expansion/process()
	for(var/i in frozen_mobs)
		var/mob/living/m = i
		m.apply_status_effect(/datum/status_effect/eldritch/void)

/datum/proximity_monitor/advanced/domain_expansion/setup_field_turf(turf/T)
	for(var/i in T.contents)
		freeze_atom(i)
	freeze_turf(T)
	return ..()

/datum/proximity_monitor/advanced/domain_expansion/proc/freeze_mob(mob/living/L)
	frozen_mobs += L
	L.add_movespeed_modifier(/datum/movespeed_modifier/status_effect/domain)

/datum/proximity_monitor/advanced/domain_expansion/proc/unfreeze_mob(mob/living/L)
	L.remove_movespeed_modifier(/datum/movespeed_modifier/status_effect/domain)
	frozen_mobs -= L

//you don't look quite right, is something the matter?
/datum/proximity_monitor/advanced/domain_expansion/proc/into_the_negative_zone(atom/A)
	A.add_atom_colour(list(-0.6,0,0,0, 0,-0.6,0,0, 0,0,-1,0, 0,0,0,1, 0.5,0.5,1,0), TEMPORARY_COLOUR_PRIORITY)

//let's put some colour back into your cheeks
/datum/proximity_monitor/advanced/domain_expansion/proc/escape_the_negative_zone(atom/A)
	A.remove_atom_colour(TEMPORARY_COLOUR_PRIORITY)
