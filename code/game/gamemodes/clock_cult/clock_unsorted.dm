//sends messages via hierophant
/proc/send_hierophant_message(mob/user, message, name_span = "heavy_brass", message_span = "brass", user_title = "Servant")
	if(!user || !message || !ticker || !ticker.mode)
		return 0
	var/parsed_message = "<span class='[name_span]'>[user_title ? "[user_title] ":""][findtextEx(user.name, user.real_name) ? user.name : "[user.real_name] (as [user.name])"]: </span><span class='[message_span]'>\"[message]\"</span>"
	for(var/M in mob_list)
		if(isobserver(M))
			var/link = FOLLOW_LINK(M, user)
			M << "[link] [parsed_message]"
		else if(is_servant_of_ratvar(M))
			M << parsed_message
	return 1

//Function Call action: Calls forth a Ratvarian spear.
/datum/action/innate/function_call
	name = "Function Call"
	button_icon_state = "ratvarian_spear"
	background_icon_state = "bg_clock"
	check_flags = AB_CHECK_RESTRAINED|AB_CHECK_STUNNED|AB_CHECK_CONSCIOUS

/datum/action/innate/function_call/IsAvailable()
	if(!is_servant_of_ratvar(owner))
		return 0
	return ..()

/datum/action/innate/function_call/Activate()
	if(owner.l_hand && owner.r_hand)
		usr << "<span class='warning'>You need an empty to hand to call forth your spear!</span>"
		return 0
	owner.visible_message("<span class='warning'>A strange spear materializes in [usr]'s hands!</span>", "<span class='brass'>You call forth your spear!</span>")
	var/obj/item/clockwork/ratvarian_spear/R = new(get_turf(usr))
	owner.put_in_hands(R)
	for(var/datum/action/innate/function_call/F in owner.actions) //Removes any bound Ratvarian spears
		qdel(F)
	return 1

//allows a mob to select a target to gate to
/atom/movable/proc/procure_gateway(mob/living/invoker, time_duration, gateway_uses, two_way)
	var/list/possible_targets = list()
	var/list/teleportnames = list()
	var/list/duplicatenamecount = list()

	for(var/obj/structure/clockwork/powered/clockwork_obelisk/O in all_clockwork_objects)
		if(!O.Adjacent(invoker) && O != src && (O.z <= ZLEVEL_SPACEMAX)) //don't list obelisks that we're next to
			var/area/A = get_area(O)
			var/locname = initial(A.name)
			var/resultkey = "[locname] [O.name]"
			if(resultkey in teleportnames) //why the fuck did you put two obelisks in the same area
				duplicatenamecount[resultkey]++
				resultkey = "[resultkey] ([duplicatenamecount[resultkey]])"
			else
				teleportnames.Add(resultkey)
				duplicatenamecount[resultkey] = 1
			possible_targets[resultkey] = O

	for(var/mob/living/L in living_mob_list)
		if(!L.stat && is_servant_of_ratvar(L) && !L.Adjacent(invoker) && L != invoker && (L.z <= ZLEVEL_SPACEMAX)) //People right next to the invoker can't be portaled to, for obvious reasons
			var/resultkey = "[L.name] ([L.real_name])"
			if(resultkey in teleportnames)
				duplicatenamecount[resultkey]++
				resultkey = "[resultkey] ([duplicatenamecount[resultkey]])"
			else
				teleportnames.Add(resultkey)
				duplicatenamecount[resultkey] = 1
			possible_targets[resultkey] = L

	if(!possible_targets.len)
		invoker << "<span class='warning'>There are no other eligible targets for a Spatial Gateway!</span>"
		return 0
	var/input_target_key = input(invoker, "Choose a target to form a rift to.", "Spatial Gateway") as null|anything in possible_targets
	var/atom/movable/target = possible_targets[input_target_key]
	if(!target || !invoker.canUseTopic(src, BE_CLOSE))
		return 0
	var/istargetobelisk = istype(target, /obj/structure/clockwork/powered/clockwork_obelisk)
	if(istargetobelisk)
		gateway_uses *= 2
		time_duration *= 2
	invoker.visible_message("<span class='warning'>The air in front of [invoker] ripples before suddenly tearing open!</span>", \
	"<span class='brass'>With a word, you rip open a [two_way ? "two-way":"one-way"] rift to [input_target_key]. It will last for [time_duration / 10] seconds and has [gateway_uses] use[gateway_uses > 1 ? "s" : ""].</span>")
	var/obj/effect/clockwork/spatial_gateway/S1 = new(istype(src, /obj/structure/clockwork/powered/clockwork_obelisk) ? get_turf(src) : get_step(get_turf(invoker), invoker.dir))
	var/obj/effect/clockwork/spatial_gateway/S2 = new(istargetobelisk ? get_turf(target) : get_step(get_turf(target), target.dir))

	//Set up the portals now that they've spawned
	S1.setup_gateway(S2, time_duration, gateway_uses, two_way)
	S2.visible_message("<span class='warning'>The air in front of [target] ripples before suddenly tearing open!</span>")
	return 1

