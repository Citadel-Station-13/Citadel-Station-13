/obj/item/clockwork/slab //Clockwork slab: The most important tool in Ratvar's arsenal. Allows scripture recital, tutorials, and generates components.
	name = "clockwork slab"
	desc = "A strange metal tablet. A clock in the center turns around and around."
	clockwork_desc = "A link between you and the Celestial Derelict. It contains information, recites scripture, and is your most vital tool as a Servant.\
	It can be used to link traps and triggers by attacking them with the slab. Keep in mind that traps linked with one another will activate in tandem!"

	icon_state = "clockwork_slab"
	lefthand_file = 'icons/mob/inhands/antag/clockwork_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/antag/clockwork_righthand.dmi'
	var/inhand_overlay //If applicable, this overlay will be applied to the slab's inhand

	slot_flags = ITEM_SLOT_BELT
	w_class = WEIGHT_CLASS_SMALL

	var/busy //If the slab is currently being used by something
	var/no_cost = FALSE //If the slab is admin-only and needs no components and has no scripture locks
	var/speed_multiplier = 1 //multiples how fast this slab recites scripture
	// var/selected_scripture = SCRIPTURE_DRIVER //handled UI side
	var/obj/effect/proc_holder/slab/slab_ability //the slab's current bound ability, for certain scripture

	var/recollecting = TRUE //if we're looking at fancy recollection. tutorial enabled by default
	var/recollection_category = "Default"

	var/list/quickbound = list(
		/datum/clockwork_scripture/spatial_gateway,
		/datum/clockwork_scripture/ranged_ability/kindle,
		/datum/clockwork_scripture/ranged_ability/hateful_manacles) //quickbound scripture, accessed by index
	var/maximum_quickbound = 5 //how many quickbound scriptures we can have

	var/obj/structure/destructible/clockwork/trap/linking //If we're linking traps together, which ones we're doing

/obj/item/clockwork/slab/internal //an internal motor for mobs running scripture
	name = "scripture motor"
	quickbound = list()
	no_cost = TRUE

/obj/item/clockwork/slab/debug
	speed_multiplier = 0
	no_cost = TRUE

/obj/item/clockwork/slab/debug/on_attack_hand(mob/living/user, act_intent = user.a_intent, unarmed_attack_flags)
	if(!is_servant_of_ratvar(user))
		add_servant_of_ratvar(user)
	return ..()

/obj/item/clockwork/slab/traitor
	var/spent = FALSE

/obj/item/clockwork/slab/traitor/check_uplink_validity()
	return !spent

/obj/item/clockwork/slab/traitor/attack_self(mob/living/user)
	if(!is_servant_of_ratvar(user) && !spent)
		to_chat(user, "<span class='userdanger'>You press your hand onto [src], golden tendrils of light latching onto you. Was this the best of ideas?</span>")
		if(add_servant_of_ratvar(user, FALSE, FALSE, /datum/antagonist/clockcult/neutered/traitor))
			spent = TRUE
			// Add some (5 KW) power so they don't suffer for 100 ticks
			GLOB.clockwork_power += 5000
			// This intentionally does not use adjust_clockwork_power.
		else
			to_chat(user, "<span class='userdanger'>[src] falls dark. It appears you weren't worthy.</span>")
	return ..()

/obj/item/clockwork/slab/cyborg //three scriptures, plus a spear and fabricator
	clockwork_desc = "A divine link to the Celestial Derelict, allowing for limited recital of scripture."
	quickbound = list(/datum/clockwork_scripture/ranged_ability/judicial_marker, /datum/clockwork_scripture/ranged_ability/linked_vanguard, \
	/datum/clockwork_scripture/create_object/stargazer)
	maximum_quickbound = 6 //we usually have one or two unique scriptures, so if ratvar is up let us bind one more
	actions_types = list()

/obj/item/clockwork/slab/cyborg/engineer //six scriptures, plus a fabricator. Might revert this if its too OP, I just thought that engineering borgs should get the all the structures
	quickbound = list(/datum/clockwork_scripture/spatial_gateway, /datum/clockwork_scripture/create_object/replicant, /datum/clockwork_scripture/create_object/sigil_of_transmission,  /datum/clockwork_scripture/create_object/stargazer, \
	/datum/clockwork_scripture/create_object/ocular_warden, /datum/clockwork_scripture/create_object/clockwork_obelisk/cyborg, /datum/clockwork_scripture/create_object/mania_motor/cyborg)

