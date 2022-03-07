/datum/controller/subsystem/mapping

/**
 * Handles generating whatever map_type the station map is
 */
/datum/controller/subsystem/mapping/proc/PerformMapGeneration()
#ifdef LOWMEMORYMODE
	return
#endif
	switch(map.maptype)
		if(MAP_TYPE_STATION)
			// Create space ruin levels
			while (space_levels_so_far < map.space_ruin_levels)
				++space_levels_so_far
				var/datum/space_level/L = new
				L.linkage_mode = Z_LINKAGE_CROSSLINKED
				L.name = "Empty Area [space_levels_so_far]"
				InstantiateMapLevel(L, null, FALSE)
			// and one level with no ruins
			for (var/i in 1 to map.space_empty_levels)
				++space_levels_so_far
				var/datum/space_level/L = new
				L.linkage_mode = Z_LINKAGE_CROSSLINKED
				L.name = "Empty Area [space_levels_so_far]"
				InstantiateMapLevel(L, null, FALSE)

			RebuildVerticality()
			RebuildTransitions()
			RebuildCrosslinking()

			// Generate mining ruins
			loading_ruins = TRUE
			var/list/lava_ruins = LevelsByTrait(ZTRAIT_LAVA_RUINS)
			if (lava_ruins.len)
				seedRuins(lava_ruins, CONFIG_GET(number/lavaland_budget), list(/area/lavaland/surface/outdoors/unexplored), lava_ruins_templates)
				for (var/lava_z in lava_ruins)
					spawn_rivers(lava_z)

			var/list/ice_ruins = LevelsByTrait(ZTRAIT_ICE_RUINS)
			if (ice_ruins.len)
				// needs to be whitelisted for underground too so place_below ruins work
				seedRuins(ice_ruins, CONFIG_GET(number/icemoon_budget), list(/area/icemoon/surface/outdoors/unexplored, /area/icemoon/underground/unexplored), ice_ruins_templates)
				for (var/ice_z in ice_ruins)
					spawn_rivers(ice_z, 4, /turf/open/openspace/icemoon, /area/icemoon/surface/outdoors/unexplored/rivers)

			var/list/ice_ruins_underground = LevelsByTrait(ZTRAIT_ICE_RUINS_UNDERGROUND)
			if (ice_ruins_underground.len)
				seedRuins(ice_ruins_underground, CONFIG_GET(number/icemoon_budget), list(/area/icemoon/underground/unexplored), ice_ruins_underground_templates)
				for (var/ice_z in ice_ruins_underground)
					spawn_rivers(ice_z, 4, GetBaseturf(ice_z), /area/icemoon/underground/unexplored/rivers)

			// Generate deep space ruins
			var/list/space_ruins = LevelsByTrait(ZTRAIT_SPACE_RUINS)
			if (space_ruins.len)
				seedRuins(space_ruins, CONFIG_GET(number/space_budget), list(/area/space), space_ruins_templates)

			// Generate station space ruins
			var/list/station_ruins = LevelsByTrait(ZTRAIT_STATION)
			if (station_ruins.len)
				seedRuins(station_ruins, (SSmapping.map.station_ruin_budget < 0) ? CONFIG_GET(number/station_space_budget) : SSmapping.map.station_ruin_budget, list(/area/space/station_ruins), station_ruins_templates)
			SSmapping.seedStation()

			loading_ruins = FALSE
	// Run map generation after ruin generation to prevent issues
	run_map_generation()

/datum/controller/subsystem/mapping/proc/run_map_generation()
	for(var/area/A in world)
		A.RunGeneration()

///Initialize all biomes, assoc as type || instance
/datum/controller/subsystem/mapping/proc/initialize_biomes()
	for(var/biome_path in subtypesof(/datum/biome))
		var/datum/biome/biome_instance = new biome_path()
		biomes[biome_path] += biome_instance

/datum/controller/subsystem/mapping/proc/seedStation()
	for(var/V in GLOB.stationroom_landmarks)
		var/obj/effect/landmark/stationroom/LM = V
		LM.load()
	if(GLOB.stationroom_landmarks.len)
		seedStation() //I'm sure we can trust everyone not to insert a 1x1 rooms which loads a landmark which loads a landmark which loads a la...

