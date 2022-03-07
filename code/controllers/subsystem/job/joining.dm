/datum/controller/subsystem/job/proc/ProcessRoundstartPlayer(mob/M, datum/job/J, loadout = TRUE, client/C)
	// autodetect
	if(!C)
		C = M.client
	if(!J && M.mind)
		J = GetJobAuto(M.mind?.assigned_role)
	// sigh make sure mind is set
	if(J)
		M.mind?.assigned_role = J.title
		M.job = J.title
	EquipPlayer(M, J, loadout, C.prefs, TRUE, FALSE, C)
	J.after_spawn(M, FALSE, C)
	GreetPlayer(M, J, TRUE, C)
	if(!J?.override_latejoin_spawn(M))
		SendToRoundstart(M, C, J)
	PostJoin(M, J, C, FALSE)

/datum/controller/subsystem/job/proc/ProcessLatejoinPlayer(mob/M, datum/job/J, loadout = TRUE, client/C)
	// autodetect
	if(!C)
		C = M.client
	if(!J && M.mind)
		J = GetJobAuto(M.mind?.assigned_role)
	// sigh make sure mind is set
	if(J)
		M.mind.assigned_role = J.title
		M.job = J.title
	EquipPlayer(M, J, loadout, C.prefs, TRUE, TRUE, C)
	J.after_spawn(M, TRUE, C)
	GreetPlayer(M, J, TRUE, C)
	if(!J?.override_latejoin_spawn(M))
		SendToLatejoin(M, C, job = J)
	PostJoin(M, J, C, TRUE)

