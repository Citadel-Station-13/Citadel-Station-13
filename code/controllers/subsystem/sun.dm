#define OCCLUSION_DISTANCE 20

/datum/sun
	var/azimuth = 0 // clockwise, top-down rotation from 0 (north) to 359
	var/power_mod = 1 // how much power this sun is outputting relative to standard


/datum/sun/vv_edit_var(var_name, var_value)
	. = ..()
	if(var_name == NAMEOF(src, azimuth))
		SSsun.complete_movement()

/atom/proc/check_obscured(datum/sun/sun, distance = OCCLUSION_DISTANCE)
	var/target_x = round(sin(sun.azimuth), 0.01)
	var/target_y = round(cos(sun.azimuth), 0.01)
	var/x_hit = x
	var/y_hit = y
	var/turf/hit

	for(var/run in 1 to distance)
		x_hit += target_x
		y_hit += target_y
		hit = locate(round(x_hit, 1), round(y_hit, 1), z)
		if(hit.opacity)
			return TRUE
		if(hit.x == 1 || hit.x == world.maxx || hit.y == 1 || hit.y == world.maxy) //edge of the map
			break
	return FALSE

SUBSYSTEM_DEF(sun)
	name = "Sun"
	wait = 1 MINUTES
	flags = SS_NO_TICK_CHECK

	var/list/datum/sun/suns = list()
	var/datum/sun/primary_sun
	var/azimuth_mod = 1 ///multiplier against base_rotation
	var/base_rotation = 6 ///base rotation in degrees per fire

/datum/controller/subsystem/sun/Initialize(start_timeofday)
	primary_sun = new
	suns += primary_sun
	primary_sun.azimuth = rand(0, 359)
	azimuth_mod = round(rand(50, 200)/100, 0.01) // 50% - 200% of standard rotation
	if(prob(50))
		azimuth_mod *= -1
	return ..()

/datum/controller/subsystem/sun/fire(resumed = FALSE)
	for(var/S in suns)
		var/datum/sun/sun = S
		sun.azimuth += azimuth_mod * base_rotation
		sun.azimuth = round(sun.azimuth, 0.01)
		if(sun.azimuth >= 360)
			sun.azimuth -= 360
		if(sun.azimuth < 0)
			sun.azimuth += 360
	complete_movement()

/datum/controller/subsystem/sun/proc/complete_movement()
	SEND_SIGNAL(src, COMSIG_SUN_MOVED, primary_sun, suns)

#undef OCCLUSION_DISTANCE
