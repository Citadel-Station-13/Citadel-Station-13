/obj/item/projectile/bullet/reusable/arrow
	name = "wooden arrow"
	desc = "Woosh!"
	damage = 15
	var/list/hunted
	var/hunted = 20
	icon_state = "arrow"
	ammo_type = /obj/item/ammo_casing/caseless/arrow/wood

/obj/item/projectile/bullet/reusable/arrow/Initialize()
	. = ..()
	hunted = typecacheof(list(
					/mob/living/simple_animal/hostile/asteroid/
	))

/obj/item/projectile/bullet/reusable/arrow/on_hit(atom/target, blocked = FALSE)
	. = ..()

	if(is_type_in_typecache(target, hunted))
		to_chat(user, "<span class='warning'>You easily land a critical shot on the [target].</span>") //To give feedback
			if(istype(target, /mob/living/))
				var/mob/living/simple_animal/hostile/asteroid/ashlands = target
				ashlands.adjustBruteLoss(-hunted) //Were doing it via ajust so we work around armor

	handle_drop()

/obj/item/projectile/bullet/reusable/arrow/ash
	name = "ashen arrow"
	desc = "Fire harderned arrow."
	damage = 25
	hunted = 50 //Yes we now one shot legion!
	ammo_type = /obj/item/ammo_casing/caseless/arrow/ash

/obj/item/projectile/bullet/reusable/arrow/bone //AP for ashwalkers
	name = "bone arrow"
	desc = "Arrow made of bone and sinew."
	damage = 35
	armour_penetration = 40
	hunted = 100
	ammo_type = /obj/item/ammo_casing/caseless/arrow/bone

/obj/item/projectile/bullet/reusable/arrow/bronze //Just some AP shots
	name = "bronze arrow"
	desc = "Bronze tipped arrow."
	armour_penetration = 10
	hunted = 40 //Metal tip 
	ammo_type = /obj/item/ammo_casing/caseless/arrow/bronze
