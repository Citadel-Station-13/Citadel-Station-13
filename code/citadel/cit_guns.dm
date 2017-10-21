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

///toy memes///

/obj/item/ammo_box/magazine/toy/x9
	name = "foam force X9 magazine"
	icon = 'icons/obj/guns/cit_guns.dmi'
	icon_state = "toy9magazine"
	max_ammo = 30
	multiple_sprites = 2

/obj/item/gun/ballistic/automatic/x9/toy
	name = "\improper Foam Force X9"
	desc = "An old but reliable assault rifle made for combat against unknown enemies. Appears to be hastily converted. Ages 8 and up."
	icon = 'icons/obj/guns/cit_guns.dmi'
	icon_state = "toy9"
	can_suppress = 0
	needs_permit = 0
	mag_type = /obj/item/ammo_box/magazine/toy/x9
	casing_ejector = 0
	spread = 45		//MAXIMUM XCOM MEMES (actually that'd be 90 spread)

/datum/design/foam_x9
	name = "Foam Force X9 Rifle"
	id = "foam_x9"
	build_type = AUTOLATHE
	materials = list(MAT_METAL = 20000, MAT_GLASS = 10000)
	build_path = /obj/item/gun/ballistic/automatic/x9/toy
	category = list("hacked", "Misc")


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

/obj/item/ammo_box/magazine/mmag/small
	name = "magpistol magazine (non-lethal disabler)"
	icon = 'icons/obj/guns/cit_guns.dmi'
	icon_state = "nlmagmag"
	origin_tech = "magnets=5"
	ammo_type = /obj/item/ammo_casing/caseless/anlmags
	caliber = "mags"
	max_ammo = 7
	multiple_sprites = 2

/obj/item/ammo_box/magazine/mmag/small/lethal
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
	mag_type = /obj/item/ammo_box/magazine/mmag/small
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
	build_path = /obj/item/ammo_box/magazine/mmag/small/lethal
	category = list("Ammo")

/datum/design/mag_magpistol/nl
	name = "Magpistol Magazine (Non-Lethal)"
	desc = "A 7 round non-lethal magazine for the Magpistol."
	id = "mag_magpistol_nl"
	req_tech = list("combat" = 5, "magnets" = 6, "materials" = 5)
	materials = list(MAT_METAL = 3000, MAT_SILVER = 250, MAT_TITANIUM = 250)
	build_path = /obj/item/ammo_box/magazine/mmag/small

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

//////Magrifle//////

///projectiles///

/obj/item/projectile/bullet/magrifle
	icon = 'icons/obj/guns/cit_guns.dmi'
	icon_state = "magjectile-large"
	damage = 30
	armour_penetration = 25
	light_range = 3
	light_color = LIGHT_COLOR_RED

/obj/item/projectile/bullet/nlmagrifle //non-lethal boolets
	icon = 'icons/obj/guns/cit_guns.dmi'
	icon_state = "magjectile-large-nl"
	damage = 5
	knockdown = 30
	stamina = 75
	armour_penetration = 0
	light_range = 3
	light_color = LIGHT_COLOR_BLUE

///ammo casings///

/obj/item/ammo_casing/caseless/amagm
	desc = "A large ferromagnetic slug intended to be launched out of a compatible weapon."
	caliber = "magm"
	icon = 'icons/obj/guns/cit_guns.dmi'
	icon_state = "mag-casing-live"
	projectile_type = /obj/item/projectile/bullet/magrifle

/obj/item/ammo_casing/caseless/anlmagm
	desc = "A large, specialized ferromagnetic slug designed with a less-than-lethal payload."
	caliber = "magm"
	icon = 'icons/obj/guns/cit_guns.dmi'
	icon_state = "mag-casing-live"
	projectile_type = /obj/item/projectile/bullet/nlmagrifle

///magazines///

/obj/item/ammo_box/magazine/mmag/
	name = "magrifle magazine (non-lethal disabler)"
	icon = 'icons/obj/guns/cit_guns.dmi'
	icon_state = "mediummagmag"
	origin_tech = "magnets=6"
	ammo_type = /obj/item/ammo_casing/caseless/anlmagm
	caliber = "magm"
	max_ammo = 15
	multiple_sprites = 2

