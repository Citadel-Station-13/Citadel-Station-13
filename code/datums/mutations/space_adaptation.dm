//Cold Resistance gives your entire body an orange halo, and makes you immune to the effects of vacuum and cold.
/datum/mutation/human/space_adaptation
	name = "Space Adaptation"
	desc = "A strange mutation that renders the host immune to the vacuum of space. Will still need an oxygen supply."
	quality = POSITIVE
	difficulty = 16
	text_gain_indication = "<span class='notice'>Your body feels warm!</span>"
	time_coeff = 5
	instability = 30

/datum/mutation/human/space_adaptation/on_acquiring(mob/living/carbon/human/owner)
	if(..())
		return
	ADD_TRAIT(owner, TRAIT_RESISTCOLD, "cold_resistance")
	ADD_TRAIT(owner, TRAIT_RESISTLOWPRESSURE, "cold_resistance")
	owner.add_filter("space_glow", 2, list("type" = "outline", "color" = "#ffe46bd8", "size" = 2))

/datum/mutation/human/space_adaptation/on_losing(mob/living/carbon/human/owner)
	if(..())
		return
	REMOVE_TRAIT(owner, TRAIT_RESISTCOLD, "cold_resistance")
	REMOVE_TRAIT(owner, TRAIT_RESISTLOWPRESSURE, "cold_resistance")
	owner.remove_filter("space_glow")

