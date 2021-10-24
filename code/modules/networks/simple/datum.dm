/**
 * Sends a simple network message.
 *
 * @param
 * id - id of network to send to
 * message - message to send or null
 * data - arbitrary list or null
 */
/datum/proc/SimpleNetworkSend(id, message, list/data)
	var/list/devices = SSnetworks.GetSimpleDevices(id)
	for(var/datum/D as anything in devices)
		D.SimpleNetworkReceive(id, message, list/data, src)

/**
 * Called on receiving a simple network message - register to these by adding the element.
 */
/datum/proc/SimpleNetworkReceive(id, message, list/data, datum/sender)
	return
