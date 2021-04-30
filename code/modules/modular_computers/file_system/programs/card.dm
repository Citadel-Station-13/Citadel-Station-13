#define CARDCON_DEPARTMENT_SERVICE "Service"
#define CARDCON_DEPARTMENT_SECURITY "Security"
#define CARDCON_DEPARTMENT_MEDICAL "Medical"
#define CARDCON_DEPARTMENT_SUPPLY "Supply"
#define CARDCON_DEPARTMENT_SCIENCE "Science"
#define CARDCON_DEPARTMENT_ENGINEERING "Engineering"
#define CARDCON_DEPARTMENT_COMMAND "Command"

/datum/computer_file/program/card_mod
	filename = "plexagonidwriter"
	filedesc = "Plexagon Access Management"
	category = PROGRAM_CATEGORY_CREW
	program_icon_state = "id"
	extended_desc = "Program for programming employee ID cards to access parts of the station."
	transfer_access = ACCESS_HEADS
	requires_ntnet = 0
	size = 8
	tgui_id = "NtosCard"
	program_icon = "id-card"

	/// If TRUE, this program only modifies Centcom accesses.
	var/is_centcom = FALSE
	/// If TRUE, this program is authenticated with limited departmental access.
	var/minor = FALSE
	/// The name/assignment combo of the ID card used to authenticate.
	var/authenticated_user
	/// The regions this program has access to based on the authenticated ID.
	var/list/region_access = list()
	var/list/head_subordinates = list()
	/// Which departments this program has access to. See region defines.
	var/target_dept

	//For some reason everything was exploding if this was static.
	var/list/sub_managers

/datum/computer_file/program/card_mod/New(obj/item/modular_computer/comp)
	. = ..()
	sub_managers = list(
		"[ACCESS_HOP]" = list(
			"department" = list(CARDCON_DEPARTMENT_SERVICE, CARDCON_DEPARTMENT_COMMAND),
			"region" = 1,
			"head" = "Head of Personnel"
		),
		"[ACCESS_HOS]" = list(
			"department" = CARDCON_DEPARTMENT_SECURITY,
			"region" = 2,
			"head" = "Head of Security"
		),
		"[ACCESS_CMO]" = list(
			"department" = CARDCON_DEPARTMENT_MEDICAL,
			"region" = 3,
			"head" = "Chief Medical Officer"
		),
		"[ACCESS_RD]" = list(
			"department" = CARDCON_DEPARTMENT_SCIENCE,
			"region" = 4,
			"head" = "Research Director"
		),
		"[ACCESS_CE]" = list(
			"department" = CARDCON_DEPARTMENT_ENGINEERING,
			"region" = 5,
			"head" = "Chief Engineer"
		)
	)

/**
 * Authenticates the program based on the specific ID card.
 *
 * If the card has ACCESS_CHANGE_IDs, it authenticates with all options.
 * Otherwise, it authenticates depending on SSid_access.sub_department_managers_tgui
 * compared to the access on the supplied ID card.
 * Arguments:
 * * user - Program's user.
 * * id_card - The ID card to attempt to authenticate under.
 */
/datum/computer_file/program/card_mod/proc/authenticate(mob/user, obj/item/card/id/id_card)
	if(!id_card)
		return

	region_access.Cut()

	// If the program isn't locked to a specific department or is_centcom and we have ACCESS_CHANGE_IDS in our auth card, we're not minor.
	if((!target_dept || is_centcom) && (ACCESS_CHANGE_IDS in id_card.access))
		minor = FALSE
		authenticated_user = "[id_card.name]"
		update_static_data(user)
		return TRUE

	// Otherwise, we're minor and now we have to build a list of restricted departments we can change access for.
	var/list/head_types = list()
	for(var/access_text in sub_managers)
		var/list/info = sub_managers[access_text]
		var/access = text2num(access_text)
		if((access in id_card.access) && ((info["region"] in target_dept) || !length(target_dept)))
			region_access += info["region"]
			//I don't even know what I'm doing anymore
			head_types += info["head"]

	head_subordinates = list()
	if(length(head_types))
		for(var/j in SSjob.occupations)
			var/datum/job/job = j
			for(var/head in head_types)//god why
				if(head in job.department_head)
					head_subordinates += job.title

	if(length(region_access))
		minor = TRUE
		authenticated_user = "[id_card.name] \[LIMITED ACCESS\]"
		update_static_data(user)
		return TRUE

	return FALSE

