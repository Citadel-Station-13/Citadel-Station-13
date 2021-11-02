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
	var/list/ordered_z_indices
	/// which level indices are considered surface
	var/list/levels_surface = list(
		1
	)
	/// ordered list of biomes used
	var/list/planet_biome/level_biomes = list(
		/datum/planet_biome/debug
	)
	/// ordered number bitflags for cardinals AND up/down - determines Z linkage
	var/list/level_linkage = list(
		NORTH|SOUTH|EAST|WEST
	}

#warn support for atmos override

#warn support for skyfall/deep chasm/etc

#warn weather

#warn lighting

/datum/planet/New()
	id = ++id_next
