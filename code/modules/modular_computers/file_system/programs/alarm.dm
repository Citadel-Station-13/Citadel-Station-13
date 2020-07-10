/datum/computer_file/program/alarm_monitor
	filename = "alarmmonitor"
	filedesc = "Alarm Monitor"
	ui_header = "alarm_green.gif"
	program_icon_state = "alert-green"
	extended_desc = "This program provides visual interface for station's alarm system."
	requires_ntnet = 1
	network_destination = "alarm monitoring network"
	size = 5
	tgui_id = "ntos_station_alert"
	ui_x = 315
	ui_y = 500

	var/has_alert = FALSE

/datum/computer_file/program/alarm_monitor/process_tick()
	..()

	if(has_alert)
		program_icon_state = "alert-red"
		ui_header = "alarm_red.gif"
		update_computer_icon()
	else
		if(!has_alert)
			program_icon_state = "alert-green"
			ui_header = "alarm_green.gif"
			update_computer_icon()
	return 1

/datum/computer_file/program/alarm_monitor/ui_data(mob/user)
	var/list/data = get_header_data()

	data["alarms"] = list()
	data["alarms"]["Fire"] = SSalarms.get_alarm_areas_by_type_and_network(FIRE_ALARM, ALARM_NETWORK_STATION)
	data["alarms"]["Atmosphere"] = SSalarms.get_alarm_areas_by_type_and_network(MOTION_ALARM, ALARM_NETWORK_STATION)
	data["alarms"]["Power"] = SSalarms.get_alarm_areas_by_type_and_network(POWER_ALARM, ALARM_NETWORK_STATION)

	return data

/datum/computer_file/program/alarm_monitor/proc/update_alarm_display()
	var/list/cached = SSalarms.alarms_by_type_and_network[ALARM_NETWORK_STATION]
	has_alert = length(cached[FIRE_ALARM]) || length(cached[ATMOS_ALARM]) || length(cached[POWER_ALARM]))

/datum/computer_file/program/alarm_monitor/run_program(mob/user)
	. = ..(user)
	RegisterAlarmTrigger(ALARM_NETWORK_STATION, .proc/update_alarm_display)
	RegisterAlarmClear(ALARM_NETWORK_STATION, .proc/update_alarm_display)

/datum/computer_file/program/alarm_monitor/kill_program(forced = FALSE)
	UnregisterAlarmTrigger(ALARM_NETWORK_STATION, .proc/update_alarm_display)
	UnregisterAlarmClear(ALARM_NETWORK_STATION, .proc/update_alarm_display)
	..()
