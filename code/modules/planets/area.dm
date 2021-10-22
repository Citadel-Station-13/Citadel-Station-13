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
 */
/area/planetary
	name = "planetary area"
	desc = "You shouldn't see this, but if you do, atleast things are working properly."
	icon = 'icons/planets/area.dmi'
	icon_state = "default"
	exterior = TRUE

	/// our biome ID
	var/biome
	/// our theme ID
	var/theme
