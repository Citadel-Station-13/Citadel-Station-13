/datum/antagonist/traitor
	name = "Traitor"
	roundend_category = "traitors"
	antagpanel_category = "Traitor"
	job_rank = ROLE_TRAITOR
	antag_moodlet = /datum/mood_event/focused
	var/special_role = ROLE_TRAITOR
	var/employer = "The Syndicate"
	var/give_objectives = TRUE
	var/should_give_codewords = TRUE
	var/should_equip = TRUE
	var/datum/traitor_class/traitor_kind
	var/datum/contractor_hub/contractor_hub
	hijack_speed = 0.5				//10 seconds per hijack stage by default

/datum/antagonist/traitor/New()
	..()
	if(!GLOB.traitor_classes.len)//Only need to fill the list when it's needed.
		for(var/I in subtypesof(/datum/traitor_class))
			new I

/datum/antagonist/traitor/proc/set_traitor_kind(var/kind)
	traitor_kind = GLOB.traitor_classes[kind]
	if(istype(SSticker.mode, /datum/game_mode/dynamic))
		var/datum/game_mode/dynamic/mode = SSticker.mode
		if(traitor_kind.cost)
			mode.spend_threat(traitor_kind.cost)
			mode.log_threat("[traitor_kind.cost] was spent due to [owner.name] being a [traitor_kind.name].")

/datum/antagonist/traitor/on_gain()
	if(owner.current && isAI(owner.current))
		set_traitor_kind(TRAITOR_AI)
	else
		var/chaos_weight = 0
		if(istype(SSticker.mode,/datum/game_mode/dynamic))
			var/datum/game_mode/dynamic/mode = SSticker.mode
			chaos_weight = (mode.threat - 50)/50
		var/list/weights = list()
		for(var/C in GLOB.traitor_classes)
			var/datum/traitor_class/class = GLOB.traitor_classes[C]
			var/weight = (1.5*class.weight)/(0.5+NUM_E**(-chaos_weight*class.chaos)) // just a logistic function
			weights[C] = weight
		var/choice = pickweightAllowZero(weights)
		if(!choice)
			choice = GLOB.traitor_classes[TRAITOR_HUMAN]
		set_traitor_kind(pickweightAllowZero(weights))
		traitor_kind.weight *= 0.8 // less likely this round
	SSticker.mode.traitors += owner
	owner.special_role = special_role
	if(give_objectives)
		traitor_kind.forge_objectives(src)
	finalize_traitor()
	..()

/datum/antagonist/traitor/on_removal()
	//Remove malf powers.
	traitor_kind.on_removal(src)
	SSticker.mode.traitors -= owner
	if(!silent && owner.current)
		to_chat(owner.current,"<span class='userdanger'> You are no longer the [special_role]! </span>")
	owner.special_role = null
	. = ..()

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
	RegisterSignal(M, COMSIG_MOVABLE_HEAR, .proc/handle_hearing)

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

/datum/antagonist/traitor/proc/give_codewords()
	if(!owner.current)
		return
	var/mob/traitor_mob=owner.current

	var/phrases = jointext(GLOB.syndicate_code_phrase, ", ")
	var/responses = jointext(GLOB.syndicate_code_response, ", ")

	var/dat = "<U><B>The Syndicate have provided you with the following codewords to identify fellow agents:</B></U>\n"
	dat += "<B>Code Phrase</B>: <span class='blue'>[phrases]</span>\n"
	dat += "<B>Code Response</B>: <span class='red'>[responses]</span>"
	to_chat(traitor_mob, dat)

	antag_memory += "<b>Code Phrase</b>: <span class='blue'>[phrases]</span><br>"
	antag_memory += "<b>Code Response</b>: <span class='red'>[responses]</span><br>"

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
		"backpack" = SLOT_IN_BACKPACK,
		"left pocket" = SLOT_L_STORE,
		"right pocket" = SLOT_R_STORE
	)

	var/where = "At your feet"
	var/equipped_slot = mob.equip_in_one_of_slots(folder, slots)
	if (equipped_slot)
		where = "In your [equipped_slot]"
	to_chat(mob, "<BR><BR><span class='info'>[where] is a folder containing <b>secret documents</b> that another Syndicate group wants. We have set up a meeting with one of their agents on station to make an exchange. Exercise extreme caution as they cannot be trusted and may be hostile.</span><BR>")

