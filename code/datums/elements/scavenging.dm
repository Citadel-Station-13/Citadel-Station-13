 /*
  * Scavenging element. Its scope shouldn't elude your imagination.
  * Basically loot piles that can be searched through for some items.
  * In my opinion, these are more engaging than normal maintenance loot spawners.
  * The loot doesn't have to be strictly made of items and objects, you could also use it to invoke some "events"
  * such as mice, rats, an halloween spook, persistent relics, traps, etcetera, go wild.
  */
/datum/element/scavenging
	element_flags = ELEMENT_BESPOKE|ELEMENT_DETACH
	id_arg_index = 3

	var/list/loot_left_per_atom = list() //loot left per attached atom.
	var/list/loot_table //pickweight list of available loot.
	var/list/unique_loot //limited loot, once the associated value reaches zero, its key is removed from loot_table
	var/scavenge_time = 12 SECONDS //how much time it takes
	var/can_use_hands = TRUE  //bare handed scavenge time multiplier. If set to zero, only tools are usable.
	var/list/tool_types //which tool types the player can use instead of scavenging by hand, associated value is their speed.
	var/del_atom_on_depletion = FALSE //Will the atom be deleted when there is no loot left?
	var/list/search_texts = list("starts searching through", "start searching through", "You hear rummaging...")
	var/loot_restriction = NO_LOOT_RESTRICTION
	var/maximum_loot_per_player = 1 //only relevant if there is a restriction.
	var/list/scavenger_restriction_list //used for restrictions.

	var/mean_loot_weight = 0
	var/list/progress_per_atom = list() //seconds of ditched progress per atom, used to resume the work instead of starting over.
	var/static/list/players_busy_scavenging = list() //players already busy scavenging.

/datum/element/scavenging/Attach(atom/target, amount = 5, list/loot, list/unique, time = 12 SECONDS, hands = TRUE, list/tools, list/texts, \
								del_deplete = FALSE, restriction = NO_LOOT_RESTRICTION, max_per_player = 1)
	. = ..()
	if(. == ELEMENT_INCOMPATIBLE || !length(loot) || !amount || !istype(target) || isarea(target))
		return ELEMENT_INCOMPATIBLE
	loot_left_per_atom[target] = amount
	if(!loot_table)
		loot_table = loot
		for(var/A in loot_table) //tally the list weights
			mean_loot_weight += loot_table[A]
		mean_loot_weight /= length(loot_table)
	if(!unique_loot)
		unique_loot = unique || list()
	scavenge_time = time
	can_use_hands = hands
	tool_types = tools
	if(texts)
		search_texts = texts
	del_atom_on_depletion = del_deplete
	loot_restriction = restriction
	maximum_loot_per_player = max_per_player
	if(can_use_hands)
		RegisterSignal(target, list(COMSIG_ATOM_ATTACK_HAND, COMSIG_ATOM_ATTACK_PAW), .proc/scavenge_barehanded)
	if(tool_types)
		RegisterSignal(target, COMSIG_PARENT_ATTACKBY, .proc/scavenge_tool)
	RegisterSignal(target, COMSIG_PARENT_EXAMINE, .proc/on_examine)

/datum/element/scavenging/Detach(atom/target)
	. = ..()
	loot_left_per_atom -= target
	progress_per_atom -= target
	if(maximum_loot_per_player == LOOT_RESTRICTION_MIND_PILE || maximum_loot_per_player == LOOT_RESTRICTION_CKEY_PILE)
		maximum_loot_per_player -= target
	UnregisterSignal(target, list(COMSIG_ATOM_ATTACK_HAND, COMSIG_PARENT_ATTACKBY, COMSIG_PARENT_EXAMINE))

/datum/element/scavenging/proc/on_examine(atom/source, mob/user, list/examine_list)
	var/methods = tool_types.Copy()
	if(can_use_hands)
		methods += list("bare handed")
	if(!length(methods))
		return
	var/text = english_list(methods, "", " or ")
	examine_list += "<span class='notice'>Looks like [source.p_they()] can be scavenged [length(tool_types) ? "with" : ""][length(methods == 1) ? "" : "either "][length(tool_types) ? "a " : ""][text]</span>"

/datum/element/scavenging/proc/scavenge_barehanded(atom/source, mob/user)
	scavenge(source, user, 1)
	return COMPONENT_NO_ATTACK_HAND

/datum/element/scavenging/proc/scavenge_tool(atom/source, obj/item/I, mob/user, params)
	if(user.a_intent == INTENT_HARM || !I.tool_behaviour) //Robust trash disposal techniques!
		return
	var/speed_multi = tool_types[I.tool_behaviour]
	if(!speed_multi)
		return
	scavenge(source, user, speed_multi)
	return COMPONENT_NO_AFTERATTACK

/// This proc has to be asynced (cough cough, do_after) in order to return the comsig values in time to stop the attack chain.
/datum/element/scavenging/proc/scavenge(atom/source, mob/user, speed_multi = 1)
	set waitfor = FALSE

	if(players_busy_scavenging[user])
		return
	players_busy_scavenging[user] = TRUE
	var/progress_done = progress_per_atom[source]
	var/len_messages = length(search_texts)
	var/msg_first_person
	if(len_messages >= 2)
		msg_first_person = "<span class='notice'>You [progress_done ? ", resume a ditched task and " : ""][search_texts[2]] [source].</span>"
	var/msg_blind
	if(len_messages >= 3)
		msg_blind = "<span class='italic'>[search_texts[3]]</span>"
	user.visible_message("<span class='notice'>[user] [search_texts[1]] [source].</span>", msg_first_person, msg_blind)
	if(do_after(user, scavenge_time * speed_multi, TRUE, source, TRUE, CALLBACK(src, .proc/set_progress, source, world.time), resume_time = progress_done * speed_multi))
		spawn_loot(source, user)
	players_busy_scavenging -= user

