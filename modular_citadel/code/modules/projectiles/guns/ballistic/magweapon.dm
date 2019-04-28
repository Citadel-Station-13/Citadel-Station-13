//Stollen vars so this all work for real - Copy pasted addtion

/obj/item/ammo_casing/mag/
	var/e_cost = 50

/obj/item/gun/mag
	var/obj/item/stock_parts/cell/cell //What type of power cell this uses
	var/cell_type = /obj/item/stock_parts/cell
	var/modifystate = 0
	var/list/ammo_type = list(/obj/item/ammo_casing/mag)
	var/can_charge = 1 //Can it be charged in a recharger?
	var/charge_sections = 4
	ammo_x_offset = 2
	var/old_ratio = 0 // stores the gun's previous ammo "ratio" to see if it needs an updated iconn
	var/charge_tick = 0
	var/charge_delay = 4
	var/dead_cell = FALSE //set to true so the gun is given an empty cell
	var/spawnwithmagazine = TRUE
	var/mag_type = /obj/item/ammo_box/magazine/m10mm //Removes the need for max_ammo and caliber info
	var/obj/item/ammo_box/magazine/magazine
	var/casing_ejector = TRUE //whether the gun ejects the chambered casing

/obj/item/gun/mag/Initialize()
	. = ..()
	if(!spawnwithmagazine)
		update_icon()
		return
	if (!magazine)
		magazine = new mag_type(src)
	chamber_round()
	update_icon()

/obj/item/gun/mag/process_chamber(empty_chamber = 1)
	var/obj/item/ammo_casing/AC = chambered //Find chambered round
	if(istype(AC)) //there's a chambered round
		if(casing_ejector)
			AC.forceMove(drop_location()) //Eject casing onto ground.
			AC.bounce_away(TRUE)
			chambered = null
		else if(empty_chamber)
			chambered = null
	chamber_round()

/obj/item/gun/mag/proc/chamber_round()
	if (chambered || !magazine)
		return
	else if (magazine.ammo_count())
		chambered = magazine.get_round()
		chambered.forceMove(src)

/obj/item/gun/mag/can_shoot()
	if(!magazine || !magazine.ammo_count(0))
		return 0
	return 1

/obj/item/gun/mag/attackby(obj/item/A, mob/user, params)
	..()
	if (istype(A, /obj/item/ammo_box/magazine))
		var/obj/item/ammo_box/magazine/AM = A
		if (!magazine && istype(AM, mag_type))
			if(user.transferItemToLoc(AM, src))
				magazine = AM
				to_chat(user, "<span class='notice'>You load a new magazine into \the [src].</span>")
				if(magazine.ammo_count())
					playsound(src, "gun_insert_full_magazine", 70, 1)
					if(!chambered)
						chamber_round()
						addtimer(CALLBACK(GLOBAL_PROC, .proc/playsound, src, 'sound/weapons/gun_chamber_round.ogg', 100, 1), 3)
				else
					playsound(src, "gun_insert_empty_magazine", 70, 1)
				A.update_icon()
				update_icon()
				return 1
			else
				to_chat(user, "<span class='warning'>You cannot seem to get \the [src] out of your hands!</span>")
				return
		else if (magazine)
			to_chat(user, "<span class='notice'>There's already a magazine in \the [src].</span>")

//ATTACK HAND IGNORING PARENT RETURN VALUE

/obj/item/gun/mag/attack_self(mob/living/user)
	var/obj/item/ammo_casing/AC = chambered //Find chambered round
	if(magazine)
		magazine.forceMove(drop_location())
		user.put_in_hands(magazine)
		magazine.update_icon()
		if(magazine.ammo_count())
			playsound(src, 'sound/weapons/gun_magazine_remove_full.ogg', 70, 1)
		else
			playsound(src, "gun_remove_empty_magazine", 70, 1)
		magazine = null
		to_chat(user, "<span class='notice'>You pull the magazine out of \the [src].</span>")
	else if(chambered)
		AC.forceMove(drop_location())
		AC.bounce_away()
		chambered = null
		to_chat(user, "<span class='notice'>You unload the round from \the [src]'s chamber.</span>")
		playsound(src, "gun_slide_lock", 70, 1)
	else
		to_chat(user, "<span class='notice'>There's no magazine in \the [src].</span>")
	update_icon()
	return


