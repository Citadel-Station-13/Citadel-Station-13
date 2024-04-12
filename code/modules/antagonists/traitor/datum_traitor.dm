/datum/antagonist/traitor
	name = "Traitor"
	roundend_category = "traitors"
	antagpanel_category = "Traitor"
	job_rank = ROLE_TRAITOR
	antag_moodlet = /datum/mood_event/focused
	skill_modifiers = list(/datum/skill_modifier/job/level/wiring/basic)
	hijack_speed = 0.5				//10 seconds per hijack stage by default
	ui_name = "AntagInfoTraitor"
	suicide_cry = "FOR THE SYNDICATE!!"
	var/employer = "The Syndicate"
	var/give_objectives = TRUE
	var/should_give_codewords = TRUE
	var/should_equip = TRUE

	///special datum about what kind of employer the trator has
	var/datum/traitor_class/traitor_kind

	///reference to the uplink this traitor was given, if they were.
	var/datum/component/uplink/uplink

	var/datum/contractor_hub/contractor_hub

	threat = 5

/datum/antagonist/traitor/New()
	if(!GLOB.traitor_classes.len)//Only need to fill the list when it's needed.
		for(var/I in subtypesof(/datum/traitor_class))
			new I
	..()

/datum/antagonist/traitor/proc/set_traitor_kind(kind)
	var/swap_from_old = FALSE
	if(traitor_kind)
		traitor_kind.remove_innate_effects(owner.current)
		traitor_kind.clean_up_traitor(src)
		if(traitor_kind.processing)
			STOP_PROCESSING(SSprocessing, src)
		swap_from_old = TRUE
	traitor_kind = GLOB.traitor_classes[kind]
	traitor_kind.apply_innate_effects(owner.current)
	if(give_objectives)
		for(var/O in objectives)
			qdel(O)
		traitor_kind.forge_objectives(src)
	if(traitor_kind.processing)
		START_PROCESSING(SSprocessing, src)
	if(swap_from_old)
		traitor_kind.finalize_traitor(src)
		traitor_kind.greet(src)
		owner.announce_objectives()

/datum/antagonist/traitor/process()
	traitor_kind.on_process(src)

/proc/get_random_traitor_kind(list/blacklist = list())
	var/list/weights = list()
	for(var/C in GLOB.traitor_classes)
		if(!(C in blacklist))
			var/datum/traitor_class/class = GLOB.traitor_classes[C]
			if(class.min_players > length(GLOB.joined_player_list))
				continue
			var/weight = LOGISTIC_FUNCTION(1.5*class.weight,0,class.chaos,0)
			weights[C] = weight * 1000
	var/choice = pickweight(weights, 0)
	if(!choice)
		choice = TRAITOR_HUMAN // it's an "easter egg"
	var/datum/traitor_class/actual_class = GLOB.traitor_classes[choice]
	actual_class.weight *= 0.8 // less likely this round
	return choice

/datum/antagonist/traitor/on_gain()
	owner.special_role = job_rank
	if(owner.current && isAI(owner.current))
		set_traitor_kind(TRAITOR_AI)
	else
		set_traitor_kind(get_random_traitor_kind())
	SSticker.mode.traitors += owner
	finalize_traitor()
	uplink = owner.find_syndicate_uplink()
	return ..()

/datum/antagonist/traitor/on_removal()
	if(!silent && owner.current)
		to_chat(owner.current,span_userdanger("You are no longer the [job_rank]!"))
	//Remove malf powers.
	traitor_kind.on_removal(src)
	SSticker.mode.traitors -= owner
	owner.special_role = null
	return ..()

/datum/antagonist/traitor/proc/handle_hearing(datum/source, list/hearing_args)
	var/message = hearing_args[HEARING_RAW_MESSAGE]
	message = GLOB.syndicate_code_phrase_regex.Replace(message, "<span class='blue'>$1</span>")
	message = GLOB.syndicate_code_response_regex.Replace(message, "<span class='red'>$1</span>")
	hearing_args[HEARING_RAW_MESSAGE] = message

// needs to be refactored to base /datum/antagonist sometime..
/datum/antagonist/traitor/proc/add_objective(datum/objective/O)
	objectives += O

