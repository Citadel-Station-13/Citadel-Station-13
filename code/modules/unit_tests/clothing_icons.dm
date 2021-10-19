/**
 * Catches missing icons for standard slots.
 */
/datum/unit_test/clothing_icons/Run()
	for(var/path in subtypesof(/obj/item))
		var/obj/item/I = path


/datum/unit_test/clothing_icons/proc/get_slots(slot_flags)
	var/static/list/what_matters = list(
		SLOT_FLAG_NECK,
		SLOT_FLAG_EARS,
		SLOT_FLAG_EYES,
		SLOT_FLAG_HEAD,
		SLOT_FLAG_GLOVES,
		SLOT_FLAG_FEET,
		SLOT_FLAG_SUIT,
		SLOT_FLAG_UNIFORM,
		SLOT_FLAG_MASK,
		SLOT_FLAG_BELT,
		SLOT_FLAG_BACK
	)
