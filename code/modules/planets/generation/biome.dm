/**
 * Planet generation - biomes
 *
 * Represents a single theme being used to generate an area.
 */
/datum/planet_biome
	/// unique string ID
	var/id

/datum/planet_biome/New()
	if(isnull(id))
		id = "[type]"

