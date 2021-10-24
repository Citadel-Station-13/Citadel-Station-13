/datum/element/simple_network
	element_flags = ELEMENT_DETACH | ELEMENT_BESPOKE
	id_arg_index = 1
	var/id

/datum/element/simple_network/Attach(datum/target, id)
	. = ..()
	if(. & ELEMENT_INCOMPATIBLE)
		return
	src.id = id
	if(SSnetworks.simple_network_lookup[id])
		SSnetworks.simple_network_lookup[id] |= target
	else
		SSnetworks.simple_network_lookup[id] = list(target)

/datum/element/simple_network/Detach(datum/source)
	SSnetworks.simple_network_lookup[id] -= source
	if(!length(SSnetworks.simple_network_lookup[id]))
		SSnetworks.simple_network_lookup -= id
	return ..()
