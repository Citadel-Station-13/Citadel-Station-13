/**
 * Submaps
 *
 * Map templates used to seed standardized areas/planets.
 */
/datum/map_template/submap
	abstract_type = /datum/map_template/submap
	prefix = "maps/submaps/"
	/// base probability
	var/base_probability = 0
	/// Spawn type - __DEFINES/maps/seeding.dm. If forced, ignores uniqueness checks
	var/spawn_type = SUBMAP_SPAWN_NORMAL
	/// What to check while spawning
	var/exclusion_mode = SUBMAP_CHECK_CENTER
	/// Possible rotations - bitfield for cardinals
	var/possible_orientations = NORTH|SOUTH|EAST|WEST
	/// ID for uniqueness check - null for no limits on how many spawns on the level
	var/group_unique_level = "default"
	/// ID for uniqueness check - null for no limits on how many spawns on a planet
	var/group_unique_planet = "default"
	/// ID for uniqueness check - null for no limits on how many spawns in the game world
	var/group_unique_global = null
	/// Biome to relative probability - leave out to prevent spawn, use ANY for any - use 0 for allowing forced spawns, otherwise 0 will prevent spawn at all
	var/list/biomes = list()
	/// Theme to relative probability - leave out to prevent spawn, use ANY for any - use 0 for allowing forced spawns, otherwise 0 will prevent spawn at all
	var/list/themes = list(PLANET_THEME_ANY = 1)

/datum/map_template/submap/New()
	. = ..()
	for(var/biome in biomes)
		if(istext(biome))
			continue
		var/prob = biomes[biome]
		biomes -= biome
		biomes["[biome]"] = prob
	for(var/theme in themes)
		if(istext(theme))
			continue
		var/prob = themes[theme]
		themes -= theme
		themes["[theme]"] = prob
		