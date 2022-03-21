GLOBAL_LIST_EMPTY(antagonists)

/datum/antagonist
	///Public name for this antagonist. Appears for player prompts and round-end reports.
	var/name = "Antagonist"
	///Section of roundend report, datums with same category will be displayed together, also default header for the section
	var/roundend_category = "other antagonists"
	///Set to false to hide the antagonists from roundend report
	var/show_in_roundend = TRUE
	///If false, the roundtype will still convert with this antag active
	var/prevent_roundtype_conversion = TRUE
	///Mind that owns this datum
	var/datum/mind/owner
	///Silent will prevent the gain/lose texts to show
	var/silent = FALSE
	///Whether or not the person will be able to have more than one datum
	var/can_coexist_with_others = TRUE
	///List of datums this type can't coexist with
	var/list/typecache_datum_blacklist = list()
	///The define string we use to identify the role for bans/player polls to spawn a random new one in.
	var/job_rank
	///Should replace jobbanned player with ghosts if granted.
	var/replace_banned = TRUE
	///List of the objective datums that this role currently has, completing all objectives at round-end will cause this antagonist to greentext.
	var/list/objectives = list()
	///String dialogue that is added to the player's in-round notes and memories regarding specifics of that antagonist, eg. the nuke code for nuke ops, or your unlock code for traitors.
	var/antag_memory = ""
	///typepath of moodlet that the mob will gain when granted this antagonist type.
	var/antag_moodlet

	///What is the configuration of this antagonist's hud icon, such as it's screen position and style, so thatit doesn't break other in-game hud icons.
	var/antag_hud_type
	///Name of the antag hud we provide to this mob.
	var/antag_hud_name
	/// If above 0, this is the multiplier for the speed at which we hijack the shuttle. Do not directly read, use hijack_speed().
	var/hijack_speed = 0
	/// The battlecry this antagonist shouts when suiciding with C4/X4.
	var/suicide_cry = ""
	/// The typepath for the outfit to show in the preview for the preferences menu.
	var/preview_outfit
	/// If set to true, the antag will not be added to the living antag list.
	var/soft_antag = FALSE

	//Antag panel properties
	///This will hide adding this antag type in antag panel, use only for internal subtypes that shouldn't be added directly but still show if possessed by mind
	var/show_in_antagpanel = TRUE
	///Antagpanel will display these together, REQUIRED
	var/antagpanel_category = "Uncategorized"
	///Will append antagonist name in admin listings - use for categories that share more than one antag type
	var/show_name_in_check_antagonists = FALSE
	/// Should this antagonist be shown as antag to ghosts? Shouldn't be used for stealthy antagonists like traitors
	var/show_to_ghosts = FALSE
//ambition start
	/// Lazy list for antagonists to request the admins objectives.
	var/list/requested_objective_changes
//ambition end

	/* CIT SPECIFIC */
	/// Quirks that will be removed upon gaining this antag. Pacifist and mute are default.
	var/list/blacklisted_quirks = list(/datum/quirk/nonviolent,/datum/quirk/mute)
	/// Amount of threat this antag poses, for dynamic mode
	var/threat = 0

	var/delete_on_mind_deletion = TRUE

	var/list/skill_modifiers
	/* CIT SPECIFIC end */

	//ANTAG UI

	///name of the UI that will try to open, right now having nothing means this won't exist but in the future all should.
	var/ui_name
	///button to access antag interface
	var/datum/action/antag_info/info_button

/datum/antagonist/New()
	GLOB.antagonists += src
	typecache_datum_blacklist = typecacheof(typecache_datum_blacklist)

/datum/antagonist/Destroy()
	GLOB.antagonists -= src
	if(!owner)
		stack_trace("Destroy()ing antagonist datum when it has no owner.")
	else
//ambition start
		owner?.do_remove_antag_datum(src)
//ambition end
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
	if(!soft_antag && old_body && old_body.stat != DEAD && !length(old_body.mind?.antag_datums))
		old_body.remove_from_current_living_antags()
	apply_innate_effects(new_body)
	if(!soft_antag && new_body.stat != DEAD)
		new_body.add_to_current_living_antags()

