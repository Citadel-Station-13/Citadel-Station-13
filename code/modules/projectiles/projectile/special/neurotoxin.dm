/obj/item/projectile/bullet/neurotoxin
	name = "neurotoxin spit"
	icon_state = "neurotoxin"
	damage = 15
	damage_type = TOX
	var/stagger_duration = 8 SECONDS

/obj/item/projectile/bullet/neurotoxin/on_hit(atom/target, blocked = FALSE)
	if(isalien(target))
		knockdown = 0
		nodamage = TRUE
	else if(iscarbon(target))
		var/mob/living/L = target
		L.KnockToFloor(TRUE)
		L.Stagger(stagger_duration)
	return ..()
