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
	ADD_TRAIT(owner, TRAIT_LOWPRESSURECOOLING, "cold_resistance")
	owner.add_filter("space_glow", 2, list("type" = "outline", "color" = "#ffe46bd8", "size" = 1))
	addtimer(CALLBACK(src, PROC_REF(glow_loop), owner), rand(1,19))

/datum/mutation/human/space_adaptation/proc/glow_loop(mob/living/carbon/human/owner)
	var/filter = owner.get_filter("space_glow")
	if(filter)
		animate(filter, alpha = 190, time = 15, loop = -1)
		animate(alpha = 110, time = 25)

/datum/mutation/human/space_adaptation/on_losing(mob/living/carbon/human/owner)
	if(..())
		return
	REMOVE_TRAIT(owner, TRAIT_RESISTCOLD, "cold_resistance")
	REMOVE_TRAIT(owner, TRAIT_RESISTLOWPRESSURE, "cold_resistance")
	REMOVE_TRAIT(owner, TRAIT_LOWPRESSURECOOLING, "cold_resistance")
	owner.remove_filter("space_glow")

