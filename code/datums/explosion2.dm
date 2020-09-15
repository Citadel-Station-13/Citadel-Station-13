/// Creates a wave explosion at a certain place
/proc/explosion2(turf/target, power, factor = 0.95, constant = 3.5, flash = 0, fire = 0, bypass_logging = FALSE)
	if(!istype(target) || (power <= EXPLOSION_POWER_DEAD))
		return
	if(!bypass_logging)
		var/logstring = "Wave explosion at [COORD(target)]: [power]/[factor]/[constant]/[flash]/[fire] initial/factor/constant/flash/fire"
		log_game(logstring)
		message_admins(logstring)
	new /datum/explosion2(target, power, factor, constant)

/**
  * New force-blastwave explosion system
  */
/datum/explosion2
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
	/// Current index for list
	var/index = 0

/datum/explosion2/New(turf/initial, power, factor = EXPLOSION_DEFAULT_FALLOFF_MULTIPLY, constant = EXPLOSION_DEFAULT_FALLOFF_SUBTRACT, flash, fire)
	id = ++next_id
	if(next_id > SHORT_REAL_LIMIT)
		next_id = 0
	SSexplosions.wave_explosions += src
	src.power_initial = power
	src.power_falloff_factor = factor
	src.power_falloff_constant = constant
	src.flash_range = flash
	src.fire_probability = fire
	if(istype(initial))
		start(initial)
	else
		stack_trace("Wave explosion created without a turf. This better be for debugging purposes.")

/datum/explosion2/Destroy()
	if(running)
		stop(FALSE)
	return ..()

/datum/explosion2/proc/start(turf/starting)
	exploding[starting] = power_initial
	if(!cycle)
		cycle = 1
	SSexplosions.active_wave_explosions += src
	running = TRUE
	tick()
	// Flash mobs
	if(flash_range)
		for(var/mob/living/L in viewers(flash_range, starting))
			L.flash_act()

/datum/explosion2/proc/stop(delete = TRUE)
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
  */
/datum/explosion2/proc/tick()
	if(++index > length(exploding))
		if(!length(exploding_next))
			finished = TRUE
			stop(TRUE)
			return
		// shift everything down
		exploding_last = exploding
		exploding = exploding_next
		exploding_dirs = exploding_next_dirs
		exploding_next = list()
		exploding_next_dirs = list()
		cycle++
		index = 1
	var/turf/victim = exploding[index]
	var/current_power = exploding[victim]
	var/new_power = round((victim.wave_ex_act(current_power, src, exploding_dirs[victim]) * power_falloff_factor) - power_falloff_constant, EXPLOSION_POWER_QUANTIZATION_ACCURACY)
	if(new_power < power_considered_dead)
		return
	var/vx = victim.x
	var/vy = victim.y
	var/vz = victim.z
	var/turf/expanding
#define RUN(xmod, ymod, dir) expanding=locate(vx+xmod,vy+ymod,vz);if(!exploding[expanding] && !exploding_last[expanding]){exploding_next[expanding]=max((exploding_next[expanding]+new_power)*0.5,new_power);exploding_next_dirs[expanding]=dir;}
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

