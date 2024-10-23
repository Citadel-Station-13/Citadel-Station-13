/datum/admins/proc/open_borgopanel(borgo in GLOB.silicon_mobs)
	set category = "Admin.Game"
	set name = "Show Borg Panel"
	set desc = "Show borg panel"

	if(!check_rights(R_ADMIN))
		return

	if (!istype(borgo, /mob/living/silicon/robot))
		borgo = input("Select a borg", "Select a borg", null, null) as null|anything in sortNames(GLOB.silicon_mobs)
	if (!istype(borgo, /mob/living/silicon/robot))
		to_chat(usr, "<span class='warning'>Borg is required for borgpanel</span>", confidential = TRUE)

	var/datum/borgpanel/borgpanel = new(usr, borgo)

	borgpanel.ui_interact(usr)



/datum/borgpanel
	var/mob/living/silicon/robot/borg
	var/user

/datum/borgpanel/New(to_user, mob/living/silicon/robot/to_borg)
	if(!istype(to_borg))
		qdel(src)
		CRASH("Borg panel is only available for borgs")
	user = CLIENT_FROM_VAR(to_user)
	if (!user)
		CRASH("Borg panel attempted to open to a mob without a client")
	borg = to_borg

/datum/borgpanel/ui_state(mob/user)
	return GLOB.admin_state

/datum/borgpanel/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "BorgPanel")
		ui.open()

/datum/borgpanel/ui_data(mob/user)
	. = list()
	.["borg"] = list(
		"ref" = REF(borg),
		"name" = "[borg]",
		"emagged" = borg.emagged,
		"active_module" = "[borg.module.type]",
		"lawupdate" = borg.lawupdate,
		"lockdown" = borg.locked_down,
		"scrambledcodes" = borg.scrambledcodes
	)
	var/obj/item/gun/energy/kinetic_accelerator/kinetic_accelerator = locate(/obj/item/gun/energy/kinetic_accelerator) in borg.module
	if(kinetic_accelerator)
		.["ka_remaining_capacity"] = kinetic_accelerator.get_remaining_mod_capacity()
	.["active_upgrades"] = list()
	for (var/obj/item/borg/upgrade/upgrade as anything in borg.upgrades) // put a non-upgrade here, i dare you.
		.["active_upgrades"] += list(list("type" = upgrade.type))
	.["laws"] = borg.laws ? borg.laws.get_law_list(include_zeroth = TRUE, render_html = FALSE) : list()
	.["channels"] = list()
	for (var/k in GLOB.radiochannels)
		if (k == RADIO_CHANNEL_COMMON)
			continue
		.["channels"] += list(list("name" = k, "installed" = (k in borg.radio.channels)))
	.["cell"] = borg.cell ? list("missing" = FALSE, "maxcharge" = borg.cell.maxcharge, "charge" = borg.cell.charge) : list("missing" = TRUE, "maxcharge" = 1, "charge" = 0)
	.["modules"] = list()
	for(var/moduletype in typesof(/obj/item/robot_module))
		var/obj/item/robot_module/module = moduletype
		.["modules"] += list(list(
			"name" = initial(module.name),
			"type" = "[module]"
		))
	.["ais"] = list(list("name" = "None", "ref" = "null", "connected" = isnull(borg.connected_ai)))
	for(var/mob/living/silicon/ai/ai in GLOB.ai_list)
		.["ais"] += list(list("name" = ai.name, "ref" = REF(ai), "connected" = (borg.connected_ai == ai)))

/datum/borgpanel/ui_static_data(mob/user)
	. = ..()
	.["upgrades"] = list()
	for(var/obj/item/borg/upgrade/upgrade as anything in GLOB.borg_upgrades)
		if(upgrade.type == upgrade.abstract_type)
			continue
		var/obj/item/borg/upgrade/modkit/modkit
		if(istype(upgrade, /obj/item/borg/upgrade/modkit))
			modkit = upgrade
			if(modkit.minebot_exclusive)
				continue
			modkit = upgrade
		.["upgrades"] += list(
			list(
				"name" = upgrade.name,
				"type" = upgrade.type,
				"module_type" = upgrade.module_type,
				"maximum_of_type" = modkit ? modkit.maximum_of_type : null,
				"denied_type" = modkit ? modkit.denied_type : null,
				"cost" = modkit ? modkit.cost : null
				)
			)