/obj/item/gun/mag/examine(mob/user)
	..()
	to_chat(user, "It has [get_ammo()] round\s remaining.")

/obj/item/gun/mag/proc/get_ammo(countchambered = 1)
	var/boolets = 0 //mature var names for mature people
	if (chambered && countchambered)
		boolets++
	if (magazine)
		boolets += magazine.ammo_count()
	return boolets

/obj/item/gun/mag/emp_act(severity)
	. = ..()
	if(!(. & EMP_PROTECT_CONTENTS))
		cell.use(round(cell.charge / severity))
		recharge_newshot() //and try to charge a new shot

/obj/item/gun/mag/get_cell()
	return cell

/obj/item/gun/mag/Initialize()
	. = ..()
	if(cell_type)
		cell = new cell_type(src)
	else
		cell = new(src)
	if(!dead_cell)
		cell.give(cell.maxcharge)
	update_ammo_types()
	recharge_newshot(TRUE)

/obj/item/gun/mag/proc/update_ammo_types()
	var/obj/item/ammo_casing/mag/shot
	for (var/i = 1, i <= ammo_type.len, i++)
		var/shottype = ammo_type[i]
		shot = new shottype(src)
		ammo_type[i] = shot
	fire_sound = shot.fire_sound
	fire_delay = shot.delay

/obj/item/gun/mag/Destroy()
	QDEL_NULL(cell)
	STOP_PROCESSING(SSobj, src)
	return ..()

/obj/item/gun/mag/can_shoot()
	var/obj/item/ammo_casing/mag/mag = ammo_type
	return !QDELETED(cell) ? (cell.charge >= mag.e_cost) : FALSE

/obj/item/gun/mag/recharge_newshot(no_cyborg_drain)
	if (!ammo_type || !cell)
		return
	if(!chambered)
		var/obj/item/ammo_casing/energy/AC = ammo_type
		if(cell.charge >= AC.e_cost) //if there's enough power in the cell cell...
			chambered = AC //...prepare a new shot based on the current ammo type selected
			if(!chambered.BB)
				chambered.newshot()

/obj/item/gun/mag/process_chamber()
	if(chambered && !chambered.BB) //if BB is null, i.e the shot has been fired...
		var/obj/item/ammo_casing/mag/mag = chambered
		cell.use(mag.e_cost)//... drain the cell cell
	chambered = null //either way, released the prepared shot
	recharge_newshot() //try to charge a new shot

/obj/item/gun/mag/update_icon(force_update)
	if(QDELETED(src))
		return
	..()
	var/ratio = CEILING(CLAMP(cell.charge / cell.maxcharge, 0, 1) * charge_sections, 1)
	if(ratio == old_ratio && !force_update)
		return
	old_ratio = ratio
	cut_overlays()

///////XCOM X9 AR///////

/obj/item/gun/ballistic/automatic/x9	//will be adminspawn only so ERT or something can use them
	name = "\improper X9 Assault Rifle"
	desc = "A rather old design of a cheap, reliable assault rifle made for combat against unknown enemies. Uses 5.56mm ammo."
	icon = 'modular_citadel/icons/obj/guns/cit_guns.dmi'
	icon_state = "x9"
	item_state = "arg"
	slot_flags = 0
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
	icon = 'modular_citadel/icons/obj/guns/cit_guns.dmi'
	icon_state = "toy9magazine"
	max_ammo = 30
	multiple_sprites = 2
	materials = list(MAT_METAL = 200)

/obj/item/gun/ballistic/automatic/x9/toy
	name = "\improper Foam Force X9"
	desc = "An old but reliable assault rifle made for combat against unknown enemies. Appears to be hastily converted. Ages 8 and up."
	icon = 'modular_citadel/icons/obj/guns/cit_guns.dmi'
	icon_state = "toy9"
	can_suppress = 0
	obj_flags = 0
	mag_type = /obj/item/ammo_box/magazine/toy/x9
	casing_ejector = 0
	spread = 90		//MAXIMUM XCOM MEMES (actually that'd be 180 spread)
	w_class = WEIGHT_CLASS_BULKY
	weapon_weight = WEAPON_HEAVY

////////XCOM2 Magpistol/////////

//////projectiles//////