/datum/element/scavenging/proc/set_progress(atom/source, start_time)
	progress_per_atom[source] = world.time - start_time
	return TRUE

/datum/element/scavenging/proc/spawn_loot(atom/source, mob/user)
	progress_per_atom -= source

	var/loot = pickweight(loot_table)
	var/special = TRUE
	var/free = FALSE
	if(!loot_left_per_atom[source])
		to_chat(user, "<span class='warning'>Looks likes there is nothing worth of interest left in [source], what a shame...</span>")
		return

	var/num_times = 0
	switch(loot_restriction)
		if(LOOT_RESTRICTION_MIND)
			num_times = LAZYACCESS(scavenger_restriction_list, user.mind)
		if(LOOT_RESTRICTION_CKEY)
			num_times = LAZYACCESS(scavenger_restriction_list, user.ckey)
		if(LOOT_RESTRICTION_MIND_PILE)
			var/list/L = LAZYACCESS(scavenger_restriction_list, source)
			if(L)
				num_times = LAZYACCESS(L, user.mind)
		if(LOOT_RESTRICTION_CKEY_PILE)
			var/list/L = LAZYACCESS(scavenger_restriction_list, source)
			if(L)
				num_times = LAZYACCESS(L, user.ckey)
	if(num_times >= maximum_loot_per_player)
		to_chat(user, "<span class='warning'>You can't find anything else vaguely useful in [source].  Another set of eyes might, however.</span>")
		return

	switch(loot) // TODO: datumize these out.
		if(SCAVENGING_FOUND_NOTHING)
			to_chat(user, "<span class='notice'>You found nothing, better luck next time.</span>")
			free = TRUE //doesn't consume the loot pile.
		if(SCAVENGING_SPAWN_MOUSE)
			var/nasty_rodent = pick("mouse", "rodent", "squeaky critter", "stupid pest", "annoying cable chewer", "nasty, ugly, evil, disease-ridden rodent")
			to_chat(user, "<span class='notice'>You found something in [source]... no wait, that's just another [nasty_rodent].</span>")
			new /mob/living/simple_animal/mouse(source.loc)
		if(SCAVENGING_SPAWN_MICE)
			user.visible_message("<span class='notice'>A small gang of mice emerges from [source].</span>", \
				"<span class='notice'>You found something in [source]... no wait, that's just another- <b>no wait, that's a lot of damn mice.</b></span>")
			for(var/i in 1 to rand(4, 6))
				new /mob/living/simple_animal/mouse(source.loc)
		if(SCAVENGING_SPAWN_TOM)
			if(GLOB.tom_existed) //There can only be one.
				to_chat(user, "<span class='notice'>You found nothing, better luck next time.</span>")
				free = TRUE
			else
				to_chat(user, "<span class='notice'>You found something in [source]... no wait, that's Tom, the mouse! What is he doing here?</span>")
				new /mob/living/simple_animal/mouse/brown/Tom(source.loc)
		else
			special = FALSE

	if(!special) //generic loot. Nothing too strange like more loot spawners anyway.
		var/atom/A = new loot(source.loc)
		if(isitem(A) && !user.get_active_held_item())
			user.put_in_hands(A)
		var/rarity_append = "."
		switch(loot_table[loot]/mean_loot_weight*100)
			if(0 to 1)
				rarity_append = "! <b>AMAZING!</b>"
			if(1 to 2)
				rarity_append = "! Woah!"
			if(2 to 5)
				rarity_append = ". Rare!"
			if(5 to 10)
				rarity_append = ". Great."
			if(10 to 25)
				rarity_append = ". Nice."
			if(20 to 50)
				rarity_append = ". Not bad."
		to_chat(user, "You found something in [source]... it's \a [A][rarity_append]")

	if(unique_loot[loot])
		var/loot_left = --unique_loot[loot]
		if(!loot_left)
			loot_table -= loot
			unique_loot -= loot
			mean_loot_weight = 0
			for(var/A in loot_table) //re-tally the list weights
				mean_loot_weight += loot_table[A]
			mean_loot_weight /= length(loot_table)

	if(free)
		return

	--loot_left_per_atom[source]
	if(del_atom_on_depletion && !loot_left_per_atom[source])
		source.visible_message("<span class='warning'>[source] has been looted clean.</span>")
		qdel(source)
		return

	if(!loot_restriction)
		return

	LAZYINITLIST(scavenger_restriction_list)
	switch(loot_restriction)
		if(LOOT_RESTRICTION_MIND)
			scavenger_restriction_list[user.mind]++
		if(LOOT_RESTRICTION_CKEY)
			scavenger_restriction_list[user.ckey]++
		if(LOOT_RESTRICTION_MIND_PILE)
			LAZYINITLIST(scavenger_restriction_list[source])
			var/list/L = scavenger_restriction_list[source]
			L[user.mind]++
		if(LOOT_RESTRICTION_CKEY_PILE)
			LAZYINITLIST(scavenger_restriction_list[source])
			var/list/L = scavenger_restriction_list[source]
			L[user.ckey]++
