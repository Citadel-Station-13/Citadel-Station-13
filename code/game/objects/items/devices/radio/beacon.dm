/obj/item/device/radio/beacon
	name = "tracking beacon"
	desc = "A beacon used by a teleporter."
	icon_state = "beacon"
	item_state = "beacon"
	lefthand_file = 'icons/mob/inhands/misc/devices_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/misc/devices_righthand.dmi'
	var/code = "electronic"
	dog_fashion = null

/obj/item/device/radio/beacon/Initialize()
	. = ..()
	GLOB.teleportbeacons += src

/obj/item/device/radio/beacon/Destroy()
	GLOB.teleportbeacons.Remove(src)
	return ..()

/obj/item/device/radio/beacon/Hear(message, atom/movable/speaker, message_langs, raw_message, radio_freq, list/spans, message_mode)
	return

/obj/item/device/radio/beacon/verb/alter_signal(t as text)
	set name = "Alter Beacon's Signal"
	set category = "Object"
	set src in usr

	if ((usr.canmove && !( usr.restrained() )))
		src.code = t
	if (!( src.code ))
		src.code = "beacon"
	src.add_fingerprint(usr)
	return
