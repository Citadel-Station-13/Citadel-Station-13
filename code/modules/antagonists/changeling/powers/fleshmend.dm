/obj/effect/proc_holder/changeling/fleshmend
	name = "Fleshmend"
	desc = "Our flesh rapidly regenerates, healing our burns, bruises, and shortness of breath. Functions while unconscious. This ability is loud, and might cause our blood to react violently to heat."
	helptext = "If we are on fire, the healing effect will not function. Does not regrow limbs or restore lost blood."
	chemical_cost = 20
	loudness = 2
	dna_cost = 2
	req_stat = UNCONSCIOUS
	action_icon = 'icons/mob/actions/actions_changeling.dmi'
	action_icon_state = "ling_fleshmend"
	action_background_icon_state = "bg_ling"

//Starts healing you every second for 10 seconds.
//Can be used whilst unconscious.
/obj/effect/proc_holder/changeling/fleshmend/sting_action(mob/living/user)
	if(user.has_status_effect(STATUS_EFFECT_FLESHMEND))
		to_chat(user, "<span class='warning'>We are already fleshmending!</span>")
		return
	to_chat(user, "<span class='notice'>We begin to heal rapidly.</span>")
	user.apply_status_effect(STATUS_EFFECT_FLESHMEND)
	return TRUE

//Check buffs.dm for the fleshmend status effect code
