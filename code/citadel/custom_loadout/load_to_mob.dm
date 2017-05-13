
//Proc that does the actual loading of items to mob
/*Itemlists are formatted as
"[typepath]" = number_of_it_to_spawn
*/

#define DROP_TO_FLOOR 0
#define LOADING_TO_HUMAN 1

/proc/handle_roundstart_items(mob/living/M)
	if(!M.ckey || !istype(M))
		return FALSE
	var/list/items = parse_custom_items_by_key(M.ckey)
	if(isnull(items))
		return FALSE
	load_itemlist_to_mob(M, items, TRUE, TRUE, FALSE)

//Just incase there's extra mob selections in the future.....
/proc/load_itemlist_to_mob(mob/living/L, list/itemlist, drop_on_floor_if_full = TRUE, load_to_all_slots = TRUE, replace_slots = FALSE)
	if(!istype(L) || !islist(itemlist))
		return FALSE
	var/loading_mode = DROP_TO_FLOOR
	var/turf/current_turf = get_turf(L)
	if(ishuman(L))
		loading_mode = LOADING_TO_HUMAN
	switch(loading_mode)
		if(DROP_TO_FLOOR)
			for(var/I in itemlist)
				var/typepath = text2path(I)
				if(!typepath)
					continue
				for(var/i = 0, i < itemlist[I], i++)
					new typepath(current_turf)
			return TRUE
		if(LOADING_TO_HUMAN)
			return load_itemlist_to_human(L, itemlist, drop_on_floor_if_full, load_to_all_slots, replace_slots)

/proc/load_itemlist_to_human(mob/living/carbon/human/H, list/itemlist, drop_on_floor_if_full = TRUE, load_to_all_slots = TRUE, replace_slots = FALSE)
	if(!istype(H) || !islist(itemlist))
		return FALSE
	var/turf/T = get_turf(H)
	for(var/item in itemlist)
		var/path = text2path(item)
		if(!path)
			continue
		var/atom/movable/loaded_atom = new path
		if(!istype(loaded_atom))
			QDEL_NULL(loaded_atom)
			continue
		if(!istype(loaded_atom, /obj/item))
			loaded_atom.forceMove(T)
			continue
		var/obj/item/loaded = loaded_atom
		if(!loaded.equip_to_best_slot(H, TRUE))
			if(!H.put_in_hands(loaded))
				loaded.forceMove(T)
	return TRUE
