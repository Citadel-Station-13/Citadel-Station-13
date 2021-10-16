GLOBAL_LIST_EMPTY(antagonists)

/datum/antagonist
	var/name = "Antagonist"
	var/roundend_category = "other antagonists"				//Section of roundend report, datums with same category will be displayed together, also default header for the section
	var/show_in_roundend = TRUE								//Set to false to hide the antagonists from roundend report
	var/datum/mind/owner						//Mind that owns this datum
	var/silent = FALSE							//Silent will prevent the gain/lose texts to show
	var/can_coexist_with_others = TRUE			//Whether or not the person will be able to have more than one datum
	var/list/typecache_datum_blacklist = list()	//List of datums this type can't coexist with
	var/delete_on_mind_deletion = TRUE
	var/job_rank
	var/replace_banned = TRUE //Should replace jobbaned player with ghosts if granted.
	var/list/objectives = list()
	var/antag_memory = ""//These will be removed with antag datum
	var/antag_moodlet //typepath of moodlet that the mob will gain with their status
	var/antag_hud_type
	var/antag_hud_name
	/// If above 0, this is the multiplier for the speed at which we hijack the shuttle. Do not directly read, use hijack_speed().
	var/hijack_speed = 0
	/// The battlecry this antagonist shouts when suiciding with C4/X4.
	var/suicide_cry = ""
	/// The typepath for the outfit to show in the preview for the preferences menu.
	var/preview_outfit

	//Antag panel properties
	var/show_in_antagpanel = TRUE	//This will hide adding this antag type in antag panel, use only for internal subtypes that shouldn't be added directly but still show if possessed by mind
	var/antagpanel_category = "Uncategorized"	//Antagpanel will display these together, REQUIRED
	var/show_name_in_check_antagonists = FALSE //Will append antagonist name in admin listings - use for categories that share more than one antag type
	var/list/blacklisted_quirks = list(/datum/quirk/nonviolent,/datum/quirk/mute) // Quirks that will be removed upon gaining this antag. Pacifist and mute are default.
	var/threat = 0 // Amount of threat this antag poses, for dynamic mode
	var/show_to_ghosts = FALSE // Should this antagonist be shown as antag to ghosts? Shouldn't be used for stealthy antagonists like traitors

	var/list/skill_modifiers

	//ANTAG UI

	///name of the UI that will try to open, right now using a generic ui
	var/ui_name = "AntagInfoGeneric"
	///button to access antag interface
	var/datum/action/antag_info/info_button
	//temporarily disable it for all antagonists other than families
	var/ui_enable

/datum/antagonist/New()
	GLOB.antagonists += src
	typecache_datum_blacklist = typecacheof(typecache_datum_blacklist)

/datum/antagonist/Destroy()
	GLOB.antagonists -= src
	if(owner)
		LAZYREMOVE(owner.antag_datums, src)
	owner = null
	return ..()

/datum/antagonist/proc/can_be_owned(datum/mind/new_owner)
	. = TRUE
	var/datum/mind/tested = new_owner || owner
	if(tested.has_antag_datum(type))
		return FALSE
	for(var/i in tested.antag_datums)
		var/datum/antagonist/A = i
		if(is_type_in_typecache(src, A.typecache_datum_blacklist))
			return FALSE

//This will be called in add_antag_datum before owner assignment.
//Should return antag datum without owner.
/datum/antagonist/proc/specialization(datum/mind/new_owner)
	return src

 ///Called by the transfer_to() mind proc after the mind (mind.current and new_character.mind) has moved but before the player (key and client) is transfered.
/datum/antagonist/proc/on_body_transfer(mob/living/old_body, mob/living/new_body)
	SHOULD_CALL_PARENT(TRUE)
	remove_innate_effects(old_body)
	if(old_body.stat != DEAD && !LAZYLEN(old_body.mind?.antag_datums))
		old_body.remove_from_current_living_antags()
	apply_innate_effects(new_body)
	if(new_body.stat != DEAD)
		new_body.add_to_current_living_antags()

//This handles the application of antag huds/special abilities
/datum/antagonist/proc/apply_innate_effects(mob/living/mob_override)
	return

//This handles the removal of antag huds/special abilities
/datum/antagonist/proc/remove_innate_effects(mob/living/mob_override)
	return

