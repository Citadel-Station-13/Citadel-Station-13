/obj/effect/proc_holder/changeling/chameleon_skin
	name = "Chameleon Skin"
	desc = "Our skin pigmentation rapidly changes to suit our current environment."
	helptext = "Allows us to become invisible after a few seconds of standing still. Can be toggled on and off."
	dna_cost = 2
	req_human = 1
	action_icon = 'icons/mob/actions/actions_changeling.dmi'
	action_icon_state = "ling_camouflage"
	action_background_icon_state = "bg_ling"

/obj/effect/proc_holder/changeling/chameleon_skin/sting_action(mob/user)
	var/mob/living/carbon/human/H = user //SHOULD always be human, because req_human = 1
	if(!istype(H)) // req_human could be done in can_sting stuff.
		return
	if(H.dna.get_mutation(CHAMELEON))
		H.dna.remove_mutation(CHAMELEON)
	else
		H.dna.add_mutation(CHAMELEON)
	return TRUE

/obj/effect/proc_holder/changeling/chameleon_skin/on_refund(mob/user)
	action.Remove(user)
	if(user.has_dna())
		var/mob/living/carbon/C = user
		C.dna.remove_mutation(CHAMELEON)
