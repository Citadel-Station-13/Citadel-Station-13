/obj/machinery/computer/station_alert
	name = "station alert console"
	desc = "Used to access the station's automated alert system."
	icon_screen = "alert:0"
	icon_keyboard = "atmos_key"
	circuit = /obj/item/circuitboard/computer/stationalert

	light_color = LIGHT_COLOR_CYAN

/obj/machinery/computer/station_alert/Initialize()
	. = ..()
	RegisterAlarmTrigger(ALARM_NETWORK_STATION, .proc/update_alarm_display)
	RegisterAlarmClear(ALARM_NETWORK_STATION, .proc/update_alarm_display)

/obj/machinery/computer/station_alert/Destroy()
	UnregisterAlarmTrigger(ALARM_NETWORK_STATION, .proc/update_alarm_display)
	UnregisterAlarmClear(ALARM_NETWORK_STATION, .proc/update_alarm_display)
	return ..()

/obj/machinery/computer/station_alert/ui_interact(mob/user, ui_key = "main", datum/tgui/ui = null, force_open = FALSE, \
									datum/tgui/master_ui = null, datum/ui_state/state = GLOB.default_state)
	ui = SStgui.try_update_ui(user, src, ui_key, ui, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "station_alert", name, 325, 500, master_ui, state)
		ui.open()

/obj/machinery/computer/station_alert/ui_data(mob/user)
	var/list/data = list()

	data["alarms"] = list()
	data["alarms"]["Fire"] = SSalarms.get_alarm_areas_by_type_and_network(FIRE_ALARM, ALARM_NETWORK_STATION)
	data["alarms"]["Atmosphere"] = SSalarms.get_alarm_areas_by_type_and_network(MOTION_ALARM, ALARM_NETWORK_STATION)
	data["alarms"]["Power"] = SSalarms.get_alarm_areas_by_type_and_network(POWER_ALARM, ALARM_NETWORK_STATION)
	return data

/obj/machinery/computer/station_alert/proc/update_alarm_display()
	update_overlays()

/obj/machinery/computer/station_alert/update_overlays()
	. = ..()
	SSvis_overlays.remove_vis_overlay(src, managed_vis_overlays)
	var/overlay_state = icon_screen
	if(stat & (NOPOWER|BROKEN))
		. |= "[icon_keyboard]_off"
		return
	. |= icon_keyboard
	var/list/cached = SSalarms.alarms_by_type_and_network[ALARM_NETWORK_STATION]
	var/active_alarms = length(cached[FIRE_ALARM]) || length(cached[ATMOS_ALARM]) || length(cached[POWER_ALARM]))
	if(active_alarms)
		overlay_state = "alert:2"
	else
		overlay_state = "alert:0"
	. |= overlay_state
	SSvis_overlays.add_vis_overlay(src, icon, overlay_state, layer, plane, dir)
	SSvis_overlays.add_vis_overlay(src, icon, overlay_state, EMISSIVE_LAYER, EMISSIVE_PLANE, dir, alpha=128)
