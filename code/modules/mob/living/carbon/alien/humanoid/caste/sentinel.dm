/mob/living/carbon/alien/humanoid/sentinel
	name = "alien sentinel"
	caste = "s"
	maxHealth = 140
	health = 140
	icon_state = "aliens"
	meleeSlashHumanPower = 15

/mob/living/carbon/alien/humanoid/sentinel/Initialize()
	AddAbility(new /obj/effect/proc_holder/alien/sneak)
	. = ..()

/mob/living/carbon/alien/humanoid/sentinel/create_internal_organs()
	internal_organs += new /obj/item/organ/alien/plasmavessel
	internal_organs += new /obj/item/organ/alien/acid
	internal_organs += new /obj/item/organ/alien/neurotoxin
	..()