/obj/item/clockwork/slab/cyborg/medical //six scriptures, plus a spear
	quickbound = list(/datum/clockwork_scripture/spatial_gateway, /datum/clockwork_scripture/ranged_ability/linked_vanguard, /datum/clockwork_scripture/ranged_ability/sentinels_compromise, \
	/datum/clockwork_scripture/create_object/vitality_matrix, /datum/clockwork_scripture/channeled/mending_mantra)

/obj/item/clockwork/slab/cyborg/security //four scriptures, plus a spear
	quickbound = list(/datum/clockwork_scripture/spatial_gateway, /datum/clockwork_scripture/channeled/volt_blaster, /datum/clockwork_scripture/ranged_ability/hateful_manacles, \
	/datum/clockwork_scripture/ranged_ability/judicial_marker, /datum/clockwork_scripture/channeled/belligerent)

/obj/item/clockwork/slab/cyborg/peacekeeper //four scriptures, plus a spear
	quickbound = list(/datum/clockwork_scripture/spatial_gateway, /datum/clockwork_scripture/channeled/volt_blaster, /datum/clockwork_scripture/ranged_ability/hateful_manacles, \
	/datum/clockwork_scripture/ranged_ability/judicial_marker, /datum/clockwork_scripture/channeled/belligerent)
/*//this module was commented out so why wasn't this?
/obj/item/clockwork/slab/cyborg/janitor //six scriptures, plus a fabricator
	quickbound = list(/datum/clockwork_scripture/spatial_gateway, /datum/clockwork_scripture/create_object/replicant, /datum/clockwork_scripture/create_object/sigil_of_transgression, \
	/datum/clockwork_scripture/create_object/stargazer, /datum/clockwork_scripture/create_object/ocular_warden, /datum/clockwork_scripture/create_object/mania_motor)
*/
/obj/item/clockwork/slab/cyborg/service //six scriptures, plus xray vision
	quickbound = list(/datum/clockwork_scripture/spatial_gateway, /datum/clockwork_scripture/create_object/replicant,/datum/clockwork_scripture/create_object/stargazer, \
	/datum/clockwork_scripture/spatial_gateway, /datum/clockwork_scripture/create_object/clockwork_obelisk/cyborg)

/obj/item/clockwork/slab/cyborg/miner //three scriptures, plus a spear and xray vision
	quickbound = list(/datum/clockwork_scripture/spatial_gateway, /datum/clockwork_scripture/ranged_ability/linked_vanguard, /datum/clockwork_scripture/channeled/belligerent, /datum/clockwork_scripture/channeled/volt_blaster)

/obj/item/clockwork/slab/cyborg/access_display(mob/living/user)
	if(!GLOB.ratvar_awakens)
		to_chat(user, "<span class='warning'>Use the action buttons to recite your limited set of scripture!</span>")
	else
		..()

/obj/item/clockwork/slab/cyborg/ui_act()
	..()
	if(!GLOB.ratvar_awakens)
		SStgui.close_uis(src)

/obj/item/clockwork/slab/Initialize(mapload)
	. = ..()
	update_slab_info(src)
	START_PROCESSING(SSobj, src)
	if(GLOB.ratvar_approaches)
		name = "supercharged [name]"
		speed_multiplier = max(0.1, speed_multiplier - 0.25)

/obj/item/clockwork/slab/Destroy()
	STOP_PROCESSING(SSobj, src)
	if(slab_ability && slab_ability.ranged_ability_user)
		slab_ability.remove_ranged_ability()
	slab_ability = null
	return ..()

/obj/item/clockwork/slab/dropped(mob/user)
	. = ..()
	addtimer(CALLBACK(src, .proc/check_on_mob, user), 1) //dropped is called before the item is out of the slot, so we need to check slightly later

/obj/item/clockwork/slab/worn_overlays(isinhands = FALSE, icon_file, used_state, style_flags = NONE)
	. = ..()
	if(isinhands && item_state && inhand_overlay)
		var/mutable_appearance/M = mutable_appearance(icon_file, "slab_[inhand_overlay]")
		. += M

/obj/item/clockwork/slab/proc/check_on_mob(mob/user)
	if(user && !(src in user.held_items) && slab_ability && slab_ability.ranged_ability_user) //if we happen to check and we AREN'T in user's hands, remove whatever ability we have
		slab_ability.remove_ranged_ability()

//Power generation
/obj/item/clockwork/slab/process()
	if(GLOB.ratvar_approaches && speed_multiplier == initial(speed_multiplier))
		name = "supercharged [name]"
		speed_multiplier = max(0.1, speed_multiplier - 0.25)
	adjust_clockwork_power(0.1) //Slabs serve as very weak power generators on their own (no, not enough to justify spamming them)

