#define STAIR_TERMINATOR_AUTOMATIC 0
#define STAIR_TERMINATOR_NO 1
#define STAIR_TERMINATOR_YES 2

// dir determines the direction of travel to go upwards (due to lack of sprites, currently only 1 and 2 make sense)
// stairs require /turf/open/openspace as the tile above them to work
// multiple stair objects can be chained together; the Z level transition will happen on the final stair object in the chain

/obj/structure/stairs
	name = "stairs"
	icon = 'icons/obj/stairs.dmi'
	icon_state = "stairs"
	anchored = TRUE

	var/force_open_above = FALSE // replaces the turf above this stair obj with /turf/open/openspace
	var/terminator_mode = STAIR_TERMINATOR_AUTOMATIC
	var/turf/listeningTo

/obj/structure/stairs/north
	dir = NORTH

/obj/structure/stairs/south
	dir = SOUTH

/obj/structure/stairs/east
	dir = EAST

/obj/structure/stairs/west
	dir = WEST

/obj/structure/stairs/Initialize(mapload)
	if(force_open_above)
		force_open_above()
		build_signal_listener()
	update_surrounding()
	return ..()

/obj/structure/stairs/Destroy()
	listeningTo = null
	return ..()

/obj/structure/stairs/Move()			//Look this should never happen but...
	. = ..()
	if(force_open_above)
		build_signal_listener()
	update_surrounding()

/obj/structure/stairs/proc/update_surrounding()
	update_icon()
	for(var/i in GLOB.cardinals)
		var/turf/T = get_step(get_turf(src), i)
		var/obj/structure/stairs/S = locate() in T
		if(S)
			S.update_icon()

/obj/structure/stairs/Uncross(atom/movable/AM, turf/newloc)
	if(!newloc || !AM)
		return ..()
	if(!isobserver(AM) && isTerminator() && (get_dir(src, newloc) == dir))
		stair_ascend(AM)
		return FALSE
	return ..()

/obj/structure/stairs/Cross(atom/movable/AM)
	if(isTerminator() && (get_dir(src, AM) == dir))
		return FALSE
	return ..()

/obj/structure/stairs/update_icon_state()
	if(isTerminator())
		icon_state = "stairs_t"
	else
		icon_state = "stairs"

/obj/structure/stairs/proc/stair_ascend(atom/movable/AM)
	var/turf/checking = get_step_multiz(src, UP)
	if(!istype(checking))
		return
	if(!checking.zPassIn(AM, UP, get_turf(src)))
		return
	var/turf/target = get_step_multiz(src, dir|UP)
	if(istype(target))
		AM.TransitForceMove(target)

/obj/structure/stairs/vv_edit_var(var_name, var_value)
	. = ..()
	if(!.)
		return
	if(var_name != NAMEOF(src, force_open_above))
		return
	if(!var_value)
		if(listeningTo)
			UnregisterSignal(listeningTo, COMSIG_TURF_UPDATE_MULTIZ)
			listeningTo = null
	else
		build_signal_listener()
		force_open_above()

/obj/structure/stairs/proc/build_signal_listener()
	if(listeningTo)
		UnregisterSignal(listeningTo, list(COMSIG_TURF_CHANGE, COMSIG_TURF_UPDATE_MULTIZ))
	var/turf/T = get_turf(src)
	var/turf/above = T.Above()
	if(!above)
		return
	RegisterSignal(above, list(COMSIG_TURF_CHANGE, COMSIG_TURF_UPDATE_MULTIZ), .proc/force_open_above)
	listeningTo = above

/obj/structure/stairs/proc/force_open_above()
	var/turf/T = get_turf(src)
	var/turf/above = T.Above()
	if(!(above.z_flags & Z_CONSIDERED_OPEN))
		above.ChangeTurf(/turf/open/openspace, flags = CHANGETURF_INHERIT_AIR)

/obj/structure/stairs/PreventZFall(atom/movable/victim, levels, fall_flags)
	. = ..()
	if(isTerminator() && levels <= 1)
		. |= FALL_TERMINATED

/obj/structure/stairs/proc/isTerminator()			//If this is the last stair in a chain and should move mobs up
	if(terminator_mode != STAIR_TERMINATOR_AUTOMATIC)
		return (terminator_mode == STAIR_TERMINATOR_YES)
	var/turf/T = get_turf(src)
	if(!T)
		return FALSE
	var/turf/them = get_step(T, dir)
	if(!them)
		return FALSE
	for(var/obj/structure/stairs/S in them)
		if(S.dir == dir)
			return FALSE
	return TRUE