/obj/item/ammo_box/magazine/mmag/lethal
	name = "magrifle magazine (lethal)"
	icon = 'icons/obj/guns/cit_guns.dmi'
	icon_state = "mediummagmag"
	origin_tech = "combat=6"
	ammo_type = /obj/item/ammo_casing/caseless/amagm

///the gun itself///

/obj/item/gun/ballistic/automatic/magrifle
	name = "\improper Magnetic Rifle"
	desc = "A simple upscalling of the technologies used in the magpistol, the magrifle is capable of firing slightly larger slugs in bursts. Compatible with the magpistol's slugs."
	icon = 'icons/obj/guns/cit_guns.dmi'
	icon_state = "magrifle"
	item_state = "arg"
	slot_flags = 0
	origin_tech = "combat=6;engineering=6;magnets=6"
	mag_type = /obj/item/ammo_box/magazine/mmag
	fire_sound = 'sound/weapons/magrifle.ogg'
	can_suppress = 0
	burst_size = 3
	fire_delay = 2
	spread = 15
	recoil = 1
	casing_ejector = 0

///research///

/obj/item/gun/ballistic/automatic/magrifle/nopin
	pin = null

/datum/design/magrifle
	name = "Magrifle"
	desc = "An upscaled Magpistol in rifle form."
	id = "magrifle"
	req_tech = list("combat" = 7, "magnets" = 7, "powerstorage" = 7)
	build_type = PROTOLATHE
	materials = list(MAT_METAL = 10000, MAT_GLASS = 2000, MAT_URANIUM = 2000, MAT_TITANIUM = 10000, MAT_SILVER = 4000, MAT_GOLD = 2000)
	build_path = /obj/item/gun/ballistic/automatic/magrifle/nopin
	category = list("Weapons")

/datum/design/mag_magrifle
	name = "Magrifle Magazine (Lethal)"
	desc = "A 15 round magazine for the Magrifle."
	id = "mag_magrifle"
	req_tech = list("combat" = 7, "magnets" = 7, "materials" = 5, "syndicate" = 4)
	build_type = PROTOLATHE
	materials = list(MAT_METAL = 8000, MAT_SILVER = 1000)
	build_path = /obj/item/ammo_box/magazine/mmag/lethal
	category = list("Ammo")

/datum/design/mag_magrifle/nl
	name = "Magrifle Magazine (Non-Lethal)"
	desc = "A 15 round non-lethal magazine for the Magrifle."
	id = "mag_magrifle_nl"
	req_tech = list("combat" = 7, "magnets" = 7, "materials" = 5)
	materials = list(MAT_METAL = 6000, MAT_SILVER = 500, MAT_TITANIUM = 500)
	build_path = /obj/item/ammo_box/magazine/mmag

///foamagrifle///

/obj/item/ammo_box/magazine/toy/foamag
	name = "foam force magrifle magazine"
	icon = 'icons/obj/guns/cit_guns.dmi'
	icon_state = "foamagmag"
	max_ammo = 15
	multiple_sprites = 2
	ammo_type = /obj/item/ammo_casing/caseless/foam_dart/mag

/obj/item/gun/ballistic/automatic/magrifle/toy
	name = "foamag rifle"
	desc = "A foam launching magnetic rifle. Ages 8 and up."
	icon_state = "foamagrifle"
	needs_permit = 0
	mag_type = /obj/item/ammo_box/magazine/toy/foamag
	casing_ejector = FALSE
	origin_tech = "combat=2;engineering=2;magnets=2"

/datum/design/foam_magrifle
	name = "Foam Force MagRifle"
	id = "foam_magrifle"
	build_type = AUTOLATHE
	materials = list(MAT_METAL = 15000, MAT_GLASS = 7500)
	build_path = /obj/item/gun/ballistic/automatic/magrifle/toy
	category = list("hacked", "Misc")


