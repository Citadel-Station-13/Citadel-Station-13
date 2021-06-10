/obj/item/projectile/judgement_cut
	name = "judgement cut"
	icon_state = "judgement_fire"
	hitsound = 'sound/weapons/judgementfire.ogg'
	damage = 10
	damage_type = BRUTE
	range = 30
	is_reflectable = FALSE
	sharpness = SHARP_EDGED
	impact_effect_type = /obj/effect/temp_visual/impact_effect/judgement_cut

/obj/item/projectile/judgement_cut/on_hit(atom/target, blocked = FALSE)
	. = ..()
	if(ishuman(target))
		new /obj/effect/temp_visual/impact_effect/judgement_cut(src)
