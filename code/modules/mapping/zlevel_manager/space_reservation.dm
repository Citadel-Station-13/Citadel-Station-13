/**
 * Dynamic space reservation datums
 */
/datum/space_reservation
	/// List of turfs we contain
	var/list/reserved_turfs = list()
	/// Width in tiles
	var/width = 0
	/// Height in tiles
	var/height = 0
	/// Coordinate pair of bottom left
	var/bottom_left_coords[3]
	/// Coordinate pair of top right
	var/top_right_coords[3]
	/// Wipe when we released? This is a good idea in most cases.
	var/wipe_reservation_on_release = TRUE
	/// Default turf type
	var/turf_type = /turf/open/space
	/// Area type to instantiate - defaults to world.area
	var/area_type
	/// Default border turf type - defaults to turf_type
	var/borderturf

/datum/space_reservation/transit
	turf_type = /turf/open/space/transit
	borderturf = /turf/open/space/transit/border

/datum/space_reservation/proc/Release()
	SSmapping.allocated_reserve_turfs -= reserved_turfs
	SSmapping.ReserveTurfs(reserved_turfs)
	reserved_turfs.Cut()
	SSmapping.space_reservations -= src

/datum/space_reservation/transit/Release()
	for(var/turf/open/space/transit/T in reserved_turfs)
		for(var/atom/movable/AM in T)
			T.throw_atom(AM)
	. = ..()

/datum/space_reservation/proc/Reserve(width, height, zlevel)
	if(width > world.maxx || height > world.maxy || width < 1 || height < 1)
		return FALSE
	if(!area_type)
		area_type = world.area
	var/area/A = area_type
	if(initial(A.area_flags) & UNIQUE_AREA)
		A = GLOB.areas_by_type[area_type]
		if(!A)
			GLOB.areas_by_type[area_type] = new area_type
			A = GLOB.areas_by_type[area_type]
	else
		A = new area_type
	var/list/avail = SSmapping.free_reserve_turfs["[zlevel]"]
	var/turf/BL
	var/turf/TR
	var/list/turf/final = list()
	var/passing = FALSE
	for(var/i in avail)
		CHECK_TICK
		BL = i
		if(!(BL.flags_1 & UNUSED_RESERVATION_TURF_1))
			continue
		if(BL.x + width > world.maxx || BL.y + height > world.maxy)
			continue
		TR = locate(BL.x + width - 1, BL.y + height - 1, BL.z)
		if(!(TR.flags_1 & UNUSED_RESERVATION_TURF_1))
			continue
		final = block(BL, TR)
		if(!final)
			continue
		passing = TRUE
		for(var/I in final)
			var/turf/checking = I
			if(!(checking.flags_1 & UNUSED_RESERVATION_TURF_1))
				passing = FALSE
				break
		if(!passing)
			continue
		break
	if(!passing || !istype(BL) || !istype(TR))
		return FALSE
	bottom_left_coords = list(BL.x, BL.y, BL.z)
	top_right_coords = list(TR.x, TR.y, TR.z)
	for(var/i in final)
		var/turf/T = i
		reserved_turfs |= T
		T.flags_1 &= ~UNUSED_RESERVATION_TURF_1
		SSmapping.free_reserve_turfs["[T.z]"] -= T
		SSmapping.allocated_reserve_turfs[T] = src
		if(borderturf && (T.x == BL.x || T.x == TR.x || T.y == BL.y || T.y == TR.y))
			T.ChangeTurf(borderturf, borderturf)
		else
			T.ChangeTurf(turf_type, turf_type)
		A.contents += T
	src.width = width
	src.height = height
	LAZYADD(SSmapping.space_reservations, src)
	return TRUE

/datum/space_reservation/Destroy()
	Release()
	return ..()