//This handles the application of antag huds/special abilities
/datum/antagonist/proc/apply_innate_effects(mob/living/mob_override)
	return

//This handles the removal of antag huds/special abilities
/datum/antagonist/proc/remove_innate_effects(mob/living/mob_override)
	return

/// This is called when the antagonist is being mindshielded.
/datum/antagonist/proc/pre_mindshield(mob/implanter, mob/living/mob_override)
	SIGNAL_HANDLER
	// return COMPONENT_MINDSHIELD_PASSED

/// This is called when the antagonist is successfully mindshielded.
/datum/antagonist/proc/on_mindshield(mob/implanter, mob/living/mob_override)
	SIGNAL_HANDLER
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


/// Handles adding and removing the clumsy mutation from clown antags. Gets called in apply/remove_innate_effects
/datum/antagonist/proc/handle_clown_mutation(mob/living/mob_override, message, removing = TRUE)
	if(!ishuman(mob_override) || owner.assigned_role != "Clown")
		return
	var/mob/living/carbon/human/human_override = mob_override
	if(removing) // They're a clown becoming an antag, remove clumsy
		human_override.dna.remove_mutation(CLOWNMUT)
		if(!silent && message)
			to_chat(human_override, span_boldnotice("[message]"))
	else
		human_override.dna.add_mutation(CLOWNMUT) // We're removing their antag status, add back clumsy


//Assign default team and creates one for one of a kind team antagonists
/datum/antagonist/proc/create_team(datum/team/team)
	return

///Called by the add_antag_datum() mind proc after the instanced datum is added to the mind's antag_datums list.
/datum/antagonist/proc/on_gain()
	SHOULD_CALL_PARENT(TRUE)
	if(!owner)
		CRASH("[src] ran on_gain() without a mind")
	if(!owner.current)
		CRASH("[src] ran on_gain() on a mind without a mob")
	if(ui_name)//in the future, this should entirely replace greet.
		info_button = new(owner.current, src)
		info_button.Grant(owner.current)
	if(!silent)
		greet()
		if(ui_name)
			to_chat(owner.current, span_big("You are \a [src]."))
			to_chat(owner.current, span_boldnotice("For more info, read the panel. you can always come back to it using the button in the top left."))
			info_button.Trigger()
	apply_innate_effects()
	give_antag_moodies()
	remove_blacklisted_quirks()
	// RegisterSignal(owner, COMSIG_PRE_MINDSHIELD_IMPLANT, .proc/pre_mindshield)
	// RegisterSignal(owner, COMSIG_MINDSHIELD_IMPLANTED, .proc/on_mindshield)
	if(is_banned(owner.current) && replace_banned)
		replace_banned_player()
	// else if(owner.current.client?.holder && (CONFIG_GET(flag/auto_deadmin_antagonists) || owner.current.client.prefs?.toggles & DEADMIN_ANTAGONIST))
	// 	owner.current.client.holder.auto_deadmin()
	if(!soft_antag && owner.current.stat != DEAD)
		owner.current.add_to_current_living_antags()

	// cit skill
	if(skill_modifiers)
		for(var/A in skill_modifiers)
			ADD_SINGLETON_SKILL_MODIFIER(owner, A, type)
			var/datum/skill_modifier/job/M = GLOB.skill_modifiers[GET_SKILL_MOD_ID(A, type)]
			if(istype(M))
				M.name = "[name] Training"
	owner.current.AddComponent(/datum/component/activity)
	SEND_SIGNAL(owner.current, COMSIG_MOB_ANTAG_ON_GAIN, src)


/**
 * Proc that checks the sent mob aganst the banlistfor this antagonist.
 * Returns FALSE if no mob is sent, or the mob is not found to be banned.
 *
 *  * mob/M: The mob that you are looking for on the banlist.
 */
/datum/antagonist/proc/is_banned(mob/M)
	if(!M)
		return FALSE
	. = (jobban_isbanned(M, ROLE_SYNDICATE) || QDELETED(M) || (job_rank && (jobban_isbanned(M,job_rank) || QDELETED(M))))

