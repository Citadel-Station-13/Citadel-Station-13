///ammo///

/obj/item/ammo_casing/caseless/mag_e
	var/energy_cost = 0

/obj/item/ammo_casing/caseless/mag_e/amagm_e
	desc = "A large ferromagnetic slug intended to be launched out of a compatible weapon."
	caliber = "mag_e"
	icon = 'modular_citadel/icons/obj/guns/cit_guns.dmi'
	icon_state = "mag-casing-live"
	projectile_type = /obj/item/projectile/bullet/magrifle
	energy_cost = 200

/obj/item/ammo_casing/caseless/mag_e/anlmagm_e
	desc = "A large, specialized ferromagnetic slug designed with a less-than-lethal payload."
	caliber = "mag_e"
	icon = 'modular_citadel/icons/obj/guns/cit_guns.dmi'
	icon_state = "mag-casing-live"
	projectile_type = /obj/item/projectile/bullet/nlmagrifle
	energy_cost = 200

/obj/item/ammo_casing/caseless/mag_e/amags
	desc = "A ferromagnetic slug intended to be launched out of a compatible weapon."
	caliber = "mag_e"
	icon = 'modular_citadel/icons/obj/guns/cit_guns.dmi'
	icon_state = "mag-casing-live"
	projectile_type = /obj/item/projectile/bullet/mags
	energy_cost = 125

/obj/item/ammo_casing/caseless/mag_e/anlmags
	desc = "A specialized ferromagnetic slug designed with a less-than-lethal payload."
	caliber = "mag_e"
	icon = 'modular_citadel/icons/obj/guns/cit_guns.dmi'
	icon_state = "mag-casing-live"
	projectile_type = /obj/item/projectile/bullet/nlmags
	energy_cost = 125

///magazines///

/obj/item/ammo_box/magazine/mmag_e/
	name = "magrifle magazine (non-lethal disabler)"
	icon = 'modular_citadel/icons/obj/guns/cit_guns.dmi'
	icon_state = "mediummagmag"
	ammo_type = /obj/item/ammo_casing/caseless/mag_e/anlmagm_e
	caliber = "mag_e"
	max_ammo = 24
	multiple_sprites = 2

/obj/item/ammo_box/magazine/mmag_e/lethal
	name = "magrifle magazine (lethal)"
	icon = 'modular_citadel/icons/obj/guns/cit_guns.dmi'
	icon_state = "mediummagmag"
	ammo_type = /obj/item/ammo_casing/caseless/mag_e/amagm_e
	max_ammo = 24

/obj/item/ammo_box/magazine/mmag_e/small
	name = "magpistol magazine (non-lethal disabler)"
	icon = 'modular_citadel/icons/obj/guns/cit_guns.dmi'
	icon_state = "smallmagmag"
	ammo_type = /obj/item/ammo_casing/caseless/mag_e/anlmags
	caliber = "mag_e"
	max_ammo = 16
	multiple_sprites = 2

/obj/item/ammo_box/magazine/mmag_e/small/lethal
	name = "magpistol magazine (lethal)"
	icon = 'modular_citadel/icons/obj/guns/cit_guns.dmi'
	icon_state = "smallmagmag"
	ammo_type = /obj/item/ammo_casing/caseless/mag_e/amags
	max_ammo = 16

///cells///

/obj/item/stock_parts/cell/magrifle_e
	name = "magrifle power supply"
	maxcharge = 14400
	chargerate = 3520

/obj/item/stock_parts/cell/magpistol_e
	name = "magpistol power supply"
	maxcharge = 6000
	chargerate = 1000

///sci designs///

/datum/design/magrifle_e
	name = "Magrifle"
	desc = "An upscaled Magpistol in rifle form."
	id = "magrifle_e"
	build_type = PROTOLATHE
	materials = list(MAT_METAL = 10000, MAT_GLASS = 2000, MAT_URANIUM = 2000, MAT_TITANIUM = 10000, MAT_SILVER = 4000, MAT_GOLD = 2000)
	build_path = /obj/item/gun/ballistic/automatic/magrifle_e/nopin
	category = list("Weapons")
	departmental_flags = DEPARTMENTAL_FLAG_SECURITY

