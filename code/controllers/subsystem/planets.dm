/**
 * Planets subsystem
 * Holds data and ticks planets
 *
 * Does NOT control planet zlevel allocation or hold submaps.
 * That is the job of SSmapping.
 */
SUBSYSTEM_DEF(planets)
	name = "Planets"
	wait = 1 SECONDS
	init_order = INIT_ORDER_PLANETS
	fire_priority = FIRE_PRIORITY_PLANETS
	flags = SS_BACKGROUND | SS_NO_TICK_CHECK

	/// all planets
	var/list/datum/planet/planets
	/// active planets - these tick
	var/list/datum/planet/active
	/// zlevel to planet lookup for fast access - z = planet datum
	var/list/z_to_planet
	/// planet to zlevels lookup for fast access - planet datum = list(zs)
	var/list/planet_to_z
	/// biome lookup by id
	var/list/biomes_by_id
	/// theme lookup by id
	var/list/themes_by_id

	/// Total zlevels instantiated so far
	var/static/planet_zlevel_count = 0
	/// Maximum safe zlevels - will never go past this when instantiating planets. For 255x255, 25-30 is safe under LAA. For 140x140, we could probably get away with 80 on LAA.
	var/static/planet_zlevel_limit = 30

	/**
	 * Why do we store by ID?
	 * GC purposes.
	 * We can store the ID to look up without referencing, and without making more than one
	 * of a given thing.
	 *
	 * Things stored by ID:
	 * Biomes
	 * Themes
	 *
	 * Things NOT stored by ID:
	 * Planets - randomly generated - they'll have an UID but not be stored by this for the most part
	 * Weather - per-planet for performance as they can then be stateful
	 */

	/// planet time update interval in per-cycles
	var/cycles_update_time = 1
	/// planet weather update interval in per-cycles
	var/cycles_update_weather = 30
	/// planet weather tick interval in cycles for fast-actions
	var/cycles_tick_weather_fast = 10
	/// planet weather tick interval in cycles for slow-actions
	var/cycles_tick_weather_slow = 30
	/// planet lighting update per-cycles
	var/cycles_update_lighting = 60

/datum/controller/subsystem/planets/Initialize()
	init_biomes()
	init_themes()
	regenerate_z_tables()
	return ..()

/datum/controller/subsystem/planets/Recover()
	. = ..()
	if(!SSplanets)
		return
	// recover planets if possible
	LAZYINITLIST(planets)
	LAZYINITLIST(active)
	planets |= SSplanets.planets
	active |= SSplanets.active

	// generate biomes and themes
	init_biomes()
	init_themes()

	// overwrite with old if conflicting and existing
	biomes_by_id |= SSplanets.biomes_by_id
	themes_by_id |= SSplanets.themes_by_id

	// regenerate lookup tables
	regenerate_z_tables()

/datum/controller/subsystem/planets/fire(resumed)
	var/dt = (flags & SS_TICKER)? wait * world.tick_lag * 0.1 : wait * 0.1
	for(var/datum/planet/P as anything in active)
		if(times_fired % cycles_update_time)
			P.UpdateTime(dt)
		if(times_fired % cycles_update_weather)
			P.UpdateWeather(dt)
		if(times_fired % cycles_tick_weather_fast)
			P.FastWeatherTick(dt)
		if(times_fired % cycles_tick_weather_slow)
			P.SlowWeatherTick(dt)
		if(times_fired % cycles_update_lighting)
			P.UpdateLighting(dt)
