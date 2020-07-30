PROCESSING_SUBSYSTEM_DEF(projectiles)
	name = "Projectiles"
	priority = FIRE_PRIORITY_PROJECTILES
	wait = 1
	stat_tag = "PP"
	flags = SS_NO_INIT|SS_TICKER
	var/global_pixel_increment_amount = 4
	var/global_projectile_speed_multiplier = 1

/datum/controller/subsystem/processing/projectiles/proc/set_pixel_speed(new_speed)
	global_pixel_increment_amount = new_speed
	for(var/i in processing)
		var/obj/item/projectile/P = i
		if(istype(P))			//there's non projectiles on this too.
			P.set_pixel_increment_amount(new_speed)

/datum/controller/subsystem/processing/projectiles/vv_edit_var(var_name, var_value)
	switch(var_name)
		if(NAMEOF(src, global_pixel_increment_amount))
			set_pixel_speed(var_value)
			return TRUE
		else
			return ..()
