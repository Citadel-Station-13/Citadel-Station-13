/obj/item/projectile/bullet/neurotoxin
	name = "neurotoxin spit"
	icon_state = "neurotoxin"
	damage = 5
	damage_type = TOX

/obj/item/projectile/bullet/neurotoxin/on_hit(atom/target, blocked = FALSE)
	if(isalien(target))
		knockdown = 0
		nodamage = TRUE
	else if(isliving(target))
		var/mob/living/L = target
		L.Knockdown(100, TRUE, FALSE, 30, 25)
	return ..()