//////Hyper-Burst Rifle//////

///projectiles///

/obj/item/projectile/bullet/mags/hyper
	icon = 'icons/obj/guns/cit_guns.dmi'
	icon_state = "magjectile"
	damage = 10
	armour_penetration = 10
	stamina = 10
	forcedodge = TRUE
	range = 6
	light_range = 1
	light_color = LIGHT_COLOR_RED

/obj/item/projectile/bullet/mags/hyper/inferno
	icon_state = "magjectile-large"
	stamina = 0
	forcedodge = FALSE
	range = 25
	light_range = 4

/obj/item/projectile/bullet/mags/hyper/inferno/on_hit(atom/target, blocked = FALSE)
	..()
	explosion(target, -1, 1, 2, 4, 5)
	return 1

///ammo casings///

/obj/item/ammo_casing/caseless/ahyper
	desc = "A large block of speciallized ferromagnetic material designed to be fired out of the experimental Hyper-Burst Rifle."
	caliber = "hypermag"
	icon = 'icons/obj/guns/cit_guns.dmi'
	icon_state = "hyper-casing-live"
	projectile_type = /obj/item/projectile/bullet/mags/hyper
	pellets = 12
	variance = 40

/obj/item/ammo_casing/caseless/ahyper/inferno
	projectile_type = /obj/item/projectile/bullet/mags/hyper/inferno
	pellets = 1
	variance = 0

///magazines///

/obj/item/ammo_box/magazine/mhyper
	name = "hyper-burst rifle magazine"
	icon = 'icons/obj/guns/cit_guns.dmi'
	icon_state = "hypermag-4"
	ammo_type = /obj/item/ammo_casing/caseless/ahyper
	caliber = "hypermag"
	desc = "A magazine for the Hyper-Burst Rifle. Loaded with a special slug that fragments into 12 smaller shards which can absolutely puncture anything, but has rather short effective range."
	max_ammo = 4

/obj/item/ammo_box/magazine/mhyper/update_icon()
	..()
	icon_state = "hypermag-[ammo_count() ? "4" : "0"]"

/obj/item/ammo_box/magazine/mhyper/inferno
	name = "hyper-burst rifle magazine (inferno)"
	ammo_type = /obj/item/ammo_casing/caseless/ahyper/inferno
	desc = "A magazine for the Hyper-Burst Rifle. Loaded with a special slug that violently reacts with whatever surface it strikes, generating a massive amount of heat and light."

///gun itself///

/obj/item/gun/ballistic/automatic/hyperburst
	name = "\improper Hyper-Burst Rifle"
	desc = "An extremely beefed up version of a stolen Nanotrasen weapon prototype, this 'rifle' is more like a cannon, with an extremely large bore barrel capable of generating several smaller magnetic 'barrels' to simultaneously launch multiple projectiles at once."
	icon = 'icons/obj/guns/cit_guns.dmi'
	icon_state = "hyperburst"
	item_state = "arg"
	slot_flags = 0
	origin_tech = "combat=6;engineering=6;magnets=6;syndicate=6"
	mag_type = /obj/item/ammo_box/magazine/mhyper
	fire_sound = 'sound/weapons/magburst.ogg'
	can_suppress = 0
	burst_size = 1
	fire_delay = 40
	recoil = 2
	casing_ejector = 0
	weapon_weight = WEAPON_HEAVY

/obj/item/gun/ballistic/automatic/hyperburst/update_icon()
	..()
	icon_state = "hyperburst[magazine ? "-[get_ammo()]" : ""][chambered ? "" : "-e"]"

///toy memes///

/obj/item/projectile/beam/lasertag/mag		//the projectile, compatible with regular laser tag armor
	icon = 'icons/obj/guns/cit_guns.dmi'
	icon_state = "magjectile-toy"
	name = "lasertag magbolt"
	forcedodge = TRUE		//for penetration memes
	range = 5		//so it isn't super annoying
	light_range = 2
	light_color = LIGHT_COLOR_YELLOW
	eyeblur = 0

