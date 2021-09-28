PROCESSING_SUBSYSTEM_DEF(planets)
	name = "Planets"
	wait = 1 SECONDS
	init_order = INIT_ORDER_PLANETS
	fire_priority = FIRE_PRIORITY_PLANETS

	/// all planets
	var/list/datum/planet/planets
	/// zlevel to planet lookup for fast access - z = planet datum
	var/list/z_to_planet
	/// planet to zlevels lookup for fast access - planet datum = list(zs)
	var/list/planet_to_z
	/// biome lookup by id
	var/list/biomes_by_id
	/// theme lookup by id
	var/list/themes_by_id

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

/datum/controller/subsystem/processing/planets/Initialize()
	init_biomes()
	init_themes()
	regenerate_z_tables()
	return ..()

/datum/controller/subsystem/processing/planets/Recover()
	. = ..()
	if(!SSplanets)
		return
	// recover planets if possible
	LAZYINITLIST(planets)
	planets |= SSplanets.planets

	// generate biomes and themes
	init_biomes()
	init_themes()

	// overwrite with old if conflicting and existing
	biomes_by_id |= SSplanets.biomes_by_id
	themes_by_id |= SSplanets.themes_by_id

	// regenerate lookup tables
	regenerate_z_tables()
