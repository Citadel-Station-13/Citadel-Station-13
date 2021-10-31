/area
	/// Are we considered an exterior area
	var/exterior = FALSE

/**
 * Are we considered an exterior area for planetary purposes
 */
/area/proc/IsExterior()


/**
 * PLANETGEN AREA: For attempting to instantiate a planet with an existing zlevel set, this marks an area as free-to-use for generation
 */
/area/planetgen_marker
	name = "planetgen marker"
	desc = "You shouldn't see this; The area should be replaced by planetgen during init. If you see this at runtime, tell a coder."
	icon = 'icons/planets/area.dmi'
	icon_state = "marker"

/**
 * Basetype of planet areas.
 * These are instanced per level biome/type.
 * The reason we use tags is to not need to pass around area-by-biome lookups per level later. 
 */
/area/planetary
	name = "planetary area"
	desc = "You shouldn't see this, but if you do, atleast things are working properly."
	icon = 'icons/planets/area.dmi'
	icon_state = "default"
	exterior = TRUE
	datum_flags = DF_USE_TAG

	/// our biome ID
	var/biome_id
	/// our planet ID
	var/planet_id

/area/planetary/New(loc, datum/planet/planet, datum/planet_biome/biome, planetary_z_index)
	ASSERT(planet)
	ASSERT(biome)
	ASSERT(planetary_z_index)
	biome_id = biome?.id
	planet_id = planet?.id
	tag = "planet_area_[planet_id]-[planetary_z_index]_[biome]"
