/datum/element/cleaning/Attach(datum/target)
	. = ..()
	if(!ismovable(target))
		return ELEMENT_INCOMPATIBLE
	RegisterSignal(target, COMSIG_MOVABLE_MOVED, .proc/Clean)

/datum/element/cleaning/Detach(datum/target)
	. = ..()
	UnregisterSignal(target, COMSIG_MOVABLE_MOVED)

/datum/element/cleaning/proc/Clean(datum/source)
	var/atom/movable/AM = source
	var/turf/T = AM.loc
	SEND_SIGNAL(T, COMSIG_COMPONENT_CLEAN_ACT, CLEAN_WEAK)
	for(var/A in T)
		if(is_cleanable(A))
			qdel(A)
		else if(isitem(A))
			var/obj/item/cleaned_item = A
			SEND_SIGNAL(cleaned_item, COMSIG_COMPONENT_CLEAN_ACT, CLEAN_WEAK)
			cleaned_item.clean_blood()
			if(ismob(cleaned_item.loc))
				var/mob/M = cleaned_item.loc
				M.regenerate_icons()
		else if(ishuman(A))
			var/mob/living/carbon/human/cleaned_human = A
			if(cleaned_human.lying)
				for(var/obj/item/I in cleaned_human.get_items_in_slots(INVENTORY_SLOT_HEAD, INVENTORY_SLOT_OUTERWEAR, INVENTORY_SLOT_UNIFORM, INVENTORY_SLOT_SHOES))
					SEND_SIGNAL(I, COMSIG_COMPONENT_CLEAN_ACT, CLEAN_WEAK)
					I.clean_blood()
				cleaned_human.update_worn_overlays_for_slots(INVENTORY_SLOT_HEAD, INVENTORY_SLOT_OUTERWEAR, INVENTORY_SLOT_UNIFORM, INVENTORY_SLOT_SHOES)
				SEND_SIGNAL(cleaned_human, COMSIG_COMPONENT_CLEAN_ACT, CLEAN_WEAK)
				cleaned_human.clean_blood()
				cleaned_human.wash_cream()
				cleaned_human.regenerate_icons()
				to_chat(cleaned_human, "<span class='danger'>[AM] cleans your face!</span>")
