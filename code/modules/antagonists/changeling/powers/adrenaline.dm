/obj/effect/proc_holder/changeling/adrenaline
	name = "Adrenaline Sacs"
	desc = "We evolve additional sacs of adrenaline throughout our body."
	helptext = "Removes all stuns instantly and adds a short-term reduction in further stuns. Can be used while unconscious. Continued use poisons the body."
	chemical_cost = 30
	dna_cost = 2
	req_human = 1
	req_stat = UNCONSCIOUS
	action_icon = 'icons/mob/actions/actions_changeling.dmi'
	action_icon_state = "ling_adrenals"
	action_background_icon_state = "bg_ling"

//Recover from stuns.
/obj/effect/proc_holder/changeling/adrenaline/sting_action(mob/living/user)
	user.do_adrenaline(100, FALSE, 70, 0, TRUE, list("epinephrine" = 3, "changelingmeth" = 10, "mannitol" = 10, "omnizine" = 10, "changelingadrenaline" = 5), "<span class='notice'>Energy rushes through us.</span>")
	return TRUE
