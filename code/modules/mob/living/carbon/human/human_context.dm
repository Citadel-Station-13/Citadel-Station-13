/mob/living/carbon/human/add_context(atom/source, list/context, obj/item/held_item, mob/living/user)
	. = ..()

	if (!ishuman(user))
		return .

	var/aim_for_mouth = user.zone_selected == "mouth"
	var/target_on_help = a_intent == INTENT_HELP
	var/target_aiming_for_mouth = zone_selected == "mouth"
	var/target_restrained = restrained()
	var/same_dir = (dir & user.dir)
	var/aim_for_groin  = user.zone_selected == "groin"
	var/target_aiming_for_groin = zone_selected == "groin"

	if(aim_for_mouth && (target_on_help || target_restrained || target_aiming_for_mouth))
		LAZYSET(context[SCREENTIP_CONTEXT_LMB], INTENT_DISARM, "Slap face")

	else if(aim_for_groin && (src == user || lying || same_dir) && (target_on_help || target_restrained || target_aiming_for_groin))
		LAZYSET(context[SCREENTIP_CONTEXT_LMB], INTENT_DISARM, "Slap ass")

	return CONTEXTUAL_SCREENTIP_SET
