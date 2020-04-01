/obj/item/gun/ballistic/automatic/magrifle
	name = "\improper Magnetic Rifle"
	desc = "A simple upscalling of the technologies used in the magpistol, the magrifle is capable of firing slightly larger slugs in bursts. Compatible with the magpistol's slugs."
	icon_state = "magrifle"
	item_state = "arg"
	force = 10
	slot_flags = NONE
	mag_type = /obj/item/ammo_box/magazine/mmag
	fire_sound = 'sound/weapons/magrifle.ogg'
	can_suppress = FALSE
	burst_size = 1
	actions_types = null
	fire_delay = 3
	spread = 0
	recoil = 0.1
	casing_ejector = FALSE
	inaccuracy_modifier = 0
	dualwield_spread_mult = 1.4
	weapon_weight = WEAPON_MEDIUM
	var/obj/item/stock_parts/cell/cell
	var/cell_type = /obj/item/stock_parts/cell/magnetic

/obj/item/gun/ballistic/automatic/magrifle/Initialize()
	. = ..()
	if(cell_type)
		cell = new cell_type(src)
	else
		cell = new(src)

/obj/item/gun/ballistic/automatic/magrifle/examine(mob/user)
	. = ..()
	if(cell)
		. += "<span class='notice'>[src]'s cell is [round(cell.charge / cell.maxcharge, 0.1) * 100]% full.</span>"
	else
		. += "<span class='notice'>[src] doesn't seem to have a cell!</span>"

/obj/item/gun/ballistic/automatic/magrifle/can_shoot()
	if(QDELETED(cell))
		return 0

	var/obj/item/ammo_casing/caseless/magnetic/shot = chambered
	if(!shot)
		return 0
	if(cell.charge < shot.energy_cost * burst_size)
		return 0
	. = ..()

/obj/item/gun/ballistic/automatic/magrifle/shoot_live_shot()
	var/obj/item/ammo_casing/caseless/magnetic/shot = chambered
	cell.use(shot.energy_cost)
	. = ..()

/obj/item/gun/ballistic/automatic/magrifle/emp_act(severity)
	. = ..()
	if(!(. & EMP_PROTECT_CONTENTS))
		cell.use(round(cell.charge / severity))

/obj/item/gun/ballistic/automatic/magrifle/get_cell()
	return cell

/obj/item/gun/ballistic/automatic/magrifle/nopin
	pin = null
	spawnwithmagazine = FALSE

/obj/item/gun/ballistic/automatic/magrifle/hyperburst
	name = "\improper Hyper-Burst Rifle"
	desc = "An extremely beefed up version of a stolen Nanotrasen weapon prototype, this 'rifle' is more like a cannon, with an extremely large bore barrel capable of generating several smaller magnetic 'barrels' to simultaneously launch multiple projectiles at once."
	icon_state = "hyperburst"
	item_state = "arg"
	mag_type = /obj/item/ammo_box/magazine/mhyper
	fire_sound = 'sound/weapons/magburst.ogg'
	fire_delay = 40
	recoil = 2
	weapon_weight = WEAPON_HEAVY

/obj/item/gun/ballistic/automatic/magrifle/hyperburst/update_icon()
	..()
	icon_state = "hyperburst[magazine ? "-[get_ammo()]" : ""][chambered ? "" : "-e"]"

///magpistol///

/obj/item/gun/ballistic/automatic/magrifle/pistol
	name = "magpistol"
	desc = "A handgun utilizing maglev technologies to propel a ferromagnetic slug to extreme velocities."
	icon_state = "magpistol"
	fire_sound = 'sound/weapons/magpistol.ogg'
	mag_type = /obj/item/ammo_box/magazine/mmag/small
	fire_delay = 2
	inaccuracy_modifier = 0.25
	cell_type = /obj/item/stock_parts/cell/magnetic/pistol

/obj/item/gun/ballistic/automatic/magrifle/pistol/update_icon()
	..()
	cut_overlays()
	if(magazine)
		add_overlay("magpistol-magazine")
	icon_state = "[initial(icon_state)][chambered ? "" : "-e"]"

/obj/item/gun/ballistic/automatic/magrifle/pistol/nopin
	pin = null
	spawnwithmagazine = FALSE
