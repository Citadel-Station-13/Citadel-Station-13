/obj/item/gun/ballistic/derringer
	name = ".38 Derringer"
	desc = "A easily consealable derringer. Uses .38 ammo"
	icon = 'icons/obj/guns/projectile.dmi'
	icon_state = "derringer"
	mag_type = /obj/item/ammo_box/magazine/internal/derr38
	fire_sound = 'sound/weapons/gun/revolver/shot_alt.ogg'
	casing_ejector = FALSE
	w_class = WEIGHT_CLASS_TINY

/obj/item/gun/ballistic/derringer/Initialize()
	..()
	transform *= 0.8 //Spriter too lazy to make icons smaller than default revolvers, local coder hacks in solution.

/obj/item/gun/ballistic/derringer/get_ammo(countchambered = FALSE, countempties = TRUE)
	var/boolets = 0 //legacy var name maturity
	if (chambered && countchambered)
		boolets++
	if (magazine)
		boolets += magazine.ammo_count(countempties)
	return boolets

/obj/item/gun/ballistic/derringer/examine(mob/user)
	. = ..()
	var/live_ammo = get_ammo(FALSE, FALSE)
	. += "[live_ammo ? live_ammo : "None"] of those are live rounds."

/obj/item/gun/ballistic/derringer/traitor
	name = "\improper .357 Syndicate Derringer"
	desc = "An easily consealable derriger, if not for the bright red and black. Uses .357 ammo"
	icon_state = "derringer_syndie"
	mag_type = /obj/item/ammo_box/magazine/internal/derr357

/obj/item/gun/ballistic/derringer/gold
	name = "\improper Golden Derringer"
	desc = "The golden sheen is somewhat counterintuitive as a stealth weapon, but it looks cool. Uses .357 ammo"
	icon_state = "derringer_gold"
	mag_type = /obj/item/ammo_box/magazine/internal/derr357

/obj/item/gun/ballistic/derringer/nukeop
	name = "\improper Gunslinger's Derringer"
	desc = "Sandalwood grip, wellkempt blue-grey steel barrels, and a crash like thunder itself. Uses the exceedingly rare 45-70 Govt. ammo"
	icon_state = "derringer_syndie"
	mag_type = /obj/item/ammo_box/magazine/internal/derr4570
