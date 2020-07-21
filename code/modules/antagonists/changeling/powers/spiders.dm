/obj/effect/proc_holder/changeling/spiders
	name = "Spread Infestation"
	desc = "Our form divides, creating arachnids which will grow into deadly beasts."
	helptext = "The spiders are thoughtless creatures, and may attack their creators when fully grown. Requires at least 3 DNA gained through Absorb (regardless of current amount), and not through DNA sting. This ability is very loud, and will guarantee that our blood will react violently to heat."
	chemical_cost = 45
	dna_cost = 1
	loudness = 4
	req_absorbs = 3
	action_icon = 'icons/effects/effects.dmi'
	action_icon_state = "spiderling"
	action_background_icon_state = "bg_ling"

//Makes some spiderlings. Good for setting traps and causing general trouble.
/obj/effect/proc_holder/changeling/spiders/sting_action(mob/user)
	spawn_atom_to_turf(/obj/structure/spider/spiderling/hunter, user, 2, FALSE)
	return TRUE
