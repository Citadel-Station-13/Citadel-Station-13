/**
 * Planet datums
 */
/datum/planet
	// basic data
	/// name
	var/name
	/// desc
	var/desc
	/// uid
	var/id
	/// uid next
	var/static/id_next = 0

	// generation
	/// are we instantiated
	var/instantiated = FALSE
	/// level count
	var/levels = 1
	/// post-instantiation - will have ordered z list of our levels
	var/list/z_levels
	/// which level indices are considered surface
	var/list/surface_levels = list(
		1
	)
	/// ordered list of biomes used
	var/list/planet_biome/level_biomes = list(
		/datum/planet_biome/debug
	)


#warn weather

#warn lighting

/datum/planet/New()
	id = ++id_next