/datum/borgpanel/ui_act(action, params)
	if(..())
		return
	switch (action)
		if ("set_charge")
			var/newcharge = input("New charge (0-[borg.cell.maxcharge]):", borg.name, borg.cell.charge) as num|null
			if (newcharge)
				borg.cell.charge = clamp(newcharge, 0, borg.cell.maxcharge)
				message_admins("[key_name_admin(user)] set the charge of [ADMIN_LOOKUPFLW(borg)] to [borg.cell.charge].")
				log_admin("[key_name(user)] set the charge of [key_name(borg)] to [borg.cell.charge].")
		if ("remove_cell")
			QDEL_NULL(borg.cell)
			message_admins("[key_name_admin(user)] deleted the cell of [ADMIN_LOOKUPFLW(borg)].")
			log_admin("[key_name(user)] deleted the cell of [key_name(borg)].")
		if ("change_cell")
			var/chosen = pick_closest_path(null, make_types_fancy(typesof(/obj/item/stock_parts/cell)))
			if (!ispath(chosen))
				chosen = text2path(chosen)
			if (chosen)
				if (borg.cell)
					QDEL_NULL(borg.cell)
				var/new_cell = new chosen(borg)
				borg.cell = new_cell
				borg.cell.charge = borg.cell.maxcharge
				borg.diag_hud_set_borgcell()
				message_admins("[key_name_admin(user)] changed the cell of [ADMIN_LOOKUPFLW(borg)] to [new_cell].")
				log_admin("[key_name(user)] changed the cell of [key_name(borg)] to [new_cell].")
		if ("toggle_emagged")
			borg.SetEmagged(!borg.emagged)
			if (borg.emagged)
				message_admins("[key_name_admin(user)] emagged [ADMIN_LOOKUPFLW(borg)].")
				log_admin("[key_name(user)] emagged [key_name(borg)].")
			else
				message_admins("[key_name_admin(user)] un-emagged [ADMIN_LOOKUPFLW(borg)].")
				log_admin("[key_name(user)] un-emagged [key_name(borg)].")
		if ("toggle_lawupdate")
			borg.lawupdate = !borg.lawupdate
			if (borg.lawupdate)
				message_admins("[key_name_admin(user)] enabled lawsync on [ADMIN_LOOKUPFLW(borg)].")
				log_admin("[key_name(user)] enabled lawsync on [key_name(borg)].")
			else
				message_admins("[key_name_admin(user)] disabled lawsync on [ADMIN_LOOKUPFLW(borg)].")
				log_admin("[key_name(user)] disabled lawsync on [key_name(borg)].")
		if ("toggle_lockdown")
			borg.SetLockdown(!borg.locked_down)
			if (borg.locked_down)
				message_admins("[key_name_admin(user)] locked down [ADMIN_LOOKUPFLW(borg)].")
				log_admin("[key_name(user)] locked down [key_name(borg)].")
			else
				message_admins("[key_name_admin(user)] released [ADMIN_LOOKUPFLW(borg)] from lockdown.")
				log_admin("[key_name(user)] released [key_name(borg)] from lockdown.")
		if ("toggle_scrambledcodes")
			borg.scrambledcodes = !borg.scrambledcodes
			if (borg.scrambledcodes)
				message_admins("[key_name_admin(user)] enabled scrambled codes on [ADMIN_LOOKUPFLW(borg)].")
				log_admin("[key_name(user)] enabled scrambled codes on [key_name(borg)].")
			else
				message_admins("[key_name_admin(user)] disabled scrambled codes on [ADMIN_LOOKUPFLW(borg)].")
				log_admin("[key_name(user)] disabled scrambled codes on [key_name(borg)].")
		if ("rename")
			var/new_name = stripped_input(user,"What would you like to name this cyborg?","Input a name",borg.real_name,MAX_NAME_LEN)
			if(!new_name)
				return
			message_admins("[key_name_admin(user)] renamed [ADMIN_LOOKUPFLW(borg)] to [new_name].")
			log_admin("[key_name(user)] renamed [key_name(borg)] to [new_name].")
			borg.fully_replace_character_name(borg.real_name,new_name)
		if ("toggle_upgrade")
			var/upgradepath = text2path(params["upgrade"])
			var/obj/item/borg/upgrade/installedupgrade = locate(upgradepath) in borg
			if (installedupgrade)
				qdel(installedupgrade)
				message_admins("[key_name_admin(user)] removed the [installedupgrade] upgrade from [ADMIN_LOOKUPFLW(borg)].")
				log_admin("[key_name(user)] removed the [installedupgrade] upgrade from [key_name(borg)].")
			else
				var/obj/item/borg/upgrade/upgrade = new upgradepath()
				if(!borg.apply_upgrade(upgrade, user, TRUE))
					to_chat(user, span_danger("Upgrade error."))
					return
				message_admins("[key_name_admin(user)] added the [upgrade] borg upgrade to [ADMIN_LOOKUPFLW(borg)].")
				log_admin("[key_name(user)] added the [upgrade] borg upgrade to [key_name(borg)].")
		if ("add_upgrade")
			var/upgradepath = text2path(params["upgrade"])
			var/obj/item/borg/upgrade/upgrade = new upgradepath()
			if(!borg.apply_upgrade(upgrade, user, TRUE))
				to_chat(user, span_danger("Upgrade error."))
				return
			message_admins("[key_name_admin(user)] added the [upgrade] borg upgrade to [ADMIN_LOOKUPFLW(borg)].")
			log_admin("[key_name(user)] added the [upgrade] borg upgrade to [key_name(borg)].")
		if ("remove_upgrade")
			var/upgradepath = text2path(params["upgrade"])
			var/obj/item/borg/upgrade/installedupgrade = locate(upgradepath) in borg
			if (installedupgrade)
				qdel(installedupgrade)
				message_admins("[key_name_admin(user)] removed the [installedupgrade] upgrade from [ADMIN_LOOKUPFLW(borg)].")
				log_admin("[key_name(user)] removed the [installedupgrade] upgrade from [key_name(borg)].")
		if ("toggle_radio")
			var/channel = params["channel"]
			if (channel in borg.radio.channels) // We're removing a channel
				if (!borg.radio.keyslot) // There's no encryption key. This shouldn't happen but we can cope
					borg.radio.channels -= channel
					if (channel == RADIO_CHANNEL_SYNDICATE)
						borg.radio.syndie = FALSE
					else if (channel == RADIO_CHANNEL_CENTCOM)
						borg.radio.independent = FALSE
				else
					borg.radio.keyslot.channels -= channel
					if (channel == RADIO_CHANNEL_SYNDICATE)
						borg.radio.keyslot.syndie = FALSE
					else if (channel == RADIO_CHANNEL_CENTCOM)
						borg.radio.keyslot.independent = FALSE
				message_admins("[key_name_admin(user)] removed the [channel] radio channel from [ADMIN_LOOKUPFLW(borg)].")
				log_admin("[key_name(user)] removed the [channel] radio channel from [key_name(borg)].")
			else	// We're adding a channel
				if (!borg.radio.keyslot) // Assert that an encryption key exists
					borg.radio.keyslot = new (borg.radio)
				borg.radio.keyslot.channels[channel] = 1
				if (channel == RADIO_CHANNEL_SYNDICATE)
					borg.radio.keyslot.syndie = TRUE
				else if (channel == RADIO_CHANNEL_CENTCOM)
					borg.radio.keyslot.independent = TRUE
				message_admins("[key_name_admin(user)] added the [channel] radio channel to [ADMIN_LOOKUPFLW(borg)].")
				log_admin("[key_name(user)] added the [channel] radio channel to [key_name(borg)].")
			borg.radio.recalculateChannels()
		if ("setmodule")
			var/newmodulepath = text2path(params["module"])
			if (ispath(newmodulepath))
				borg.module.transform_to(newmodulepath)
				message_admins("[key_name_admin(user)] changed the module of [ADMIN_LOOKUPFLW(borg)] to [newmodulepath].")
				log_admin("[key_name(user)] changed the module of [key_name(borg)] to [newmodulepath].")
		if ("slavetoai")
			var/mob/living/silicon/ai/newai = locate(params["slavetoai"]) in GLOB.ai_list
			if (newai && newai != borg.connected_ai)
				borg.notify_ai(DISCONNECT)
				if(borg.shell)
					borg.undeploy()
				borg.set_connected_ai(newai)
				borg.notify_ai(TRUE)
				message_admins("[key_name_admin(user)] slaved [ADMIN_LOOKUPFLW(borg)] to the AI [ADMIN_LOOKUPFLW(newai)].")
				log_admin("[key_name(user)] slaved [key_name(borg)] to the AI [key_name(newai)].")
			else if (params["slavetoai"] == "null")
				borg.notify_ai(DISCONNECT)
				if(borg.shell)
					borg.undeploy()
				borg.set_connected_ai(null)
				message_admins("[key_name_admin(user)] freed [ADMIN_LOOKUPFLW(borg)] from being slaved to an AI.")
				log_admin("[key_name(user)] freed [key_name(borg)] from being slaved to an AI.")
			if (borg.lawupdate)
				borg.lawsync()

	. = TRUE