/datum/design/mag_magrifle_e
	name = "Magrifle Magazine (Lethal)"
	desc = "A 24-round magazine for the Magrifle."
	id = "mag_magrifle_e"
	build_type = PROTOLATHE
	materials = list(MAT_METAL = 8000, MAT_SILVER = 1000)
	build_path = /obj/item/ammo_box/magazine/mmag_e/lethal
	category = list("Ammo")
	departmental_flags = DEPARTMENTAL_FLAG_SECURITY

/datum/design/mag_magrifle_e/nl
	name = "Magrifle Magazine (Non-Lethal)"
	desc = "A 24- round non-lethal magazine for the Magrifle."
	id = "mag_magrifle_e_nl"
	materials = list(MAT_METAL = 6000, MAT_SILVER = 500, MAT_TITANIUM = 500)
	build_path = /obj/item/ammo_box/magazine/mmag_e
	departmental_flags = DEPARTMENTAL_FLAG_SECURITY

/datum/design/magpistol_e
	name = "Magpistol"
	desc = "A weapon which fires ferromagnetic slugs."
	id = "magpistol_e"
	build_type = PROTOLATHE
	materials = list(MAT_METAL = 7500, MAT_GLASS = 1000, MAT_URANIUM = 1000, MAT_TITANIUM = 5000, MAT_SILVER = 2000)
	build_path = /obj/item/gun/ballistic/automatic/pistol/mag_e/nopin
	category = list("Weapons")
	departmental_flags = DEPARTMENTAL_FLAG_SECURITY

/datum/design/mag_magpistol_e
	name = "Magpistol Magazine"
	desc = "A 14 round magazine for the Magpistol."
	id = "mag_magpistol_e"
	build_type = PROTOLATHE
	materials = list(MAT_METAL = 4000, MAT_SILVER = 500)
	build_path = /obj/item/ammo_box/magazine/mmag_e/small/lethal
	category = list("Ammo")
	departmental_flags = DEPARTMENTAL_FLAG_SECURITY

/datum/design/mag_magpistol_e/nl
	name = "Magpistol Magazine (Non-Lethal)"
	desc = "A 14 round non-lethal magazine for the Magpistol."
	id = "mag_magpistol_e_nl"
	materials = list(MAT_METAL = 3000, MAT_SILVER = 250, MAT_TITANIUM = 250)
	build_path = /obj/item/ammo_box/magazine/mmag_e/small
	departmental_flags = DEPARTMENTAL_FLAG_SECURITY

/*
// TECHWEBS IMPLEMENTATION
*/

/*
/datum/techweb_node/magnetic_weapons
	id = "magnetic_weapons"
	display_name = "Magnetic Weapons"
	description = "Weapons using magnetic technology"
	prereq_ids = list("weaponry", "adv_weaponry", "emp_adv")
	design_ids = list("magrifle_e", "magpistol_e", "mag_magrifle_e", "mag_magrifle_e_nl", "mag_magpistol_e", "mag_magpistol_e_nl")
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 2500)
	export_price = 5000
*/

///magrifle///

/obj/item/gun/ballistic/automatic/magrifle_e
	name = "\improper Magnetic Rifle"
	desc = "A simple upscalling of the technologies used in the magpistol, the magrifle is capable of firing slightly larger slugs in bursts. Compatible with the magpistol's slugs."
	icon = 'modular_citadel/icons/obj/guns/cit_guns.dmi'
	icon_state = "magrifle"
	item_state = "arg"
	slot_flags = 0
	mag_type = /obj/item/ammo_box/magazine/mmag_e
	fire_sound = 'sound/weapons/magrifle.ogg'
	can_suppress = 0
	burst_size = 3
	fire_delay = 2
	spread = 5
	recoil = 0.15
	casing_ejector = 0
	var/obj/item/stock_parts/cell/cell
	var/cell_type = /obj/item/stock_parts/cell/magrifle_e
	var/dead_cell = FALSE

