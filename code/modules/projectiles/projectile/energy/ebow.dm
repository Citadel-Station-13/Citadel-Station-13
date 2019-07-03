/obj/item/projectile/energy/bolt //ebow bolts
	name = "bolt"
	icon_state = "cbbolt"
	damage = 15
	damage_type = TOX
	nodamage = 0
	knockdown = 100
	stutter = 5
	var/radiation_max = 900
	var/radiation_increase = 300

/obj/item/projectile/energy/bolt/on_hit(atom/A, blocked)
	. = ..()
	if(isliving(A))
		var/mob/living/M = A
		if(M.radiation < radiation_max)
			M.radiation = min(M.radiation + radiation_increase, radiation_max)

/obj/item/projectile/energy/bolt/halloween
	name = "candy corn"
	icon_state = "candy_corn"

/obj/item/projectile/energy/bolt/large
	damage = 20
	knockdown = 79
	radiation_increase = 0
