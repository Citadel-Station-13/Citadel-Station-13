/obj/item/gun/energy/laser/carbine
	name = "laser carbine"
	desc = "A ruggedized laser carbine featuring much higher capacity and improved handling when compared to a normal laser gun."
	icon = 'icons/obj/guns/cit_guns.dmi'
	icon_state = "lasernew"
	item_state = "laser"
	origin_tech = "combat=4;magnets=4"
	force = 10
	throwforce = 10
	ammo_type = list(/obj/item/ammo_casing/energy/lasergun)
	cell_type = /obj/item/stock_parts/cell/lascarbine
	resistance_flags = FIRE_PROOF | ACID_PROOF

/obj/item/gun/energy/laser/carbine/nopin
	pin = null

/obj/item/stock_parts/cell/lascarbine
	name = "laser carbine power supply"
	maxcharge = 2500

/datum/design/lasercarbine
	name = "Laser Carbine"
	desc = "Beefed up version of a standard laser gun."
	id = "lasercarbine"
	req_tech = list("combat" = 5, "magnets" = 5, "powerstorage" = 4)
	build_type = PROTOLATHE
	materials = list(MAT_GOLD = 2500, MAT_METAL = 5000, MAT_GLASS = 5000)
	build_path = /obj/item/gun/energy/laser/carbine/nopin
	category = list("Weapons")

/obj/item/gun/ballistic/automatic/pistol/antitank
	name = "Anti Tank Pistol"
	desc = "A massively impractical and silly monstrosity of a pistol that fires .50 calliber rounds. The recoil is likely to dislocate your wrist."
	icon = 'icons/obj/guns/cit_guns.dmi'
	icon_state = "atp"
	item_state = "pistol"
	recoil = 6
	mag_type = /obj/item/ammo_box/magazine/sniper_rounds
	fire_delay = 50
	burst_size = 1
	origin_tech = "combat=7"
	can_suppress = 0
	w_class = WEIGHT_CLASS_NORMAL
	actions_types = list()
	fire_sound = 'sound/weapons/blastcannon.ogg'
	spread = 30		//damn thing has no rifling.


/obj/item/gun/ballistic/automatic/pistol/antitank/update_icon()
	..()
	if(magazine)
		cut_overlays()
		add_overlay("atp-mag")
	else
		cut_overlays()
	icon_state = "[initial(icon_state)][chambered ? "" : "-e"]"

/obj/item/gun/ballistic/automatic/pistol/antitank/syndicate
	name = "Syndicate Anti Tank Pistol"
	desc = "A massively impractical and silly monstrosity of a pistol that fires .50 calliber rounds. The recoil is likely to dislocate a variety of joints without proper bracing."
	pin = /obj/item/device/firing_pin/implant/pindicate
	origin_tech = "combat=7;syndicate=6"

