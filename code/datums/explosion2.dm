/// Creates a wave explosion at a certain place
/proc/wave_explosion(turf/target, power, factor = EXPLOSION_DEFAULT_FALLOFF_MULTIPLY, constant = EXPLOSION_DEFAULT_FALLOFF_SUBTRACT, flash = 0, fire = 0, atom/source, speed = 0,
	silent = FALSE, bypass_logging = FALSE, block_resistance = 1, start_immediately = TRUE)
	if(!istype(target) || (power <= EXPLOSION_POWER_DEAD))
		return
	if(!bypass_logging)
		var/logstring = "Wave explosion at [COORD(target)]: [power]/[factor]/[constant]/[flash]/[fire]/[speed] initial/factor/constant/flash/fire/speed"
		log_game(logstring)
		message_admins(logstring)
	return new /datum/wave_explosion(target, power, factor, constant, flash, fire, source, speed, silent, start_immediately, block_resistance)

/**
  * New force-blastwave explosion system
  */
/datum/wave_explosion
	/// Next unique numerical ID
	var/static/next_id = 0
	/// Our unique nuumerical ID
	var/id
	/// world.time we started at
	var/start_time
	/// Are we currently running?
	var/running = FALSE
	/// Are we currently finished?
	var/finished = FALSE
	/// What atom we originated from, if any
	var/atom/source

	/// Explosion power at which point to consider to be a dead expansion
	var/power_considered_dead = EXPLOSION_POWER_DEAD
	/// Explosion power we were initially at
	var/power_initial
	/// Base explosion power falloff multiplier (applied first)
	var/power_falloff_factor = EXPLOSION_DEFAULT_FALLOFF_MULTIPLY
	/// Base explosion power falloff subtract (applied second)
	var/power_falloff_constant = EXPLOSION_DEFAULT_FALLOFF_SUBTRACT
	/// Flash range
	var/flash_range = 0
	/// Fire probability per tile
	var/fire_probability = 0
	/// Are we silent/do we make the screenshake/sounds?
	var/silent = FALSE

	// Modifications
	/// Object damage mod
	var/object_damage_mod = 1
	/// Hard obstcales get this mod INSTEAD of object damage mod
	var/hard_obstacle_mod = 1
	/// Window shatter mod. Overrides both [hard_obstcale_mod] and [object_damage_mod]
	var/window_shatter_mod = 1
	/// Wall destruction mod
	var/wall_destroy_mod = 1
	/// Mob damage mod
	var/mob_damage_mod = 1
	/// Mob gib mod
	var/mob_gib_mod = 1
	/// Mob deafen mod
	var/mob_deafen_mod = 1
	/// block = block / this, if 0 any block is absolute
	var/block_resistance = 1

	/// List of turfs mapped to their powers.
	var/list/turf/exploding = list()
	/// [exploding] but dirs rather than powers
	var/list/turf/exploding_dirs = list()
	/// [exploding] but for the next ring
	var/list/turf/exploding_next = list()
	/// [exploding_next] but dirs rather than powers
	var/list/turf/exploding_next_dirs = list()
	/// [exploding] but for the last ring
	var/list/turf/exploding_last = list()
	/// What cycle are we on?
	var/cycle
	/// When we started the current cycle
	var/cycle_start
	/// Time to wait between cycles
	var/cycle_speed = 0
	/// Current index for list
	var/index = 0

/datum/wave_explosion/New(turf/initial, power, factor = EXPLOSION_DEFAULT_FALLOFF_MULTIPLY, constant = EXPLOSION_DEFAULT_FALLOFF_SUBTRACT, flash = 0, fire = 0, atom/source, speed = 0, silent = FALSE, autostart = TRUE, block_resistance = 1)
	id = ++next_id
	if(next_id > SHORT_REAL_LIMIT)
		next_id = 0
	SSexplosions.wave_explosions += src
	src.power_initial = power
	src.power_falloff_factor = factor
	src.power_falloff_constant = constant
	src.flash_range = flash
	src.fire_probability = fire
	src.source = source
	src.cycle_speed = speed
	src.silent = silent
	src.block_resistance = block_resistance
	if(!istype(initial))
		stack_trace("Wave explosion created without a turf. This better be for debugging purposes.")
		return
	if(autostart)
		start(initial)

/datum/wave_explosion/Destroy()
	if(running)
		stop(FALSE)
	return ..()