//TODO Collate
/datum/antagonist/traitor/roundend_report()
	var/list/result = list()

	var/traitorwin = TRUE

	result += printplayer(owner)

	var/TC_uses = 0
	var/uplink_true = FALSE
	var/purchases = ""
	LAZYINITLIST(GLOB.uplink_purchase_logs_by_key)
	var/datum/uplink_purchase_log/H = GLOB.uplink_purchase_logs_by_key[owner.key]
	if(H)
		TC_uses = H.total_spent
		uplink_true = TRUE
		purchases += H.generate_render(FALSE)

	var/objectives_text = ""
	if(objectives.len)//If the traitor had no objectives, don't need to process this.
		var/count = 1
		for(var/datum/objective/objective in objectives)
			if(objective.completable)
				var/completion = objective.check_completion()
				if(completion >= 1)
					objectives_text += "<br><B>Objective #[count]</B>: [objective.explanation_text] <span class='greentext'><B>Success!</span>"
				else if(completion <= 0)
					objectives_text += "<br><B>Objective #[count]</B>: [objective.explanation_text] <span class='redtext'>Fail.</span>"
					traitorwin = FALSE
				else
					objectives_text += "<br><B>Objective #[count]</B>: [objective.explanation_text] <span class='yellowtext'>[completion*100]%</span>"
			else
				objectives_text += "<br><B>Objective #[count]</B>: [objective.explanation_text]"
			count++

	if(uplink_true)
		var/uplink_text = "(used [TC_uses] TC) [purchases]"
		if(TC_uses==0 && traitorwin)
			var/static/icon/badass = icon('icons/badass.dmi', "badass")
			uplink_text += "<BIG>[icon2html(badass, world)]</BIG>"
		result += uplink_text

	result += objectives_text

	var/special_role_text = lowertext(name)

	if(contractor_hub)
		result += contractor_round_end()

	if(traitorwin)
		result += "<span class='greentext'>The [special_role_text] was successful!</span>"
	else
		result += "<span class='redtext'>The [special_role_text] has failed!</span>"
		SEND_SOUND(owner.current, 'sound/ambience/ambifailure.ogg')

	return result.Join("<br>")

/// Proc detailing contract kit buys/completed contracts/additional info
/datum/antagonist/traitor/proc/contractor_round_end()
	var result = ""
	var total_spent_rep = 0

	var/completed_contracts = 0
	var/tc_total = contractor_hub.contract_TC_payed_out + contractor_hub.contract_TC_to_redeem
	for(var/datum/syndicate_contract/contract in contractor_hub.assigned_contracts)
		if(contract.status == CONTRACT_STATUS_COMPLETE)
			completed_contracts++

	var/contractor_item_icons = "" // Icons of purchases
	var/contractor_support_unit = "" // Set if they had a support unit - and shows appended to their contracts completed

	for(var/datum/contractor_item/contractor_purchase in contractor_hub.purchased_items)	// Get all the icons/total cost for all our items bought
		contractor_item_icons += "<span class='tooltip_container'>\[ <i class=\"fas [contractor_purchase.item_icon]\"></i><span class='tooltip_hover'><b>[contractor_purchase.name] - [contractor_purchase.cost] Rep</b><br><br>[contractor_purchase.desc]</span> \]</span>"
		total_spent_rep += contractor_purchase.cost
		if(istype(contractor_purchase, /datum/contractor_item/contractor_partner))	// Special case for reinforcements, we want to show their ckey and name on round end.
			var/datum/contractor_item/contractor_partner/partner = contractor_purchase
			contractor_support_unit += "<br><b>[partner.partner_mind.key]</b> played <b>[partner.partner_mind.current.name]</b>, their contractor support unit."
	if (contractor_hub.purchased_items.len)
		result += "<br>(used [total_spent_rep] Rep)"
		result += contractor_item_icons
	result += "<br>"
	if(completed_contracts > 0)
		var/pluralCheck = "contract"
		if(completed_contracts > 1)
			pluralCheck = "contracts"
		result += "Completed <span class='greentext'>[completed_contracts]</span> [pluralCheck] for a total of \
					<span class='greentext'>[tc_total] TC</span>!<br>"
	return result

/datum/antagonist/traitor/roundend_report_footer()
	var/phrases = jointext(GLOB.syndicate_code_phrase, ", ")
	var/responses = jointext(GLOB.syndicate_code_response, ", ")

	var message = "<br><b>The code phrases were:</b> <span class='bluetext'>[phrases]</span><br>\
					<b>The code responses were:</b> <span class='redtext'>[responses]</span><br>"

	return message


/datum/antagonist/traitor/is_gamemode_hero()
	return SSticker.mode.name == "traitor"
