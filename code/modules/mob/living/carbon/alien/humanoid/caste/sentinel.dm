<<<<<<< HEAD
/mob/living/carbon/alien/humanoid/sentinel
	name = "alien sentinel"
	caste = "s"
	maxHealth = 150
	health = 150
	icon_state = "aliens"


/mob/living/carbon/alien/humanoid/sentinel/Initialize()
	AddAbility(new /obj/effect/proc_holder/alien/sneak)
	..()

/mob/living/carbon/alien/humanoid/sentinel/create_internal_organs()
	internal_organs += new /obj/item/organ/alien/plasmavessel
	internal_organs += new /obj/item/organ/alien/acid
	internal_organs += new /obj/item/organ/alien/neurotoxin
	..()


/mob/living/carbon/alien/humanoid/sentinel/movement_delay()
	. = ..()
=======
/mob/living/carbon/alien/humanoid/sentinel
	name = "alien sentinel"
	caste = "s"
	maxHealth = 150
	health = 150
	icon_state = "aliens"


/mob/living/carbon/alien/humanoid/sentinel/Initialize()
	AddAbility(new /obj/effect/proc_holder/alien/sneak)
	. = ..()

/mob/living/carbon/alien/humanoid/sentinel/create_internal_organs()
	internal_organs += new /obj/item/organ/alien/plasmavessel
	internal_organs += new /obj/item/organ/alien/acid
	internal_organs += new /obj/item/organ/alien/neurotoxin
	..()


/mob/living/carbon/alien/humanoid/sentinel/movement_delay()
	. = ..()
>>>>>>> 772924b... More Initialize() fixes, requires someone to test with DB (#30831)
