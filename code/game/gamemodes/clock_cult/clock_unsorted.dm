//sends messages via hierophant
/proc/titled_hierophant_message(mob/user, message, name_span = "heavy_brass", message_span = "brass", user_title = "Servant")
	if(!user || !message || !ticker || !ticker.mode)
		return 0
	var/parsed_message = "<span class='[name_span]'>[user_title ? "[user_title] ":""][findtextEx(user.name, user.real_name) ? user.name : "[user.real_name] (as [user.name])"]: \
	</span><span class='[message_span]'>\"[message]\"</span>"
	hierophant_message(parsed_message, FALSE, user)
	return 1

/proc/hierophant_message(message, servantsonly, atom/target) //sends a generic message to all servants and optionally observers
	if(!message || !ticker || !ticker.mode)
		return 0
	for(var/M in mob_list)
		if(!servantsonly && isobserver(M))
			if(target)
				var/link = FOLLOW_LINK(M, target)
				M << "[link] [message]"
			else
				M << message
		else if(is_servant_of_ratvar(M))
			M << message

//Hierophant Network action, allows a servant with it to communicate
/datum/action/innate/hierophant
	name = "Hierophant Network"
	desc = "Allows you to communicate with other Servants."
	button_icon_state = "hierophant"
	background_icon_state = "bg_clock"
	check_flags = AB_CHECK_RESTRAINED|AB_CHECK_STUNNED|AB_CHECK_CONSCIOUS
	buttontooltipstyle = "clockcult"
	var/title = "Servant"
	var/span_for_name = "heavy_brass"
	var/span_for_message = "brass"

/datum/action/innate/hierophant/IsAvailable()
	if(!is_servant_of_ratvar(owner))
		return 0
	return ..()

/datum/action/innate/hierophant/Activate()
	var/input = stripped_input(usr, "Please enter a message to send to other servants.", "Hierophant Network", "")
	if(!input || !IsAvailable())
		return

	titled_hierophant_message(owner, input, span_for_name, span_for_message, title)

//Function Call action: Calls forth a Ratvarian spear once every 3 minutes
/datum/action/innate/function_call
	name = "Function Call"
	desc = "Allows you to summon a Ratvarian spear to fight enemies."
	button_icon_state = "ratvarian_spear"
	background_icon_state = "bg_clock"
	check_flags = AB_CHECK_RESTRAINED|AB_CHECK_STUNNED|AB_CHECK_CONSCIOUS
	buttontooltipstyle = "clockcult"
	var/cooldown = 0
	var/base_cooldown = 1800

/datum/action/innate/function_call/IsAvailable()
	if(!is_servant_of_ratvar(owner) || cooldown > world.time)
		return 0
	return ..()

/datum/action/innate/function_call/Activate()
	if(!owner.get_empty_held_indexes())
		usr << "<span class='warning'>You need an empty to hand to call forth your spear!</span>"
		return 0
	owner.visible_message("<span class='warning'>A strange spear materializes in [owner]'s hands!</span>", "<span class='brass'>You call forth your spear!</span>")
	var/obj/item/clockwork/ratvarian_spear/R = new(get_turf(usr))
	owner.put_in_hands(R)
	if(!ratvar_awakens)
		owner << "<span class='warning'>Your spear begins to break down in this plane of existence. You can't use it for long!</span>"
		addtimer(R, "break_spear", base_cooldown, FALSE)
	cooldown = base_cooldown + world.time
	owner.update_action_buttons_icon()
	addtimer(src, "update_actions", base_cooldown, FALSE)
	return 1

/datum/action/innate/function_call/proc/update_actions()
	if(owner)
		owner.update_action_buttons_icon()

