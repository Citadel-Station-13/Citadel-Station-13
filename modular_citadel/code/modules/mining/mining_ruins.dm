/datum/map_template/ruin/lavaland/alien_nest
	name = "Alien Nest"
	id = "alien-nest"
	description = "Not even Necropolis is safe from alien infestation. The competition for hosts has locked the legion and aliens in an endless conflict that can only be resolved by a PKA."
	suffix = "lavaland_surface_alien_nest.dmm"
	cost = 20

//Aliens for the alien nest space ruin.
/obj/effect/mob_spawn/alien/corpse/humanoid/drone
	mob_type = /mob/living/carbon/alien/humanoid/drone
	death = TRUE
	name = "alien drone"
	mob_name = "alien drone"

/obj/effect/mob_spawn/alien/corpse/humanoid/queen
	mob_type = /mob/living/carbon/alien/humanoid/royal/queen
	death = TRUE
	name = "alien queen"
	mob_name = "alien queen"

/obj/item/reagent_containers/syringe/alien
	name = "Hive's Blessing"
	desc = "A syringe filled with a strange viscous liquid. It might be best to leave it alone."
	amount_per_transfer_from_this = 1
	volume = 1
	list_reagents = list("xenomicrobes" = 1)