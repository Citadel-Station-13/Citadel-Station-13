/obj/item/ammo_casing/caseless/foam_dart
	name = "foam dart"
	desc = "It's nerf or nothing! Ages 8 and up."
	projectile_type = /obj/item/projectile/bullet/reusable/foam_dart
	caliber = "foam_force"
	icon = 'icons/obj/guns/toy.dmi'
	icon_state = "foamdart"
	materials = list(MAT_METAL = 11.25)
	harmful = FALSE
	var/modified = FALSE

/obj/item/ammo_casing/caseless/foam_dart/update_icon()
	..()
	if (modified)
		icon_state = "foamdart_empty"
		desc = "It's nerf or nothing! ... Although, this one doesn't look too safe."
		if(BB)
			BB.icon_state = "foamdart_empty"
	else
		icon_state = initial(icon_state)
		desc = "It's nerf or nothing! Ages 8 and up."
		if(BB)
			BB.icon_state = initial(BB.icon_state)


/obj/item/ammo_casing/caseless/foam_dart/attackby(obj/item/A, mob/user, params)
	var/obj/item/projectile/bullet/reusable/foam_dart/FD = BB
	if (istype(A, /obj/item/screwdriver) && !modified)
		modified = TRUE
		FD.modified = TRUE
		FD.damage_type = BRUTE
		to_chat(user, "<span class='notice'>You pop the safety cap off [src].</span>")
		update_icon()
	else if (istype(A, /obj/item/stack/rods))
		if(modified)
			if(!FD.rod)
				harmful = TRUE
				var/obj/item/stack/rods/R = A
				if(A.use(1))
					FD.rod = new
					FD.damage = 5
					FD.nodamage = FALSE
					to_chat(user, "<span class='notice'>You insert some [A] into [src].</span>")
			else
				to_chat(user, "<span class='warning'>There's already something in [src].</span>")
		else
			to_chat(user, "<span class='warning'>The safety cap prevents you from inserting [A] into [src].</span>")
	else
		return ..()

/obj/item/ammo_casing/caseless/foam_dart/attack_self(mob/living/user)
	var/obj/item/projectile/bullet/reusable/foam_dart/FD = BB
	if(FD.rod)
		FD.damage = initial(FD.damage)
		FD.nodamage = initial(FD.nodamage)
		FD.rod.forceMove(drop_location())
		to_chat(user, "<span class='notice'>You remove [FD.rod] from [src].</span>")
		FD.rod = null

/obj/item/ammo_casing/caseless/foam_dart/riot
	name = "riot foam dart"
	desc = "Whose smart idea was it to use toys as crowd control? Ages 18 and up."
	projectile_type = /obj/item/projectile/bullet/reusable/foam_dart/riot
	icon_state = "foamdart_riot"
	materials = list(MAT_METAL = 1125)