/*
/datum/explosion/New(atom/epicenter, devastation_range, heavy_impact_range, light_impact_range, flash_range, adminlog, ignorecap, flame_range, silent, smoke)
	set waitfor = FALSE


	// Archive the uncapped explosion for the doppler array
	var/orig_dev_range = devastation_range
	var/orig_heavy_range = heavy_impact_range
	var/orig_light_range = light_impact_range

	var/orig_max_distance = max(devastation_range, heavy_impact_range, light_impact_range, flash_range, flame_range)

	//Zlevel specific bomb cap multiplier
	var/cap_multiplier = SSmapping.level_trait(epicenter.z, ZTRAIT_BOMBCAP_MULTIPLIER)
	if (isnull(cap_multiplier))
		cap_multiplier = 1

	if(!ignorecap)
		devastation_range = min(GLOB.MAX_EX_DEVESTATION_RANGE * cap_multiplier, devastation_range)
		heavy_impact_range = min(GLOB.MAX_EX_HEAVY_RANGE * cap_multiplier, heavy_impact_range)
		light_impact_range = min(GLOB.MAX_EX_LIGHT_RANGE * cap_multiplier, light_impact_range)

	var/max_range = max(devastation_range, heavy_impact_range, light_impact_range, flame_range)

	var/x0 = epicenter.x
	var/y0 = epicenter.y
	var/z0 = epicenter.z
	var/area/areatype = get_area(epicenter)
	SSblackbox.record_feedback("associative", "explosion", 1, list("dev" = devastation_range, "heavy" = heavy_impact_range, "light" = light_impact_range, "flash" = flash_range, "flame" = flame_range, "orig_dev" = orig_dev_range, "orig_heavy" = orig_heavy_range, "orig_light" = orig_light_range, "x" = x0, "y" = y0, "z" = z0, "area" = areatype.type, "time" = TIME_STAMP("YYYY-MM-DD hh:mm:ss", 1)))

	// Play sounds; we want sounds to be different depending on distance so we will manually do it ourselves.
	// Stereo users will also hear the direction of the explosion!

	// Calculate far explosion sound range. Only allow the sound effect for heavy/devastating explosions.
	// 3/7/14 will calculate to 80 + 35

	var/far_dist = 0
	far_dist += heavy_impact_range * 5
	far_dist += devastation_range * 20

	if(!silent)
		var/frequency = get_rand_frequency()
		var/sound/explosion_sound = sound(get_sfx("explosion"))
		var/sound/far_explosion_sound = sound('sound/effects/explosionfar.ogg')

		for(var/mob/M in GLOB.player_list)
			// Double check for client
			var/turf/M_turf = get_turf(M)
			if(M_turf && M_turf.z == z0)
				var/dist = get_dist(M_turf, epicenter)
				var/baseshakeamount
				if(orig_max_distance - dist > 0)
					baseshakeamount = sqrt((orig_max_distance - dist)*0.1)
				// If inside the blast radius + world.view - 2
				if(dist <= round(max_range + world.view - 2, 1))
					M.playsound_local(epicenter, null, 100, 1, frequency, falloff = 5, S = explosion_sound)
					if(baseshakeamount > 0)
						shake_camera(M, 25, clamp(baseshakeamount, 0, 10))
				// You hear a far explosion if you're outside the blast radius. Small bombs shouldn't be heard all over the station.
				else if(dist <= far_dist)
					var/far_volume = clamp(far_dist, 30, 50) // Volume is based on explosion size and dist
					far_volume += (dist <= far_dist * 0.5 ? 50 : 0) // add 50 volume if the mob is pretty close to the explosion
					M.playsound_local(epicenter, null, far_volume, 1, frequency, falloff = 5, S = far_explosion_sound)
					if(baseshakeamount > 0)
						shake_camera(M, 10, clamp(baseshakeamount*0.25, 0, 2.5))
			EX_PREPROCESS_CHECK_TICK

	if(heavy_impact_range > 1)
		var/datum/effect_system/explosion/E
		if(smoke)
			E = new /datum/effect_system/explosion/smoke
		else
			E = new
		E.set_up(epicenter)
		E.start()

		if(reactionary)
			var/turf/Trajectory = T
			while(Trajectory != epicenter)
				Trajectory = get_step_towards(Trajectory, epicenter)
				dist += cached_exp_block[Trajectory]

		var/flame_dist = dist < flame_range
		var/throw_dist = dist

		if(dist < devastation_range)
			dist = EXPLODE_DEVASTATE
		else if(dist < heavy_impact_range)
			dist = EXPLODE_HEAVY
		else if(dist < light_impact_range)
			dist = EXPLODE_LIGHT
		else
			dist = EXPLODE_NONE

		//------- EX_ACT AND TURF FIRES -------

		if((T == epicenter) && !QDELETED(explosion_source) && ismovable(explosion_source) && (get_turf(explosion_source) == T)) // Ensures explosives detonating from bags trigger other explosives in that bag
			var/list/atoms = list()
			for(var/atom/A in explosion_source.loc)		// the ismovableatom check 2 lines above makes sure we don't nuke an /area
				atoms += A
			for(var/i in atoms)
				var/atom/A = i
				if(!QDELETED(A))
					A.ex_act(dist)

		if(flame_dist && prob(40) && !isspaceturf(T) && !T.density)
			new /obj/effect/hotspot(T) //Mostly for ambience!

		if(dist > EXPLODE_NONE)
			T.explosion_level = max(T.explosion_level, dist)	//let the bigger one have it
			T.explosion_id = id
			T.ex_act(dist)
			exploded_this_tick += T

		//--- THROW ITEMS AROUND ---

		var/throw_dir = get_dir(epicenter,T)
		for(var/obj/item/I in T)
			if(!I.anchored)
				var/throw_range = rand(throw_dist, max_range)
				var/turf/throw_at = get_ranged_target_turf(I, throw_dir, throw_range)
				I.throw_speed = EXPLOSION_THROW_SPEED //Temporarily change their throw_speed for embedding purposes (Reset when it finishes throwing, regardless of hitting anything)
				I.throw_at(throw_at, throw_range, EXPLOSION_THROW_SPEED)

		//wait for the lists to repop
		var/break_condition
		if(reactionary)
			//If we've caught up to the density checker thread and there are no more turfs to process
			break_condition = iteration == expBlockLen && iteration < affTurfLen
		else
			//If we've caught up to the turf gathering thread and it's still running
			break_condition = iteration == affTurfLen && !stopped

	if(running)	//if we aren't in a hurry
		//Machines which report explosions.
		for(var/array in GLOB.doppler_arrays)
			var/obj/machinery/doppler_array/A = array
			A.sense_explosion(epicenter, devastation_range, heavy_impact_range, light_impact_range, took,orig_dev_range, orig_heavy_range, orig_light_range)

	++stopped
	qdel(src)
*/
