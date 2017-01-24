/obj/item/weapon/gun/grenadelauncher
	name = "grenade launcher"
	desc = "a terrible, terrible thing. it's really awful!"
	icon = 'icons/obj/guns/projectile.dmi'
	icon_state = "riotgun"
	item_state = "riotgun"
	w_class = WEIGHT_CLASS_BULKY
	throw_speed = 2
	throw_range = 7
	force = 5
	var/list/grenades = new/list()
	var/max_grenades = 3
	materials = list(MAT_METAL=2000)

/obj/item/weapon/gun/grenadelauncher/examine(mob/user)
	..()
	user << "[grenades.len] / [max_grenades] grenades loaded."

/obj/item/weapon/gun/grenadelauncher/attackby(obj/item/I, mob/user, params)

	if((istype(I, /obj/item/weapon/grenade)))
		if(grenades.len < max_grenades)
			if(!user.unEquip(I))
				return
			I.loc = src
			grenades += I
			user << "<span class='notice'>You put the grenade in the grenade launcher.</span>"
			user << "<span class='notice'>[grenades.len] / [max_grenades] Grenades.</span>"
		else
			usr << "<span class='danger'>The grenade launcher cannot hold more grenades.</span>"

/obj/item/weapon/gun/grenadelauncher/afterattack(obj/target, mob/user , flag)
	if(target == user)
		return

	if(grenades.len)
		fire_grenade(target,user)
	else
		user << "<span class='danger'>The grenade launcher is empty.</span>"

/obj/item/weapon/gun/grenadelauncher/proc/fire_grenade(atom/target, mob/user)
	user.visible_message("<span class='danger'>[user] fired a grenade!</span>", \
						"<span class='danger'>You fire the grenade launcher!</span>")
	var/obj/item/weapon/grenade/F = grenades[1] //Now with less copypasta!
	grenades -= F
	F.loc = user.loc
	F.throw_at_fast(target, 30, 2,user)
	message_admins("[key_name_admin(user)] fired a grenade ([F.name]) from a grenade launcher ([src.name]).")
	log_game("[key_name(user)] fired a grenade ([F.name]) from a grenade launcher ([src.name]).")
	F.active = 1
	F.icon_state = initial(F.icon_state) + "_active"
	playsound(user.loc, 'sound/weapons/armbomb.ogg', 75, 1, -3)
	addtimer(F, "prime", 15)