//allows a mob to select a target to gate to
/atom/movable/proc/procure_gateway(mob/living/invoker, time_duration, gateway_uses, two_way)
	var/list/possible_targets = list()
	var/list/teleportnames = list()
	var/list/duplicatenamecount = list()

	for(var/obj/structure/destructible/clockwork/powered/clockwork_obelisk/O in all_clockwork_objects)
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
	if(!src || !target || !invoker || !invoker.canUseTopic(src, BE_CLOSE) || !is_servant_of_ratvar(invoker) || (istype(src, /obj/item) && invoker.get_active_held_item() != src))
		return 0 //if any of the involved things no longer exist, the invoker is stunned, too far away to use the object, or does not serve ratvar, or if the object is an item and not in the mob's active hand, fail
	var/istargetobelisk = istype(target, /obj/structure/destructible/clockwork/powered/clockwork_obelisk)
	if(istargetobelisk)
		gateway_uses *= 2
		time_duration *= 2
	invoker.visible_message("<span class='warning'>The air in front of [invoker] ripples before suddenly tearing open!</span>", \
	"<span class='brass'>With a word, you rip open a [two_way ? "two-way":"one-way"] rift to [input_target_key]. It will last for [time_duration / 10] seconds and has [gateway_uses] use[gateway_uses > 1 ? "s" : ""].</span>")
	var/obj/effect/clockwork/spatial_gateway/S1 = new(istype(src, /obj/structure/destructible/clockwork/powered/clockwork_obelisk) ? get_turf(src) : get_step(get_turf(invoker), invoker.dir))
	var/obj/effect/clockwork/spatial_gateway/S2 = new(istargetobelisk ? get_turf(target) : get_step(get_turf(target), target.dir))

	//Set up the portals now that they've spawned
	S1.setup_gateway(S2, time_duration, gateway_uses, two_way)
	S2.visible_message("<span class='warning'>The air in front of [target] ripples before suddenly tearing open!</span>")
	return 1

/proc/scripture_unlock_check() //returns a list of scriptures and if they're unlocked or not
	var/servants = 0
	var/unconverted_ai_exists = FALSE
	for(var/mob/living/M in living_mob_list)
		if(is_servant_of_ratvar(M) && (ishuman(M) || issilicon(M)))
			servants++
		else if(isAI(M))
			unconverted_ai_exists = TRUE
	. = list(SCRIPTURE_DRIVER = TRUE, SCRIPTURE_SCRIPT = FALSE, SCRIPTURE_APPLICATION = FALSE, SCRIPTURE_REVENANT = FALSE, SCRIPTURE_JUDGEMENT = FALSE)
	//Drivers: always unlocked
	.[SCRIPTURE_SCRIPT] = (servants >= 5 && clockwork_caches >= 1)
	//Script: 5 or more non-brain servants and 1+ clockwork caches
	.[SCRIPTURE_APPLICATION] = (servants >= 8 && clockwork_caches >= 3 && clockwork_construction_value >= 100)
	//Application: 8 or more non-brain servants, 3+ clockwork caches, and at least 100 CV
	.[SCRIPTURE_REVENANT] = (servants >= 10 && clockwork_caches >= 4 && clockwork_construction_value >= 200)
	//Revenant: 10 or more non-brain servants, 4+ clockwork caches, and at least 200 CV
	.[SCRIPTURE_JUDGEMENT] = (servants >= 12 && clockwork_caches >= 5 && clockwork_construction_value >= 300 && !unconverted_ai_exists)
	//Judgement: 12 or more non-brain servants, 5+ clockwork caches, at least 300 CV, and there are no living, non-servant ais

/proc/scripture_unlock_alert(list/previous_states) //reports to servants when scripture is locked or unlocked
	. = scripture_unlock_check()
	for(var/i in .)
		if(.[i] != previous_states[i])
			hierophant_message("<span class='large_brass'><i>Hierophant Network:</i> <b>[i] Scripture has been [.[i] ? "un":""]locked.</b></span>")

/proc/change_construction_value(amount)
	clockwork_construction_value += amount

/proc/get_component_name(id) //returns a component name from a component id
	switch(id)
		if("belligerent_eye")
			return "Belligerent Eye"
		if("vanguard_cogwheel")
			return "Vanguard Cogwheel"
		if("guvax_capacitor")
			return "Guvax Capacitor"
		if("replicant_alloy")
			return "Replicant Alloy"
		if("hierophant_ansible")
			return "Hierophant Ansible"
		else
			return null

