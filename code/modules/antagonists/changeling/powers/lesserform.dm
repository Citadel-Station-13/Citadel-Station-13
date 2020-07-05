/obj/effect/proc_holder/changeling/lesserform
	name = "Lesser Form"
	desc = "We debase ourselves and become lesser. We become a monkey. This ability is loud, and might cause our blood to react violently to heat."
	chemical_cost = 5
	dna_cost = 1
	loudness = 2
	req_human = 1
	action_icon = 'icons/mob/actions/actions_changeling.dmi'
	action_icon_state = "ling_lesser"
	action_background_icon_state = "bg_ling"

//Transform into a monkey.
/obj/effect/proc_holder/changeling/lesserform/sting_action(mob/living/carbon/human/user)
	if(!user || user.notransform)
		return 0
	to_chat(user, "<span class='warning'>Our genes cry out!</span>")

	user.monkeyize(TR_KEEPITEMS | TR_KEEPIMPLANTS | TR_KEEPORGANS | TR_KEEPDAMAGE | TR_KEEPVIRUS | TR_KEEPSE)
	return TRUE