/obj/item/projectile/bullet/mags
	icon = 'modular_citadel/icons/obj/guns/cit_guns.dmi'
	icon_state = "magjectile"
	damage = 15
	armour_penetration = 10
	light_range = 2
	speed = 0.6
	range = 25
	light_color = LIGHT_COLOR_RED

/obj/item/projectile/bullet/nlmags //non-lethal boolets
	icon = 'modular_citadel/icons/obj/guns/cit_guns.dmi'
	icon_state = "magjectile-nl"
	damage = 2
	knockdown = 0
	stamina = 25
	armour_penetration = -10
	light_range = 2
	speed = 0.7
	range = 25
	light_color = LIGHT_COLOR_BLUE


/////actual ammo/////

/obj/item/ammo_casing/mag/amags
	desc = "A ferromagnetic slug intended to be launched out of a compatible weapon."
	caliber = "mags"
	icon = 'modular_citadel/icons/obj/guns/cit_guns.dmi'
	icon_state = "mag-casing-live"
	e_cost = 50
	projectile_type = /obj/item/projectile/bullet/mags

/obj/item/ammo_casing/mag/anlmags
	desc = "A specialized ferromagnetic slug designed with a less-than-lethal payload."
	caliber = "mags"
	icon = 'modular_citadel/icons/obj/guns/cit_guns.dmi'
	icon_state = "mag-casing-live"
	e_cost = 50
	projectile_type = /obj/item/projectile/bullet/nlmags

//////magazines/////

/obj/item/ammo_box/magazine/mmag/small
	name = "magpistol magazine (non-lethal disabler)"
	icon = 'modular_citadel/icons/obj/guns/cit_guns.dmi'
	icon_state = "nlmagmag"
	ammo_type = /obj/item/ammo_casing/mag/anlmags
	caliber = "mags"
	max_ammo = 15
	multiple_sprites = 2

/obj/item/ammo_box/magazine/mmag/small/lethal
	name = "magpistol magazine (lethal)"
	icon = 'modular_citadel/icons/obj/guns/cit_guns.dmi'
	icon_state = "smallmagmag"
	ammo_type = /obj/item/ammo_casing/mag/amags

//////the gun itself//////

/obj/item/gun/ballistic/mag/pistol/mag
	name = "magpistol"
	desc = "A handgun utilizing maglev technologies to propel a ferromagnetic slug to extreme velocities."
	icon = 'modular_citadel/icons/obj/guns/cit_guns.dmi'
	icon_state = "magpistol"
	force = 10
	fire_sound = 'sound/weapons/magpistol.ogg'
	mag_type = /obj/item/ammo_box/magazine/mmag/small
//	cell_type = /obj/item/stock_parts/cell/magpistal
	can_suppress = 0
	casing_ejector = 0
	fire_delay = 2
	recoil = 0.2

/obj/item/gun/mag/automatic/pistol/mag/update_icon()
	..()
	if(magazine)
		cut_overlays()
		add_overlay("magpistol-magazine")
	else
		cut_overlays()
	icon_state = "[initial(icon_state)][chambered ? "" : "-e"]"

//////the cell////////////

/obj/item/stock_parts/cell/magpistal
	name = "magpistal hyper power cell"
	desc = "A small hyper cell, used in the mag pistal"
	maxcharge = 3500 //70 shots before recharge

///research memes///

/obj/item/gun/mag/automatic/pistol/mag/nopin
	pin = null
	spawnwithmagazine = FALSE

/datum/design/magpistol
	name = "Magpistol"
	desc = "A weapon which fires ferromagnetic slugs."
	id = "magpisol"
	build_type = PROTOLATHE
	materials = list(MAT_METAL = 7500, MAT_GLASS = 1000, MAT_URANIUM = 1000, MAT_TITANIUM = 5000, MAT_SILVER = 2000)
	build_path = /obj/item/gun/mag/automatic/pistol/mag/nopin
	category = list("Weapons")
	departmental_flags = DEPARTMENTAL_FLAG_SECURITY

/datum/design/mag_magpistol
	name = "Magpistol Magazine"
	desc = "A 14 round magazine for the Magpistol."
	id = "mag_magpistol"
	build_type = PROTOLATHE
	materials = list(MAT_METAL = 4000, MAT_SILVER = 500)
	build_path = /obj/item/ammo_box/magazine/mmag/small/lethal
	category = list("Ammo")
	departmental_flags = DEPARTMENTAL_FLAG_SECURITY

