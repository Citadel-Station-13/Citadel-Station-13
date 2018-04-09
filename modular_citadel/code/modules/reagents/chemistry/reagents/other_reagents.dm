/datum/reagent/water/fish
	name = "Dirty water"
	id = "fishwater"
	description = "An ubiquitous chemical substance that is composed of hydrogen and oxygen. This seems to have been taken from a dirty fishtank."
	taste_description = "Shit filled water"
	glass_icon_state = "glass_clear"
	glass_name = "glass of fishwater"
	glass_desc = "I've got no idea why you would ever want to drink this."
	shot_glass_icon_state = "shotglassclear"
	var/toxpwr = 0.25

/datum/reagent/water/fish/on_mob_life(mob/living/M)
	if(toxpwr)
		M.adjustToxLoss(toxpwr*REM, 0)
		. = 1
	..()
 
/datum/reagent/space_cleaner/reaction_obj(obj/O, reac_volume)
	if(istype(O, /obj/effect/decal/cleanable) || istype(O, /obj/item/projectile/bullet/reusable/foam_dart) || istype(O, /obj/item/ammo_casing/caseless/foam_dart))
		qdel(O)
	else
		if(O)
			O.remove_atom_colour(WASHABLE_COLOUR_PRIORITY)
			O.SendSignal(COMSIG_COMPONENT_CLEAN_ACT, CLEAN_STRENGTH_BLOOD)
