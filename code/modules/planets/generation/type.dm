/**
 * Planet generation - type
 *
 * Represents a type of planet
 */
/datum/planet_type
	/// name
	var/name = "Unknown Planet Type"
	/// desc
	var/desc = "A coder screwed up if you can see this."
	/// read only - number of zlevels we have
	var/level_count = 1
	/// count of disjoint areas
	var/disjoint_logical_zones = 1
	/// READ ONLY - Generated from level_zones
	VAR_PROTECTED/list/zone_levels
	///  READ ONLY - List of PLANET LEVEL INDICES, not real z-indices, to each zone
	VAR_PROTECTED/list/level_zones = list(
		1
	)
	/// Width of a zone in **ZLEVELS** at its widest plane
	VAR_PROTECTED/list/zone_widths = list(
		1
	)
	/// Height of a zone in **ZLEVELS** at its tallest plane
	VAR_PROTECTED/list/zone_heights = list(
		1
	)
	/// Level transit lookup. Each level needs to either be a blank list, or a list of TEXT_NORTH, TEXT_SOUTH, TEXT_EAST, TEXT_WEST.
	VAR_PROTECTED/list/level_transits = list(
		list()
	)
	/// Level offsets for procedural generation. List of list(x, y) indexed by level. Must be >= 0, as this is *added* to what a level grabs from a /datum/procedural_generation, which goes from 1 to width or height.
	VAR_PROTECTED/list/level_offsets = list(
		list(0, 0)
	)
	/// which logical surface is considered the planetary surface
	var/surface_zone = 1
	/// when requested, this will instantiate to a datum/procedural_generation. indiced by zone
	var/list/perlin_generators
	/// when requested, this will instantiate to a datum/procedural_generation. indiced by zone
	var/list/automata_generators
	/// list of seeds to use. will be APPENDED to the default list.
	var/list/seeds

/**
 * Get the zone index for a level index
 */
/datum/planet_type/proc/LevelToZone(index)
	ASSERT(ISINRANGE(index, 1, level_count))
	return level_zones[index]

/**
 * Gets a list of level indices for a zone
 */
/datum/planet_type/proc/ZoneToLevels(zone)
	ASSERT(ISINRANGE(zone, 1, disjoint_logical_zones))
	return zone_levels[zone]

/**
 * Gets width of a certain zone index
 */
/datum/planet_type/proc/ZoneWidth(zone)
	return zone_widths[zone] * world.maxx

/**
 * Gets height of a certain zone index
 */
/datum/planet_type/proc/ZoneHeight(zone)
	return zone_heights[zone] * world.maxy

/**
 * Regenerates level_zones lookup
 */
/datum/planet_type/proc/GenerateZoneLookup()
	zone_levels = list()
	for(var/zone in 1 to level_count)
		zone_levels += level_zones[zone]

/**
 * Gets a list() of TEXT_NORTH, TEXT_SOUTH, TEXT_EAST, TEXT_WEST associated to the level indices they should use planetary auto-transitions to
 */
/datum/planet_type/proc/LevelTransitMapping(level)
	return level_transits[level]

/**
 * Gets procedural generation x offset of a level
 */
/datum/planet_type/proc/LevelOffsetX(level)
	if(!level_offsets || level_offsets.len < level)
		return 0
	return level_offsets[level][1]

/**
 * Gets procedural generation y offset of a level
 */
/datum/planet_type/proc/LevelOffsetY(level)
	if(!level_offsets || level_offsets.len < level)
		return 0
	return level_offsets[level][2]

/datum/planet_type/New()
	if(istype(src, /datum/planet_type))
		CRASH("Abstract planet_type made")
	LAZYINITLIST(seeds)
	if(islist(seeds))
		for(var/key in seeds)
			if(!seeds[key])
				seeds[key] = GenerateUniqueSeed()
	var/list/default_seeds = list()
	for(var/i in 1 to disjoint_logical_zones)
		default_seeds["perlin_seed_[i]"] = GenerateUniqueSeed()
		default_seeds["automata_seed_[i]"] = GenerateUniqueSeed()
	GenerateZoneLookup()

/**
 * Gets a randomized, unique seed
 */
/datum/planet_type/proc/GenerateUniqueSeed()
	return md5(GUID())

/**
 * Requests a perlin generator for a level index
 */
/datum/planet_type/proc/RequestLevelPerlin(index)
	if(!islist(perlin_generators))
		perlin_generators = list()
		perlin_generators.len = disjoint_logical_zones
	var/zone = LevelToZone(index)
	if(!perlin_generators[index])
		perlin_generators[index] = new /datum/procedural_generation/perlin("seed" = seeds["perlin_seed_[zone]"])
	return automata_generators[index]

/**
 * Requests a cellular automata generator for a level index
 */
/datum/planet_type/proc/RequestLevelAutomata(index)
	if(!islist(automata_generators))
		automata_generators = list()
		automata_generators.len = disjoint_logical_zones
	var/zone = LevelToZone(index)
	if(!automata_generators[index])
		automata_generators[index] = new /datum/procedural_generation/cellular_automata("seed" = seeds["perlin_seed_[zone]"])
	return automata_generators[index]

/**
 * Generation stage 1: Called from planet datum, allocates ourselves.
 * Returns a list of ordered z_indices.
 */
/datum/planet_type/proc/Allocate(list/existing_levels, datum/planet/planet)
	var/needed = level_count
	if(!islist(existing_levels))
		. = list()
	else
		for(var/i in existing_levels)
			if(!isnum(i))
				CRASH("Invalid Z index passed into existing levels of planet_type allocation.")
		. = existing_levels.Copy()
		needed -= existing_levels.len
	if(needed < 0)
		CRASH("Too many existing levels for planet type")
	var/list/allocated = SSplanets._allocate_planetary_zlevels(needed)
	if(!allocated)
		CRASH("Failed to allocate enough zlevels")
	. |= allocated

/**
 * Generation stage 2: Called from planet datum, must already have z_indices
 * Performs biome generation.
 * Returns list of biomes that require ruin seeding.
 */
/datum/planet_type/proc/Generate(list/levels, datum/planet/planet)

/**
 * Generation stage 3: Called from planet datum, must already have z_indices.
 * Performs submap seeding.
 * Return list of biomes that require post processing (see: cavegen)
 */
/datum/planet_type/proc/Seed(list/levels, datum/planet/planet, list/datum/planet_biome/biomes)

/**
 * Generation stage 4: Called from planet datum, must already have z_indices.
 * Performs post processing if needed.
 */
/datum/planet_type/proc/Finalize(list/levels, datum/planet/planet, list/datum/planet_biome/biomes)
