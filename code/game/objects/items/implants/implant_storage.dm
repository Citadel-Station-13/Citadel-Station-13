/obj/item/implant/storage
	name = "storage implant"
	desc = "Stores up to two big items in a bluespace pocket."
	icon_state = "storage"
	implant_color = "r"
	var/max_slot_stacking = 4
	var/obj/item/storage/bluespace_pocket/pocket

/obj/item/implant/storage/activate()
	. = ..()
	SEND_SIGNAL(pocket, COMSIG_TRY_STORAGE_SHOW, imp_in, TRUE)

/obj/item/implant/storage/removed(source, silent = FALSE, special = 0)
	if(!special)
		QDEL_NULL(pocket)
	else
		pocket?.moveToNullspace()
	return ..()

/obj/item/implant/storage/implant(mob/living/target, mob/user, silent = FALSE)
	for(var/X in target.implants)
		if(istype(X, type))
			var/obj/item/implant/storage/imp_e = X
			var/datum/component/storage/STR = imp_e.pocket.GetComponent(/datum/component/storage)
			if(!STR || (STR && STR.max_items < max_slot_stacking))
				imp_e.pocket.AddComponent(/datum/component/storage/concrete/implant)
				qdel(src)
				return TRUE
			return FALSE
	. = ..()
	if(.)
		if(!QDELETED(pocket))
			pocket.forceMove(target)
		else
			pocket = new(target)

/obj/item/storage/bluespace_pocket
	name = "internal bluespace pocket"
	icon_state = "pillbox"
	w_class = WEIGHT_CLASS_TINY
	desc = "A tiny yet spacious pocket, usually found implanted inside sneaky syndicate agents and nowhere else."
	component_type = /datum/component/storage/concrete/implant
	resistance_flags = INDESTRUCTIBLE //A bomb!

/obj/item/implanter/storage
	name = "implanter (storage)"
	imp_type = /obj/item/implant/storage
