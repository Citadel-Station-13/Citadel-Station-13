/datum/reagent/space_cleaner/reaction_obj(obj/O, reac_volume)
	if(istype(O, /obj/effect/decal/cleanable) || istype(O, /obj/item/projectile/bullet/reusable/foam_dart/mag) || istype(O, /obj/item/ammo_casing/caseless/foam_dart))
		qdel(O)
	else
		if(O)
			O.remove_atom_colour(WASHABLE_COLOUR_PRIORITY)
			O.SendSignal(COMSIG_COMPONENT_CLEAN_ACT, CLEAN_STRENGTH_BLOOD)
