#define MAX_STACK_PICKUP 30

/datum/component/storage/concrete/rped
	collection_mode = COLLECT_EVERYTHING
	allow_quick_gather = TRUE
	allow_quick_empty = TRUE
	click_gather = TRUE
	storage_flags = STORAGE_FLAGS_LEGACY_DEFAULT
	max_w_class = WEIGHT_CLASS_NORMAL
	max_combined_w_class = 100
	max_items = 100
	display_numerical_stacking = TRUE

	var/static/list/allowed_material_types = list(
		/obj/item/stack/sheet/glass,
		/obj/item/stack/sheet/plasteel,
		/obj/item/stack/cable_coil,
	)

	var/static/list/allowed_bluespace_types = list(
		/obj/item/stack/ore/bluespace_crystal,
		/obj/item/stack/sheet/bluespace_crystal,
	)

/datum/component/storage/concrete/rped/can_be_inserted(obj/item/I, stop_messages, mob/M)
	. = ..()
	if(!.)
		return .

	//we check how much of glass,plasteel & cable the user can insert
	if(isstack(I))
		//user tried to insert invalid stacktype
		if(!is_type_in_list(I, allowed_material_types) && !is_type_in_list(I, allowed_bluespace_types))
			return FALSE

		var/obj/item/stack/the_stack = I
		var/present_amount = 0

		//we try to count & limit how much the user can insert of each type to prevent them from using it as an normal storage medium
		for(var/obj/item/stack/stack_content in parent)
			//is user trying to insert any of these listed bluespace stuff
			if(is_type_in_list(I, allowed_bluespace_types))
				//if yes count total bluespace stuff is the RPED and then compare the total amount to the value the user is trying to insert
				if(is_type_in_list(stack_content, allowed_bluespace_types))
					present_amount += stack_content.amount
			//count other normal stack stuff
			else if(istype(I,stack_content.type))
				present_amount = stack_content.amount
				break

		//no more storage for this specific stack type
		if(MAX_STACK_PICKUP - present_amount == 0)
			return FALSE

		//we want the user to insert the exact stack amount which is available so we dont have to bother subtracting & leaving left overs for the user
		var/available = MAX_STACK_PICKUP-present_amount
		if(available - the_stack.amount < 0)
			return FALSE

	else if(istype(I, /obj/item/circuitboard/machine) || istype(I, /obj/item/circuitboard/computer))
		return TRUE

	//check normal insertion of other stock parts
	else if(!I.get_part_rating())
		return FALSE

	return .

/datum/component/storage/concrete/rped/quick_empty(mob/M)
	var/atom/A = parent
	if(!M.canUseStorage() || !A.Adjacent(M) || M.incapacitated())
		return
	if(check_locked(null, M, TRUE))
		return FALSE
	A.add_fingerprint(M)
	var/list/things = contents()
	var/lowest_rating = INFINITY
	for(var/obj/item/B in things)
		if(B.get_part_rating() < lowest_rating)
			lowest_rating = B.get_part_rating()
	for(var/obj/item/B in things)
		if(B.get_part_rating() > lowest_rating)
			things.Remove(B)
	if(lowest_rating == INFINITY)
		to_chat(M, "<span class='notice'>There's no parts to dump out from [parent].</span>")
		return
	to_chat(M, "<span class='notice'>You start dumping out tier/cell rating [lowest_rating] parts from [parent].</span>")
	var/turf/T = get_turf(A)
	var/datum/progressbar/progress = new(M, length(things), T)
	while (do_after(M, 1 SECONDS, T, NONE, FALSE, CALLBACK(src, PROC_REF(mass_remove_from_storage), T, things, progress, TRUE, M)))
		stoplag(1)
	progress.end_progress()
	A.do_squish(0.8, 1.2)

/datum/component/storage/concrete/bluespace/rped
	collection_mode = COLLECT_EVERYTHING
	allow_quick_gather = TRUE
	allow_quick_empty = TRUE
	click_gather = TRUE
	max_w_class = WEIGHT_CLASS_BULKY  // can fit vending refills
	max_combined_w_class = 800
	max_items = 350
	display_numerical_stacking = TRUE

	var/static/list/allowed_material_types = list(
		/obj/item/stack/sheet/glass,
		/obj/item/stack/sheet/plasteel,
		/obj/item/stack/cable_coil,
	)

	var/static/list/allowed_bluespace_types = list(
		/obj/item/stack/ore/bluespace_crystal,
		/obj/item/stack/sheet/bluespace_crystal,
	)

/datum/component/storage/concrete/bluespace/rped/can_be_inserted(obj/item/I, stop_messages, mob/M)
	. = ..()
	if(!.)
		return .

	//we check how much of glass,plasteel & cable the user can insert
	if(isstack(I))
		//user tried to insert invalid stacktype
		if(!is_type_in_list(I, allowed_material_types) && !is_type_in_list(I, allowed_bluespace_types))
			return FALSE

		var/obj/item/stack/the_stack = I
		var/present_amount = 0

		//we try to count & limit how much the user can insert of each type to prevent them from using it as an normal storage medium
		for(var/obj/item/stack/stack_content in parent)
			//is user trying to insert any of these listed bluespace stuff
			if(is_type_in_list(I, allowed_bluespace_types))
				//if yes count total bluespace stuff is the RPED and then compare the total amount to the value the user is trying to insert
				if(is_type_in_list(stack_content, allowed_bluespace_types))
					present_amount += stack_content.amount
			//count other normal stack stuff
			else if(istype(I,stack_content.type))
				present_amount = stack_content.amount
				break

		//no more storage for this specific stack type
		if(MAX_STACK_PICKUP - present_amount == 0)
			return FALSE

		//we want the user to insert the exact stack amount which is available so we dont have to bother subtracting & leaving left overs for the user
		var/available = MAX_STACK_PICKUP-present_amount
		if(available - the_stack.amount < 0)
			return FALSE

	else if(istype(I, /obj/item/circuitboard/machine) || istype(I, /obj/item/circuitboard/computer))
		return TRUE

	//check normal insertion of other stock parts
	else if(!I.get_part_rating())
		return FALSE

	return .

/datum/component/storage/concrete/bluespace/rped/quick_empty(mob/M)
	var/atom/A = parent
	if(!M.canUseStorage() || !A.Adjacent(M) || M.incapacitated())
		return
	if(check_locked(null, M, TRUE))
		return FALSE
	A.add_fingerprint(M)
	var/list/things = contents()
	var/lowest_rating = INFINITY
	for(var/obj/item/B in things)
		if(B.get_part_rating() < lowest_rating)
			lowest_rating = B.get_part_rating()
	for(var/obj/item/B in things)
		if(B.get_part_rating() > lowest_rating)
			things.Remove(B)
	if(lowest_rating == INFINITY)
		to_chat(M, "<span class='notice'>There's no parts to dump out from [parent].</span>")
		return
	to_chat(M, "<span class='notice'>You start dumping out tier/cell rating [lowest_rating] parts from [parent].</span>")
	var/turf/T = get_turf(A)
	var/datum/progressbar/progress = new(M, length(things), T)
	while (do_after(M, 10, T, NONE, FALSE, CALLBACK(src, PROC_REF(mass_remove_from_storage), T, things, progress, TRUE, M)))
		stoplag(1)
	progress.end_progress()
	A.do_squish(0.8, 1.2)

#undef MAX_STACK_PICKUP
