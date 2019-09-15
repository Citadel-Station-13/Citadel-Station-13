/obj/effect/proc_holder/changeling/spiders
	name = "Spread Infestation"
	desc = "Our form divides, creating arachnids which will grow into deadly beasts."
	helptext = "The spiders are thoughtless creatures, and may attack their creators when fully grown.This ability is loud, and might cause our blood to react violently to heat."
	chemical_cost = 45
	dna_cost = 1
	loudness = 2
	req_absorbs = 2
	action_icon = 'icons/effects/effects.dmi'
	action_icon_state = "spiderling"
	action_background_icon_state = "bg_ling"

//Makes some spiderlings. Good for setting traps and causing general trouble.
/obj/effect/proc_holder/changeling/spiders/sting_action(mob/user)
	spawn_atom_to_turf(/obj/structure/spider/spiderling/hunter, user, 2, FALSE)
	return TRUE