// Adds the specified antag hud to the player. Usually called in an antag datum file
/datum/antagonist/proc/add_antag_hud(antag_hud_type, antag_hud_name, mob/living/mob_override)
	var/datum/atom_hud/antag/hud = GLOB.huds[antag_hud_type]
	hud.join_hud(mob_override)
	set_antag_hud(mob_override, antag_hud_name)

// Removes the specified antag hud from the player. Usually called in an antag datum file
/datum/antagonist/proc/remove_antag_hud(antag_hud_type, mob/living/mob_override)
	var/datum/atom_hud/antag/hud = GLOB.huds[antag_hud_type]
	hud.leave_hud(mob_override)
	set_antag_hud(mob_override, null)

// Handles adding and removing the clumsy mutation from clown antags. Gets called in apply/remove_innate_effects
/datum/antagonist/proc/handle_clown_mutation(mob/living/mob_override, message, removing = TRUE)
	var/mob/living/carbon/human/H = mob_override
	if(H && istype(H) && owner.assigned_role == "Clown")
		if(removing) // They're a clown becoming an antag, remove clumsy
			H.dna.remove_mutation(CLOWNMUT)
			if(!silent && message)
				to_chat(H, "<span class='boldnotice'>[message]</span>")
		else
			H.dna.add_mutation(CLOWNMUT) // We're removing their antag status, add back clumsy

//Assign default team and creates one for one of a kind team antagonists
/datum/antagonist/proc/create_team(datum/team/team)
	return

 ///Called by the add_antag_datum() mind proc after the instanced datum is added to the mind's antag_datums list.
/datum/antagonist/proc/on_gain()
	SHOULD_CALL_PARENT(TRUE)
	set waitfor = FALSE
	if(!(owner?.current))
		return
	if(ui_name)//in the future, this should entirely replace greet.
		if(ui_enable == TRUE)
			info_button = new(owner.current, src)
			info_button.Grant(owner.current)
	if(!silent)
		greet()
		if(ui_name)
			if(ui_enable == TRUE)
				to_chat(owner.current, span_big("You are \a [src]."))
				to_chat(owner.current, span_boldnotice("For more info, read the panel. you can always come back to it using the button in the top left."))
				info_button.Trigger()
	apply_innate_effects()
	give_antag_moodies()
	remove_blacklisted_quirks()
	if(is_banned(owner.current) && replace_banned)
		replace_banned_player()
	if(skill_modifiers)
		for(var/A in skill_modifiers)
			ADD_SINGLETON_SKILL_MODIFIER(owner, A, type)
			var/datum/skill_modifier/job/M = GLOB.skill_modifiers[GET_SKILL_MOD_ID(A, type)]
			if(istype(M))
				M.name = "[name] Training"
	owner.current.AddComponent(/datum/component/activity)
	if(owner.current.stat != DEAD)
		owner.current.add_to_current_living_antags()
	SEND_SIGNAL(owner.current, COMSIG_MOB_ANTAG_ON_GAIN, src)

/datum/antagonist/proc/is_banned(mob/M)
	if(!M)
		return FALSE
	. = (jobban_isbanned(M, ROLE_SYNDICATE) || QDELETED(M) || (job_rank && (jobban_isbanned(M,job_rank) || QDELETED(M))))

/datum/antagonist/proc/replace_banned_player()
	set waitfor = FALSE

	var/list/mob/candidates = pollCandidatesForMob("Do you want to play as a [name]?", "[name]", null, job_rank, 50, owner.current)
	if(LAZYLEN(candidates))
		var/mob/C = pick(candidates)
		to_chat(owner, "Your mob has been taken over by a ghost! Appeal your job ban if you want to avoid this in the future!")
		message_admins("[key_name_admin(C)] has taken control of ([key_name_admin(owner.current)]) to replace a jobbaned player.")
		owner.current.ghostize(0)
		C.transfer_ckey(owner.current, FALSE)

