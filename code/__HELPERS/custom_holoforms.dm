// Generates a holoform appearance
// Equipment list is slot = path.
/proc/generate_custom_holoform_from_prefs(datum/preferences/prefs, list/equipment_by_slot, list/inhand_equipment, copy_job_first = FALSE)
	ASSERT(prefs)
	var/mob/living/carbon/human/dummy/mannequin = generate_or_wait_for_human_dummy(DUMMY_HUMAN_SLOT_HOLOFORM)
	prefs.copy_to(mannequin)
	if(copy_job_first)
		var/datum/job/highest = prefs.get_highest_job()
		if(highest && !istype(highest, /datum/job/ai) && !istype(highest, /datum/job/cyborg))
			highest.equip(mannequin, TRUE, preference_source = prefs)

	if(length(equipment_by_slot))
		LAZYINITLIST(spawned)
		for(var/slot in equipment_by_slot)
			var/obj/item/I = new equipment_by_slot[slot]
			mannequin.equip_to_slot_if_possible(I, slot, TRUE, TRUE, TRUE, TRUE)
	if(length(inhand_equipment))
		LAZYINITLIST(spawned)
		for(var/path in inhand_equipment)
			var/obj/item/I = new path
			mannequin.equip_to_slot_if_possible(I, SLOT_IN_HANDS, TRUE, TRUE, TRUE, TRUE)
	var/icon/result = getFlatIcon(mannequin)
	unset_busy_human_dummy(DUMMY_HUMAN_SLOT_HOLOFORM)
	return result

/proc/process_holoform_icon_filter(icon/I, filter_type)
	switch(filter_type)
		if(HOLOFORM_FILTER_AI)
			I = getHologramIcon(I)
		if(HOLOFORM_FILTER_STATIC)
			I = getStaticIcon(I)
		if(HOLOFORM_FILTER_PAI)
			I = getPAIHologramIcon(I)
	return I

//Errors go to user.
/proc/generate_custom_holoform_from_prefs_safe(datum/preferences/prefs, list/equipment_by_slot, list/inhand_equipment, mob/user, copy_job_first = FALSE)
	if(user)
		if(user.prefs.last_custom_holoform < world.time + CUSTOM_HOLOFORM_DELAY)
			return
	if(length(equipment_by_slot))
		for(var/slot in equipment_by_slot)
			var/path = equipment_by_slot[slot]
			if(!ispath(path, /obj/item))
				equipment_by_slot -= slot
				to_chat(user, "<span class='boldwarning'>[path] is not a valid path and has been removed.</span>")
				continue
			else
				var/obj/item/I = path
				if(!initial(I.allow_virtual_spawn))
					equipment_by_slot -= slot
					to_chat(user, "<span class='boldwarning'>[path] is not an allowed path and has been removed.</span>")
					continue
	if(length(inhand_equipment))
		for(var/path in inhand_equipment)
			if(!ispath(path, /obj/item))
				inhand_equipment -= path
				to_chat(user, "<span class='boldwarning'>[path] is not a valid path and has been removed.</span>")
				continue
			else
				var/obj/item/I = path
				if(!initial(I.allow_virtual_spawn))
					inhand_equipment -= slot
					to_chat(user, "<span class='boldwarning'>[path] is not an allowed path and has been removed.</span>")
					continue
	return generate_custom_holoform_from_prefs(prefs, equipment_by_slot, inhand_equipment, copy_job_first)

//Prompts this client for custom holoform parameters.
/proc/user_interface_custom_holoform(client/C)
	var/datum/preferences/target_prefs = C.prefs
	ASSERT(target_prefs)
	//In the future, maybe add custom path allowances a la admin create outfit but for now..
	return generate_custom_holoform_from_prefs_safe(target_prefs, null, null, C.mob, TRUE)