/obj/item/clockwork/slab/examine(mob/user)
	. = ..()
	if(!is_servant_of_ratvar(user) || !isobserver(user))
		return
	if(LAZYLEN(quickbound))
		for(var/i in 1 to quickbound.len)
			if(!quickbound[i])
				continue
			var/datum/clockwork_scripture/quickbind_slot = quickbound[i]
			. += "Quickbind button: <span class='[get_component_span(initial(quickbind_slot.primary_component))]'>[initial(quickbind_slot.name)]</span>."
	. += "Available power: <span class='bold brass'>[DisplayPower(get_clockwork_power())].</span>"

//Slab actions; Hierophant, Quickbind
/obj/item/clockwork/slab/ui_action_click(mob/user, action)
	if(istype(action, /datum/action/item_action/clock/quickbind))
		var/datum/action/item_action/clock/quickbind/Q = action
		recite_scripture(quickbound[Q.scripture_index], user, FALSE)

//Scripture Recital
/obj/item/clockwork/slab/attack_self(mob/living/user)
	if(iscultist(user))
		to_chat(user, "<span class='heavy_brass'>\"You reek of blood. You've got a lot of nerve to even look at that slab.\"</span>")
		user.visible_message("<span class='warning'>A sizzling sound comes from [user]'s hands!</span>", "<span class='userdanger'>[src] suddenly grows extremely hot in your hands!</span>")
		playsound(get_turf(user), 'sound/weapons/sear.ogg', 50, 1)
		user.dropItemToGround(src)
		user.emote("scream")
		user.apply_damage(5, BURN, BODY_ZONE_L_ARM)
		user.apply_damage(5, BURN, BODY_ZONE_R_ARM)
		return FALSE
	if(!is_servant_of_ratvar(user))
		to_chat(user, "<span class='warning'>The information on [src]'s display shifts rapidly. After a moment, your head begins to pound, and you tear your eyes away.</span>")
		if(user.confused || user.dizziness)
			user.confused += 5
			user.dizziness += 5
		return FALSE
	if(busy)
		to_chat(user, "<span class='warning'>[src] refuses to work, displaying the message: \"[busy]!\"</span>")
		return FALSE
	if(!no_cost && !can_recite_scripture(user))
		to_chat(user, "<span class='nezbere'>[src] hums fitfully in your hands, but doesn't seem to do anything...</span>")
		return FALSE
	access_display(user)

/obj/item/clockwork/slab/AltClick(mob/living/user)
	. = ..()
	if(is_servant_of_ratvar(user) && linking && user.canUseTopic(src, BE_CLOSE, ismonkey(user)))
		linking = null
		to_chat(user, "<span class='notice'>Object link canceled.</span>")
		return TRUE

/obj/item/clockwork/slab/proc/access_display(mob/living/user)
	if(!is_servant_of_ratvar(user))
		return FALSE
	ui_interact(user)
	return TRUE

/obj/item/clockwork/slab/proc/recite_scripture(datum/clockwork_scripture/scripture, mob/living/user)
	if(!scripture || !user || !user.canUseTopic(src) || (!no_cost && !can_recite_scripture(user)))
		return FALSE
	if(user.get_active_held_item() != src)
		to_chat(user, "<span class='warning'>You need to hold the slab in your active hand to recite scripture!</span>")
		return FALSE
	var/initial_tier = initial(scripture.tier)
	if(initial_tier == SCRIPTURE_PERIPHERAL && !issilicon(user))	//Silicons use peripheral scripture & cannot open the slab.
		to_chat(user, "<span class='warning'>Nice try using href exploits</span>")
		return
	if(!GLOB.ratvar_awakens && !no_cost && !SSticker.scripture_states[initial_tier] &&!issilicon(user))	//silicons can't choose their spells, so lets allow them to always cast their assigned ones.
		to_chat(user, "<span class='warning'>That scripture is not unlocked, and cannot be recited!</span>")
		return FALSE
	var/datum/clockwork_scripture/scripture_to_recite = new scripture
	scripture_to_recite.slab = src
	scripture_to_recite.invoker = user
	scripture_to_recite.run_scripture()
	return TRUE

/*
 * Gets text for a certain section. "Default" is used for when you first open Recollection.
 * Current sections (make sure to update this if you add one:
 * Basics
 * Terminology
 * Components
 * Scripture
 * Power
 * Conversion
 * * what - What section?
 */
