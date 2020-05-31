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
		ui.set_autoupdate(FALSE) // This UI is only ever opened by one person, and never is updated outside of user input.
		ui = new(user, src, ui_key, "skills", "[owner.name]'s Skills", 620, 580, master_ui, state)
		ui.open()

/datum/skill_holder/ui_static_data(mob/user)
	. = list()
	var/datum/asset/spritesheet/simple/assets = get_asset_datum(/datum/asset/spritesheet/simple/skills)

	var/all_mods = list()
	for(var/id in all_current_skill_modifiers)
		var/datum/skill_modifier/M = GLOB.skill_modifiers[id]
		all_mods[id] = list(
			name = M.name,
			desc = M.desc,
			icon = assets.icon_class_name(M.icon_name)
		)

	.["categories"] = list()
	var/list/current
	var/category
	for(var/path in GLOB.skill_datums)
		var/datum/skill/S = GLOB.skill_datums[path]
		if(!current || S.ui_category != category)
			if(category)
				var/list/cat = list("name" = category, "skills" = current)
				.["categories"] += list(cat)
			current = list()
			category = S.ui_category

		var/skill_value = owner.get_skill_value(path, FALSE)
		var/skill_level = owner.get_skill_level(path, FALSE)
		var/list/mod_list = list()
		var/list/modifiers
		var/list/mod_ids = list()

		var/value_mods = LAZYACCESS(skill_value_mods, path)
		var/mod_value = skill_value
		for(var/k in value_mods)
			var/datum/skill_modifier/M = GLOB.skill_modifiers[k]
			mod_list |= M.name
			mod_ids |= M.identifier
			mod_value = M.apply_modifier(mod_value, path, src, MODIFIER_TARGET_VALUE)

		var/lvl_mods = LAZYACCESS(skill_level_mods, path)
		var/mod_level = skill_level
		for(var/k in lvl_mods)
			var/datum/skill_modifier/M = GLOB.skill_modifiers[k]
			mod_list |= M.name
			mod_ids |= M.identifier
			mod_level = M.apply_modifier(mod_level, path, src, MODIFIER_TARGET_LEVEL)
		mod_level = SANITIZE_SKILL_LEVEL(S.type, round(mod_level, 1))

		for(var/k in mod_ids)
			var/list/mod = all_current_skill_modifiers[k]
			if(mod)
				LAZYADD(modifiers, list(mod))

		var/list/data = list(
			name = S.name,
			desc = S.desc,
			color = S.name_color,
			skill_base = S.standard_render_value(skill_value, skill_level),
			skill_mod = S.standard_render_value(mod_value, mod_level),
			mods_tooltip = english_list(mod_list, null),
			modifiers = modifiers
		)
		current += list(data)

	if(category)
		var/list/cat = list("name" = category, "skills" = current)
		.["categories"] += list(cat)

/datum/skill_holder/ui_data(mob/user)
	. = list()
	.["see_skill_mods"] = see_skill_mods
	.["compact_mode"] = compact_mode
	.["selected_category"] = selected_category

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
		if("select")
			selected_category = params["category"]
