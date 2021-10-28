/**
 * Planet generation presets
 */
/datum/planet_preset
	/// Preset name
	var/name = "Unknown Preset"
	/// temperature center
	var/temperature_center = 0
	/// temperature deviation
	var/temperature_deviation = 5
	/// humidity center
	var/humidity_center = 0
	/// humidity deviation
	var/humidity_deviation = 5
	/// elevation center
	var/elevation_center = 0
	/// elevation deviation
	var/elevation_deviation = 1
	/// forced temperature
	var/force_temperature
	/// forced humidity
	var/force_humidity
	/// forced elevation
	var/force_eleation
	/// planet size
	var/size = PLANET_SIZE_TINY
	/// 
