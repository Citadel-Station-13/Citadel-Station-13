/datum/reagent/syndicateadrenals
	name = "Syndicate Adrenaline"
	description = "Regenerates your stamina and increases your reaction time."
	color = "#E62111"
	overdose_threshold = 6

/datum/reagent/syndicateadrenals/on_mob_life(mob/living/M)
	M.adjustStaminaLoss(-5*REM)
	. = ..()

/datum/reagent/syndicateadrenals/on_mob_metabolize(mob/living/M)
	. = ..()
	if(istype(M))
		M.next_move_modifier *= 0.5
		to_chat(M, "<span class='notice'>You feel an intense surge of energy rushing through your veins.</span>")

/datum/reagent/syndicateadrenals/on_mob_end_metabolize(mob/living/M)
	. = ..()
	if(istype(M))
		M.next_move_modifier *= 2
		to_chat(M, "<span class='notice'>You feel as though the world around you is going faster.</span>")

/datum/reagent/syndicateadrenals/overdose_start(mob/living/M)
	to_chat(M, "<span class='danger'>You feel an intense pain in your chest...</span>")
	return

/datum/reagent/syndicateadrenals/overdose_process(mob/living/M)
	if(iscarbon(M))
		var/mob/living/carbon/C = M
		if(!C.undergoing_cardiac_arrest())
			C.set_heartattack(TRUE)
	return
