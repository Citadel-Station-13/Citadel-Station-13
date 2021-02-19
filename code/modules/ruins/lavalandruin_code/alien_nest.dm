//Aliens for the alien nest space ruin.
/obj/effect/mob_spawn/alien/corpse/humanoid/drone
	mob_type = /mob/living/carbon/alien/humanoid/drone
	death = TRUE
	name = "alien drone"
	mob_name = "alien drone"

/obj/effect/mob_spawn/alien/corpse/humanoid/hunter
	mob_type = /mob/living/carbon/alien/humanoid/hunter
	death = TRUE
	name = "alien hunter"
	mob_name = "alien hunter"

/obj/effect/mob_spawn/alien/corpse/humanoid/sentinel
	mob_type = /mob/living/carbon/alien/humanoid/sentinel
	death = TRUE
	name = "alien sentinel"
	mob_name = "alien sentinel"

/obj/effect/mob_spawn/alien/corpse/humanoid/praetorian
	mob_type = /mob/living/carbon/alien/humanoid/royal/praetorian
	death = TRUE
	name = "alien praetorian"
	mob_name = "alien praetorian"

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
	list_reagents = list(/datum/reagent/xenomicrobes = 1)
