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

////////////Anti Tank Pistol////////////

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
	origin_tech = "combat=6;magnets=6"

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

/obj/item/ammo_box/aspinfusor
	name = "ammo box (spinfusor disks)"
	icon = 'icons/obj/guns/cit_guns.dmi'
	icon_state = "spinfusorbox"
	ammo_type = /obj/item/ammo_casing/caseless/spinfusor
	max_ammo = 8

/datum/supply_pack/security/armory/spinfusor
	name = "Stormhammer Spinfusor Crate"
	cost = 7000
	contains = list(/obj/item/gun/ballistic/automatic/spinfusor,
					/obj/item/gun/ballistic/automatic/spinfusor)
	crate_name = "spinfusor crate"

/datum/supply_pack/security/armory/spinfusorammo
	name = "Spinfusor Disk Crate"
	cost = 4000
	contains = list(/obj/item/ammo_box/aspinfusor,
					/obj/item/ammo_box/aspinfusor,
					/obj/item/ammo_box/aspinfusor,
					/obj/item/ammo_box/aspinfusor)
	crate_name = "spinfusor disk crate"

///////XCOM X9 AR///////

/obj/item/gun/ballistic/automatic/x9	//will be adminspawn only so ERT or something can use them
	name = "\improper X9 Assault Rifle"
	desc = "A rather old design of a cheap, reliable assault rifle made for combat against unknown enemies. Uses 5.56mm ammo."
	icon = 'icons/obj/guns/cit_guns.dmi'
	icon_state = "x9"
	item_state = "arg"
	slot_flags = 0
	origin_tech = "combat=7;engineering=7"
	mag_type = /obj/item/ammo_box/magazine/m556	//Uses the m90gl's magazine, just like the NT-ARG
	fire_sound = 'sound/weapons/gunshot_smg.ogg'
	can_suppress = 0
	burst_size = 6	//in line with XCOMEU stats. This can fire 5 bursts from a full magazine.
	fire_delay = 1
	spread = 30	//should be 40 for XCOM memes, but since its adminspawn only, might as well make it useable
	recoil = 1

////////XCOM2 Magpistol/////////

//////projectiles//////

/obj/item/projectile/bullet/mags
	icon = 'icons/obj/guns/cit_guns.dmi'
	icon_state = "magjectile"
	damage = 25
	armour_penetration = 10
	light_range = 2
	light_color = LIGHT_COLOR_RED

/obj/item/projectile/bullet/nlmags //non-lethal boolets
	icon = 'icons/obj/guns/cit_guns.dmi'
	icon_state = "magjectile-nl"
	damage = 2
	knockdown = 15
	stamina = 50
	armour_penetration = -10
	light_range = 2
	light_color = LIGHT_COLOR_BLUE


/////actual ammo/////

/obj/item/ammo_casing/caseless/amags
	desc = "A ferromagnetic slug intended to be launched out of a compatible weapon."
	caliber = "mags"
	icon = 'icons/obj/guns/cit_guns.dmi'
	icon_state = "mag-casing-live"
	projectile_type = /obj/item/projectile/bullet/mags

/obj/item/ammo_casing/caseless/anlmags
	desc = "A specialized ferromagnetic slug designed with a less-than-lethal payload."
	caliber = "mags"
	icon = 'icons/obj/guns/cit_guns.dmi'
	icon_state = "mag-casing-live"
	projectile_type = /obj/item/projectile/bullet/nlmags

//////magazines/////

/obj/item/ammo_box/magazine/mmags
	name = "magpistol magazine (non-lethal disabler)"
	icon = 'icons/obj/guns/cit_guns.dmi'
	icon_state = "nlmagmag"
	origin_tech = "magnets=5"
	ammo_type = /obj/item/ammo_casing/caseless/anlmags
	caliber = "mags"
	max_ammo = 7
	multiple_sprites = 2

/obj/item/ammo_box/magazine/mmags/lethal
	name = "magpistol magazine (lethal)"
	icon = 'icons/obj/guns/cit_guns.dmi'
	icon_state = "smallmagmag"
	origin_tech = "combat=5"
	ammo_type = /obj/item/ammo_casing/caseless/amags

//////the gun itself//////

/obj/item/gun/ballistic/automatic/pistol/mag
	name = "magpistol"
	desc = "A handgun utilizing maglev technologies to propel a ferromagnetic slug to extreme velocities."
	icon = 'icons/obj/guns/cit_guns.dmi'
	icon_state = "magpistol"
	force = 10
	fire_sound = 'sound/weapons/magpistol.ogg'
	mag_type = /obj/item/ammo_box/magazine/mmags
	can_suppress = 0
	casing_ejector = 0
	fire_delay = 5
	origin_tech = "combat=4;magnets=4"