/datum/design/mag_magpistol/nl
	name = "Magpistol Magazine (Non-Lethal)"
	desc = "A 14 round non-lethal magazine for the Magpistol."
	id = "mag_magpistol_nl"
	materials = list(MAT_METAL = 3000, MAT_SILVER = 250, MAT_TITANIUM = 250)
	build_path = /obj/item/ammo_box/magazine/mmag/small
	departmental_flags = DEPARTMENTAL_FLAG_SECURITY

//////toy memes/////

/obj/item/projectile/bullet/reusable/foam_dart/mag
	name = "magfoam dart"
	icon = 'modular_citadel/icons/obj/guns/cit_guns.dmi'
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
	max_ammo = 14

/obj/item/gun/ballistic/shotgun/toy/mag
	name = "foam force magpistol"
	desc = "A fancy toy sold alongside light-up foam force darts. Ages 8 and up."
	icon = 'modular_citadel/icons/obj/guns/cit_guns.dmi'
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

//////Magrifle//////

///projectiles///

/obj/item/projectile/bullet/magrifle
	icon = 'modular_citadel/icons/obj/guns/cit_guns.dmi'
	icon_state = "magjectile-large"
	damage = 20
	armour_penetration = 25
	light_range = 3
	speed = 0.7
	range = 35
	light_color = LIGHT_COLOR_RED

/obj/item/projectile/bullet/nlmagrifle //non-lethal boolets
	icon = 'modular_citadel/icons/obj/guns/cit_guns.dmi'
	icon_state = "magjectile-large-nl"
	damage = 2
	knockdown = 0
	stamina = 25
	armour_penetration = -10
	light_range = 3
	speed = 0.65
	range = 35
	light_color = LIGHT_COLOR_BLUE

///ammo casings///

/obj/item/ammo_casing/energy/mag/amagm
	desc = "A large ferromagnetic slug intended to be launched out of a compatible weapon."
	caliber = "magm"
	icon = 'modular_citadel/icons/obj/guns/cit_guns.dmi'
	icon_state = "mag-casing-live"
	e_cost = 50
	projectile_type = /obj/item/projectile/bullet/magrifle

/obj/item/ammo_casing/energy/mag/anlmagm
	desc = "A large, specialized ferromagnetic slug designed with a less-than-lethal payload."
	caliber = "magm"
	icon = 'modular_citadel/icons/obj/guns/cit_guns.dmi'
	icon_state = "mag-casing-live"
	e_cost = 50
	projectile_type = /obj/item/projectile/bullet/nlmagrifle

///magazines///

/obj/item/ammo_box/magazine/mmag/
	name = "magrifle magazine (non-lethal disabler)"
	icon = 'modular_citadel/icons/obj/guns/cit_guns.dmi'
	icon_state = "mediummagmag"
	ammo_type = /obj/item/ammo_casing/energy/mag/anlmagm
	caliber = "magm"
	max_ammo = 24
	multiple_sprites = 2

/obj/item/ammo_box/magazine/mmag/lethal
	name = "magrifle magazine (lethal)"
	icon = 'modular_citadel/icons/obj/guns/cit_guns.dmi'
	icon_state = "mediummagmag"
	ammo_type = /obj/item/ammo_casing/energy/mag/amagm
	max_ammo = 24

///the gun itself///

/obj/item/gun/mag/automatic/magrifle
	name = "\improper Magnetic Rifle"
	desc = "A simple upscalling of the technologies used in the magpistol, the magrifle is capable of firing slightly larger slugs in bursts. Compatible with the magpistol's slugs."
	icon = 'modular_citadel/icons/obj/guns/cit_guns.dmi'
	icon_state = "magrifle"
	item_state = "arg"
	slot_flags = 0
	cell_type = /obj/item/stock_parts/cell/magrifle
	mag_type = /obj/item/ammo_box/magazine/mmag
	fire_sound = 'sound/weapons/magrifle.ogg'
	can_suppress = 0
	burst_size = 3
	fire_delay = 2
	spread = 5
	recoil = 0.15
	casing_ejector = 0

//////the cell////////////

/obj/item/stock_parts/cell/magrifle
	name = "magrifle hyper power cell"
	desc = "A small hyper cell, used in the mag rifle"
	maxcharge = 2400 //48 shots before recharge

