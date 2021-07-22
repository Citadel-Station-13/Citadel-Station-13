// the light switch
// can have multiple per area
// can also operate on non-loc area through "otherarea" var
/obj/machinery/light_switch
	name = "light switch"
	icon = 'icons/obj/power.dmi'
	icon_state = "light1"
	base_icon_state = "light"
	plane = ABOVE_WALL_PLANE
	desc = "Make dark."
	var/on = TRUE
	var/area/area = null
	var/otherarea = null

/obj/machinery/light_switch/Initialize()
	. = ..()
	area = get_area(src)

	if(otherarea)
		area = locate(text2path("/area/[otherarea]"))

	if(!name)
		name = "light switch ([area.name])"

	on = area.lightswitch
	update_icon()

/obj/machinery/light_switch/update_icon_state()
	if(stat & NOPOWER)
		icon_state = "[base_icon_state]-p"
		return ..()
	icon_state = "[base_icon_state][area.lightswitch ? 1 : 0]"
	return ..()

/obj/machinery/light_switch/update_overlays()
	. = ..()
	if(!(stat & NOPOWER))
		. += emissive_appearance(icon, "[base_icon_state]-glow", alpha = src.alpha)

/obj/machinery/light_switch/examine(mob/user)
	. = ..()
	. += "It is [on? "on" : "off"]."

/obj/machinery/light_switch/interact(mob/user)
	. = ..()
	on = !on

	area.lightswitch = on
	area.update_icon()

	for(var/obj/machinery/light_switch/L in area)
		L.on = on
		L.update_icon()

	area.power_change()

/obj/machinery/light_switch/power_change()

	if(!otherarea)
		if(powered(LIGHT))
			stat &= ~NOPOWER
		else
			stat |= NOPOWER

		update_icon()

/obj/machinery/light_switch/emp_act(severity)
	. = ..()
	if (. & EMP_PROTECT_SELF)
		return
	if(!(stat & (BROKEN|NOPOWER)))
		power_change()
