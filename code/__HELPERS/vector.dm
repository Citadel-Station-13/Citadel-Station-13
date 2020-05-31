// Basic geometry things.

/datum/vector/
	var/x = 0
	var/y = 0

/datum/vector/New(var/x, var/y)
	src.x = x
	src.y = y

/datum/vector/proc/duplicate()
	return new /datum/vector(x, y)

/datum/vector/proc/euclidian_norm()
	return sqrt(x*x + y*y)

/datum/vector/proc/squared_norm()
	return x*x + y*y

/datum/vector/proc/normalize()
	var/norm = euclidian_norm()
	x = x/norm
	y = y/norm
	return src

/datum/vector/proc/chebyshev_norm()
	return max(abs(x), abs(y))

/datum/vector/proc/chebyshev_normalize()
	var/norm = chebyshev_norm()
	x = x/norm
	y = y/norm
	return src

/datum/vector/proc/is_integer()
	return ISINTEGER(x) && ISINTEGER(y)

/atom/movable/proc/vector_translate(var/datum/vector/V, var/delay)
	var/turf/T = get_turf(src)
	var/turf/destination = locate(T.x + V.x, T.y + V.y, z)
	var/datum/vector/V_norm = V.duplicate()
	V_norm.chebyshev_normalize()
	if (!V_norm.is_integer())
		return
	var/turf/destination_temp
	while (destination_temp != destination)
		destination_temp = locate(T.x + V_norm.x, T.y + V_norm.y, z)
		forceMove(destination_temp)
		T = get_turf(src)
		sleep(delay + world.tick_lag) // Shortest possible time to sleep

/atom/proc/get_translated_turf(var/datum/vector/V)
	var/turf/T = get_turf(src)
	return locate(T.x + V.x, T.y + V.y, z)

/proc/atoms2vector(var/atom/A, var/atom/B)
	return new /datum/vector((B.x - A.x), (B.y - A.y)) // Vector from A -> B