/obj/item/clockwork/slab/proc/get_recollection(what) //Now DMDOC compliant!*
	. = list()
	switch(what) //need someone to rewrite info for this.
		if("Default")
			.["title"] = "Default"
			.["info"] = "Hello servant! Currently these categories dosen't work!"
		/*
		if("Basics")
			.["title"] = "Basics"
			.["info"] = "# MARKDOWN WITH HTML?"
		if("Terminology")
			.["title"] = "Terminology"
			.["info"] = "# MARKDOWN WITH HTML?"
		if("Components")
			.["title"] = "Default"
			.["info"] = "# MARKDOWN WITH HTML?"
		if("Scripture")
			.["title"] = "Default"
			.["info"] = "# MARKDOWN WITH HTML?"
		if("Power")
			.["title"] = "Power"
			.["info"] = "# MARKDOWN WITH HTML?"
		if("Conversion")
			.["title"] = "Conversion"
			.["info"] = "# MARKDOWN WITH HTML?"
		*/
		else
			return null //error text handled tgui side. should not cause BSOD

/obj/item/clockwork/slab/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "ClockworkSlab", name)
		ui.open()

/obj/item/clockwork/slab/ui_data(mob/user) //we display a lot of data via TGUI
	. = ..()
	if(!.)
		return
	.["recollection"] = recollecting
	.["power"] = DisplayPower(get_clockwork_power())
	.["power_unformatted"] = get_clockwork_power()
	.["HONOR_RATVAR"] = GLOB.ratvar_awakens
	.["scripture"] = list()
	for(var/s in GLOB.all_scripture) //don't block this, even when ratvar spawns for roundend griff.
		var/datum/clockwork_scripture/S = GLOB.all_scripture[s]
		if(S.tier == SCRIPTURE_PERIPHERAL) // This tier is skiped because this contains basetype stuff
			continue

		// FUTURE IMPL: cache these perhaps?
		var/list/data = list()
		data["name"] = S.name
		data["descname"] = S.descname
		data["tip"] = "[S.desc]\n[S.usage_tip]"
		data["required"] = "([DisplayPower(S.power_cost)][S.special_power_text ? "+ [replacetext(S.special_power_text, "POWERCOST", "[DisplayPower(S.special_power_cost)]")]" : ""])"
		data["required_unformatted"] = S.power_cost
		data["type"] = "[S.type]"
		data["quickbind"] = S.quickbind //this is if it cant quickbind (bool)
		data["fontcolor"] = get_component_color_bright(S.primary_component)
		data["important"] = S.important //italic!

		var/found = quickbound.Find(S.type)
		if(found)
			data["bound"] = found //number (pos) on where is it on the list
		if(S.invokers_required > 1)
			data["invokers"] = "Invokers: [S.invokers_required]"

		.["rec_binds"] = list()
		for(var/i in 1 to maximum_quickbound)
			if(LAZYLEN(quickbound) < i || !quickbound[i])
				.["rec_binds"] += list(list()) //a blank json.
			else
				var/datum/clockwork_scripture/quickbind_slot = quickbound[i]
				.["rec_binds"] += list(list(
					"name" = initial(quickbind_slot.name),
					"color" = get_component_color_bright(initial(quickbind_slot.primary_component))
				))

		.["scripture"][S.tier] += list(data)