/datum/admins/proc/change_laws()
	set category = "Admin.Player Interaction"
	set name = "Change Silicon Laws"
	set desc = "Change Silicon Laws"

	if(!check_rights(R_ADMIN))
		return
	var/chosensilicon = input("Select a Silicon", "Select a Silicon", null, null) as null|anything in GLOB.silicon_mobs
	if (!istype(chosensilicon, /mob/living/silicon))
		to_chat(usr, "<span class='warning'>Silicon is required for law changes</span>", confidential=TRUE)
		return
	var/chosen = pick_closest_path(null, make_types_fancy(typesof(/obj/item/ai_module)))
	if (!chosen)
		return
	var/new_board = new chosen(src)
	var/obj/item/ai_module/chosenboard = new_board
	var/mob/living/silicon/beepboop = chosensilicon
	chosenboard.install(beepboop.laws, usr)
	message_admins("[key_name_admin(usr)] added [chosenboard] to [ADMIN_LOOKUPFLW(beepboop)].")
	log_admin("[key_name(usr)] added [chosenboard] to [key_name(beepboop)].")
	qdel(new_board)

GLOBAL_LIST_INIT(borg_upgrades, populate_borg_upgrades())

/proc/populate_borg_upgrades()
	. = list()
	for(var/type in typesof(/obj/item/borg/upgrade))
		. += new type
