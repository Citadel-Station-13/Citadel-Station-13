// yeah yeah verbs suck whatever I suck at this fix this someone please - kevinz000

/mob/verb/check_skills()
	set name = "Check Skills"
	set category = "IC"
	set desc = "Check your skills (if you have any..)"

	if(!mind)
		to_chat(usr, "<span class='warning'>How do you check the skills of [(usr == src)? "yourself when you are" : "something"] without a mind?</span>")
		return
	if(!mind.skill_holder)
		to_chat(usr, "<span class='warning'>How do you check the skills of [(usr == src)? "yourself when you are" : "something"] without the capability for skills? (PROBABLY A BUG, PRESS F1.)</span>")
		return

	mind.skill_holder.ui_interact(src)

/datum/skill_holder/ui_state(mob/user)
	return GLOB.always_state

/datum/skill_holder/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "SkillPanel", "[owner.name]'s Skills")
		ui.set_autoupdate(FALSE) 
		ui.open()
	else if(need_static_data_update)
		update_static_data(user)
		need_static_data_update = FALSE

/datum/skill_holder/ui_static_data(mob/user)
	. = list()
	.["skills"] = list()
	for(var/path in GLOB.skill_datums)
		var/datum/skill/S = GLOB.skill_datums[path]
		var/list/dat = S.get_skill_data(src)
		if(islist(dat["modifiers"]))
			dat["modifiers"] = jointext(dat["modifiers"], ", ")
		dat["percent_base"] = (dat["value_base"] / dat["max_value"])
		dat["percent_mod"] = (dat["value_mod"] / dat["max_value"])
		.["skills"] += list(dat)

/datum/skill_holder/ui_data(mob/user)
	. = list()
	.["playername"] = owner.name
	.["see_skill_mods"] = see_skill_mods
	.["admin"] = check_rights(R_DEBUG, FALSE)

/datum/skill_holder/ui_act(action, params)
	. = ..()
	if(.)
		return
	switch(action)
		if("toggle_mods")
			see_skill_mods = !see_skill_mods
			return TRUE
		if ("adj_exp")
			if(!check_rights(R_DEBUG))
				return
			var/skill = text2path(params["skill"])
			var/number = input("Please insert the amount of experience/progress you'd like to add/subtract:") as num|null
			if (number)
				owner.set_skill_value(skill, owner.get_skill_value(skill, FALSE) + number)
			return TRUE
		if ("set_exp")
			if(!check_rights(R_DEBUG))
				return
			var/skill = text2path(params["skill"])
			var/number = input("Please insert the number you want to set the player's exp/progress to:") as num|null
			if (!isnull(number))
				owner.set_skill_value(skill, number)
			return TRUE
		if ("set_lvl")
			if(!check_rights(R_DEBUG))
				return
			var/datum/skill/level/S = GLOB.skill_datums[text2path(params["skill"])]
			var/number = input("Please insert a whole number between 0[S.associative ? " ([S.unskilled_tier])" : ""] and [S.max_levels][S.associative ? " ([S.levels[S.max_levels]])" : ""] corresponding to the level you'd like to set the player to.") as num|null
			if (number >= 0 && number <= S.max_levels)
				owner.set_skill_value(S.type, S.get_skill_level_value(number))
			return TRUE