/proc/get_component_span(id) //returns a component spanclass from a component id
	switch(id)
		if("belligerent_eye")
			return "neovgre"
		if("vanguard_cogwheel")
			return "inathneq"
		if("guvax_capacitor")
			return "sevtug"
		if("replicant_alloy")
			return "nezbere"
		if("hierophant_ansible")
			return "nzcrentr"
		else
			return null

/proc/get_component_id(name) //returns a component id from a component name
	switch(name)
		if("Belligerent Eye")
			return "belligerent_eye"
		if("Vanguard Cogwheel")
			return "vanguard_cogwheel"
		if("Guvax Capacitor")
			return "guvax_capacitor"
		if("Replicant Alloy")
			return "replicant_alloy"
		if("Hierophant Ansible")
			return "hierophant_ansible"
		else
			return null

/proc/generate_cache_component(specific_component_id) //generates a component in the global component cache, either random based on lowest or a specific component
	if(specific_component_id)
		clockwork_component_cache[specific_component_id]++
	else
		var/component_to_generate = get_weighted_component_id()
		clockwork_component_cache[component_to_generate]++

/proc/get_weighted_component_id(obj/item/clockwork/slab/storage_slab) //returns a chosen component id based on the lowest amount of that component
	. = list()
	if(storage_slab)
		if(clockwork_caches)
			for(var/i in clockwork_component_cache)
				.[i] = max(MAX_COMPONENTS_BEFORE_RAND - LOWER_PROB_PER_COMPONENT*(clockwork_component_cache[i] + storage_slab.stored_components[i]), 1)
		else
			for(var/i in clockwork_component_cache)
				.[i] = max(MAX_COMPONENTS_BEFORE_RAND - LOWER_PROB_PER_COMPONENT*storage_slab.stored_components[i], 1)
	else
		for(var/i in clockwork_component_cache)
			.[i] = max(MAX_COMPONENTS_BEFORE_RAND - LOWER_PROB_PER_COMPONENT*clockwork_component_cache[i], 1)
	. = pickweight(.)

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

/proc/cache_check(mob/M)
	if(!clockwork_caches)
		M.throw_alert("nocache", /obj/screen/alert/clockwork/nocache)
	else
		M.clear_alert("nocache")

/*
The Ratvarian Language
	In the lore of the Servants of Ratvar, the Ratvarian tongue is a timeless language and full of power. It sounds like gibberish, much like Nar-Sie's language, but is in fact derived from
aforementioned language, and may induce miracles when spoken in the correct way with an amplifying tool (similar to runes used by the Nar-Sian cult).

	While the canon states that the language of Ratvar and his servants is incomprehensible to the unenlightened as it is a derivative of the most ancient known language, in reality it is
actually very simple. To translate a plain English sentence to Ratvar's tongue, simply move all of the letters thirteen places ahead, starting from "a" if the end of the alphabet is reached.
This cipher is known as "rot13" for "rotate 13 places" and there are many sites online that allow instant translation between English and rot13 - one of the benefits is that moving the translated
sentence thirteen places ahead changes it right back to plain English.

	There are, however, a few parts of the Ratvarian tongue that aren't typical and are implemented for fluff reasons. Some words may have graves, or hyphens (prefix and postfix), making the plain
English translation apparent but disjoined (for instance, "Orubyq zl-cbjre!" translates directly to "Behold my-power!") although this can be ignored without impacting overall quality. When
translating from Ratvar's tongue to plain English, simply remove the disjointments and use the finished sentence. This would make "Orubyq zl-cbjre!" into "Behold my power!" after removing the
abnormal spacing, hyphens, and grave accents.

List of nuances:
- Any time the WORD "of" occurs, it is linked to the previous word by a hyphen. (i.e. "V nz-bs Ratvar." directly translates to "I am-of Ratvar.")
- Any time "th", followed by any two letters occurs, you add a grave (`) between those two letters, i.e; "Thi`s"
- In the same vein, any time "ti", followed by one letter occurs, you add a grave (`) between "i" and the letter, i.e; "Ti`me"
- Whereever "te" or "et" appear and there is another letter next to the e(i.e; "m"etal, greate"r"), add a hyphen between "e" and the letter, i.e; "M-etal", "Greate-r"
- Where "gua" appears, add a hyphen between "gu" and "a", i.e "Gu-ard"
- Where the WORD "and" appears it is linked to all surrounding words by hyphens, i.e; "Sword-and-shield"
- Where the WORD "to" appears, it is linked to the following word by a hyphen, i.e; "to-use"
- Where the WORD "my" appears, it is linked to the following word by a hyphen, i.e; "my-light"
- Although "Ratvar" translates to "Engine" in English, the word "Ratvar" is used regardless of language as it is a proper noun.
 - The same rule applies to Ratvar's four generals: Nezbere (Armorer), Sevtug (Fright), Nzcrentr (Amperage), and Inath-neq (Vangu-Ard), although these words can be used in proper context if one is
   not referring to the four generals and simply using the words themselves.
*/