/obj/item/ammo_casing/energy/laser/magtag
	projectile_type = /obj/item/projectile/beam/lasertag/mag
	select_name = "magtag"
	pellets = 3
	variance = 30
	e_cost = 1000
	fire_sound = 'sound/weapons/magburst.ogg'

/obj/item/gun/energy/laser/practice/hyperburst
	name = "toy hyper-burst launcher"
	desc = "A toy laser with a unique beam shaping lens that projects harmless bolts capable of going through objects. Compatible with existing laser tag systems."
	ammo_type = list(/obj/item/ammo_casing/energy/laser/magtag)
	icon = 'icons/obj/guns/cit_guns.dmi'
	icon_state = "toyburst"
	clumsy_check = FALSE
	needs_permit = FALSE
	fire_delay = 40
	weapon_weight = WEAPON_HEAVY
	selfcharge = TRUE
	charge_delay = 2
	recoil = 2
	cell_type = /obj/item/stock_parts/cell/toymagburst

/obj/item/stock_parts/cell/toymagburst
	name = "toy mag burst rifle power supply"
	maxcharge = 4000

/datum/design/foam_hyperburst
	name = "MagTag Hyper Rifle"
	id = "foam_hyperburst"
	build_type = AUTOLATHE
	materials = list(MAT_METAL = 35000, MAT_GLASS = 15000)
	build_path = /obj/item/gun/energy/laser/practice/hyperburst
	category = list("hacked", "Misc")

/*		made redundant by reskinnable stetchkins
//////Stealth Pistol//////

/obj/item/gun/ballistic/automatic/pistol/stealth
	name = "stealth pistol"
	desc = "A unique bullpup pistol with a compact frame. Has an integrated surpressor."
	icon = 'icons/obj/guns/cit_guns.dmi'
	icon_state = "stealthpistol"
	w_class = WEIGHT_CLASS_SMALL
	origin_tech = "combat=3;materials=3;syndicate=4"
	mag_type = /obj/item/ammo_box/magazine/m10mm
	can_suppress = 0
	fire_sound = 'sound/weapons/gunshot_silenced.ogg'
	suppressed = 1
	burst_size = 1

/obj/item/gun/ballistic/automatic/pistol/stealth/update_icon()
	..()
	if(magazine)
		cut_overlays()
		add_overlay("stealthpistol-magazine")
	else
		cut_overlays()
	icon_state = "[initial(icon_state)][chambered ? "" : "-e"]"

*/

///foam stealth pistol///

/obj/item/gun/ballistic/automatic/toy/pistol/stealth
	name = "foam force stealth pistol"
	desc = "A small, easily concealable toy bullpup handgun. Ages 8 and up."
	icon = 'icons/obj/guns/cit_guns.dmi'
	icon_state = "foamsp"
	w_class = WEIGHT_CLASS_SMALL
	mag_type = /obj/item/ammo_box/magazine/toy/pistol
	can_suppress = FALSE
	fire_sound = 'sound/weapons/gunshot_silenced.ogg'
	suppressed = TRUE
	burst_size = 1
	fire_delay = 0
	actions_types = list()

/obj/item/gun/ballistic/automatic/toy/pistol/stealth/update_icon()
	..()
	if(magazine)
		cut_overlays()
		add_overlay("foamsp-magazine")
	else
		cut_overlays()
	icon_state = "[initial(icon_state)][chambered ? "" : "-e"]"

/datum/design/foam_sp
	name = "Foam Force Stealth Pistol"
	id = "foam_sp"
	build_type = AUTOLATHE
	materials = list(MAT_METAL = 15000, MAT_GLASS = 1000)
	build_path = /obj/item/gun/ballistic/automatic/toy/pistol/stealth
	category = list("hacked", "Misc")


//////10mm soporific bullets//////

obj/item/projectile/bullet/c10mm/soporific
	name ="10mm soporific bullet"
	armour_penetration = 0
	nodamage = TRUE
	dismemberment = 0
	knockdown = 0