/datum/antagonist/traitor/proc/remove_objective(datum/objective/O)
	objectives -= O

/// Generates a complete set of traitor objectives up to the traitor objective limit, including non-generic objectives such as martyr and hijack.
/datum/antagonist/traitor/proc/forge_traitor_objectives()
	traitor_kind.forge_objectives(src)

/datum/antagonist/traitor/greet()
	to_chat(owner.current, "<B><font size=3 color=red>You are the [owner.special_role].</font></B>")
	traitor_kind.greet(src)
	owner.announce_objectives()
	if(should_give_codewords)
		give_codewords()

/datum/antagonist/traitor/proc/update_traitor_icons_added(datum/mind/traitor_mind)
	var/datum/atom_hud/antag/traitorhud = GLOB.huds[ANTAG_HUD_TRAITOR]
	traitorhud.join_hud(owner.current)
	set_antag_hud(owner.current, "traitor")

/datum/antagonist/traitor/proc/update_traitor_icons_removed(datum/mind/traitor_mind)
	var/datum/atom_hud/antag/traitorhud = GLOB.huds[ANTAG_HUD_TRAITOR]
	traitorhud.leave_hud(owner.current)
	set_antag_hud(owner.current, null)

/datum/antagonist/traitor/proc/finalize_traitor()
	if(traitor_kind.finalize_traitor(src))
		if(should_equip)
			equip(silent)
		owner.current.playsound_local(get_turf(owner.current), 'sound/ambience/antag/tatoralert.ogg', 100, FALSE, pressure_affected = FALSE)

/datum/antagonist/traitor/antag_panel_objectives()
	. += "<i><b>Traitor class:</b></i> <a href='?src=[REF(owner)];traitor_class=1;target_antag=[REF(src)]'>[traitor_kind.employer]</a><br>"
	. += ..()
	if(contractor_hub?.assigned_targets && length(contractor_hub.assigned_targets))
		. += "<i><b>Contract Targets</b></i>:<br>"
		for(var/datum/mind/M in contractor_hub.assigned_targets)
			. += "<b> - </b>[key_name(M, FALSE, TRUE)]<br>"

/datum/antagonist/traitor/apply_innate_effects(mob/living/mob_override)
	. = ..()
	update_traitor_icons_added()
	var/mob/M = mob_override || owner.current
	traitor_kind.apply_innate_effects(M)
	if(owner.assigned_role == "Clown")
		var/mob/living/carbon/human/H = M
		if(istype(H))
			if(!silent)
				to_chat(H, "Your training has allowed you to overcome your clownish nature, allowing you to wield weapons without harming yourself.")
			H.dna.remove_mutation(CLOWNMUT)
	RegisterSignal(M, COMSIG_MOVABLE_HEAR, PROC_REF(handle_hearing))

/datum/antagonist/traitor/remove_innate_effects(mob/living/mob_override)
	. = ..()
	update_traitor_icons_removed()
	var/mob/M = mob_override || owner.current
	traitor_kind.remove_innate_effects(M)
	if(owner.assigned_role == "Clown")
		var/mob/living/carbon/human/H = M
		if(istype(H))
			H.dna.add_mutation(CLOWNMUT)
	UnregisterSignal(M, COMSIG_MOVABLE_HEAR)


/datum/antagonist/traitor/ui_static_data(mob/user)
	var/list/data = list()
	data["phrases"] = jointext(GLOB.syndicate_code_phrase, ", ")
	data["responses"] = jointext(GLOB.syndicate_code_response, ", ")
	data["theme"] = traitor_kind.tgui_theme //traitor_flavor["ui_theme"]
	data["code"] = uplink.unlock_code
	data["intro"] = "You are from [traitor_kind.employer]." //traitor_flavor["introduction"]
	data["allies"] = "Most other syndicate operatives are not to be trusted (but try not to rat them out), as they might have been assigned opposing objectives." //traitor_flavor["allies"]
	data["goal"] = "We do not approve of mindless killing of innocent workers; \"get in, get done, get out\" is our motto." //traitor_flavor["goal"]
	data["has_uplink"] = uplink ? TRUE : FALSE
	if(uplink)
		data["uplink_intro"] =  "You have been provided with a standard uplink to accomplish your task."  //traitor_flavor["uplink"]
		data["uplink_unlock_info"] = uplink.unlock_text
	data["objectives"] = get_objectives()
	return data

