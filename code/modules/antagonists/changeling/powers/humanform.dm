/datum/action/changeling/humanform
	name = "Human Form"
	desc = "We change into a human. Costs 5 chemicals."
	button_icon_state = "human_form"
	chemical_cost = 5
	req_dna = 1

//Transform into a human.
/datum/action/changeling/humanform/sting_action(mob/living/carbon/user)
	var/datum/antagonist/changeling/changeling = user.mind.has_antag_datum(/datum/antagonist/changeling)

	var/datum/changelingprofile/chosen_prof = changeling.select_dna()
	if(!chosen_prof)
		return
	if(!user || user.mob_transforming)
		return 0
	to_chat(user, "<span class='notice'>We transform our appearance.</span>")

	changeling.purchasedpowers -= src

	var/newmob = user.humanize(TR_KEEPITEMS | TR_KEEPIMPLANTS | TR_KEEPORGANS | TR_KEEPDAMAGE | TR_KEEPVIRUS | TR_KEEPSE)

	changeling_transform(newmob, chosen_prof)
	return TRUE
