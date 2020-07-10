SUBSYSTEM_DEF(alarms)
	flags = SS_NO_FIRE | SS_NO_INIT

	/// Alarm list. network = list(area = alarm types as flag). Almost all accesses should happen through here! Optimizations can be done without changing the layout of this layered list.
	var/static/list/active_alarms = list()
	/// list = list(network = list(singular_alarm_type_bit = list(area1, area2, ...)))
	var/static/list/alarm_areas_by_type_and_network = list()

/**
  * Triggers an alarm in an area. Source is only included for read, never ever cache the source lest you cause GC issues.
  */
/datum/controller/subsystem/alarms/proc/trigger_alarm(alarm_type, area/A, datum/source, network = ALARM_NETWORK_STATION)
	LAZYINITLIST(active_alarms[network])
	var/existing = active_alarms[network][A]
	var/missing = alarm_type & ~(existing)
	if(!missing)
		return
	active_alarms[network][A] |= missing
	LAZYINITLIST(alarm_areas_by_type_and_network[network])
	for(var/bit in bitfield2list(missing))
		LAZYOR(alarm_areas_by_type_and_network[network][bit], A)
	SEND_SIGNAL(src, ALARM_TRIGGER_COMSIG(network), A, missing, source)

/**
  * Ditto.
  */
/datum/controller/subsystem/alarms/proc/clear_alarm(alarm_type, area/A, datum/source, network = ALARM_NETWORK_STATION)
	if(!active_alarms[network] || !active_alarms[network][A])
		return
	var/active = alarm_type & active_alarms[network][A]
	if(!active)
		return
	active_alarms[network][A] &= ~(active)
	for(var/bit in bitfield2list(active))
		if(alarm_areas_by_type_and_network[network])
			LAZYREMOVE(alarm_areas_by_type_and_network[network][bit], A)
	SEND_SIGNAL(src, ALARM_CLEAR_COMSIG(network), A, active, source)

/**
  * Clears all alarms for an area, like when an area is being deleted.	
  */
/datum/controller/subsystem/alarms/proc/clear_all_alarms(area/A)
	for(var/network in active_alarms)
		clear_alarm(ALL, A, null, network)

/**
  * Get all alarms as area = alarm_flags, regardless of network.
  */
/datum/controller/subsystem/alarms/proc/get_all_alarms()
	. = list()
	for(var/network in active_alarms)
		for(var/area in active_alarms[network])
			.[area] = .[area]? (.[area] | active_alarms[network][area]) : active_alarms[network][area]

/**
  * Returns a list of areas with the given alarm type in the given network
  */
/datum/controller/subsystem/alarms/proc/get_alarm_areas_by_type_and_network(type, network)
	return (alarm_areas_by_type_and_network[network]? alarm_areas_by_type_and_network[network][type] : list())
