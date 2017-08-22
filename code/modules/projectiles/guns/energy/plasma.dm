/obj/item/gun/energy/plasma //Not intended to be used, use its children instead.
	name = "plasma gun"
	desc = "A high-power plasma gun. You shouldn't ever see this."
	icon_state = "xray"
	w_class = WEIGHT_CLASS_NORMAL
	ammo_type = list(/obj/item/ammo_casing/energy/plasmagun)
	ammo_x_offset = 2
	shaded_charge = 1


/obj/item/gun/energy/plasma/rifle
	name = "plasma cannon"
	desc = "A state of the art cannon utilizing plasma in a uranium-235 lined core to output hi-power, radiating bolts of energy."
	icon_state = "alienrifle"
	item_state = null
	icon = 'icons/obj/guns/VGguns.dmi'
	w_class = WEIGHT_CLASS_BULKY
	ammo_type = list(/obj/item/ammo_casing/energy/plasmagun/rifle)
	ammo_x_offset = 4



/obj/item/gun/energy/plasma/light
	name = "plasma rifle"
	desc = "A state of the art rifle utilizing plasma in a uranium-235 lined core to output radiating bolts of energy."
	icon_state = "lightalienrifle"
	item_state = null
	icon = 'icons/obj/guns/VGguns.dmi'
	ammo_type = list(/obj/item/ammo_casing/energy/plasmagun/light)
	ammo_x_offset = 2


/obj/item/gun/energy/plasma/MP40k
	name = "Plasma MP40k"
	desc = "A plasma MP40k. Ich liebe den geruch von plasma am morgen."
	icon_state = "PlasMP"
	item_state = null
	icon = 'icons/obj/guns/VGguns.dmi'
	ammo_type = list(/obj/item/ammo_casing/energy/plasmagun/MP40k)
	ammo_x_offset = 3

//Laser rifles, technically lazer, but w/e

/obj/item/gun/energy/laser/rifle
	name = "laser rifle"
	desc = "A laser rifle issued to high ranking members of a certain shadow corporation."
	icon_state = "xcomlasergun"
	item_state = null
	icon = 'icons/obj/guns/VGguns.dmi'
	ammo_type = list(/obj/item/ammo_casing/energy/lasergun)
	ammo_x_offset = 4

/obj/item/gun/energy/laser/LaserAK
	name = "Laser AK470"
	desc = "A laser AK. Death solves all problems -- No man, no problem."
	icon_state = "LaserAK"
	item_state = null
	icon = 'icons/obj/guns/VGguns.dmi'
	ammo_type = list(/obj/item/ammo_casing/energy/laser)
	ammo_x_offset = 4
