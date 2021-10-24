/datum/proc/RegisterSimpleNetwork(id)
	AddElement(/datum/element/simple_network, id)

/datum/proc/RegisterSimpleNetworkObfuscated(id)
	AddElement(/datum/element/simple_network, SSmapping.get_obfuscated_id(id, "simple_networks"))
