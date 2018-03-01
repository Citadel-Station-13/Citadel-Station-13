/obj/item/gun/ballistic/automatic/triphase
	name = "Triphase Laser Rifle"
	desc = "Designed as a new type of experimental hybrid energy weapon, the triphase laser rifle utilises energy magazines to charge an internal high-efficiency capacitor, which in turn powers a focusing crystal to create a beam of high-powered light."
	icon = 'icons/obj/guns/cit_guns.dmi'
	icon_state = "triphase"
	item_state = "arg"
	mag_type = /obj/item/ammo_box/magazine/recharge/triphase
	fire_delay = 50 //Focusing crystal requires cooldown
	can_suppress = FALSE
	burst_size = 0
	actions_types = list()
	fire_sound = 'sound/weapons/laser.ogg'
	pin = null
	casing_ejector = FALSE
	energyhybrid = TRUE

/obj/item/gun/ballistic/automatic/triphase/update_icon()
	..()
	if(magazine)
		cut_overlays()
		add_overlay("triphase-magazine")
	else
		cut_overlays()
	icon_state = "[initial(icon_state)][chambered ? "" : "-e"]"