/obj/item/gun/ballistic/automatic/magrifle_e/examine(mob/user)
	. = ..()
	if(cell)
		. += "<span class='notice'>[src]'s cell is [round(cell.charge / cell.maxcharge, 0.1) * 100]% full.</span>"
	else
		. += "<span class='notice'>[src] doesn't seem to have a cell!</span>"

/obj/item/gun/ballistic/automatic/magrifle_e/can_shoot()
	if(QDELETED(cell))
		return 0

	var/obj/item/ammo_casing/caseless/mag_e/shot = chambered
	if(!shot)
		return 0
	if(cell.charge < shot.energy_cost*burst_size)
		return 0
	. = ..()

/obj/item/gun/ballistic/automatic/magrifle_e/shoot_live_shot()
	var/obj/item/ammo_casing/caseless/mag_e/shot = chambered
	cell.use(shot.energy_cost)
	. = ..()

/obj/item/gun/ballistic/automatic/magrifle_e/emp_act(severity)
	. = ..()
	if(!(. & EMP_PROTECT_CONTENTS))
		cell.use(round(cell.charge / severity))

/obj/item/gun/ballistic/automatic/magrifle_e/get_cell()
	return cell

/obj/item/gun/ballistic/automatic/magrifle_e/Initialize()
	. = ..()
	if(cell_type)
		cell = new cell_type(src)
	else
		cell = new(src)

	if(!dead_cell)
		cell.give(cell.maxcharge)

/obj/item/gun/ballistic/automatic/magrifle_e/nopin
	pin = null
	spawnwithmagazine = FALSE

///magpistol///

/obj/item/gun/ballistic/automatic/pistol/mag_e
	name = "magpistol"
	desc = "A handgun utilizing maglev technologies to propel a ferromagnetic slug to extreme velocities."
	icon = 'modular_citadel/icons/obj/guns/cit_guns.dmi'
	icon_state = "magpistol"
	force = 10
	fire_sound = 'sound/weapons/magpistol.ogg'
	mag_type = /obj/item/ammo_box/magazine/mmag_e/small
	can_suppress = 0
	casing_ejector = 0
	fire_delay = 2
	recoil = 0.2
	var/obj/item/stock_parts/cell/cell
	var/cell_type = /obj/item/stock_parts/cell/magpistol_e
	var/dead_cell = FALSE

/obj/item/gun/ballistic/automatic/pistol/mag_e/examine(mob/user)
	. = ..()
	if(cell)
		. += "<span class='notice'>[src]'s cell is [round(cell.charge / cell.maxcharge, 0.1) * 100]% full.</span>"
	else
		. += "<span class='notice'>[src] doesn't seem to have a cell!</span>"

/obj/item/gun/ballistic/automatic/pistol/mag_e/can_shoot()
	if(QDELETED(cell))
		return 0

	var/obj/item/ammo_casing/caseless/mag_e/shot = chambered
	if(!shot)
		return 0
	if(cell.charge < shot.energy_cost)
		return 0
	. = ..()

/obj/item/gun/ballistic/automatic/pistol/mag_e/shoot_live_shot()
	var/obj/item/ammo_casing/caseless/mag_e/shot = chambered
	cell.use(shot.energy_cost)
	. = ..()

/obj/item/gun/ballistic/automatic/pistol/mag_e/emp_act(severity)
	. = ..()
	if(!(. & EMP_PROTECT_CONTENTS))
		cell.use(round(cell.charge / severity))

/obj/item/gun/ballistic/automatic/pistol/mag_e/get_cell()
	return cell

/obj/item/gun/ballistic/automatic/pistol/mag_e/Initialize()
	. = ..()
	if(cell_type)
		cell = new cell_type(src)
	else
		cell = new(src)

	if(!dead_cell)
		cell.give(cell.maxcharge)

/obj/item/gun/ballistic/automatic/pistol/mag_e/update_icon()
	..()
	if(magazine)
		cut_overlays()
		add_overlay("magpistol-magazine")
	else
		cut_overlays()
	icon_state = "[initial(icon_state)][chambered ? "" : "-e"]"

/obj/item/gun/ballistic/automatic/pistol/mag_e/nopin
	pin = null
	spawnwithmagazine = FALSE