/obj/item/projectile/bullet/c10mm/soporific/on_hit(atom/target, blocked = FALSE)
	if((blocked != 100) && isliving(target))
		var/mob/living/L = target
		L.blur_eyes(6)
		if(L.staminaloss >= 60)
			L.Sleeping(250)
		else
			L.adjustStaminaLoss(25)
	return 1

/obj/item/ammo_casing/c10mm/soporific
	name = ".10mm soporific bullet casing"
	desc = "A 10mm soporific bullet casing."
	projectile_type = /obj/item/projectile/bullet/c10mm/soporific

/obj/item/ammo_box/magazine/m10mm/soporific
	name = "pistol magazine (10mm soporific)"
	icon = 'icons/obj/guns/cit_guns.dmi'
	icon_state = "9x19pS"
	desc = "A gun magazine. Loaded with rounds which inject the target with a variety of illegal substances to induce sleep in the target."
	ammo_type = /obj/item/ammo_casing/c10mm/soporific

/obj/item/ammo_box/c10mm/soporific
	name = "ammo box (10mm soporific)"
	ammo_type = /obj/item/ammo_casing/c10mm/soporific
	max_ammo = 24

//////Flechette Launcher//////

///projectiles///

/obj/item/projectile/bullet/cflechetteap	//shreds armor
	name = "flechette (armor piercing)"
	damage = 8
	armour_penetration = 80

/obj/item/projectile/bullet/cflechettes		//shreds flesh and forces bleeding
	name = "flechette (serrated)"
	damage = 8
	dismemberment = 10
	armour_penetration = -80

/obj/item/projectile/bullet/cflechettes/on_hit(atom/target, blocked = FALSE)
	if((blocked != 100) && iscarbon(target))
		var/mob/living/carbon/C = target
		C.bleed(10)
	return ..()

///ammo casings (CASELESS AMMO CASINGS WOOOOOOOO)///

/obj/item/ammo_casing/caseless/flechetteap
	name = "flechette (armor piercing)"
	desc = "A flechette made with a tungsten alloy."
	projectile_type = /obj/item/projectile/bullet/cflechetteap
	caliber = "flechette"
	throwforce = 1
	throw_speed = 3

/obj/item/ammo_casing/caseless/flechettes
	name = "flechette (serrated)"
	desc = "A serrated flechette made of a special alloy intended to deform drastically upon penetration of human flesh."
	projectile_type = /obj/item/projectile/bullet/cflechettes
	caliber = "flechette"
	throwforce = 2
	throw_speed = 3
	embed_chance = 75

///magazine///

/obj/item/ammo_box/magazine/flechette
	name = "flechette magazine (armor piercing)"
	icon = 'icons/obj/guns/cit_guns.dmi'
	icon_state = "flechettemag"
	origin_tech = "combat=5;syndicate=1"
	ammo_type = /obj/item/ammo_casing/caseless/flechetteap
	caliber = "flechette"
	max_ammo = 40
	multiple_sprites = 2

/obj/item/ammo_box/magazine/flechette/s
	name = "flechette magazine (serrated)"
	ammo_type = /obj/item/ammo_casing/caseless/flechettes

///the gun itself///

/obj/item/gun/ballistic/automatic/flechette
	name = "\improper CX Flechette Launcher"
	desc = "A flechette launching machine pistol with an unconventional bullpup frame."
	icon = 'icons/obj/guns/cit_guns.dmi'
	icon_state = "flechettegun"
	item_state = "gun"
	w_class = WEIGHT_CLASS_NORMAL
	slot_flags = 0
	/obj/item/device/firing_pin/implant/pindicate
	origin_tech = "combat=6;materials=2;syndicate=5"
	mag_type = /obj/item/ammo_box/magazine/flechette/
	fire_sound = 'sound/weapons/gunshot_smg.ogg'
	can_suppress = 0
	burst_size = 5
	fire_delay = 1
	casing_ejector = 0
	spread = 20

