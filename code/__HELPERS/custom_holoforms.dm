// Generates a holoform appearance
// Equipment list is slot = path.
/proc/generate_custom_holoform_from_prefs(datum/preferences/prefs, filter_type = HOLOFORM_FILTER_AI, list/equipment_by_slot, list/inhand_equipment)
	ASSERT(prefs)
	var/mob/living/carbon/human/dummy/mannequin = generate_or_wait_for_human_dummy(DUMMY_HUMAN_SLOT_HOLOFORM)
	prefs.copy_to(mannequin)
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
	var/icon/result = get_custom_holoform_icon(mannequin, filter_type)
	unset_busy_human_dummy(DUMMY_HUMAN_SLOT_HOLOFORM)
	return result

/proc/get_custom_holoform_icon(atom/A, filter_type)
	var/icon/I = getFlatIcon(A)
	switch(filter_type)
		if(HOLOFORM_FILTER_AI)
			I = getHologramIcon(I)
		if(HOLOFORM_FILTER_STATIC)
			I = getStaticIcon(I)
		if(HOLOFORM_FILTER_PAI)
			I = getPAIHologramIcon(I)
	return I

//Errors go to user.
/proc/generate_custom_holoform_from_prefs_safe(datum/preferences/prefs, filter_type, list/equipment_by_slot, list/inhand_equipment, mob/user)
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
	return generate_custom_holoform_from_prefs(prefs, filter_type, equipment_by_slot, inhand_equipment)

//Prompts this client for custom holoform parameters.
/proc/user_interface_custom_holoform(client/C)
	var/datum/preferences/target_prefs = C.prefs
	ASSERT(target_prefs)

