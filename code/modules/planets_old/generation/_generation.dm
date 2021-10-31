/**
 * How generation works
 *
 * Planest generation is done in multiple passes and levels.
 *
 * Planet type - determines zlevel count, places planet levels and prepares for the next stage. Stateful.
 * Planet level - Each zlevel has one. Places planet biomes and prepares for the next stage. Stateful.
 * Planet biomes - Represents a theme of terrain generation, generates, and prepares for the next stage. Stateful.
 * Level themes - modifiers used to either weight or entirely restrict what's placed on an area.
 *
 * High level overview:
 * Abstract Instantiation:
 * - Planet is made
 * - Basic high levels (general planet type, temperature and humidity skews, size, etc) are generated
 * - Planet type datum made and populated with above
 *
 * Allocation:
 * - Zlevels are instantiated and assigned to the type
 * - Type splits zlevels into level datums, and populates the level datums (For example, 2x2 would be distinctly continuous in perlin seeding)
 * - At this point you have multiple blank (in case of new planets) or a set of blank and nonempty (for existing zlevels being put on a planet) zlevels.
 *
 * Generation/Loading:
 * - Levels do their procedural generation cycles and assigns biome data to a set of areas, which then replace existing areas valid for planetgen (full map for new levels, or marker areas and turfs for existing levels)
 * - Generation is passed down to the biomes
 * - Biomes may generate the terrain and seed ruins as they see fit
 * - Ruin seeding if done uses tags for biomes and themes to determine what to fit, as well as a budget that's passed down
 * - At this point, everything is seeded/loaded physically
 *
 * Linking:
 * - Zlevel datums are modified to link back to the level datums and planets they corrospond to
 * - Zlevel datums have their linkages set as needed
 * - Linkages are updated
 * - At this point, you have a playable map
 *
 * Effect Render
 * - Weather, lighting, etc are generated and updated
 *
 * Finalization
 * - Planet is marked "active" and begins to tick via SSplanets
 */

/**
 * Master proc used to generate a planet
 */
/datum/controller/subsystem/planets/proc/DoGeneration(datum/planet/planet, list/z_indices_existing)

/**
 * Master proc used to generate a planet from scratch
 */
/datum/controller/subsystem/planets/proc/GenerateFromScratch(danger, datum/planet_type/forced_type, list/datum/planet_level/forced_levels, list/datum/planet_biome/forced_biomes, list/z_indices_existing)