/**
 * Proc that replaces a player who cannot play a specific antagonist due to being banned via a poll, and alerts the player of their being on the banlist.
 */
/datum/antagonist/proc/replace_banned_player()
	set waitfor = FALSE

	var/list/mob/dead/observer/candidates = pollCandidatesForMob("Do you want to play as a [name]?", "[name]", job_rank, 50, owner.current)
	if(LAZYLEN(candidates))
		var/mob/dead/observer/C = pick(candidates)
		to_chat(owner, "Your mob has been taken over by a ghost! Appeal your job ban if you want to avoid this in the future!")
		message_admins("[key_name_admin(C)] has taken control of ([key_name_admin(owner)]) to replace a jobbanned player.")
		owner.current.ghostize(0)
		C.transfer_ckey(owner.current, FALSE)

/**
 * Called by the remove_antag_datum() and remove_all_antag_datums() mind procs for the antag datum to handle its own removal and deletion.
 */
/datum/antagonist/proc/on_removal()
	SHOULD_CALL_PARENT(TRUE)
	if(!owner)
		CRASH("Antag datum with no owner.")

	remove_innate_effects()
	clear_antag_moodies()
	owner.do_remove_antag_datum(src)
	// cit skill
	for(var/A in skill_modifiers)
		owner.remove_skill_modifier(GET_SKILL_MOD_ID(A, type))
	// end
	if(!LAZYLEN(owner.antag_datums) && !soft_antag)
		owner.current.remove_from_current_living_antags()
	if(info_button)
		QDEL_NULL(info_button)
	if(!silent && owner.current)
		farewell()
	// UnregisterSignal(owner, COMSIG_PRE_MINDSHIELD_IMPLANT)
	// UnregisterSignal(owner, COMSIG_MINDSHIELD_IMPLANTED)
	var/datum/team/team = get_team()
	if(team)
		team.remove_member(owner)
	qdel(src)

/**
 * Proc that sends fluff or instructional messages to the player when they are given this antag datum.
 * Use this proc for playing sounds, sending alerts, or helping to setup non-gameplay influencing aspects of the antagonist type.
 */
/datum/antagonist/proc/greet()
	return

/**
 * Proc that sends fluff or instructional messages to the player when they lose this antag datum.
 * Use this proc for playing sounds, sending alerts, or otherwise informing the player that they're no longer a specific antagonist type.
 */
/datum/antagonist/proc/farewell()
	return

/**
 * Proc that assigns this antagonist's ascribed moodlet to the player.
 */
/datum/antagonist/proc/give_antag_moodies()
	if(!antag_moodlet)
		return
	SEND_SIGNAL(owner.current, COMSIG_ADD_MOOD_EVENT, "antag_moodlet", antag_moodlet)

/**
 * Proc that removes this antagonist's ascribed moodlet from the player.
 */
/datum/antagonist/proc/clear_antag_moodies()
	if(!antag_moodlet)
		return
	SEND_SIGNAL(owner.current, COMSIG_CLEAR_MOOD_EVENT, "antag_moodlet")

/**
 * Removes invalid quirks.
 */
/datum/antagonist/proc/remove_blacklisted_quirks()
	var/mob/living/L = owner.current
	if(istype(L))
		for(var/q in L.roundstart_quirks)
			var/datum/quirk/Q = q
			if(Q.type in blacklisted_quirks)
				if(initial(Q.antag_removal_text))
					to_chat(L, "<span class='boldannounce'>[initial(Q.antag_removal_text)]</span>")
				qdel(Q)

/**
 * Proc that will return the team this antagonist belongs to, when called. Helpful with antagonists that may belong to multiple potential teams in a single round, like families.
 */
/datum/antagonist/proc/get_team()
	return

/**
 * Proc that sends string information for the end-round report window to the server.
 * This runs on every instance of every antagonist that exists at the end of the round.
 * This is the body of the message, sandwiched between roundend_report_header and roundend_report_footer.
 */
/datum/antagonist/proc/roundend_report()
	var/list/report = list()

	if(!owner)
		CRASH("Antagonist datum without owner")

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

