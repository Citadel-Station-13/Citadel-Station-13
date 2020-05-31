/mob/living/carbon/alien/larva/death(gibbed)
	if(stat == DEAD)
		return

	. = ..()

	update_icons()

/mob/living/carbon/alien/larva/spawn_gibs(with_bodyparts, atom/loc_override)
	var/location = loc_override ? loc_override.drop_location() : drop_location()
	if(with_bodyparts)
		new /obj/effect/gibspawner/larva(location, src)
	else
		new /obj/effect/gibspawner/larva/bodypartless(location, src)

/mob/living/carbon/alien/larva/gib_animation()
	new /obj/effect/temp_visual/gib_animation(loc, "gibbed-l")

/mob/living/carbon/alien/larva/spawn_dust()
	new /obj/effect/decal/remains/xeno(loc)

/mob/living/carbon/alien/larva/dust_animation()
	new /obj/effect/temp_visual/dust_animation(loc, "dust-l")