/datum/wave_explosion/proc/start(turf/starting)
	exploding[starting] = power_initial

	var/x0 = starting.x
	var/y0 = starting.y
	var/z0 = starting.z
	var/area/areatype = get_area(starting)

	SSblackbox.record_feedback("associative", "wave_explosion", 1, list("power" = power_initial, factor = "factor", constant = "constant", flash = "flash", fire = "fire", speed = "speed", "x" = x0, "y" = y0, "z" = z0, "area" = areatype.type, "time" = TIME_STAMP("YYYY-MM-DD hh:mm:ss", 1)))
	if(!cycle)
		cycle = 1
	SSexplosions.active_wave_explosions += src
	running = TRUE
	cycle_start = world.time
	tick()

	// Play sounds; we want sounds to be different depending on distance so we will manually do it ourselves.
	// Stereo users will also hear the direction of the explosion!

	// Calculate far explosion sound range. Only allow the sound effect for heavy/devastating explosions.
	// 3/7/14 will calculate to 80 + 35

	var/far_dist = sqrt(power_initial) * 7.5

	if(!silent)
		var/frequency = get_rand_frequency()
		var/sound/explosion_sound = sound(get_sfx("explosion"))
		var/sound/far_explosion_sound = sound('sound/effects/explosionfar.ogg')

		for(var/mob/M in GLOB.player_list)
			// Double check for client
			var/turf/M_turf = get_turf(M)
			if(M_turf && M_turf.z == z0)
				var/dist = get_dist(M_turf, starting)
				var/baseshakeamount
				if(sqrt(power_initial) - dist > 0)
					baseshakeamount = sqrt((sqrt(power_initial) - dist)*0.1)
				// If inside the blast radius + world.view - 2
				if(dist <= round(2 * sqrt(power_initial) + world.view - 2, 1))
					M.playsound_local(starting, null, 100, 1, frequency, max_distance = 5, S = explosion_sound)
					if(baseshakeamount > 0)
						shake_camera(M, 25, clamp(baseshakeamount, 0, 10))
				// You hear a far explosion if you're outside the blast radius. Small bombs shouldn't be heard all over the station.
				else if(dist <= far_dist)
					var/far_volume = clamp(far_dist, 30, 50) // Volume is based on explosion size and dist
					far_volume += (dist <= far_dist * 0.5 ? 50 : 0) // add 50 volume if the mob is pretty close to the explosion
					M.playsound_local(starting, null, far_volume, 1, frequency, max_distance = 5, S = far_explosion_sound)
					if(baseshakeamount > 0)
						shake_camera(M, 10, clamp(baseshakeamount*0.25, 0, 2.5))

	for(var/array in GLOB.doppler_arrays)
		var/obj/machinery/doppler_array/A = array
		A.sense_wave_explosion(starting, power_initial, cycle_speed)

	// Flash mobs
	if(flash_range)
		for(var/mob/living/L in viewers(flash_range, starting))
			L.flash_act()

/datum/wave_explosion/proc/stop(delete = TRUE)
	SSexplosions.active_wave_explosions -= src
	SSexplosions.currentrun -= src
	exploding = list()
	exploding_next = list()
	exploding_last = list()
	cycle = null
	running = FALSE
	qdel(src)

/**
  * Called by SSexplosions to propagate this.
  * Return TRUE if postponed
  */
/datum/wave_explosion/proc/tick()
	if(++index > length(exploding))
		if(!length(exploding_next))
			finished = TRUE
			stop(TRUE)
			return TRUE
		if((cycle_start + cycle_speed) > world.time)		// postpone
			return TRUE
		// shift everything down
		exploding_last = exploding
		exploding = exploding_next
		exploding_dirs = exploding_next_dirs
		exploding_next = list()
		exploding_next_dirs = list()
		cycle_start = world.time
		cycle++
		index = 1
	var/turf/victim = exploding[index]
	var/current_power = exploding[victim]
	var/returned = max(0, victim.wave_explode(current_power, src, exploding_dirs[victim]))
	var/blocked = current_power - returned
	if(block_resistance <= 0)
		if(blocked > EXPLOSION_POWER_NO_RESIST_THRESHOLD)
			returned = 0
	else if(blocked > 0)
		returned = current_power - (blocked / block_resistance)
	var/new_power = round((returned * power_falloff_factor) - power_falloff_constant, EXPLOSION_POWER_QUANTIZATION_ACCURACY)
	if(new_power < power_considered_dead)
		return
	var/vx = victim.x
	var/vy = victim.y
	var/vz = victim.z
	var/turf/expanding
#define RUN(xmod, ymod, dir) expanding=locate(vx+xmod,vy+ymod,vz);if(expanding){if(!exploding[expanding] && !exploding_last[expanding]){exploding_next[expanding]=max((exploding_next[expanding]+new_power)*0.5,new_power);exploding_next_dirs[expanding]=dir;}}
	RUN(0,1,NORTH)
	RUN(1,1,NORTHEAST)
	RUN(1,0,EAST)
	RUN(1,-1,SOUTHEAST)
	RUN(0,-1,SOUTH)
	RUN(-1,-1,SOUTHWEST)
	RUN(-1,0,WEST)
	RUN(-1,1,NORTHWEST)
#undef RUN
	if(prob(fire_probability))
		new /obj/effect/hotspot(victim)
