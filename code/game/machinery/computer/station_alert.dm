/obj/machinery/computer/station_alert
	name = "station alert console"
	desc = "Used to access the station's automated alert system."
	icon_screen = "alert:0"
	icon_keyboard = "atmos_key"
	circuit = /obj/item/circuitboard/computer/stationalert
	///Listens for alarms, provides the alarms list for our ui
	var/datum/alarm_listener/listener

	light_color = LIGHT_COLOR_CYAN

/obj/machinery/computer/station_alert/Initialize(mapload)
	listener = new(list(ALARM_ATMOS, ALARM_FIRE, ALARM_POWER), list(z))
	return ..()

/obj/machinery/computer/station_alert/Destroy()
	QDEL_NULL(listener)
	return ..()

/obj/machinery/computer/station_alert/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "StationAlertConsole", name)
		ui.open()

/obj/machinery/computer/station_alert/ui_data(mob/user)
	var/list/data = list()

	data["alarms"] = list()
	var/list/alarms = listener.alarms
	for(var/alarm_type in alarms)
		data["alarms"][alarm_type] = list()
		for(var/area_name in alarms[alarm_type])
			data["alarms"][alarm_type] += area_name

	return data

/obj/machinery/computer/station_alert/on_machine_stat_update(stat)
	if(stat & BROKEN)
		listener.prevent_alarm_changes()
	else
		listener.allow_alarm_changes()

/obj/machinery/computer/station_alert/update_overlays()
	. = ..()
	SSvis_overlays.remove_vis_overlay(src, managed_vis_overlays)
	var/overlay_state = icon_screen
	if(stat & (NOPOWER|BROKEN))
		. |= "[icon_keyboard]_off"
		return
	. |= icon_keyboard
	if(length(listener.alarms))
		overlay_state = "alert:2"
	else
		overlay_state = "alert:0"
	. |= overlay_state
	SSvis_overlays.add_vis_overlay(src, icon, overlay_state, layer, plane, dir)
	SSvis_overlays.add_vis_overlay(src, icon, overlay_state, EMISSIVE_LAYER, EMISSIVE_PLANE, dir, alpha=128)
