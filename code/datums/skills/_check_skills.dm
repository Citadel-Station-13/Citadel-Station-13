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

/datum/skill_holder/ui_interact(mob/user, ui_key = "main", datum/tgui/ui = null, force_open = FALSE, datum/tgui/master_ui = null, datum/ui_state/state = GLOB.always_state)
	if(need_static_data_update)
		update_static_data(user)
		need_static_data_update = FALSE
	ui = SStgui.try_update_ui(user, src, ui_key, ui, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "skillpanel", "[owner.name]'s Skills", 620, 580, master_ui, state)
		ui.set_autoupdate(FALSE) // This UI is only ever opened by one person, and never is updated outside of user input.
		ui.open()

/datum/skill_holder/ui_static_data(mob/user)
	. = list()
	.["skills"] = list()
	for(var/path in GLOB.skill_datums)
		var/datum/skill/S = GLOB.skill_datums[path]
		var/list/dat = S.get_skill_data(src)
		if(dat["modifiers"])
			dat["modifiers"] = jointext(dat["modifiers"], ", ")
		.["skills"] += list(dat)

/datum/skill_holder/ui_data(mob/user)
	. = list()
	.["see_skill_mods"] = see_skill_mods
	.["compact_mode"] = compact_mode

/datum/skill_holder/ui_act(action, params)
	. = ..()
	if(.)
		return
	switch(action)
		if("toggle_mods")
			see_skill_mods = !see_skill_mods
			return TRUE
		if("compact_toggle")
			compact_mode = !compact_mode
