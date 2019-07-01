//Makes you immune to the effects of vacuum (on top of the cold resistance).
/datum/mutation/human/space_adaptation
	name = "Space Adaptation"
	desc = "A strange mutation that renders the host immune to the vacuum if space. Will still need an oxygen supply and warm clothes."
	quality = POSITIVE
	difficulty = 18
	locked = TRUE
	text_gain_indication = "<span class='notice'>Your body feels warm!</span>"
	time_coeff = 5
	instability = 25

/datum/mutation/human/space_adaptation/on_acquiring(mob/living/carbon/human/owner)
	. = ..()
	if(.)
		return
	ADD_TRAIT(owner, TRAIT_RESISTLOWPRESSURE, GENETIC_MUTATION)

/datum/mutation/human/space_adaptation/on_losing(mob/living/carbon/human/owner)
	. = ..()
	if(.)
		return
	REMOVE_TRAIT(owner, TRAIT_RESISTLOWPRESSURE, GENETIC_MUTATION)
