/obj/item/weapon/gun/energy/plasma
	name = "plasma gun"
	desc = "A high-power plasma gun. You shouldn't ever see this."
	icon_state = "xray"
	w_class = WEIGHT_CLASS_NORMAL
	ammo_type = list(/obj/item/ammo_casing/energy/plasmagun)
	ammo_x_offset = 1
	shaded_charge = 1

/obj/item/weapon/gun/energy/plasma/rifle
	name = "plasma cannon"
	desc = "A state of the art cannon utilizing plasma in a uranium-235 lined core to output hi-power, radiating bolts of energy."
	icon_state = "alienrifle"
	w_class = WEIGHT_CLASS_BULKY
	ammo_type = list(/obj/item/ammo_casing/energy/plasmagun/rifle)
	ammo_x_offset = 4

/obj/item/weapon/gun/energy/plasma/light
	name = "plasma rifle"
	desc = "A state of the art rifle utilizing plasma in a uranium-235 lined core to output radiating bolts of energy."
	icon_state = "lightalienrifle"
	ammo_type = list(/obj/item/ammo_casing/energy/plasmagun/light)
	ammo_x_offset = 2

/obj/item/weapon/gun/energy/plasma/MP40k
	name = "Plasma MP40k"
	desc = "A plasma MP40k. Ich liebe den geruch von plasma am morgen."
	icon_state = "PlasMP"
	ammo_type = list(/obj/item/ammo_casing/energy/plasmagun/MP40k)
	ammo_x_offset = 3