//Regexes used to alter english to ratvarian style
#define RATVAR_OF_MATCH				regex("(\\w)\\s(\[oO]\[fF])","g")
#define RATVAR_OF_REPLACEMENT 		"$1-$2"
#define RATVAR_GUA_MATCH			regex("(\[gG]\[uU])(\[aA])","g")
#define RATVAR_GUA_REPLACEMENT		"$1-$2"
#define RATVAR_TH_MATCH				regex("(\[tT]\[hH]\\w)(\\w)","g")
#define RATVAR_TH_REPLACEMENT		"$1`$2"
#define RATVAR_TI_MATCH				regex("(\[tT]\[iI])(\\w)","g")
#define RATVAR_TI_REPLACEMENT		"$1`$2"
#define RATVAR_ET_MATCH				regex("(\\w)(\[eE]\[tT])","g")
#define RATVAR_ET_REPLACEMENT		"$1-$2"
#define RATVAR_TE_MATCH				regex("(\[tT]\[eE])(\\w)","g")
#define RATVAR_TE_REPLACEMENT		"$1-$2"
#define RATVAR_PRE_AND_MATCH		regex("(\\w)\\s(\[aA]\[nN]\[dD])","g")
#define RATVAR_PRE_AND_REPLACEMENT	"$1-$2"
#define RATVAR_POST_AND_MATCH		regex("(\[aA]\[nN]\[dD])\\s(\\w)","g")
#define RATVAR_POST_AND_REPLACEMENT	"$1-$2"
#define RATVAR_TO_MATCH				regex("(\\s)(\[tT]\[oO])\\s(\\w)","g")
#define RATVAR_TO_REPLACEMENT		"$1$2-$3"
#define RATVAR_MY_MATCH 			regex("(\\s)(\[mM]\[yY])\\s(\\w)","g")
#define RATVAR_MY_REPLACEMENT		"$1$2-$3"

//Regexes used to remove ratvarian styling from english
#define REVERSE_RATVAR_HYPHEN_PRE_AND_MATCH			regex("(\\w)-(\[aA]\[nN]\[dD])","g") //specifically structured to support -emphasis-, including with -and-
#define REVERSE_RATVAR_HYPHEN_PRE_AND_REPLACEMENT	"$1 $2"
#define REVERSE_RATVAR_HYPHEN_POST_AND_MATCH		regex("(\[aA]\[nN]\[dD])-(\\w)","g")
#define REVERSE_RATVAR_HYPHEN_POST_AND_REPLACEMENT	"$1 $2"
#define REVERSE_RATVAR_HYPHEN_TO_MY_MATCH			regex("(\[tTmM]\[oOyY])-","g")
#define REVERSE_RATVAR_HYPHEN_TO_MY_REPLACEMENT		"$1 "
#define REVERSE_RATVAR_HYPHEN_TE_MATCH				regex("(\[tT]\[eE])-","g")
#define REVERSE_RATVAR_HYPHEN_TE_REPLACEMENT		"$1"
#define REVERSE_RATVAR_HYPHEN_ET_MATCH				regex("-(\[eE]\[tT])","g")
#define REVERSE_RATVAR_HYPHEN_ET_REPLACEMENT		"$1"
#define REVERSE_RATVAR_HYPHEN_GUA_MATCH				regex("(\[gG]\[uU])-(\[aA])","g")
#define REVERSE_RATVAR_HYPHEN_GUA_REPLACEMENT		"$1$2"
#define REVERSE_RATVAR_HYPHEN_OF_MATCH				regex("-(\[oO]\[fF])","g")
#define REVERSE_RATVAR_HYPHEN_OF_REPLACEMENT		" $1"