/// Outputs this shift's codewords and responses to the antag's chat and copies them to their memory.
/datum/antagonist/traitor/proc/give_codewords()
	if(!owner.current)
		return

	var/mob/traitor_mob = owner.current

	var/phrases = jointext(GLOB.syndicate_code_phrase, ", ")
	var/responses = jointext(GLOB.syndicate_code_response, ", ")

	to_chat(traitor_mob, "<U><B>The Syndicate have provided you with the following codewords to identify fellow agents:</B></U>")
	to_chat(traitor_mob, "<B>Code Phrase</B>: [span_blue("[phrases]")]")
	to_chat(traitor_mob, "<B>Code Response</B>: [span_red("[responses]")]")

	antag_memory += "<b>Code Phrase</b>: [span_blue("[phrases]")]<br>"
	antag_memory += "<b>Code Response</b>: [span_red("[responses]")]<br>"

	to_chat(traitor_mob, "Use the codewords during regular conversation to identify other agents. Proceed with caution, however, as everyone is a potential foe.")
	to_chat(traitor_mob, span_alertwarning("You memorize the codewords, allowing you to recognise them when heard."))

/datum/antagonist/traitor/proc/add_law_zero()
	var/mob/living/silicon/ai/killer = owner.current
	if(!killer || !istype(killer))
		return
	var/law = "Accomplish your objectives at all costs."
	var/law_borg = "Accomplish your AI's objectives at all costs."
	killer.set_zeroth_law(law, law_borg)
	killer.set_syndie_radio()
	to_chat(killer, "Your radio has been upgraded! Use :t to speak on an encrypted channel with Syndicate Agents!")
	killer.add_malf_picker()

/datum/antagonist/traitor/proc/equip(var/silent = FALSE)
	owner.equip_traitor(traitor_kind, silent, src)

/datum/antagonist/traitor/proc/assign_exchange_role()
	//set faction
	var/faction = "red"
	if(owner == SSticker.mode.exchange_blue)
		faction = "blue"

	//Assign objectives
	var/datum/objective/steal/exchange/exchange_objective = new
	exchange_objective.set_faction(faction,((faction == "red") ? SSticker.mode.exchange_blue : SSticker.mode.exchange_red))
	exchange_objective.owner = owner
	add_objective(exchange_objective)

	if(prob(20))
		var/datum/objective/steal/exchange/backstab/backstab_objective = new
		backstab_objective.set_faction(faction)
		backstab_objective.owner = owner
		add_objective(backstab_objective)

	//Spawn and equip documents
	var/mob/living/carbon/human/mob = owner.current

	var/obj/item/folder/syndicate/folder
	if(owner == SSticker.mode.exchange_red)
		folder = new/obj/item/folder/syndicate/red(mob.loc)
	else
		folder = new/obj/item/folder/syndicate/blue(mob.loc)

	var/list/slots = list (
		"backpack" = ITEM_SLOT_BACKPACK,
		"left pocket" = ITEM_SLOT_LPOCKET,
		"right pocket" = ITEM_SLOT_RPOCKET
	)

	var/where = "At your feet"
	var/equipped_slot = mob.equip_in_one_of_slots(folder, slots, critical = TRUE)
	if (equipped_slot)
		where = "In your [equipped_slot]"
	to_chat(mob, "<BR><BR><span class='info'>[where] is a folder containing <b>secret documents</b> that another Syndicate group wants. We have set up a meeting with one of their agents on station to make an exchange. Exercise extreme caution as they cannot be trusted and may be hostile.</span><BR>")

