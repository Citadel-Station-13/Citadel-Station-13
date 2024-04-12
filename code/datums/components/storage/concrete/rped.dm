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

/datum/component/storage/concrete/rped/can_be_inserted(obj/item/I, stop_messages, mob/M)
	. = ..()
	if(!I.get_part_rating())
		if (!stop_messages)
			to_chat(M, "<span class='warning'>[parent] only accepts machine parts!</span>")
		return FALSE

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

/datum/component/storage/concrete/bluespace/rped/can_be_inserted(obj/item/I, stop_messages, mob/M)
	. = ..()
	if(!I.get_part_rating())
		if (!stop_messages)
			to_chat(M, "<span class='warning'>[parent] only accepts machine parts!</span>")
		return FALSE


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