///Called by the remove_antag_datum() and remove_all_antag_datums() mind procs for the antag datum to handle its own removal and deletion.
/datum/antagonist/proc/on_removal()
	SHOULD_CALL_PARENT(TRUE)
	remove_innate_effects()
	clear_antag_moodies()
	if(owner)
		LAZYREMOVE(owner.antag_datums, src)
		for(var/A in skill_modifiers)
			owner.remove_skill_modifier(GET_SKILL_MOD_ID(A, type))
		if(!LAZYLEN(owner.antag_datums))
			owner.current.remove_from_current_living_antags()
		if(info_button)
			QDEL_NULL(info_button)
		if(!silent && owner.current)
			farewell()
	var/datum/team/team = get_team()
	if(team)
		team.remove_member(owner)
	// we don't remove the activity component on purpose--no real point to it
	qdel(src)

/datum/antagonist/proc/greet()
	return

/datum/antagonist/proc/farewell()
	return

/datum/antagonist/proc/give_antag_moodies()
	if(!antag_moodlet)
		return
	SEND_SIGNAL(owner.current, COMSIG_ADD_MOOD_EVENT, "antag_moodlet", antag_moodlet)

/datum/antagonist/proc/clear_antag_moodies()
	if(!antag_moodlet)
		return
	SEND_SIGNAL(owner.current, COMSIG_CLEAR_MOOD_EVENT, "antag_moodlet")

/datum/antagonist/proc/remove_blacklisted_quirks()
	var/mob/living/L = owner.current
	if(istype(L))
		for(var/q in L.roundstart_quirks)
			var/datum/quirk/Q = q
			if(Q.type in blacklisted_quirks)
				if(initial(Q.antag_removal_text))
					to_chat(L, "<span class='boldannounce'>[initial(Q.antag_removal_text)]</span>")
				qdel(Q)

//Returns the team antagonist belongs to if any.
/datum/antagonist/proc/get_team()
	return

//Individual roundend report
/datum/antagonist/proc/roundend_report()
	var/list/report = list()

	if(!owner)
		CRASH("antagonist datum without owner")

	report += printplayer(owner)

	var/objectives_complete = TRUE
	if(objectives.len)
		report += printobjectives(objectives)
		for(var/datum/objective/objective in objectives)
			if(objective.completable && !objective.check_completion())
				objectives_complete = FALSE
				break

	if(objectives.len == 0 || objectives_complete)
		report += "<span class='greentext big'>The [name] was successful!</span>"
	else
		report += "<span class='redtext big'>The [name] has failed!</span>"

	return report.Join("<br>")

//Displayed at the start of roundend_category section, default to roundend_category header
/datum/antagonist/proc/roundend_report_header()
	return 	"<span class='header'>The [roundend_category] were:</span><br>"

//Displayed at the end of roundend_category section
/datum/antagonist/proc/roundend_report_footer()
	return


//ADMIN TOOLS

//Called when using admin tools to give antag status
/datum/antagonist/proc/admin_add(datum/mind/new_owner,mob/admin)
	message_admins("[key_name_admin(admin)] made [new_owner.current] into [name].")
	log_admin("[key_name(admin)] made [new_owner.current] into [name].")
	new_owner.add_antag_datum(src)

//Called when removing antagonist using admin tools
/datum/antagonist/proc/admin_remove(mob/user)
	if(!user)
		return
	message_admins("[key_name_admin(user)] has removed [name] antagonist status from [owner.current].")
	log_admin("[key_name(user)] has removed [name] antagonist status from [owner.current].")
	on_removal()

//gamemode/proc/is_mode_antag(antagonist/A) => TRUE/FALSE

//Additional data to display in antagonist panel section
//nuke disk code, genome count, etc
/datum/antagonist/proc/antag_panel_data()
	return ""

/datum/antagonist/proc/enabled_in_preferences(datum/mind/M)
	if(job_rank)
		if(M.current && M.current.client && (job_rank in M.current.client.prefs.be_special))
			return TRUE
		else
			return FALSE
	return TRUE

// List if ["Command"] = CALLBACK(), user will be appeneded to callback arguments on execution
/datum/antagonist/proc/get_admin_commands()
	. = list()

/// Creates an icon from the preview outfit.
/// Custom implementors of `get_preview_icon` should use this, as the
/// result of `get_preview_icon` is expected to be the completed version.
/datum/antagonist/proc/render_preview_outfit(datum/outfit/outfit, mob/living/carbon/human/dummy)
	dummy = dummy || new /mob/living/carbon/human/dummy/consistent
	dummy.equipOutfit(outfit, visualsOnly = TRUE)
	COMPILE_OVERLAYS(dummy)
	var/icon = getFlatIcon(dummy)

	// We don't want to qdel the dummy right away, since its items haven't initialized yet.
	SSatoms.prepare_deletion(dummy)

	return icon