/obj/item/clockwork/slab/ui_static_data(mob/user)
	. = list()
	.["tier_infos"] = list() //HEY!! WHEN ADDING NEW TIER, ADD IT HERE
	.["tier_infos"][SCRIPTURE_PERIPHERAL] = list(
		"requirement" = "Breaking the code DM side. Report to coggerbus if this appears!!",
		"ready" = FALSE //just in case. Should NOT exist at all
	)
	.["tier_infos"][SCRIPTURE_DRIVER] = list(
		"requirement" = "None, this is already unlocked",
		"ready" = TRUE //to bold it on JS side, and to say "These scriptures are permanently unlocked."
	)
	.["tier_infos"][SCRIPTURE_SCRIPT] = list(
		"requirement" = "These scriptures will automatically unlock when the Ark is halfway ready or if [DisplayPower(SCRIPT_UNLOCK_THRESHOLD)] of power is reached.",
		"ready" = SSticker.scripture_states[SCRIPTURE_SCRIPT] //huh, on the gamemode ticker? okay...
	)
	.["tier_infos"][SCRIPTURE_APPLICATION] = list(
		"requirement" = "Unlock these optional scriptures by converting another servant or if [DisplayPower(APPLICATION_UNLOCK_THRESHOLD)] of power is reached..",
		"ready" = SSticker.scripture_states[SCRIPTURE_APPLICATION]
	)
	.["tier_infos"][SCRIPTURE_JUDGEMENT] = list(
		"requirement" = "Unlock powerful equipment and structures by converting five servants or if [DisplayPower(JUDGEMENT_UNLOCK_THRESHOLD)] of power is reached..",
		"ready" = SSticker.scripture_states[SCRIPTURE_JUDGEMENT]
	)
	// no need to learn shit, ratvar is free
	.["recollection_categories"] = list()
	if(GLOB.ratvar_awakens)
		return
	.["recollection_categories"] = list(
		list("name" = "Getting Started", "desc" = "First-time servant? Read this first."),
		list("name" = "Basics", "desc" = "A primer on how to play as a servant."),
		list("name" = "Terminology", "desc" = "Common acronyms, words, and terms."),
		list("name" = "Components", "desc" = "Information on components, your primary resource."),
		list("name" = "Scripture", "desc" = "Information on scripture, ancient tools used by the cult."),
		list("name" = "Power", "desc" = "The power system that certain objects use to function."),
		list("name" = "Conversion", "desc" = "Converting the crew, cyborgs, and very walls to your cause.")
	)
	.["rec_section"] = get_recollection(recollection_category)
	generate_all_scripture()
	//needs a new place to live, preferably when clockcult unlocks/downgrades a tier.
	//comsig maybe?

/obj/item/clockwork/slab/ui_act(action, params)
	. = ..()
	if(.)
		return
	switch(action)
		if("toggle")
			recollecting = !recollecting
			. = TRUE
		if("recite")
			INVOKE_ASYNC(src, .proc/recite_scripture, text2path(params["script"]), usr, FALSE)
			. = TRUE
		if("bind")
			var/datum/clockwork_scripture/path = text2path(params["script"]) //we need a path and not a string
			if(!ispath(path, /datum/clockwork_scripture) || !initial(path.quickbind) || initial(path.tier) == SCRIPTURE_PERIPHERAL) //fuck you href bus
				to_chat(usr, "<span class='warning'>Nice try using href exploits</span>")
				return FALSE
			var/found_index = quickbound.Find(path)
			if(found_index) //hey, we already HAVE this bound
				if(LAZYLEN(quickbound) == found_index) //if it's the last scripture, remove it instead of leaving a null
					quickbound -= path
				else
					quickbound[found_index] = null //otherwise, leave it as a null so the scripture maintains position
				update_quickbind()
			else
				// todo: async this due to ((input)) but its fine for now
				var/target_index = input("Position of [initial(path.name)], 1 to [maximum_quickbound]?", "Input")  as num|null
				if(isnum(target_index) && target_index > 0 && target_index <= maximum_quickbound && !..())
					var/datum/clockwork_scripture/S
					if(LAZYLEN(quickbound) >= target_index)
						S = quickbound[target_index]
					if(S != path)
						quickbind_to_slot(path, target_index)
			. = TRUE
		if("rec_category")
			recollection_category = params["category"]
			update_static_data()
			. = TRUE

/obj/item/clockwork/slab/proc/quickbind_to_slot(datum/clockwork_scripture/scripture, index) //takes a typepath(typecast for initial()) and binds it to a slot
	if(!ispath(scripture) || !scripture || (scripture in quickbound))
		return
	while(LAZYLEN(quickbound) < index)
		quickbound += null
	var/datum/clockwork_scripture/quickbind_slot = GLOB.all_scripture[quickbound[index]]
	if(quickbind_slot && !quickbind_slot.quickbind)
		return //we can't unbind things we can't normally bind
	quickbound[index] = scripture
	update_quickbind()

/obj/item/clockwork/slab/proc/update_quickbind()
	for(var/datum/action/item_action/clock/quickbind/Q in actions)
		qdel(Q) //regenerate all our quickbound scriptures
	if(LAZYLEN(quickbound))
		for(var/i in 1 to quickbound.len)
			if(!quickbound[i])
				continue
			var/datum/action/item_action/clock/quickbind/Q = new /datum/action/item_action/clock/quickbind(src)
			Q.scripture_index = i
			var/datum/clockwork_scripture/quickbind_slot = GLOB.all_scripture[quickbound[i]]
			Q.name = "[quickbind_slot.name] ([Q.scripture_index])"
			Q.desc = quickbind_slot.quickbind_desc
			Q.button_icon_state = quickbind_slot.name
			Q.UpdateButtons()
			if(isliving(loc))
				Q.Grant(loc)