/proc/scripture_unlock_check(scripture_tier) //check if the selected scripture tier is unlocked
	var/servants = 0
	var/unconverted_ai_exists = FALSE
	for(var/mob/living/M in living_mob_list)
		if(is_servant_of_ratvar(M) && (ishuman(M) || issilicon(M)))
			servants++
	for(var/mob/living/silicon/ai/ai in living_mob_list)
		if(!is_servant_of_ratvar(ai) && ai.client)
			unconverted_ai_exists = TRUE
	switch(scripture_tier)
		if(SCRIPTURE_DRIVER)
			return 1
		if(SCRIPTURE_SCRIPT)
			if(servants >= 5 && clockwork_caches)
				return 1 //5 or more non-brain servants and any number of clockwork caches
		if(SCRIPTURE_APPLICATION)
			if(servants >= 8 && clockwork_caches >= 3 && clockwork_construction_value >= 75)
				return 1 //8 or more non-brain servants, 3+ clockwork caches, and at least 75 CV
		if(SCRIPTURE_REVENANT)
			if(servants >= 10 && clockwork_caches >= 4 && clockwork_construction_value >= 150)
				return 1 //10 or more non-brain servants, 4+ clockwork caches, and at least 150 CV
		if(SCRIPTURE_JUDGEMENT)
			if(servants >= 12 && clockwork_caches >= 5 && clockwork_construction_value >= 250 && !unconverted_ai_exists)
				return 1 //12 or more non-brain servants, 5+ clockwork caches, at least 250 CV, and there are no living, non-servant ais
	return 0

/proc/generate_cache_component(specific_component_id) //generates a component in the global component cache, either random based on lowest or a specific component
	if(specific_component_id)
		clockwork_component_cache[specific_component_id]++
	else
		var/component_to_generate = get_weighted_component_id()
		clockwork_component_cache[component_to_generate]++