/// Given an icon, will crop it to be consistent of those in the preferences menu.
/// Not necessary, and in fact will look bad if it's anything other than a human.
/datum/antagonist/proc/finish_preview_icon(icon/icon)
	// Zoom in on the top of the head and the chest
	// I have no idea how to do this dynamically.
	icon.Scale(115, 115)

	// This is probably better as a Crop, but I cannot figure it out.
	icon.Shift(WEST, 8)
	icon.Shift(SOUTH, 30)

	icon.Crop(1, 1, ANTAGONIST_PREVIEW_ICON_SIZE, ANTAGONIST_PREVIEW_ICON_SIZE)

	return icon

/// Returns the icon to show on the preferences menu.
/datum/antagonist/proc/get_preview_icon()
	if (isnull(preview_outfit))
		return null

	return finish_preview_icon(render_preview_outfit(preview_outfit))


/datum/antagonist/Topic(href,href_list)
	if(!check_rights(R_ADMIN))
		return
	//Antag memory edit
	if (href_list["memory_edit"])
		edit_memory(usr)
		owner.traitor_panel()
		return

	//Some commands might delete/modify this datum clearing or changing owner
	var/datum/mind/persistent_owner = owner

	var/commands = get_admin_commands()
	for(var/admin_command in commands)
		if(href_list["command"] == admin_command)
			var/datum/callback/C = commands[admin_command]
			C.Invoke(usr)
			persistent_owner.traitor_panel()
			return

/datum/antagonist/proc/edit_memory(mob/user)
	var/new_memo = stripped_multiline_input(user, "Write new memory", "Memory", antag_memory, MAX_MESSAGE_LEN)
	if (isnull(new_memo))
		return
	antag_memory = new_memo

/// Gets how fast we can hijack the shuttle, return 0 for can not hijack. Defaults to hijack_speed var, override for custom stuff like buffing hijack speed for hijack objectives or something.
/datum/antagonist/proc/hijack_speed()
	var/datum/objective/hijack/H = locate() in objectives
	if(!isnull(H?.hijack_speed_override))
		return H.hijack_speed_override
	return hijack_speed

/// Gets our threat level. Defaults to threat var, override for custom stuff like different traitor goals having different threats.
/datum/antagonist/proc/threat()
	. = CONFIG_GET(keyed_list/antag_threat)[lowertext(name)]
	if(. == null)
		return threat

//This one is created by admin tools for custom objectives
/datum/antagonist/custom
	antagpanel_category = "Custom"
	show_name_in_check_antagonists = TRUE //They're all different

/datum/antagonist/custom/admin_add(datum/mind/new_owner,mob/admin)
	var/custom_name = stripped_input(admin, "Custom antagonist name:", "Custom antag", "Antagonist")
	if(custom_name)
		name = custom_name
	else
		return
	..()

///ANTAGONIST UI STUFF

/datum/antagonist/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, ui_name, name)
		ui.open()

/datum/antagonist/ui_state(mob/user)
	return GLOB.always_state

///generic helper to send objectives as data through tgui. supports smart objectives too!
/datum/antagonist/proc/get_objectives()
	var/objective_count = 1
	var/list/objective_data = list()
	//all obj
	for(var/datum/objective/objective in objectives)
		objective_data += list(list(
			"count" = objective_count,
			"name" = objective.objective_name,
			"explanation" = objective.explanation_text,
			"complete" = objective.completed,
		))
		objective_count++
	return objective_data

//button for antags to review their descriptions/info

/datum/action/antag_info
	name = "Open Antag Information:"
	button_icon_state = "round_end"
	var/datum/antagonist/antag_datum

/datum/action/antag_info/New(Target, datum/antagonist/antag_datum)
	. = ..()
	src.antag_datum = antag_datum
	name += " [antag_datum.name]"

/datum/action/antag_info/Trigger()
	if(antag_datum)
		antag_datum.ui_interact(owner)

/datum/action/antag_info/IsAvailable()
	return TRUE
