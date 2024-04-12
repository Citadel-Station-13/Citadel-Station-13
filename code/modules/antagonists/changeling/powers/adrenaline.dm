/datum/action/changeling/adrenaline
	name = "Adrenaline Sacs"
	desc = "We evolve additional sacs of adrenaline throughout our body. Costs 30 chemicals."
	helptext = "Removes all stuns instantly and adds a short-term reduction in further stuns. Can be used while unconscious. Continued use poisons the body. This ability is loud, and might cause our blood to react violently to heat."
	button_icon_state = "adrenaline"
	chemical_cost = 30
	loudness = 2
	dna_cost = 2
	req_human = TRUE
	req_stat = UNCONSCIOUS

//Recover from stuns.
/datum/action/changeling/adrenaline/sting_action(mob/living/user)
	user.do_adrenaline(0, FALSE, 70, 0, TRUE, list(/datum/reagent/medicine/epinephrine = 3, /datum/reagent/medicine/changelinghaste = 10, /datum/reagent/medicine/changelingadrenaline = 5), "<span class='notice'>Energy rushes through us.</span>", 0, 0.75, 0)
	return TRUE
