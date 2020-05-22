/mob/living/simple_animal/pet/redpanda
	name = "Red panda"
	desc = "Wah't a dork."
	icon = 'icons/mob/pets.dmi'
	icon_state = "red_panda"
	icon_living = "red_panda"
	icon_dead = "dead_panda"
	speak = list("Churip","Chuuriip","Cheep-cheep","Chiteurp","squueeaacipt")
	speak_emote = list("chirps", "huff-quacks")
	emote_hear = list("squeak-chrips.", "huff-squacks.")
	emote_see = list("shakes its head.", "rolls about.")
	speak_chance = 1
	turns_per_move = 5
	see_in_dark = 6
	butcher_results = list(/obj/item/reagent_containers/food/snacks/meat/slab = 3)
	response_help = "pets"
	response_disarm = "gently pushes aside"
	response_harm = "kicks"
	gold_core_spawnable = FRIENDLY_SPAWN
	do_footstep = TRUE