/obj/item/gun/ballistic/automatic/pistol/mag/update_icon()
	..()
	if(magazine)
		cut_overlays()
		add_overlay("magpistol-magazine")
	else
		cut_overlays()
	icon_state = "[initial(icon_state)][chambered ? "" : "-e"]"

///research memes///

/obj/item/gun/ballistic/automatic/pistol/mag/nopin
	pin = null

/datum/design/magpistol
	name = "Magpistol"
	desc = "A weapon which fires ferromagnetic slugs."
	id = "magpisol"
	req_tech = list("combat" = 5, "magnets" = 6, "powerstorage" = 5)
	build_type = PROTOLATHE
	materials = list(MAT_METAL = 7500, MAT_GLASS = 1000, MAT_URANIUM = 1000, MAT_TITANIUM = 5000, MAT_SILVER = 2000)
	build_path = /obj/item/gun/ballistic/automatic/pistol/mag/nopin
	category = list("Weapons")

/datum/design/mag_magpistol
	name = "Magpistol Magazine"
	desc = "A 7 round magazine for the Magpistol."
	id = "mag_magpistol"
	req_tech = list("combat" = 5, "magnets" = 6, "materials" = 5, "syndicate" = 3)
	build_type = PROTOLATHE
	materials = list(MAT_METAL = 4000, MAT_SILVER = 500)
	build_path = /obj/item/ammo_box/magazine/mmags/lethal
	category = list("Ammo")

/datum/design/mag_magpistol/nl
	name = "Magpistol Magazine (Non-Lethal)"
	desc = "A 7 round non-lethal magazine for the Magpistol."
	id = "mag_magpistol_nl"
	req_tech = list("combat" = 5, "magnets" = 6, "materials" = 5)
	materials = list(MAT_METAL = 3000, MAT_SILVER = 250, MAT_TITANIUM = 250)
	build_path = /obj/item/ammo_box/magazine/mmags

//////toy memes/////

/obj/item/projectile/bullet/reusable/foam_dart/mag
	name = "magfoam dart"
	icon = 'icons/obj/guns/cit_guns.dmi'
	icon_state = "magjectile-toy"
	ammo_type = /obj/item/ammo_casing/caseless/foam_dart/mag
	light_range = 2
	light_color = LIGHT_COLOR_YELLOW

/obj/item/ammo_casing/caseless/foam_dart/mag
	name = "magfoam dart"
	desc = "A foam dart with fun light-up projectiles powered by magnets!"
	projectile_type = /obj/item/projectile/bullet/reusable/foam_dart/mag

/obj/item/ammo_box/magazine/internal/shot/toy/mag
	ammo_type = /obj/item/ammo_casing/caseless/foam_dart/mag
	max_ammo = 7

/obj/item/gun/ballistic/shotgun/toy/mag
	name = "foam force magpistol"
	desc = "A fancy toy sold alongside light-up foam force darts. Ages 8 and up."
	icon = 'icons/obj/guns/cit_guns.dmi'
	icon_state = "toymag"
	item_state = "gun"
	mag_type = /obj/item/ammo_box/magazine/internal/shot/toy/mag
	fire_sound = 'sound/weapons/magpistol.ogg'
	slot_flags = SLOT_BELT
	w_class = WEIGHT_CLASS_SMALL

/obj/item/ammo_box/foambox/mag
	name = "ammo box (Magnetic Foam Darts)"
	icon = 'icons/obj/guns/toy.dmi'
	icon_state = "foambox"
	ammo_type = /obj/item/ammo_casing/caseless/foam_dart/mag
	max_ammo = 42

/datum/design/magfoam_dart
	name = "Box of MagFoam Darts"
	id = "magfoam_dart"
	build_type = AUTOLATHE
	materials = list(MAT_METAL = 300, MAT_GLASS = 200)
	build_path = /obj/item/ammo_box/foambox/mag
	category = list("initial", "Misc")

/datum/design/foam_magpistol
	name = "Foam Force Magpistol"
	id = "magfoam_launcher"
	build_type = AUTOLATHE
	materials = list(MAT_METAL = 7500, MAT_GLASS = 1000)
	build_path = /obj/item/gun/ballistic/shotgun/toy/mag
	category = list("hacked", "Misc")