/proc/get_weighted_component_id(obj/item/clockwork/slab/storage_slab) //returns a chosen component id based on the lowest amount of that component
	if(storage_slab)
		return pickweight(list("belligerent_eye" = max(MAX_COMPONENTS_BEFORE_RAND - LOWER_PROB_PER_COMPONENT*(clockwork_component_cache["belligerent_eye"] + storage_slab.stored_components["belligerent_eye"]), 1), \
			"vanguard_cogwheel" = max(MAX_COMPONENTS_BEFORE_RAND - LOWER_PROB_PER_COMPONENT*(clockwork_component_cache["vanguard_cogwheel"] + storage_slab.stored_components["vanguard_cogwheel"]), 1), \
			"guvax_capacitor" = max(MAX_COMPONENTS_BEFORE_RAND - LOWER_PROB_PER_COMPONENT*(clockwork_component_cache["guvax_capacitor"] + storage_slab.stored_components["guvax_capacitor"]), 1), \
			"replicant_alloy" = max(MAX_COMPONENTS_BEFORE_RAND - LOWER_PROB_PER_COMPONENT*(clockwork_component_cache["replicant_alloy"] + storage_slab.stored_components["replicant_alloy"]), 1), \
			"hierophant_ansible" = max(MAX_COMPONENTS_BEFORE_RAND - LOWER_PROB_PER_COMPONENT*(clockwork_component_cache["hierophant_ansible"] + storage_slab.stored_components["hierophant_ansible"]), 1)))

	return pickweight(list("belligerent_eye" = max(MAX_COMPONENTS_BEFORE_RAND - LOWER_PROB_PER_COMPONENT*clockwork_component_cache["belligerent_eye"], 1), \
		"vanguard_cogwheel" = max(MAX_COMPONENTS_BEFORE_RAND - LOWER_PROB_PER_COMPONENT*clockwork_component_cache["vanguard_cogwheel"], 1), \
		"guvax_capacitor" = max(MAX_COMPONENTS_BEFORE_RAND - LOWER_PROB_PER_COMPONENT*clockwork_component_cache["guvax_capacitor"], 1), \
		"replicant_alloy" = max(MAX_COMPONENTS_BEFORE_RAND - LOWER_PROB_PER_COMPONENT*clockwork_component_cache["replicant_alloy"], 1), \
		"hierophant_ansible" = max(MAX_COMPONENTS_BEFORE_RAND - LOWER_PROB_PER_COMPONENT*clockwork_component_cache["hierophant_ansible"], 1)))

/proc/clockwork_say(atom/movable/AM, message, whisper=FALSE)
	// When servants invoke ratvar's power, they speak in ways that non
	// servants do not comprehend.
	// Our ratvarian chants are stored in their ratvar forms

	var/list/spans = list(SPAN_ROBOT)

	var/old_languages_spoken = AM.languages_spoken
	AM.languages_spoken = HUMAN //anyone who can understand HUMAN will hear weird shitty ratvar speak, otherwise it'll get starred out
	if(isliving(AM))
		var/mob/living/L = AM
		if(!whisper)
			L.say(message, "clock", spans)
		else
			L.whisper(message)
	else
		AM.say(message)
	AM.languages_spoken = old_languages_spoken

/*

The Ratvarian Language

	In the lore of the Servants of Ratvar, the Ratvarian tongue is a timeless language and full of power. It sounds like gibberish, much like Nar-Sie's language, but is in fact derived from
aforementioned language, and may induce miracles when spoken in the correct way with an amplifying tool (similar to runes used by the Nar-Sian cult).

	While the canon states that the language of Ratvar and his servants is incomprehensible to the unenlightened as it is a derivative of the most ancient known language, in reality it is
actually very simple. To translate a plain English sentence to Ratvar's tongue, simply move all of the letters thirteen places ahead, starting from "a" if the end of the alphabet is reached.
This cipher is known as "rot13" for "rotate 13 places" and there are many sites online that allow instant translation between English and rot13 - one of the benefits is that moving the translated
sentence thirteen places ahead changes it right back to plain English.

	There are, however, a few parts of the Ratvarian tongue that aren't typical and are implemented for fluff reasons. Some words may have apostrophes, hyphens, and spaces, making the plain
English translation apparent but disjoined (for instance, "Oru`byq zl-cbjre!" translates directly to "Beh'old my-power!") although this can be ignored without impacting overall quality. When
translating from Ratvar's tongue to plain English, simply remove the disjointments and use the finished sentence. This would make "Oru`byq zl-cbjre!" into "Behold my power!" after removing the
abnormal spacing, hyphens, and grave accents.

List of nuances:

- Any time the word "of" occurs, it is linked to the previous word by a hyphen. If it is the first word, nothing is done. (i.e. "V nz-bs Ratvar." directly translates to "I am-of Ratvar.")
- Although "Ratvar" translates to "Engine" in English, the word "Ratvar" is used regardless of language as it is a proper noun.
 - The same rule applies to Ratvar's four generals: Nezbere (Armorer), Sevtug (Fright), Nzcrentr (Amperage), and Inath-Neq (Vangu-Ard), although these words can be used in proper context if one is
   not referring to the four generals and simply using the words themselves.

*/
