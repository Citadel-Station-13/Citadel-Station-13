/**
 * Planet datums
 */
/datum/planet
	// basic data
	/// name
	var/name
	/// desc
	var/desc
	/// uid
	var/id
	/// uid next
	var/static/id_next = 0

	// instantiation/terrain
	/// planet type
	var/datum/planet_type/planet_type
	/// planet levels list - order matters based on type!
	var/list/datum/planet_level/planet_levels
	/// physical zlevels. order matters based on type! null if not instantiated
	var/list/zlevels
	/// Are we instantiated fully?
	var/instantiated = FALSE

	// generation data
	/// danger - 0 to 100
	var/danger
	/// temperature - 0 to 100
	var/temperature
	/// humidity - 0 to 100
	var/humidity
	/// Default, non-overridden zoom for perlin in 1 per tiles
	var/zoom = 100 / 256
	/// Variance - how high the humidity and temperatures vary from the above
	var/variance
	/// level seeds - order matters, depends on type for how many is needed
	var/list/seeds

	// player facing metadata - updated as needed
	/// player facing name
	var/scan_name
	/// player facing danger - 0 to 100
	var/scan_danger
	/// player facing temperaure - 0 to 100
	var/scan_temperature
	/// player facing humidity - 0 to 100
	var/scan_humidity
	/// planet size
	var/scan_size
	/// planet depth
	var/scan_depth
	/// if player characters or player oriented life is present - 0 to 10
	var/scan_external_lifesigns
	/// general lifesigns - 0 to 10
	var/scan_lifesigns
	/// day/night cycle
	var/scan_day_seconds

	// time
	/// daylight start time as ratio (e.g. earth would be 6/24)
	var/daylight_start_ratio
	/// daylight max strength time as ratio (e.g. earth would be 12/24)
	var/daylight_max_ratio
	/// daylight fade start time as ratio (e.g. earth would be 15/24)
	var/daylight_fade_ratio
	/// daylight end start time as ratio (e.g. earth would be 20/24)
	var/daylight_end_ratio
	/// daylight color
	var/daylight_color = rgb(255, 255, 255)
	/// daylight max strength
	var/daylight_strength = 0.75
	/// Seconds in a day
	var/day_seconds
	/// time
	var/datum/planet_time/time

	// weather


	// lighting

/datum/planet/New()
	id = ++id_next
