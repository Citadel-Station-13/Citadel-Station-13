/obj/item/knot
	name = "knot"
	desc = "One of the many dogborg knots created by the infamous knot module."
	icon_state = "1"
	icon = 'icons/obj/knots.dmi'
	force = 0
	throwforce = 0
	w_class = WEIGHT_CLASS_TINY
	throw_speed = 1
	throw_range = 7

/obj/item/knot/Initialize()
	. = ..()
	icon_state = "[rand(1,12)]"
	return .

/obj/item/knot_module
	name = "knot module"
	desc = "Yes."
	icon = 'icons/obj/tools.dmi'
	icon_state = "rcd"
	lefthand_file = 'icons/mob/inhands/equipment/tools_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/tools_righthand.dmi'

/obj/item/knot_module/afterattack(atom/A, mob/user, proximity)
	. = ..()
	if(!proximity)
		return
	if (!(istype(A, /obj/structure/table) || isfloorturf(A)))
		return
	var/turf/T = get_turf(A)
	playsound(src.loc, 'sound/machines/click.ogg', 10, 1)
	new /obj/item/knot(T)