/datum/controller/subsystem/job/proc/GreetPlayer(mob/M, datum/job/J, latejoin, client/C)
	var/client/output = C || M.client
	if(!J)
		return
	var/effective_title = output.prefs.GetPreferredAltTitle(J.title)
	to_chat(output, span_bold("You are the [effective_title]"))
	to_chat(output, span_bold("As the [effective_title] you answer directly to [J.GetSupervisorText()]. Special circumstances may change this."))
	J.radio_help_message(M)
	if(J.req_admin_notify)
		to_chat(output, "<b>You are playing a job that is important for Game Progression. If you have to disconnect immediately, please notify the admins via adminhelp. Otherwise put your locker gear back into the locker and cryo out.</b>")
	if(J.custom_spawn_text)
		to_chat(output, "<b>[J.custom_spawn_text]</b>")
	if(CONFIG_GET(number/minimal_access_threshold))
		to_chat(output, "<span class='notice'><B>As this station was initially staffed with a [CONFIG_GET(flag/jobs_have_minimal_access) ? "full crew, only your job's necessities" : "skeleton crew, additional access may"] have been added to your ID card.</B></span>")
	if(ishuman(M))
		var/mob/living/carbon/human/wageslave = M
		to_chat(output, "<b><span class = 'big'>Your account ID is [wageslave.account_id].</span></b>")
		M.add_memory("Your account ID is [wageslave.account_id].")

/datum/controller/subsystem/job/proc/EquipPlayer(mob/M, datum/job/J, loadout = TRUE, datum/preferences/prefs, announce, latejoin, client/C)
	if(!istype(J))
		J = GetJobAuto(J)
	ASSERT(istype(J))
	// attempt autodetect prefs
	if(!prefs)
		prefs = M.client?.prefs
	// if dress code compliant or no job, do loadout only. otherwise, do loadout first or job first based on dress code compliance
	var/list/obj/item/leftovers
	if(!J || !J.dresscodecompliant)
		leftovers = EquipLoadout(M, FALSE, null, prefs, C)
		HandleLoadoutLeftovers(M, leftovers, null, C)
		return

	J.equip(M, FALSE, announce, latejoin, null, prefs)

	if(J.dresscodecompliant)
		leftovers = EquipLoadout(M, FALSE, null, prefs, C)

	HandleLoadoutLeftovers(M, leftovers, null, C)

/datum/controller/subsystem/job/proc/PostJoin(mob/M, datum/job/J, client/C, latejoin)
	// job handling
	if(J)
		SSpersistence.antag_rep_change[M.client.ckey] += J.GetAntagRep()

	// auto deadmin
/*		if(M.client.holder)
			if(CONFIG_GET(flag/auto_deadmin_players) || (M.client.prefs?.toggles & DEADMIN_ALWAYS))
				M.client.holder.auto_deadmin()
			else
				handle_auto_deadmin_roles(M.client, rank) */


	// tcg card handling
	var/list/tcg_cards = C.prefs.tcg_cards
	var/list/tcg_decks = C.prefs.tcg_decks
	if(tcg_cards && ishuman(M))
		var/mob/living/carbon/human/H = M
		var/obj/item/tcgcard_binder/binder = new(get_turf(H))
		H.equip_to_slot_if_possible(binder, SLOT_IN_BACKPACK, disable_warning = TRUE, bypass_equip_delay_self = TRUE)
		for(var/card_type in tcg_cards)
			if(card_type)
				if(islist(tcg_cards[card_type]))
					for(var/duplicate in tcg_cards[card_type])
						var/obj/item/tcg_card/card = new(get_turf(H), card_type, duplicate)
						card.forceMove(binder)
						binder.cards.Add(card)
				else
					var/obj/item/tcg_card/card = new(get_turf(H), card_type, tcg_cards[card_type])
					card.forceMove(binder)
					binder.cards.Add(card)
		binder.check_for_exodia()
		if(length(tcg_decks))
			binder.decks = tcg_decks

	if(latejoin)
		AnnounceJoin(M, J, C)

/datum/controller/subsystem/job/proc/AnnounceJoin(mob/M, datum/job/J, client/C)
	if(istype(get_area(M), /area/shuttle/arrival) && SSshuttle.arrivals)
		SSshuttle.arrivals.QueueAnnounce(M, J.title)
	else
		AnnounceArrival(M, J.title)
/**
 * Assigns a player to a role.
 * @params
 * - M - mind or mob
 * - J - job , job title, or job type
 * - latejoin - latejoining mob?
 * - force - bypass checks
 */
/datum/controller/subsystem/job/proc/Assign(datum/mind/M, datum/job/J, latejoin = FALSE, force = FALSE)
	if(ismob(M))
		var/mob/_M = M
		M = _M.mind
	if(!istype(M))
		CRASH("Invalid mind.")
	if(!istype(J))
		J = GetJobAuto(J)
	if(!istype(J))
		CRASH("Invalid job.")
	JobDebug("ASSIGN: [M], [J], latejoin: [latejoin]")
	if(!force && !CanAssign(M, J, latejoin))
		JobDebug("ASSIGN: Failed CanAssign")
		return FALSE
	JobDebug("ASSIGN: Passed: JCP: [J.current_positions] (incremented)")
	M.assigned_role = J.title
	// hook into roundstart system so it doesn't have to call this manually
	if(unassigned)
		unassigned -= M.current
	J.current_positions++
	return TRUE

/datum/controller/subsystem/job/proc/CanAssign(M, datum/job/J, latejoin)
	var/mob/checking = ismob(M) && M
	if(!checking)
		if(istype(M, /datum/mind))
			var/datum/mind/_M = M
			checking = _M.current
		if(istype(M, /client))
			var/client/_C = M
			checking = _C.mob
	. = FALSE
	if(!checking)
		CRASH("No mob")
	if(!istype(J))
		CRASH("No job")
	if(jobban_isbanned(checking, J.title))
		return FALSE
	if(!J.player_old_enough(checking.client))
		return FALSE
	if(J.required_playtime_remaining(checking.client))
		return FALSE
	var/position_limit = latejoin? J.total_positions : J.roundstart_positions
	if(J.current_positions + 1 > position_limit)
		return FALSE
	return TRUE

/**
 * Sends a mob to a spawnpoint. Set override = TRUE to disable auto-detect of job.
 */
/datum/controller/subsystem/job/proc/SendToLatejoin(mob/M, client/C = M.client, faction, job, method, override)
	if(!override && M.mind?.assigned_role)
		var/datum/job/J = SSjob.GetJobName(M.mind.assigned_role)
		if(J)
			faction = J.faction
			job = J.GetID()

	var/atom/movable/landmark/spawnpoint/S

	S = SSjob.GetLatejoinSpawnpoint(C, job, faction, method)

	if(S)
		M.forceMove(S.GetSpawnLoc())
		S.OnSpawn(M, C)

	var/error_message = "Unable to send [key_name(M)] to latejoin."
	message_admins(error_message)
	subsystem_log(error_message)
	CRASH(error_message)		// this is serious.

/datum/controller/subsystem/job/proc/SendToRoundstart(mob/M, client/C, datum/job/J)
	var/atom/movable/landmark/spawnpoint/S = GetRoundstartSpawnpoint(M, C, J.GetID(), J.faction)
	if(!S)
		stack_trace("Couldn't find a roundstart spawnpoint for [M] ([C]) - [J.type] ([J.faction]).")
		SendToLatejoin(M)
	else
		var/atom/A = S.GetSpawnLoc()
		M.forceMove(A)
		S.OnSpawn(M, C)

/*
/datum/controller/subsystem/job/proc/handle_auto_deadmin_roles(client/C, rank)
	if(!C?.holder)
		return TRUE
	var/datum/job/job = GetJobName(rank)
	if(!job)
		return
	if((job.auto_deadmin_role_flags & DEADMIN_POSITION_HEAD) && (CONFIG_GET(flag/auto_deadmin_heads) || (C.prefs?.toggles & DEADMIN_POSITION_HEAD)))
		return C.holder.auto_deadmin()
	else if((job.auto_deadmin_role_flags & DEADMIN_POSITION_SECURITY) && (CONFIG_GET(flag/auto_deadmin_security) || (C.prefs?.toggles & DEADMIN_POSITION_SECURITY)))
		return C.holder.auto_deadmin()
	else if((job.auto_deadmin_role_flags & DEADMIN_POSITION_SILICON) && (CONFIG_GET(flag/auto_deadmin_silicons) || (C.prefs?.toggles & DEADMIN_POSITION_SILICON))) //in the event there's ever psuedo-silicon roles added, ie synths.
		return C.holder.auto_deadmin()*/
