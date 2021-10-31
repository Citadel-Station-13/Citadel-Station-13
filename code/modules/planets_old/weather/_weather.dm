/**
 * Weather datums for planets
 */
/datum/weather
	/// name
	var/name = "Unknown Weather"
	/// visual icon
	var/icon = 'icons/modules/planets/weather/overlays.dmi'

/**
 * Constructor
 */
/datum/weather/New(datum/planet/target, ...)

	Initialize(arglist(args.Copy(2)))

/**
 * Initialization
 */
/datum/weather/proc/Initialize(...)
