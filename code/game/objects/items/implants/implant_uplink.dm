/obj/item/implant/uplink
	name = "uplink implant"
	desc = "Sneeki breeki."
	icon = 'icons/obj/radio.dmi'
	icon_state = "radio"
	lefthand_file = 'icons/mob/inhands/misc/devices_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/misc/devices_righthand.dmi'
	var/starting_tc = 0

/obj/item/implant/uplink/Initialize(mapload, _owner)
	. = ..()
	AddComponent(/datum/component/uplink, _owner, TRUE, FALSE, null, starting_tc)

/obj/item/implanter/uplink
	name = "implanter (uplink)"
	imp_type = /obj/item/implant/uplink

/obj/item/implanter/uplink/precharged
	name = "implanter (precharged uplink)"
	imp_type = /obj/item/implant/uplink/precharged

/obj/item/implant/uplink/precharged
	starting_tc = TELECRYSTALS_PRELOADED_IMPLANT

/obj/item/implant/uplink/starting
	starting_tc = TELECRYSTALS_DEFAULT - UPLINK_IMPLANT_TELECRYSTAL_COST
