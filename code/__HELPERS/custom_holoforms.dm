// Generates a holoform appearance
// Equipment list is slot = path.
/proc/generate_custom_holoform_from_prefs(datum/preferences/prefs, list/equipment_by_slot, list/inhand_equipment, copy_job = FALSE, apply_loadout = FALSE)
	ASSERT(prefs)
	var/mob/living/carbon/human/dummy/mannequin = generate_or_wait_for_human_dummy(DUMMY_HUMAN_SLOT_HOLOFORM)
	prefs.copy_to(mannequin)
	if(apply_loadout && prefs.parent)
		SSjob.equip_loadout(prefs.parent.mob, mannequin, bypass_prereqs = TRUE)
		SSjob.post_equip_loadout(prefs.parent.mob, mannequin, bypass_prereqs = TRUE)
	if(copy_job)
		var/datum/job/highest = prefs.get_highest_job()
		if(highest && !istype(highest, /datum/job/ai) && !istype(highest, /datum/job/cyborg))
			highest.equip(mannequin, TRUE, preference_source = prefs.parent)

	if(length(equipment_by_slot))
		for(var/slot in equipment_by_slot)
			var/obj/item/I = new equipment_by_slot[slot]
			mannequin.equip_to_slot_if_possible(I, slot, TRUE, TRUE, TRUE, TRUE)
	if(length(inhand_equipment))
		for(var/path in inhand_equipment)
			var/obj/item/I = new path
			mannequin.equip_to_slot_if_possible(I, ITEM_SLOT_HANDS, TRUE, TRUE, TRUE, TRUE)


	var/icon/combined = new
	for(var/d in GLOB.cardinals)
		mannequin.setDir(d)
		CHECK_TICK
		var/icon/capture = getFlatIcon(mannequin)
		CHECK_TICK
		combined.Insert(capture, dir = d)
		CHECK_TICK

	unset_busy_human_dummy(DUMMY_HUMAN_SLOT_HOLOFORM)
	return combined

/proc/process_holoform_icon_filter(icon/I, filter_type, clone = TRUE)
	if(clone)
		I = icon(I)		//Clone
	switch(filter_type)
		if(HOLOFORM_FILTER_AI)
			I = getHologramIcon(I)
		if(HOLOFORM_FILTER_STATIC)
			I = getStaticIcon(I)
		if(HOLOFORM_FILTER_PAI)
			I = getPAIHologramIcon(I)
	return I

//Prompts this client for custom holoform parameters.
/proc/user_interface_custom_holoform(client/C)
	var/datum/preferences/target_prefs = C.prefs
	if(target_prefs.path)
		var/list/characters = list()
		var/savefile/S = new /savefile(target_prefs.path)
		if(S)
			var/name
			var/max_save_slots = C.prefs.max_save_slots
			for(var/i=1, i<=max_save_slots, i++)
				S.cd = "/character[i]"
				S["real_name"] >> name
				if(name)
					characters[name] = i
			var/chosen_name = input(C, "Which character do you wish to use as your appearance.") as anything in characters
			if(chosen_name)
				if(C.prefs.last_custom_holoform > world.time - CUSTOM_HOLOFORM_DELAY)
					to_chat(C.mob, "<span class='boldwarning'>You are attempting to set your custom holoform too fast!</span>")
					return
				target_prefs = new(C)
				if(!target_prefs.load_character(characters[chosen_name], TRUE))
					target_prefs = C.prefs

	ASSERT(target_prefs)
	//In the future, maybe add custom path allowances a la admin create outfit but for now..
	return generate_custom_holoform_from_prefs(target_prefs, null, null, TRUE, TRUE)

//Errors go to user.
/proc/generate_custom_holoform_from_prefs_safe(datum/preferences/prefs, mob/user)
	if(user)
		if(user.client.prefs.last_custom_holoform > world.time - CUSTOM_HOLOFORM_DELAY)
			to_chat(user, "<span class='boldwarning'>You are attempting to set your custom holoform too fast!</span>")
			return
	return generate_custom_holoform_from_prefs(prefs, null, null, TRUE, TRUE)