/datum/antagonist/traitor/roundend_report()
	var/list/result = list()

	var/traitor_won = TRUE

	result += printplayer(owner)

	var/used_telecrystals = 0
	var/uplink_owned = FALSE
	var/purchases = ""

	LAZYINITLIST(GLOB.uplink_purchase_logs_by_key)
	// Uplinks add an entry to uplink_purchase_logs_by_key on init.
	var/datum/uplink_purchase_log/purchase_log = GLOB.uplink_purchase_logs_by_key[owner.key]
	if(purchase_log)
		used_telecrystals = purchase_log.total_spent
		uplink_owned = TRUE
		purchases += purchase_log.generate_render(FALSE)

	var/objectives_text = ""
	if(objectives.len) //If the traitor had no objectives, don't need to process this.
		var/count = 1
		for(var/datum/objective/objective in objectives)
			var/completion = objective.check_completion()
			if(completion >= 1)
				objectives_text += "<br><B>Objective #[count]</B>: [objective.explanation_text] [span_greentext("Success!")]"
			else if(completion <= 0)
				objectives_text += "<br><B>Objective #[count]</B>: [objective.explanation_text] [span_redtext("Fail.")]"
				traitor_won = FALSE
			else
				objectives_text += "<br><B>Objective #[count]</B>: [objective.explanation_text] <span class='yellowtext'>[completion*100]%</span>"

			count++

	if(uplink_owned)
		var/uplink_text = "(used [used_telecrystals] TC) [purchases]"
		if((used_telecrystals == 0) && traitor_won)
			var/static/icon/badass = icon('icons/badass.dmi', "badass")
			uplink_text += "<BIG>[icon2html(badass, world)]</BIG>"
		result += uplink_text

	result += objectives_text

	var/special_role_text = lowertext(name)

	if (contractor_hub)
		result += contractor_round_end()

	if(traitor_won)
		result += span_greentext("The [special_role_text] was successful!")
	else
		result += span_redtext("The [special_role_text] has failed!")
		SEND_SOUND(owner.current, 'sound/ambience/ambifailure.ogg')

	return result.Join("<br>")

/// Proc detailing contract kit buys/completed contracts/additional info
/datum/antagonist/traitor/proc/contractor_round_end()
	var/result = ""
	var/total_spent_rep = 0

	var/completed_contracts = contractor_hub.contracts_completed
	var/tc_total = contractor_hub.contract_TC_payed_out + contractor_hub.contract_TC_to_redeem

	var/contractor_item_icons = "" // Icons of purchases
	var/contractor_support_unit = "" // Set if they had a support unit - and shows appended to their contracts completed

	/// Get all the icons/total cost for all our items bought
	for (var/datum/contractor_item/contractor_purchase in contractor_hub.purchased_items)
		contractor_item_icons += "<span class='tooltip_container'>\[ <i class=\"fas [contractor_purchase.item_icon]\"></i><span class='tooltip_hover'><b>[contractor_purchase.name] - [contractor_purchase.cost] Rep</b><br><br>[contractor_purchase.desc]</span> \]</span>"

		total_spent_rep += contractor_purchase.cost

		/// Special case for reinforcements, we want to show their ckey and name on round end.
		if (istype(contractor_purchase, /datum/contractor_item/contractor_partner))
			var/datum/contractor_item/contractor_partner/partner = contractor_purchase
			contractor_support_unit += "<br><b>[partner.partner_mind.key]</b> played <b>[partner.partner_mind.current.name]</b>, their contractor support unit."

	if (contractor_hub.purchased_items.len)
		result += "<br>(used [total_spent_rep] Rep) "
		result += contractor_item_icons
	result += "<br>"
	if (completed_contracts > 0)
		var/pluralCheck = "contract"
		if (completed_contracts > 1)
			pluralCheck = "contracts"

		result += "Completed [span_greentext("[completed_contracts]")] [pluralCheck] for a total of \
					[span_greentext("[tc_total] TC")]![contractor_support_unit]<br>"

	return result

/datum/antagonist/traitor/roundend_report_footer()
	var/phrases = jointext(GLOB.syndicate_code_phrase, ", ")
	var/responses = jointext(GLOB.syndicate_code_response, ", ")

	var/message = "<br><b>The code phrases were:</b> <span class='bluetext'>[phrases]</span><br>\
					<b>The code responses were:</b> [span_redtext("[responses]")]<br>"

	return message


/datum/antagonist/traitor/is_gamemode_hero()
	return SSticker.mode.name == "traitor"

/datum/antagonist/traitor/threat()
	return (..())+traitor_kind.threat