/**
 * Proc that sends string data for the round-end report.
 * Displayed before roundend_report and roundend_report_footer.
 * Appears at start of roundend_catagory section.
 */
/datum/antagonist/proc/roundend_report_header()
	return "<span class='header'>The [roundend_category] were:</span><br>"

/**
 * Proc that sends string data for the round-end report.
 * Displayed after roundend_report and roundend_report_footer.
 * Appears at the end of the roundend_catagory section.
 */
/datum/antagonist/proc/roundend_report_footer()
	return


//ADMIN TOOLS

//Called when using admin tools to give antag status
/datum/antagonist/proc/admin_add(datum/mind/new_owner,mob/admin)
	message_admins("[key_name_admin(admin)] made [key_name_admin(new_owner)] into [name].")
	log_admin("[key_name(admin)] made [key_name(new_owner)] into [name].")
	new_owner.add_antag_datum(src)

//Called when removing antagonist using admin tools
/datum/antagonist/proc/admin_remove(mob/user)
	if(!user)
		return
	message_admins("[key_name_admin(user)] has removed [name] antagonist status from [key_name_admin(owner)].")
	log_admin("[key_name(user)] has removed [name] antagonist status from [key_name(owner)].")
	on_removal()

//gamemode/proc/is_mode_antag(antagonist/A) => TRUE/FALSE

/**
 * Additional data to display in the antagonist panel section.
 * For example, nuke disk code, genome count, etc
 */
/datum/antagonist/proc/antag_panel_data()
	return ""

/datum/antagonist/proc/enabled_in_preferences(datum/mind/M)
	if(job_rank)
		if(M.current && M.current.client && (job_rank in M.current.client.prefs.be_special))
			return TRUE
		else
			return FALSE
	return TRUE

/// List of ["Command"] = CALLBACK(), user will be appeneded to callback arguments on execution
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

/**
 * Gets how fast we can hijack the shuttle, return 0 for can not hijack.
 * Defaults to hijack_speed var, override for custom stuff like buffing hijack speed for hijack objectives or something.
 */
/datum/antagonist/proc/hijack_speed()
	var/datum/objective/hijack/H = locate() in objectives
	if(!isnull(H?.hijack_speed_override))
		return H.hijack_speed_override
	return hijack_speed

/**
 * Gets our threat level. Override this proc for custom functionality/dynamic threat level.
 */
/datum/antagonist/proc/threat()
	. = CONFIG_GET(keyed_list/antag_threat)[lowertext(name)]
	if(. == null)
		return threat

//This one is created by admin tools for custom objectives
/datum/antagonist/custom
	antagpanel_category = "Custom"
	show_name_in_check_antagonists = TRUE //They're all different
	var/datum/team/custom_team

/datum/antagonist/custom/create_team(datum/team/team)
	custom_team = team

/datum/antagonist/custom/get_team()
	return custom_team

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
			"name" = objective.name,
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

///Clears change requests from deleted objectives to avoid broken references.
/datum/antagonist/proc/clean_request_from_del_objective(datum/objective/source, force)
	var/objective_reference = REF(source)
	for(var/uid in requested_objective_changes)
		var/list/change_request = requested_objective_changes[uid]
		if(change_request["target"] != objective_reference)
			continue
		LAZYREMOVE(requested_objective_changes, uid)


/datum/antagonist/proc/add_objective_change(uid, list/additions)
	LAZYADD(requested_objective_changes, uid)
	var/datum/objective/request_target = additions["target"]
	if(!ispath(request_target))
		request_target = locate(request_target) in objectives
		if(istype(request_target))
			RegisterSignal(request_target, COMSIG_PARENT_QDELETING, .proc/clean_request_from_del_objective)
	requested_objective_changes[uid] = additions


/datum/antagonist/proc/remove_objective_change(uid)
	if(!LAZYACCESS(requested_objective_changes, uid))
		return
	var/datum/objective/request_target = requested_objective_changes[uid]["target"]
	if(!ispath(request_target))
		request_target = locate(request_target) in objectives
		if(istype(request_target))
			UnregisterSignal(request_target, COMSIG_PARENT_QDELETING)
	LAZYREMOVE(requested_objective_changes, uid)