/proc/text2ratvar(text) //Takes english and applies ratvarian styling rules (and rot13) to it
	var/ratvarian 	= replacetext(text, 		RATVAR_OF_MATCH, 		RATVAR_OF_REPLACEMENT)
	ratvarian 		= replacetext(ratvarian,	RATVAR_GUA_MATCH, 		RATVAR_GUA_REPLACEMENT)
	ratvarian 		= replacetext(ratvarian,	RATVAR_TH_MATCH, 		RATVAR_TH_REPLACEMENT)
	ratvarian 		= replacetext(ratvarian,	RATVAR_TI_MATCH, 		RATVAR_TI_REPLACEMENT)
	ratvarian 		= replacetext(ratvarian, 	RATVAR_ET_MATCH, 		RATVAR_ET_REPLACEMENT)
	ratvarian 		= replacetext(ratvarian, 	RATVAR_TE_MATCH, 		RATVAR_TE_REPLACEMENT)
	ratvarian 		= replacetext(ratvarian, 	RATVAR_PRE_AND_MATCH,	RATVAR_PRE_AND_REPLACEMENT)
	ratvarian 		= replacetext(ratvarian, 	RATVAR_POST_AND_MATCH,	RATVAR_POST_AND_REPLACEMENT)
	ratvarian 		= replacetext(ratvarian, 	RATVAR_TO_MATCH, 		RATVAR_TO_REPLACEMENT)
	ratvarian 		= replacetext(ratvarian, 	RATVAR_MY_MATCH, 		RATVAR_MY_REPLACEMENT)
	return rot13(ratvarian)

/proc/ratvar2text(ratvarian) //Reverts ravarian styling and rot13 in text.
	var/text 	= replacetext(rot13(ratvarian), "`",								 		"")
	text 		= replacetext(text, 			REVERSE_RATVAR_HYPHEN_GUA_MATCH,	 		REVERSE_RATVAR_HYPHEN_GUA_REPLACEMENT)
	text 		= replacetext(text, 			REVERSE_RATVAR_HYPHEN_PRE_AND_MATCH,	 	REVERSE_RATVAR_HYPHEN_PRE_AND_REPLACEMENT)
	text 		= replacetext(text, 			REVERSE_RATVAR_HYPHEN_POST_AND_MATCH,	 	REVERSE_RATVAR_HYPHEN_POST_AND_REPLACEMENT)
	text 		= replacetext(text, 			REVERSE_RATVAR_HYPHEN_TO_MY_MATCH,			REVERSE_RATVAR_HYPHEN_TO_MY_REPLACEMENT)
	text 		= replacetext(text, 			REVERSE_RATVAR_HYPHEN_TE_MATCH,				REVERSE_RATVAR_HYPHEN_TE_REPLACEMENT)
	text 		= replacetext(text, 			REVERSE_RATVAR_HYPHEN_ET_MATCH,				REVERSE_RATVAR_HYPHEN_ET_REPLACEMENT)
	text 		= replacetext(text, 			REVERSE_RATVAR_HYPHEN_OF_MATCH,				REVERSE_RATVAR_HYPHEN_OF_REPLACEMENT)
	return text