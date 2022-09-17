/obj/item/gun/ballistic/derringer
	name = "\improper .38 Derringer"
	desc = "A easily concealable derringer. Uses .38 ammo"
	icon = 'icons/obj/guns/projectile.dmi'
	icon_state = "derringer"
	flags_1 = CONDUCT_1
	mag_type = /obj/item/ammo_box/magazine/internal/derringer
	fire_delay = 5
	obj_flags = UNIQUE_RENAME
	fire_sound = 'sound/weapons/revolvershot.ogg'
	casing_ejector = FALSE
	w_class = WEIGHT_CLASS_TINY

/obj/item/gun/ballistic/derringer/get_ammo(countchambered = FALSE, countempties = TRUE)
	var/boolets = 0 //legacy var name maturity
	if (chambered && countchambered)
		boolets++
	if (magazine)
		boolets += magazine.ammo_count(countempties)
	return boolets

/obj/item/gun/ballistic/derringer/attackby(obj/item/A, mob/user, params)
	. = ..()
	if(.)
		return
	var/num_loaded = magazine.attackby(A, user, params, 1)
	if(num_loaded)
		to_chat(user, "<span class='notice'>You load [num_loaded] bullet\s into \the [src].</span>")
		playsound(user, 'sound/weapons/bulletinsert.ogg', 60, 1)
		A.update_icon()
		update_icon()
		chamber_round(0)


/obj/item/gun/ballistic/derringer/attack_self(mob/living/user)
	var/num_unloaded = 0
	while (get_ammo() > 0)
		var/obj/item/ammo_casing/CB
		CB = magazine.get_round(0)
		chambered = null
		CB.forceMove(drop_location())
		CB.update_icon()
		num_unloaded++
	if (num_unloaded)
		to_chat(user, "<span class='notice'>You break open \the [src] and unload [num_unloaded] bullets\s.</span>")
	else
		to_chat(user, "<span class='warning'>[src] is empty!</span>")

/obj/item/gun/ballistic/derringer/examine(mob/user)
	. = ..()
	var/live_ammo = get_ammo(FALSE, FALSE)
	. += "[live_ammo ? live_ammo : "None"] of those are live rounds."

/obj/item/gun/ballistic/derringer/traitor
	name = "\improper .357 Syndicate Derringer"
	desc = "An easily concealable derriger, if not for the bright red and black. Uses .357 ammo"
	icon_state = "derringer_syndie"
	mag_type = /obj/item/ammo_box/magazine/internal/derringer/a357

/obj/item/gun/ballistic/derringer/gold
	name = "\improper Golden Derringer"
	desc = "The golden sheen is somewhat counterintuitive as a stealth weapon, but it looks cool. Uses .357 ammo"
	icon_state = "derringer_gold"
	mag_type = /obj/item/ammo_box/magazine/internal/derringer/a357
	fire_sound = 'sound/weapons/resonator_blast.ogg'

/obj/item/gun/ballistic/derringer/nukeop
	name = "\improper Gunslinger's Derringer"
	desc = "Sandalwood grip, wellkempt blue-grey steel barrels, and a crash like thunder itself. Uses the exceedingly rare 45-70 Govt. ammo"
	icon_state = "derringer"
	mag_type = /obj/item/ammo_box/magazine/internal/derringer/g4570
	fire_sound = 'sound/weapons/gunshotshotgunshot.ogg'
