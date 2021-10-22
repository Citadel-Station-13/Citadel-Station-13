/**
 * A turf pending planetgen
 */
/turf/planetgen_marker
	name = "planetgen marker"
	desc = "You shouldn't see this. Contact a coder ASAP. This turf should be replaced by planetgen at init."
	blocks_air = TRUE
	density = TRUE
	icon = 'icons/planets/turfs.dmi'
	icon_state = "marker"

/**
 * Are we considered an external turf for planetary weather and lighting
 */
/turf/proc/IsExterior()
	#warn multiz roof support
	return loc.IsExterior()

/**
 * Gets our planet datum, if any
 */
/turf/proc/GetPlanet()
	var/datum/space_level/SL = SSmapping.get_level(z)
	return SL.planet

/**
 * Checks if a turf is eligible for planetgen - mostly used when loading in existing levels.
 * If instantiating new levels, this is ignored.
 */
/turf/proc/planetgen_eligible()
	return istype(src, /turf/planetgen_marker) && istype(loc, /area/planetgen_marker)
