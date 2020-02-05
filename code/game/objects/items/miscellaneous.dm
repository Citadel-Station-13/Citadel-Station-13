/obj/item/caution
	desc = "Caution! Wet Floor!"
	name = "wet floor sign"
	icon = 'icons/obj/janitor.dmi'
	icon_state = "caution"
	lefthand_file = 'icons/mob/inhands/equipment/custodial_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/custodial_righthand.dmi'
	force = 1
	throwforce = 3
	throw_speed = 2
	throw_range = 5
	w_class = WEIGHT_CLASS_SMALL
	attack_verb = list("warned", "cautioned", "smashed")

/obj/item/skub
	desc = "It's skub."
	name = "skub"
	icon = 'icons/obj/items_and_weapons.dmi'
	icon_state = "skub"
	w_class = WEIGHT_CLASS_BULKY
	attack_verb = list("skubbed")

/obj/item/supermatterspray
	name = "supermatter spray"
	desc = "A spray bottle containing some kind of magical spray to fix the SM. \"Do not inhale.\" is written on the side. Unless aimed at the supermatter, it does nothing."
	icon = 'icons/obj/supermatter.dmi'
	icon_state = "supermatterspray"
	w_class = WEIGHT_CLASS_SMALL
	var/usesleft = 2