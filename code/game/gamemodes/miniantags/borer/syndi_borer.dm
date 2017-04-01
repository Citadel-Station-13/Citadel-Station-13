/mob/living/simple_animal/borer/syndi_borer
	var/mob/owner = null
	borer_alert = "Serve as a syndicate cortical borer? (Warning, You can no longer be cloned!)"
	
/mob/living/simple_animal/borer/syndi_borer/Initialize(mapload, gen=1)
	..()
	real_name = "Syndicate Borer [rand(1000,9999)]"
	truename = "[borer_names[min(generation, borer_names.len)]] [rand(1000,9999)]"

	GrantBorerActions()
	make_larvae_action.Remove(src)

/mob/living/simple_animal/borer/syndi_borer/GrantControlActions()
	talk_to_brain_action.Grant(victim)
	give_back_control_action.Grant(victim)

/mob/living/simple_animal/borer/syndi_borer/RemoveControlActions()
	talk_to_brain_action.Remove(victim)
	give_back_control_action.Remove(victim)