///research///

/obj/item/gun/ballistic/automatic/magrifle/nopin
	pin = null
	spawnwithmagazine = FALSE

/datum/design/magrifle
	name = "Magrifle"
	desc = "An upscaled Magpistol in rifle form."
	id = "magrifle"
	build_type = PROTOLATHE
	materials = list(MAT_METAL = 10000, MAT_GLASS = 2000, MAT_URANIUM = 2000, MAT_TITANIUM = 10000, MAT_SILVER = 4000, MAT_GOLD = 2000)
	build_path = /obj/item/gun/ballistic/automatic/magrifle/nopin
	category = list("Weapons")
	departmental_flags = DEPARTMENTAL_FLAG_SECURITY

/datum/design/mag_magrifle
	name = "Magrifle Magazine (Lethal)"
	desc = "A 24-round magazine for the Magrifle."
	id = "mag_magrifle"
	build_type = PROTOLATHE
	materials = list(MAT_METAL = 8000, MAT_SILVER = 1000)
	build_path = /obj/item/ammo_box/magazine/mmag/lethal
	category = list("Ammo")
	departmental_flags = DEPARTMENTAL_FLAG_SECURITY

/datum/design/mag_magrifle/nl
	name = "Magrifle Magazine (Non-Lethal)"
	desc = "A 24- round non-lethal magazine for the Magrifle."
	id = "mag_magrifle_nl"
	materials = list(MAT_METAL = 6000, MAT_SILVER = 500, MAT_TITANIUM = 500)
	build_path = /obj/item/ammo_box/magazine/mmag
	departmental_flags = DEPARTMENTAL_FLAG_SECURITY

///foamagrifle///

/obj/item/ammo_box/magazine/toy/foamag
	name = "foam force magrifle magazine"
	icon = 'modular_citadel/icons/obj/guns/cit_guns.dmi'
	icon_state = "foamagmag"
	max_ammo = 24
	multiple_sprites = 2
	ammo_type = /obj/item/ammo_casing/caseless/foam_dart/mag
	materials = list(MAT_METAL = 200)

/obj/item/gun/ballistic/automatic/magrifle/toy
	name = "foamag rifle"
	desc = "A foam launching magnetic rifle. Ages 8 and up."
	icon_state = "foamagrifle"
	obj_flags = 0
	mag_type = /obj/item/ammo_box/magazine/toy/foamag
	casing_ejector = FALSE
	spread = 60
	w_class = WEIGHT_CLASS_BULKY
	weapon_weight = WEAPON_HEAVY

/*
// TECHWEBS IMPLEMENTATION
*/

/datum/techweb_node/magnetic_weapons
	id = "magnetic_weapons"
	display_name = "Magnetic Weapons"
	description = "Weapons using magnetic technology"
	prereq_ids = list("weaponry", "adv_weaponry", "emp_adv")
	design_ids = list("magrifle", "magpisol", "mag_magrifle", "mag_magrifle_nl", "mag_magpistol", "mag_magpistol_nl")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 2500)
	export_price = 5000


//////Hyper-Burst Rifle//////

///projectiles///

/obj/item/projectile/bullet/mags/hyper
	icon = 'modular_citadel/icons/obj/guns/cit_guns.dmi'
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
	icon = 'modular_citadel/icons/obj/guns/cit_guns.dmi'
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
	icon = 'modular_citadel/icons/obj/guns/cit_guns.dmi'
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
	icon = 'modular_citadel/icons/obj/guns/cit_guns.dmi'
	icon_state = "hyperburst"
	item_state = "arg"
	slot_flags = 0
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
	icon = 'modular_citadel/icons/obj/guns/cit_guns.dmi'
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
	icon = 'modular_citadel/icons/obj/guns/cit_guns.dmi'
	icon_state = "toyburst"
	clumsy_check = FALSE
	obj_flags = 0
	fire_delay = 40
	weapon_weight = WEAPON_HEAVY
	selfcharge = EGUN_SELFCHARGE
	charge_delay = 2
	recoil = 2
	cell_type = /obj/item/stock_parts/cell/toymagburst

/obj/item/stock_parts/cell/toymagburst
	name = "toy mag burst rifle power supply"
	maxcharge = 4000
