/**
 * Sends a simple network message.
 *
 * @param
 * id - id of network to send to
 * message - message to send or null
 * data - arbitrary list or null
 * range - range from the current atom, defaults to ignoring.
 */
/atom/SimpleNetworkSend(id, message, list/data, range = INFINITY)
	if(range == INFINITY)
		return ..()
	var/list/devices = SSnetworks.GetSimpleDevicesRange(id, src, range)
	for(var/datum/D as anything in devices)
		D.SimpleNetworkReceive(id, message, data, src)
