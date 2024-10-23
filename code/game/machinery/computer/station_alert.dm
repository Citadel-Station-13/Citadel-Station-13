/obj/machinery/computer/station_alert
	name = "station alert console"
	desc = "Used to access the station's automated alert system."
	icon_screen = "alert:0"
	icon_keyboard = "atmos_key"
	circuit = /obj/item/circuitboard/computer/stationalert
	light_color = LIGHT_COLOR_CYAN
	/// Station alert datum for showing alerts UI
	var/datum/station_alert/alert_control

/obj/machinery/computer/station_alert/Initialize(mapload)
	alert_control = new(src, list(ALARM_ATMOS, ALARM_FIRE, ALARM_POWER), list(z), title = name)
	return ..()

/obj/machinery/computer/station_alert/Destroy()
	QDEL_NULL(alert_control)
	return ..()

/obj/machinery/computer/station_alert/ui_interact(mob/user)
	alert_control.ui_interact(user)

/obj/machinery/computer/station_alert/on_machine_stat_update(stat)
	if(stat & BROKEN)
		alert_control.listener.prevent_alarm_changes()
	else
		alert_control.listener.allow_alarm_changes()

/obj/machinery/computer/station_alert/update_overlays()
	. = ..()
	SSvis_overlays.remove_vis_overlay(src, managed_vis_overlays)
	var/overlay_state = icon_screen
	if(machine_stat & (NOPOWER|BROKEN))
		. |= "[icon_keyboard]_off"
		return
	. |= icon_keyboard
	if(length(alert_control.listener.alarms))
		overlay_state = "alert:2"
	else
		overlay_state = "alert:0"
	. |= overlay_state
	SSvis_overlays.add_vis_overlay(src, icon, overlay_state, layer, plane, dir)
	SSvis_overlays.add_vis_overlay(src, icon, overlay_state, EMISSIVE_LAYER, EMISSIVE_PLANE, dir, alpha=128)
