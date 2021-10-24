SUBSYSTEM_DEF(networks)
	name = "Networks"
	flags = SS_NO_FIRE
	// no init order for now
	// no fire priority for now

	// Simple networks
	/// id lookup to a list of devices
	var/static/list/simple_network_lookup = list()
