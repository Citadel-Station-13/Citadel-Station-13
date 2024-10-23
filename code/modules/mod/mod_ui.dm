/obj/item/mod/control/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "MODsuit", name)
		ui.open()

/obj/item/mod/control/ui_data(mob/user)
	var/data = list()
	data["interface_break"] = interface_break
	data["malfunctioning"] = malfunctioning
	data["open"] = open
	data["active"] = active
	data["complexity"] = complexity
	data["selected_module"] = selected_module?.name
	data["wearer_name"] = wearer ? (wearer.get_authentification_name("Unknown") || "Unknown") : "No Occupant"
	data["wearer_job"] = wearer ? wearer.get_assignment("Unknown", "Unknown", FALSE) : "No Job"
	data["AI"] = ai?.name
	data["is_pAI"] = ai ? ispAI(ai) : FALSE
	data["is_user_AI"] = ai ? user == ai : FALSE
	data["cell"] = cell?.name
	data["charge"] = cell ? round(cell.percent(), 1) : 0
	data["modules"] = list()
	for(var/obj/item/mod/module/module as anything in modules)
		var/list/module_data = list(
			name = module.name,
			description = module.desc,
			module_type = module.module_type,
			active = module.active,
			idle_power = module.idle_power_cost,
			active_power = module.active_power_cost,
			use_power = module.use_power_cost,
			complexity = module.complexity,
			cooldown_time = module.cooldown_time,
			cooldown = round(COOLDOWN_TIMELEFT(module, cooldown_timer), 1 SECONDS),
			id = module.tgui_id,
			ref = REF(module),
			configuration_data = module.get_configuration()
		)
		module_data += module.add_ui_data()
		data["modules"] += list(module_data)
	return data

/obj/item/mod/control/ui_static_data(mob/user)
	var/data = list()
	data["ui_theme"] = ui_theme
	data["control"] = name
	data["complexity_max"] = complexity_max
	data["helmet"] = helmet?.name
	data["chestplate"] = chestplate?.name
	data["gauntlets"] = gauntlets?.name
	data["boots"] = boots?.name
	return data

/obj/item/mod/control/ui_act(action, params)
	. = ..()
	if(.)
		return
	if(malfunctioning && prob(75))
		balloon_alert(usr, "button malfunctions!")
		return
	switch(action)
		if("activate")
			toggle_activate(usr)
		if("select")
			var/obj/item/mod/module/module = locate(params["ref"]) in modules
			if(!module)
				return
			module.on_select()
		if("configure")
			var/obj/item/mod/module/module = locate(params["ref"]) in modules
			if(!module)
				return
			module.configure_edit(params["key"], params["value"])
		if("remove_pai")
			if(ishuman(usr)) // Only the MODsuit's wearer should be removing the pAI.
				var/mob/user = usr
				extract_pai(user)
	return TRUE