/obj/item/gun/ballistic/automatic/flechette/update_icon()
	..()
	if(magazine)
		cut_overlays()
		add_overlay("flechettegun-magazine")
	else
		cut_overlays()
	icon_state = "[initial(icon_state)][chambered ? "" : "-e"]"

///unique variant///

/obj/item/projectile/bullet/cflechetteshredder
	name = "flechette (shredder)"
	damage = 5
	dismemberment = 40

/obj/item/ammo_casing/caseless/flechetteshredder
	name = "flechette (shredder)"
	desc = "A serrated flechette made of a special alloy that forms a monofilament edge."
	projectile_type = /obj/item/projectile/bullet/cflechettes

/obj/item/ammo_box/magazine/flechette/shredder
	name = "flechette magazine (shredder)"
	icon_state = "shreddermag"
	ammo_type = /obj/item/ammo_casing/caseless/flechetteshredder

/obj/item/gun/ballistic/automatic/flechette/shredder
	name = "\improper CX Shredder"
	desc = "A flechette launching machine pistol made of ultra-light CFRP optimized for firing serrated monofillament flechettes."
	w_class = WEIGHT_CLASS_SMALL
	mag_type = /obj/item/ammo_box/magazine/flechette/shredder
	spread = 30

/obj/item/gun/ballistic/automatic/flechette/shredder/update_icon()
	..()
	if(magazine)
		cut_overlays()
		add_overlay("shreddergun-magazine")
	else
		cut_overlays()
	icon_state = "[initial(icon_state)][chambered ? "" : "-e"]"

//////modular pistol////// (reskinnable stetchkins)

/obj/item/gun/ballistic/automatic/pistol/modular
	name = "modular pistol"
	desc = "A small, easily concealable 10mm handgun. Has a threaded barrel for suppressors."
	icon = 'icons/obj/guns/cit_guns.dmi'
	icon_state = "cde"
	can_unsuppress = TRUE
	unique_rename = TRUE
	unique_reskin = list("Default" = "cde",
						"NT-99" = "n99",
						"Stealth" = "stealthpistol",
						"HKVP-78" = "vp78",
						"Luger" = "p08b",
						"Mk.58" = "secguncomp",
						"PX4 Storm" = "px4"
						)

/obj/item/gun/ballistic/automatic/pistol/modular/update_icon()
	..()
	if(current_skin)
		icon_state = "[unique_reskin[current_skin]][chambered ? "" : "-e"][suppressed ? "-suppressed" : ""]"
	else
		icon_state = "[initial(icon_state)][chambered ? "" : "-e"][suppressed ? "-suppressed" : ""]"
	if(magazine && suppressed)
		cut_overlays()
		add_overlay("[unique_reskin[current_skin]]-magazine-sup")	//Yes, this means the default iconstate can't have a magazine overlay
	else if (magazine)
		cut_overlays()
		add_overlay("[unique_reskin[current_skin]]-magazine")
	else
		cut_overlays()

/////////RAYGUN MEMES/////////

/obj/item/projectile/beam/lasertag/ray		//the projectile, compatible with regular laser tag armor
	icon = 'icons/obj/guns/cit_guns.dmi'
	icon_state = "ray"
	name = "ray bolt"
	eyeblur = 0

/obj/item/ammo_casing/energy/laser/raytag
	projectile_type = /obj/item/projectile/beam/lasertag/ray
	select_name = "raytag"
	fire_sound = 'sound/weapons/raygun.ogg'

/obj/item/gun/energy/laser/practice/raygun
	name = "toy ray gun"
	icon = 'icons/obj/guns/cit_guns.dmi'
	icon_state = "raygun"
	desc = "A toy laser with a classic, retro feel and look. Compatible with existing laser tag systems."
	ammo_type = list(/obj/item/ammo_casing/energy/laser/raytag)
	selfcharge = TRUE

/datum/design/toyray
	name = "RayTag Gun"
	id = "toyray"
	build_type = AUTOLATHE
	materials = list(MAT_METAL = 7500, MAT_GLASS = 1000)
	build_path = /obj/item/gun/energy/laser/practice/raygun
	category = list("hacked", "Misc")
