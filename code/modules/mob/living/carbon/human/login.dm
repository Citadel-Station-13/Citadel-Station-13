/mob/living/carbon/human/Login()
	..()
	if(dna?.species?.has_field_of_vision && CONFIG_GET(flag/use_field_of_vision))
		LoadComponent(/datum/component/field_of_vision, field_of_vision_type)

	if(!LAZYLEN(afk_thefts))
		return

	var/list/print_msg = list()
	print_msg += "<span class='info'>*---------*</span>"
	print_msg += "<span class='userdanger'>As you snap back to consciousness, you recall people messing with your stuff...</span>"

	afk_thefts = reverseRange(afk_thefts)

	for(var/list/iter_theft as anything in afk_thefts)
		if(!islist(iter_theft) || LAZYLEN(iter_theft) != AFK_THEFT_TIME)
			stack_trace("[src] ([ckey]) returned to their body and had a null/malformed afk_theft entry. Contents: [json_encode(iter_theft)]")
			continue

		var/thief_name = iter_theft[AFK_THEFT_NAME]
		var/theft_message = iter_theft[AFK_THEFT_MESSAGE]
		var/time_since = world.time - iter_theft[AFK_THEFT_TIME]

		if(time_since > AFK_THEFT_FORGET_DETAILS_TIME)
			print_msg += "\t<span class='danger'><b>Someone [theft_message], but it was at least [DisplayTimeText(AFK_THEFT_FORGET_DETAILS_TIME)] ago.</b></span>"
		else
			print_msg += "\t<span class='danger'><b>[thief_name] [theft_message] roughly [DisplayTimeText(time_since, 10)] ago.</b></span>"

	if(LAZYLEN(afk_thefts) >= AFK_THEFT_MAX_MESSAGES)
		print_msg += "<span class='warning'>There may have been more, but that's all you can remember...</span>"
	print_msg += "<span class='info'>*---------*</span>"

	to_chat(src, print_msg.Join("\n"))
	LAZYNULL(afk_thefts)
