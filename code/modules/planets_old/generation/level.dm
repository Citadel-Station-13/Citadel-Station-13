/**
 * Planet generation - level
 *
 * Represents an entire zlevel
 */
/datum/planet_level
	/// name
	var/name = "Unknown Planet Level"
	/// desc
	var/desc = "A bugged level. You shouldn't be seeing this."

/**
 * Generation stage 2: Called from /datum/planet_type.
 * Generates a zlevel with the specified offsets and using the specified planet type, filling in biomes.
 * Should NOT do ruin seeding or post-processing like adding trees.
 * Return list of biomes to do post processing after submap seeding.
 */
/datum/planet_level/proc/Generate(zlevel, datum/planet/planet, datum/planet_type/planet_type)
	var/list/biomes = list()
	for(var/x in 1 to world.maxx)
		for(var/y in 1 to world.maxy)
			var/turf/T = locate(x, y, zlevel)
			if(!T.planetgen_eligible())
				continue
			var/datum/planet_biome/biome = ProcessTile(T, planet, planet_type, biomes)
			if(biome)
				biomes[biome.id] = TRUE
	return biomes

/**
 * Generates a single tile. Returns the biome used.
 */
/datum/planet_level/proc/ProcessTile(turf/T, datum/planet/planet, datum/planet_type/planet_type)

/**
 * Adds post-processing effects like generating caves, spawning mobs, trees, etc, to an a zlevel
 */
/datum/planet_level/proc/PostProcess(zlevel, datum/planet/planet, datum/planet_type/planet_type, list/datum/planet_biome/biomes)
