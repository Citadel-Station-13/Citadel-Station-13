/obj/item/weapon/gun/magic/staff/
	slot_flags = SLOT_BACK

/obj/item/weapon/gun/magic/staff/change
	name = "staff of change"
	desc = "An artefact that spits bolts of coruscating energy which cause the target's very form to reshape itself"
	fire_sound = "sound/magic/Staff_Change.ogg"
	ammo_type = /obj/item/ammo_casing/magic/change
	icon_state = "staffofchange"
	item_state = "staffofchange"

/obj/item/weapon/gun/magic/staff/animate
	name = "staff of animation"
	desc = "An artefact that spits bolts of life-force which causes objects which are hit by it to animate and come to life! This magic doesn't affect machines."
	fire_sound = "sound/magic/Staff_animation.ogg"
	ammo_type = /obj/item/ammo_casing/magic/animate
	icon_state = "staffofanimation"
	item_state = "staffofanimation"

/obj/item/weapon/gun/magic/staff/healing
	name = "staff of healing"
	desc = "An artefact that spits bolts of restoring magic which can remove ailments of all kinds and even raise the dead."
	fire_sound = "sound/magic/Staff_Healing.ogg"
	ammo_type = /obj/item/ammo_casing/magic/heal
	icon_state = "staffofhealing"
	item_state = "staffofhealing"

/obj/item/weapon/gun/magic/staff/healing/handle_suicide() //Stops people trying to commit suicide to heal themselves
	return

/obj/item/weapon/gun/magic/staff/chaos
	name = "staff of chaos"
	desc = "An artefact that spits bolts of chaotic magic that can potentially do anything."
	fire_sound = "sound/magic/Staff_Chaos.ogg"
	ammo_type = /obj/item/ammo_casing/magic/chaos
	icon_state = "staffofchaos"
	item_state = "staffofchaos"
	max_charges = 10
	recharge_rate = 2
	no_den_usage = 1

/obj/item/weapon/gun/magic/staff/door
	name = "staff of door creation"
	desc = "An artefact that spits bolts of transformative magic that can create doors in walls."
	fire_sound = "sound/magic/Staff_Door.ogg"
	ammo_type = /obj/item/ammo_casing/magic/door
	icon_state = "staffofdoor"
	item_state = "staffofdoor"
	max_charges = 10
	recharge_rate = 2
	no_den_usage = 1

/obj/item/weapon/gun/magic/staff/honk
	name = "staff of the honkmother"
	desc = "Honk"
	fire_sound = "sound/items/airhorn.ogg"
	ammo_type = /obj/item/ammo_casing/magic/honk
	icon_state = "honker"
	item_state = "honker"
	max_charges = 4
	recharge_rate = 8
