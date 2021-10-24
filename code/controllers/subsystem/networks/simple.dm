/**
 * Returns list of devices on a simple network.
 *
 * **WARNING: LIST IS NOT A COPY FOR PERFORMANCE - DO NOT MODIFY WITHOUT COPYING.**
 */
/datum/controller/subsystem/networks/proc/GetSimpleDevices(id)
	return simple_network_lookup[id] || list()

/**
 * Returns list of devices on a simple network within distance of atom
 */
/datum/controller/subsystem/networks/proc/GetSimpleDevicesRange(id, atom/center, range = 25)
	center = get_turf(center)
	if(!center)
		return list()
	. = list()
	for(var/atom/A in GetSimpleDevices(id))
		if(get_dist(A, center) <= range)
			. += A
