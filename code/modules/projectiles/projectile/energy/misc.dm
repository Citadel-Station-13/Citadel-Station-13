/obj/item/projectile/energy/declone
	name = "radiation beam"
	icon_state = "declone"
	damage = 20
	damage_type = CLONE
	irradiate = 100
	impact_effect_type = /obj/effect/temp_visual/impact_effect/green_laser

/obj/item/projectile/energy/dart //ninja throwing dart
	name = "dart"
	icon_state = "toxin"
	damage = 5
	damage_type = TOX
	knockdown = 100
	range = 7

/obj/item/projectile/energy/pickle //projectile for adminspawn only gun
	name = "pickle-izing beam"
	icon_state = "declone"

/obj/item/projectile/energy/pickle/on_hit(atom/target)
	//we don't care if they blocked it, they're turning into a pickle
	if(isliving(target))
		var/mob/living/living_target = target
		living_target.turn_into_pickle() //yes this is a real proc
