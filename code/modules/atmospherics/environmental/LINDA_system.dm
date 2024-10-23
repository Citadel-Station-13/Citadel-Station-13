/atom/var/CanAtmosPass = ATMOS_PASS_YES
/atom/var/CanAtmosPassVertical = ATMOS_PASS_YES

/atom/proc/CanAtmosPass(turf/T)
	switch (CanAtmosPass)
		if (ATMOS_PASS_PROC)
			return ATMOS_PASS_YES
		if (ATMOS_PASS_DENSITY)
			return !density
		else
			return CanAtmosPass

/turf/CanAtmosPass = ATMOS_PASS_NO
/turf/CanAtmosPassVertical = ATMOS_PASS_NO

/turf/open/CanAtmosPass = ATMOS_PASS_PROC
/turf/open/CanAtmosPassVertical = ATMOS_PASS_PROC

/turf/open/CanAtmosPass(turf/T, vertical = FALSE)
	var/dir = vertical? get_dir_multiz(src, T) : get_dir(src, T)
	var/opp = REVERSE_DIR(dir)
	. = TRUE
	if(vertical && !(zAirOut(dir, T) && T.zAirIn(dir, src)))
		. = FALSE
	if(blocks_air || T.blocks_air)
		. = FALSE
	if (T == src)
		return .
	for(var/obj/O in contents+T.contents)
		var/turf/other = (O.loc == src ? T : src)
		if(!(vertical? (CANVERTICALATMOSPASS(O, other)) : (CANATMOSPASS(O, other))))
			. = FALSE
		if(O.BlockThermalConductivity()) 	//the direction and open/closed are already checked on CanAtmosPass() so there are no arguments
			conductivity_blocked_directions |= dir
			T.conductivity_blocked_directions |= opp
			if(!.)
				return .

/atom/movable/proc/BlockThermalConductivity() // Objects that don't let heat through.
	return FALSE

/turf/proc/ImmediateCalculateAdjacentTurfs()
	var/canpass = CANATMOSPASS(src, src)
	var/canvpass = CANVERTICALATMOSPASS(src, src)
	for(var/direction in GLOB.cardinals_multiz)
		var/turf/T = get_step_multiz(src, direction)
		if(!istype(T))
			continue
		if(isopenturf(T) && !(blocks_air || T.blocks_air) && ((direction & (UP|DOWN))? (canvpass && CANVERTICALATMOSPASS(T, src)) : (canpass && CANATMOSPASS(T, src))) )
			LAZYINITLIST(atmos_adjacent_turfs)
			LAZYINITLIST(T.atmos_adjacent_turfs)
			atmos_adjacent_turfs[T] = ATMOS_ADJACENT_ANY
			T.atmos_adjacent_turfs[src] = ATMOS_ADJACENT_ANY
		else
			if (atmos_adjacent_turfs)
				atmos_adjacent_turfs -= T
			if (T.atmos_adjacent_turfs)
				T.atmos_adjacent_turfs -= src
			UNSETEMPTY(T.atmos_adjacent_turfs)
			T.set_sleeping(T.blocks_air)
		T.__update_auxtools_turf_adjacency_info(isspaceturf(T.get_z_base_turf()), -1)
	UNSETEMPTY(atmos_adjacent_turfs)
	src.atmos_adjacent_turfs = atmos_adjacent_turfs
	for(var/t in atmos_adjacent_turfs)
		var/turf/open/T = t
		for(var/obj/machinery/door/firedoor/FD in T)
			FD.UpdateAdjacencyFlags()
	for(var/obj/machinery/door/firedoor/FD in src)
		FD.UpdateAdjacencyFlags()
	__update_auxtools_turf_adjacency_info(isspaceturf(get_z_base_turf()))

/turf/proc/set_sleeping(should_sleep)

//returns a list of adjacent turfs that can share air with this one.
//alldir includes adjacent diagonal tiles that can share
//	air with both of the related adjacent cardinal tiles
/turf/proc/GetAtmosAdjacentTurfs(alldir = 0)
	var/adjacent_turfs
	if (atmos_adjacent_turfs)
		adjacent_turfs = atmos_adjacent_turfs.Copy()
	else
		return list()		// don't bother checking diagonals, diagonals are going to be cardinal checks anyways.

	if (!alldir)
		return adjacent_turfs

	var/turf/other
	var/turf/mid
	for (var/d in GLOB.diagonals)
		other = get_step(src, d)
		if(!other)
			continue
		// NS step
		mid = get_step(src, NSCOMPONENT(d))
		if((mid in adjacent_turfs) && (get_step(mid, EWCOMPONENT(d)) in adjacent_turfs))
			adjacent_turfs += other
			continue
		// EW step
		mid = get_step(src, EWCOMPONENT(d))
		if((mid in adjacent_turfs) && (get_step(mid, NSCOMPONENT(d)) in adjacent_turfs))
			adjacent_turfs += other
			continue
	return adjacent_turfs

/atom/proc/air_update_turf(command = 0)
	if(!isturf(loc) && command)
		return
	var/turf/T = get_turf(loc)
	T.air_update_turf(command)

/turf/air_update_turf(command = 0)
	if(command)
		ImmediateCalculateAdjacentTurfs()

/atom/movable/proc/move_update_air(turf/T)
    if(isturf(T))
        T.air_update_turf(1)
    air_update_turf(1)

/atom/proc/atmos_spawn_air(text) //because a lot of people loves to copy paste awful code lets just make an easy proc to spawn your plasma fires
	var/turf/open/T = get_turf(src)
	if(!istype(T))
		return
	T.atmos_spawn_air(text)

/turf/open/atmos_spawn_air(text)
	if(!text || !air)
		return

	var/datum/gas_mixture/G = new
	G.parse_gas_string(text)
	assume_air(G)
