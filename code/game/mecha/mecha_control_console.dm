/obj/machinery/computer/mecha
	name = "exosuit control console"
	desc = "Used to remotely locate or lockdown exosuits."
	icon_screen = "mecha"
	icon_keyboard = "tech_key"
	req_access = list(ACCESS_ROBOTICS)
	circuit = /obj/item/circuitboard/computer/mecha_control
	var/list/located = list()
	var/screen = 0
	var/stored_data
	ui_x = 500
	ui_y = 500
	
/obj/machinery/computer/mecha/ui_interact(mob/user, ui_key = "main", datum/tgui/ui = null, force_open = FALSE, \
									datum/tgui/master_ui = null, datum/ui_state/state = GLOB.default_state)
	ui = SStgui.try_update_ui(user, src, ui_key, ui, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "ExosuitControlConsole", name, ui_x, ui_y, master_ui, state)
		ui.open()

	if(screen==1)
		dat += "<h3>Log contents</h3>"
		dat += "<a href='?src=[REF(src)];return=1'>Return</a><hr>"
		dat += "[stored_data]"

	dat += "<A href='?src=[REF(src)];refresh=1'>(Refresh)</A><BR>"
	dat += "</body></html>"

	user << browse(dat, "window=computer;size=400x500")
	onclose(user, "computer")

/obj/machinery/computer/mecha/Topic(href, href_list)
	if(..())
		return
	if(href_list["send_message"])
		var/obj/item/mecha_parts/mecha_tracking/MT = locate(href_list["send_message"])
		if (!istype(MT))
			return
		var/message = stripped_input(usr,"Input message","Transmit message")
		var/obj/mecha/M = MT.in_mecha()
		if(trim(message) && M)
			M.occupant_message(message)
		return
	if(href_list["shock"])
		var/obj/item/mecha_parts/mecha_tracking/MT = locate(href_list["shock"])
		if (istype(MT))
			MT.shock()
	if(href_list["get_log"])
		var/obj/item/mecha_parts/mecha_tracking/MT = locate(href_list["get_log"])
		if(istype(MT))
			stored_data = MT.get_mecha_log()
			screen = 1
	if(href_list["return"])
		screen = 0
	updateUsrDialog()
	return

/obj/item/mecha_parts/mecha_tracking
	name = "exosuit tracking beacon"
	desc = "Device used to transmit exosuit data."
	icon = 'icons/obj/device.dmi'
	icon_state = "motion2"
	w_class = WEIGHT_CLASS_SMALL
	var/ai_beacon = FALSE //If this beacon allows for AI control. Exists to avoid using istype() on checking.
	var/recharging = 0

/obj/item/mecha_parts/mecha_tracking/proc/get_mecha_info()
	if(!in_mecha())
		return 0
	var/obj/mecha/M = src.loc
	var/cell_charge = M.get_charge()
	var/answer = {"<b>Name:</b> [M.name]
<b>Integrity:</b> [M.obj_integrity/M.max_integrity*100]%
<b>Cell charge:</b> [isnull(cell_charge)?"Not found":"[M.cell.percent()]%"]
<b>Airtank:</b> [M.return_pressure()]kPa
<b>Pilot:</b> [M.occupant||"None"]
<b>Location:</b> [get_area(M)||"Unknown"]
<b>Active equipment:</b> [M.selected||"None"] "}
	if(istype(M, /obj/mecha/working/ripley))
		var/obj/mecha/working/ripley/RM = M
		answer += "<b>Used cargo space:</b> [RM.cargo.len/RM.cargo_capacity*100]%<br>"

	return answer

/obj/item/mecha_parts/mecha_tracking/emp_act()
	. = ..()
	if(!(. & EMP_PROTECT_SELF))
		qdel(src)

/obj/item/mecha_parts/mecha_tracking/Destroy()
	if(ismecha(loc))
		var/obj/mecha/M = loc
		if(src in M.trackers)
			M.trackers -= src
	return ..()

/obj/item/mecha_parts/mecha_tracking/proc/in_mecha()
	if(ismecha(loc))
		return loc
	return 0

/obj/item/mecha_parts/mecha_tracking/proc/shock()
	if(recharging)
		return
	var/obj/mecha/M = in_mecha()
	if(M)
		M.emp_act(EMP_HEAVY)
		addtimer(CALLBACK(src, /obj/item/mecha_parts/mecha_tracking/proc/recharge), 15 SECONDS, TIMER_UNIQUE | TIMER_OVERRIDE)
		recharging = 1

/obj/item/mecha_parts/mecha_tracking/proc/recharge()
	recharging = 0

/obj/item/mecha_parts/mecha_tracking/proc/get_mecha_log()
	if(!ismecha(loc))
		return 0
	var/obj/mecha/M = src.loc
	return M.get_log_html()


/obj/item/mecha_parts/mecha_tracking/ai_control
	name = "exosuit AI control beacon"
	desc = "A device used to transmit exosuit data. Also allows active AI units to take control of said exosuit."
	ai_beacon = TRUE


/obj/item/storage/box/mechabeacons
	name = "exosuit tracking beacons"

/obj/item/storage/box/mechabeacons/PopulateContents()
	..()
	new /obj/item/mecha_parts/mecha_tracking(src)
	new /obj/item/mecha_parts/mecha_tracking(src)
	new /obj/item/mecha_parts/mecha_tracking(src)
	new /obj/item/mecha_parts/mecha_tracking(src)
	new /obj/item/mecha_parts/mecha_tracking(src)
	new /obj/item/mecha_parts/mecha_tracking(src)
	new /obj/item/mecha_parts/mecha_tracking(src)
