/obj/effect/proc_holder/changeling/panacea
	name = "Anatomic Panacea"
	desc = "Expels impurifications from our form; curing diseases, removing parasites, sobering us, purging toxins and radiation, and resetting our genetic code completely."
	helptext = "Can be used while unconscious."
	chemical_cost = 20
	dna_cost = 2
	req_stat = UNCONSCIOUS
	action_icon = 'icons/mob/actions/actions_changeling.dmi'
	action_icon_state = "ling_anatomic_panacea"
	action_background_icon_state = "bg_ling"

//Heals the things that the other regenerative abilities don't.
/obj/effect/proc_holder/changeling/panacea/sting_action(mob/living/user)
	if(user.has_status_effect(STATUS_EFFECT_PANACEA))
		to_chat(user, "<span class='warning'>We are already cleansing our impurities!</span>")
		return
	to_chat(user, "<span class='notice'>We cleanse impurities from our form.</span>")
	user.apply_status_effect(STATUS_EFFECT_PANACEA)
	return TRUE

//buffs.dm has the code for anatomic panacea
