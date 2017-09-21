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

////////ATP//////////

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

/////////////spinfusor stuff////////////////

/obj/item/projectile/bullet/spinfusor
	name ="spinfusor disk"
	icon = 'icons/obj/guns/cit_guns.dmi'
	icon_state= "spinner"
	damage = 30
	dismemberment = 25

/obj/item/projectile/bullet/spinfusor/on_hit(atom/target, blocked = FALSE) //explosion to emulate the spinfusor's AOE
	..()
	explosion(target, -1, -1, 2, 0, -1)
	return 1

/obj/item/ammo_casing/caseless/spinfusor
	name = "spinfusor disk"
	desc = "A magnetic disk designed specifically for the Stormhammer magnetic cannon. Warning: extremely volatile!"
	projectile_type = /obj/item/projectile/bullet/spinfusor
	caliber = "spinfusor"
	icon = 'icons/obj/guns/cit_guns.dmi'
	icon_state = "disk"
	throwforce = 15 //still deadly when thrown
	throw_speed = 3

/obj/item/ammo_casing/caseless/spinfusor/throw_impact(atom/target) //disks detonate when thrown
	if(!..()) // not caught in mid-air
		visible_message("<span class='notice'>[src] detonates!</span>")
		playsound(src.loc, "sparks", 50, 1)
		explosion(target, -1, -1, 1, 1, -1)
		qdel(src)
		return 1

/obj/item/ammo_box/magazine/internal/spinfusor
	name = "spinfusor internal magazine"
	ammo_type = /obj/item/ammo_casing/caseless/spinfusor
	caliber = "spinfusor"
	max_ammo = 1

/obj/item/gun/ballistic/automatic/spinfusor
	name = "Stormhammer Magnetic Cannon"
	desc = "An innovative weapon utilizing mag-lev technology to spin up a magnetic fusor and launch it at extreme velocities."
	icon = 'icons/obj/guns/cit_guns.dmi'
	icon_state = "spinfusor"
	item_state = "spinfusor"
	mag_type = /obj/item/ammo_box/magazine/internal/spinfusor
	fire_sound = 'sound/weapons/rocketlaunch.ogg'
	w_class = WEIGHT_CLASS_BULKY
	can_suppress = 0
	burst_size = 1
	fire_delay = 20
	select = 0
	actions_types = list()
	casing_ejector = 0

/obj/item/gun/ballistic/automatic/spinfusor/attackby(obj/item/A, mob/user, params)
	var/num_loaded = magazine.attackby(A, user, params, 1)
	if(num_loaded)
		to_chat(user, "<span class='notice'>You load [num_loaded] disk\s into \the [src].</span>")
		update_icon()
		chamber_round()

/obj/item/gun/ballistic/automatic/spinfusor/attack_self(mob/living/user)
	return //caseless rounds are too glitchy to unload properly. Best to make it so that you cannot remove disks from the spinfusor

/obj/item/gun/ballistic/automatic/spinfusor/update_icon()
	..()
	icon_state = "spinfusor[magazine ? "-[get_ammo(1)]" : ""]"

/obj/item/gun/ballistic/automatic/spinfusor/nopin
	pin = null

/datum/design/spinfusorcannon
	name = "Stormhammer Magnetic Cannon"
	desc = "An innovative magnetic weapon utilizing a 'spinfusor' disk spun at extreme speeds as projectiles, magnifying their already volatile nature to the extremes."
	id = "spinfusorcannon"
	req_tech = list("combat" = 5, "magnets" = 6, "powerstorage" = 5, "materials" = 5, "programming" = 5)
	build_type = PROTOLATHE
	materials = list(MAT_METAL = 7500, MAT_GLASS = 5000, MAT_SILVER = 5000, MAT_GOLD = 5000, MAT_TITANIUM = 10000)
	build_path = /obj/item/gun/ballistic/automatic/spinfusor/nopin
	category = list("Weapons")

/datum/design/spinfusordisk
	name = "Spinfusor Disk"
	desc = "An extremely volatile disk with magnetic properties, it is designed to be launched out of Stormhammers. WARNING: Will detonate if not handled with care."
	id = "spinfusordisk"
	req_tech = list("combat" = 5, "magnets" = 6, "powerstorage" = 5, "materials" = 5)
	build_type = PROTOLATHE
	materials = list(MAT_METAL = 2000, MAT_GLASS = 500, MAT_SILVER = 1000, MAT_GOLD = 1000, MAT_PLASMA = 1000, MAT_URANIUM = 1000, MAT_TITANIUM = 1000)
	build_path = /obj/item/ammo_casing/caseless/spinfusor
	category = list("Weapons") //explosive frisbees are definitely weapons rather than ammo
