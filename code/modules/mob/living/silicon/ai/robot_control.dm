/datum/robot_control
	var/mob/living/silicon/ai/owner

/datum/robot_control/New(mob/living/silicon/ai/new_owner)
	if(!istype(new_owner))
		qdel(src)
	owner = new_owner

/datum/robot_control/proc/is_interactable(mob/user)
	if(user != owner || owner.incapacitated())
		return FALSE
	if(owner.control_disabled)
		to_chat(user, span_warning("Wireless control is disabled."))
		return FALSE
	return TRUE

/datum/robot_control/ui_status(mob/user)
	if(is_interactable(user))
		return ..()
	return UI_CLOSE

/datum/robot_control/ui_state(mob/user)
	return GLOB.always_state

/datum/robot_control/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "RemoteRobotControl")
		ui.open()

/datum/robot_control/ui_data(mob/user)
	if(!owner || user != owner)
		return
	var/list/data = list()
	var/turf/ai_current_turf = get_turf(owner)
	var/ai_zlevel = ai_current_turf.z

	var/mob/living/simple_animal/bot/bot = owner.bot_ref?.resolve()
	if((owner.waypoint_mode && bot) && !(bot.remote_disabled || owner.control_disabled))
		data["commandeering"] = REF(bot)
	else
		data["commandeering"] = null

	data["robots"] = list()
	for(var/mob/living/simple_animal/bot/our_bot as anything in GLOB.bots_list)
		if(our_bot.z != ai_zlevel || our_bot.remote_disabled) //Only non-emagged bots on the same Z-level are detected!
			continue
		var/list/robot_data = list(
			name = our_bot.name,
			model = our_bot.model,
			mode = our_bot.get_mode(),
			hacked = our_bot.hacked,
			location = get_area_name(our_bot, TRUE),
			ref = REF(our_bot)
		)
		data["robots"] += list(robot_data)

	return data

/datum/robot_control/ui_act(action, params)
	if(..())
		return
	var/mob/living/our_user = usr
	if(!is_interactable(our_user))
		return

	var/mob/living/simple_animal/bot/bot = locate(params["ref"]) in GLOB.bots_list
	if(isnull(bot))
		return

	switch(action)
		if("callbot") //Command a bot to move to a selected location.
			if(owner.call_bot_cooldown > world.time)
				to_chat(our_user, span_danger("Error: Your last call bot command is still processing, please wait for the bot to finish calculating a route."))
				return

			if(bot.remote_disabled)
				return

			owner.bot_ref = WEAKREF(bot)
			owner.waypoint_mode = TRUE
			to_chat(our_user, span_notice("Set your waypoint by clicking on a valid location free of obstructions."))
		if("interface") //Remotely connect to a bot!
			owner.bot_ref = WEAKREF(bot)
			if(bot.remote_disabled)
				return
			bot.attack_ai(our_user)

	return TRUE