/datum/computer_file/program/card_mod/ui_act(action, params)
	. = ..()
	if(.)
		return

	var/obj/item/computer_hardware/card_slot/card_slot
	var/obj/item/computer_hardware/card_slot/card_slot2
	var/obj/item/computer_hardware/printer/printer
	if(computer)
		card_slot = computer.all_components[MC_CARD]
		card_slot2 = computer.all_components[MC_CARD2]
		printer = computer.all_components[MC_PRINT]
		if(!card_slot || !card_slot2)
			return

	var/mob/user = usr
	var/obj/item/card/id/user_id_card = card_slot.stored_card
	var/obj/item/card/id/target_id_card = card_slot2.stored_card

	switch(action)
		// Log in.
		if("PRG_authenticate")
			if(!computer || !user_id_card)
				playsound(computer, 'sound/machines/terminal_prompt_deny.ogg', 50, FALSE)
				return TRUE
			if(authenticate(user, user_id_card))
				playsound(computer, 'sound/machines/terminal_on.ogg', 50, FALSE)
				return TRUE
		// Log out.
		if("PRG_logout")
			authenticated_user = null
			playsound(computer, 'sound/machines/terminal_off.ogg', 50, FALSE)
			return TRUE
		// Print a report.
		if("PRG_print")
			if(!computer || !printer)
				return TRUE
			if(!authenticated_user)
				return TRUE
			var/contents = {"<h4>Access Report</h4>
						<u>Prepared By:</u> [user_id_card?.registered_name ? user_id_card.registered_name : "Unknown"]<br>
						<u>For:</u> [target_id_card.registered_name ? target_id_card.registered_name : "Unregistered"]<br>
						<hr>
						<u>Assignment:</u> [target_id_card.assignment]<br>
						<u>Access:</u><br>
						"}

			var/list/known_access_rights = get_all_accesses()
			for(var/A in target_id_card.access)
				if(A in known_access_rights)
					contents += "  [get_access_desc(A)]"

			if(!printer.print_text(contents,"access report"))
				to_chat(usr, "<span class='notice'>Hardware error: Printer was unable to print the file. It may be out of paper.</span>")
				return TRUE
			else
				playsound(computer, 'sound/machines/terminal_on.ogg', 50, FALSE)
				computer.visible_message("<span class='notice'>\The [computer] prints out a paper.</span>")
			return TRUE
		// Eject the ID used to log on to the ID app.
		if("PRG_ejectauthid")
			if(!computer || !card_slot)
				return TRUE
			if(user_id_card)
				return card_slot.try_eject(user)
			else
				var/obj/item/I = user.get_active_held_item()
				if(istype(I, /obj/item/card/id))
					return card_slot.try_insert(I, user)
		// Eject the ID being modified.
		if("PRG_ejectmodid")
			if(!computer || !card_slot2)
				return TRUE
			if(target_id_card)
				GLOB.data_core.manifest_modify(target_id_card.registered_name, target_id_card.assignment)
				return card_slot2.try_eject(user)
			else
				var/obj/item/I = user.get_active_held_item()
				if(istype(I, /obj/item/card/id))
					return card_slot2.try_insert(I, user)
			return TRUE
		// generic eject
		if("PRG_eject")
			if(!computer || !card_slot2)
				return
			if(target_id_card)
				GLOB.data_core.manifest_modify(target_id_card.registered_name, target_id_card.assignment)
				return card_slot2.try_eject(user)
			else
				var/obj/item/I = user.get_active_held_item()
				if(istype(I, /obj/item/card/id))
					return card_slot2.try_insert(I)
			return FALSE
		// Used to fire someone. Wipes all access from their card and modifies their assignment.
		if("PRG_terminate")
			if(!computer || !authenticated_user)
				return TRUE
			if(minor)
				if(!(target_id_card.assignment in head_subordinates) && target_id_card.assignment != "Assistant")
					to_chat(usr, "<span class='notice'>Software error: You do not have the necessary permissions to demote this card.</span>")
					return TRUE

			// Set the new assignment then remove the trim.
			target_id_card.access -= get_all_centcom_access() + get_all_accesses()
			target_id_card.assignment = "Unassigned"
			target_id_card.update_label()

			playsound(computer, 'sound/machines/terminal_prompt_deny.ogg', 50, FALSE)
			return TRUE
		// Change ID card assigned name.
		if("PRG_edit")
			if(!computer || !authenticated_user || !target_id_card)
				return TRUE

			var/old_name = target_id_card.registered_name

			// Sanitize the name first. We're not using the full sanitize_name proc as ID cards can have a wider variety of things on them that
			// would not pass as a formal character name, but would still be valid on an ID card created by a player.
			var/new_name = sanitize(params["name"])

			if(!new_name)
				target_id_card.registered_name = null
				playsound(computer, "terminal_type", 50, FALSE)
				target_id_card.update_label()
				// We had a name before and now we have no name, so this will unassign the card and we update the icon.
				if(old_name)
					target_id_card.update_icon()
				return TRUE

			// However, we are going to reject bad names overall including names with invalid characters in them, while allowing numbers.
			new_name = reject_bad_name(new_name, allow_numbers = TRUE)

			if(!new_name)
				to_chat(usr, "<span class='notice'>Software error: The ID card rejected the new name as it contains prohibited characters.</span>")
				return TRUE

			target_id_card.registered_name = new_name
			playsound(computer, "terminal_type", 50, FALSE)
			target_id_card.update_label()
			// Card wasn't assigned before and now it is, so update the icon accordingly.
			if(!old_name)
				target_id_card.update_icon()
			return TRUE
		// Change age
		// if("PRG_age")
		// 	if(!computer || !authenticated_user || !target_id_card)
		// 		return TRUE

		// 	var/new_age = params["id_age"]
		// 	if(!isnum(new_age))
		// 		stack_trace("[key_name(usr)] ([usr]) attempted to set invalid age \[[new_age]\] to [target_id_card]")
		// 		return TRUE

		// 	target_id_card.registered_age = new_age
		// 	playsound(computer, "terminal_type", 50, FALSE)
		// 	return TRUE
		// Change assignment
		if("PRG_assign")
			if(!computer || !authenticated_user || !target_id_card)
				return TRUE
			var/target = params["assign_target"]
			if(!target)
				return

			if(target == "Custom")
				var/custom_name = params["custom_name"]
				if(custom_name)
					target_id_card.assignment = custom_name
					target_id_card.update_label()
			else
				if(minor && !(target in head_subordinates))
					return
				var/list/new_access = list()
				if(is_centcom)
					new_access = get_centcom_access(target)
				else
					var/datum/job/job
					for(var/jobtype in subtypesof(/datum/job))
						var/datum/job/J = new jobtype
						if(J.title == target)
							job = J
							break
					if(!job)
						to_chat(user, "<span class='warning'>No class exists for this job: [target]</span>")
						return
					new_access = job.get_access()
				target_id_card.access -= get_all_centcom_access() + get_all_accesses()
				target_id_card.access |= new_access
				target_id_card.assignment = target
				target_id_card.update_label()
			playsound(computer, 'sound/machines/terminal_prompt_confirm.ogg', 50, FALSE)
			return TRUE
		// Add/remove access.
		if("PRG_access")
			if(!computer || !authenticated_user || !target_id_card)
				return TRUE
			// playsound(computer, "terminal_type", 50, FALSE)
			var/access_type = text2num(params["access_target"])
			if(access_type in (is_centcom ? get_all_centcom_access() : get_all_accesses()))
				if(access_type in target_id_card.access)
					target_id_card.access -= access_type
				else
					target_id_card.access |= access_type
				playsound(computer, "terminal_type", 50, FALSE)
				return TRUE
		if("PRG_grantall")
			if(!computer || !authenticated_user || !target_id_card)
				return TRUE
			target_id_card.access |= (is_centcom ? get_all_centcom_access() : get_all_accesses())
			playsound(computer, 'sound/machines/terminal_prompt_confirm.ogg', 50, FALSE)
			return TRUE
		if("PRG_denyall")
			if(!computer || !authenticated_user || !target_id_card || minor)
				return
			target_id_card.access.Cut()
			playsound(computer, 'sound/machines/terminal_prompt_deny.ogg', 50, FALSE)
			return TRUE
		if("PRG_grantregion")
			if(!computer || !authenticated_user || !target_id_card)
				return TRUE
			var/region = text2num(params["region"])
			if(isnull(region))
				return
			target_id_card.access |= get_region_accesses(region)
			playsound(computer, 'sound/machines/terminal_prompt_confirm.ogg', 50, FALSE)
			return TRUE
		if("PRG_denyregion")
			if(!computer || !authenticated_user)
				return
			var/region = text2num(params["region"])
			if(isnull(region))
				return
			target_id_card.access -= get_region_accesses(region)
			playsound(computer, 'sound/machines/terminal_prompt_deny.ogg', 50, FALSE)
			return TRUE

/datum/computer_file/program/card_mod/ui_static_data(mob/user)
	var/list/data = list()
	data["station_name"] = station_name()
	data["centcom_access"] = is_centcom
	data["minor"] = target_dept || minor ? TRUE : FALSE

	var/list/departments = target_dept
	if(is_centcom)
		departments = list("CentCom" = get_all_centcom_jobs())
	else if(isnull(departments))
		departments = list(
			CARDCON_DEPARTMENT_COMMAND = list("Captain"),//lol
			CARDCON_DEPARTMENT_ENGINEERING = GLOB.engineering_positions,
			CARDCON_DEPARTMENT_MEDICAL = GLOB.medical_positions,
			CARDCON_DEPARTMENT_SCIENCE = GLOB.science_positions,
			CARDCON_DEPARTMENT_SECURITY = GLOB.security_positions,
			CARDCON_DEPARTMENT_SUPPLY = GLOB.supply_positions,
			CARDCON_DEPARTMENT_SERVICE = GLOB.civilian_positions
		)
	data["jobs"] = list()
	for(var/department in departments)
		var/list/job_list = departments[department]
		var/list/department_jobs = list()
		for(var/job in job_list)
			if(minor && !(job in head_subordinates))
				continue
			department_jobs += list(list(
				"display_name" = replacetext(job, "&nbsp", " "),
				"job" = job
			))
		if(length(department_jobs))
			data["jobs"][department] = department_jobs

	var/list/regions = list()
	for(var/i in 1 to 7)
		if((minor || target_dept) && !(i in region_access))
			continue

		var/list/accesses = list()
		for(var/access in get_region_accesses(i))
			if (get_access_desc(access))
				accesses += list(list(
					"desc" = replacetext(get_access_desc(access), "&nbsp", " "),
					"ref" = access,
				))

		regions += list(list(
			"name" = get_region_accesses_name(i),
			"regid" = i,
			"accesses" = accesses
		))

	data["regions"] = regions

	return data

/datum/computer_file/program/card_mod/ui_data(mob/user)
	var/list/data = get_header_data()

	data["station_name"] = station_name()

	var/obj/item/computer_hardware/card_slot/card_slot
	var/obj/item/computer_hardware/card_slot/card_slot2
	var/obj/item/computer_hardware/printer/printer

	if(computer)
		card_slot = computer.all_components[MC_CARD]
		card_slot2 = computer.all_components[MC_CARD2]
		printer = computer.all_components[MC_PRINT]
		data["have_auth_card"] = !!(card_slot)
		data["have_id_slot"] = !!(card_slot2)
		data["have_printer"] = !!(printer)
	else
		data["have_id_slot"] = FALSE
		data["have_printer"] = FALSE

	if(!card_slot2)
		return data //We're just gonna error out on the js side at this point anyway

	var/obj/item/card/id/auth_card = card_slot.stored_card
	data["authIDName"] = auth_card ? auth_card.name : "-----"

	data["authenticated"] = !!authenticated_user

	var/obj/item/card/id/id_card = card_slot2.stored_card
	data["has_id"] = !!id_card
	data["id_name"] = id_card ? id_card.name : "-----"
	if(id_card)
		data["id_rank"] = id_card.assignment ? id_card.assignment : "Unassigned"
		data["id_owner"] = id_card.registered_name ? id_card.registered_name : "-----"
		data["access_on_card"] = id_card.access
		// data["wildcardSlots"] = id_card.wildcard_slots
		// data["id_age"] = id_card.registered_age

		// if(id_card.trim)
		// 	var/datum/id_trim/card_trim = id_card.trim
		// 	data["hasTrim"] = TRUE
		// 	data["trimAssignment"] = card_trim.assignment ? card_trim.assignment : ""
		// 	data["trimAccess"] = card_trim.access ? card_trim.access : list()
		// else
		// 	data["hasTrim"] = FALSE
		// 	data["trimAssignment"] = ""
		// 	data["trimAccess"] = list()

	return data


#undef CARDCON_DEPARTMENT_SERVICE
#undef CARDCON_DEPARTMENT_SECURITY
#undef CARDCON_DEPARTMENT_MEDICAL
#undef CARDCON_DEPARTMENT_SCIENCE
#undef CARDCON_DEPARTMENT_SUPPLY
#undef CARDCON_DEPARTMENT_ENGINEERING
#undef CARDCON_DEPARTMENT_COMMAND
