#define COLLECT_ONE 0
#define COLLECT_EVERYTHING 1
#define COLLECT_SAME 2

#define DROP_NOTHING 0
#define DROP_AT_PARENT 1
#define DROP_AT_LOCATION 2

// External storage-related logic:
// /mob/proc/ClickOn() in /_onclick/click.dm - clicking items in storages
// /mob/living/Move() in /modules/mob/living/living.dm - hiding storage boxes on mob movement

/datum/component/storage
	dupe_mode = COMPONENT_DUPE_UNIQUE
	var/datum/component/storage/concrete/master		//If not null, all actions act on master and this is just an access point.

	var/list/can_hold								//if this is set, only things in this typecache will fit.
	var/list/can_hold_extra							//if this is set, it will also be able to hold these.
	var/list/cant_hold								//if this is set, anything in this typecache will not be able to fit.

	var/list/mob/is_using							//lazy list of mobs looking at the contents of this storage.

	var/locked = FALSE								//when locked nothing can see inside or use it.

	/// Storage flags, including what kinds of limiters we use for how many items we can hold
	var/storage_flags = STORAGE_FLAGS_LEGACY_DEFAULT
	/// Max w_class we can hold. Applies to [STORAGE_LIMIT_COMBINED_W_CLASS] and [STORAGE_LIMIT_VOLUME]
	var/max_w_class = WEIGHT_CLASS_SMALL
	/// Max combined w_class. Applies to [STORAGE_LIMIT_COMBINED_W_CLASS]
	var/max_combined_w_class = WEIGHT_CLASS_SMALL * 7
	/// Max items we can hold. Applies to [STORAGE_LIMIT_MAX_ITEMS]
	var/max_items = 7
	/// Max volume we can hold. Applies to [STORAGE_LIMIT_VOLUME]. Auto scaled on New() if unset.
	var/max_volume

	var/emp_shielded = FALSE

	var/silent = FALSE								//whether this makes a message when things are put in.
	var/click_gather = FALSE						//whether this can be clicked on items to pick it up rather than the other way around.
	var/rustle_sound = TRUE							//play rustle sound on interact.
	var/allow_quick_empty = FALSE					//allow empty verb which allows dumping on the floor of everything inside quickly.
	var/allow_quick_gather = FALSE					//allow toggle mob verb which toggles collecting all items from a tile.

	var/collection_mode = COLLECT_EVERYTHING

	var/insert_preposition = "in"					//you put things "in" a bag, but "on" a tray.

	var/display_numerical_stacking = FALSE			//stack things of the same type and show as a single object with a number.

	/// "legacy"/default view mode's storage "boxes"
	var/obj/screen/storage/boxes/ui_boxes
	/// New volumetric storage display mode's left side
	var/obj/screen/storage/left/ui_left
	/// New volumetric storage display mode's center 'blocks'
	var/obj/screen/storage/continuous/ui_continuous
	/// The close button, used in all modes. Frames right side in volumetric mode.
	var/obj/screen/storage/close/ui_close
	/// Associative list of list(item = screen object) for volumetric storage item screen blocks
	var/list/ui_item_blocks

	var/current_maxscreensize

	var/allow_big_nesting = FALSE					//allow storage objects of the same or greater size.

	var/attack_hand_interact = TRUE					//interact on attack hand.
	var/quickdraw = FALSE							//altclick interact

	var/datum/action/item_action/storage_gather_mode/modeswitch_action

	//Screen variables: Do not mess with these vars unless you know what you're doing. They're not defines so storage that isn't in the same location can be supported in the future.
	var/screen_max_columns = 7							//These two determine maximum screen sizes.
	var/screen_max_rows = INFINITY
	var/screen_pixel_x = 16								//These two are pixel values for screen loc of boxes and closer
	var/screen_pixel_y = 16
	var/screen_start_x = 4								//These two are where the storage starts being rendered, screen_loc wise.
	var/screen_start_y = 2
	//End

	var/limited_random_access = FALSE					//Quick if statement in accessible_items to determine if we care at all about what people can access at once.
	var/limited_random_access_stack_position = 0					//If >0, can only access top <x> items
	var/limited_random_access_stack_bottom_up = FALSE				//If TRUE, above becomes bottom <x> items

/datum/component/storage/Initialize(datum/component/storage/concrete/master)
	if(!isatom(parent))
		return COMPONENT_INCOMPATIBLE
	if(master)
		change_master(master)

	RegisterSignal(parent, COMSIG_CONTAINS_STORAGE, .proc/on_check)
	RegisterSignal(parent, COMSIG_IS_STORAGE_LOCKED, .proc/check_locked)
	RegisterSignal(parent, COMSIG_TRY_STORAGE_SHOW, .proc/signal_show_attempt)
	RegisterSignal(parent, COMSIG_TRY_STORAGE_INSERT, .proc/signal_insertion_attempt)
	RegisterSignal(parent, COMSIG_TRY_STORAGE_CAN_INSERT, .proc/signal_can_insert)
	RegisterSignal(parent, COMSIG_TRY_STORAGE_TAKE_TYPE, .proc/signal_take_type)
	RegisterSignal(parent, COMSIG_TRY_STORAGE_FILL_TYPE, .proc/signal_fill_type)
	RegisterSignal(parent, COMSIG_TRY_STORAGE_SET_LOCKSTATE, .proc/set_locked)
	RegisterSignal(parent, COMSIG_TRY_STORAGE_TAKE, .proc/signal_take_obj)
	RegisterSignal(parent, COMSIG_TRY_STORAGE_QUICK_EMPTY, .proc/signal_quick_empty)
	RegisterSignal(parent, COMSIG_TRY_STORAGE_HIDE_FROM, .proc/signal_hide_attempt)
	RegisterSignal(parent, COMSIG_TRY_STORAGE_HIDE_ALL, .proc/close_all)
	RegisterSignal(parent, COMSIG_TRY_STORAGE_RETURN_INVENTORY, .proc/signal_return_inv)

	RegisterSignal(parent, COMSIG_PARENT_ATTACKBY, .proc/attackby)

	RegisterSignal(parent, COMSIG_ATOM_ATTACK_HAND, .proc/on_attack_hand)
	RegisterSignal(parent, COMSIG_ATOM_ATTACK_PAW, .proc/on_attack_hand)
	RegisterSignal(parent, COMSIG_ATOM_EMP_ACT, .proc/emp_act)
	RegisterSignal(parent, COMSIG_ATOM_ATTACK_GHOST, .proc/show_to_ghost)
	RegisterSignal(parent, COMSIG_ATOM_ENTERED, .proc/refresh_mob_views)
	RegisterSignal(parent, COMSIG_ATOM_EXITED, .proc/_remove_and_refresh)
	RegisterSignal(parent, COMSIG_ATOM_CANREACH, .proc/canreach_react)

	RegisterSignal(parent, COMSIG_ITEM_PRE_ATTACK, .proc/preattack_intercept)
	RegisterSignal(parent, COMSIG_ITEM_ATTACK_SELF, .proc/attack_self)
	RegisterSignal(parent, COMSIG_ITEM_PICKUP, .proc/signal_on_pickup)

	RegisterSignal(parent, COMSIG_MOVABLE_POST_THROW, .proc/close_all)
	RegisterSignal(parent, COMSIG_MOVABLE_MOVED, .proc/check_views)

	RegisterSignal(parent, COMSIG_CLICK_ALT, .proc/on_alt_click)
	RegisterSignal(parent, COMSIG_MOUSEDROP_ONTO, .proc/mousedrop_onto)
	RegisterSignal(parent, COMSIG_MOUSEDROPPED_ONTO, .proc/mousedrop_receive)

	update_actions()

/datum/component/storage/Destroy()
	close_all()
	QDEL_NULL(ui_boxes)
	QDEL_NULL(ui_close)
	QDEL_NULL(ui_continuous)
	QDEL_NULL(ui_left)
	// DO NOT USE QDEL_LIST_ASSOC.
	if(ui_item_blocks)
		for(var/i in ui_item_blocks)
			qdel(ui_item_blocks[i])		//qdel the screen object not the item
		ui_item_blocks.Cut()
	LAZYCLEARLIST(is_using)
	return ..()

/datum/component/storage/PreTransfer()
	update_actions()

/datum/component/storage/proc/update_actions()
	QDEL_NULL(modeswitch_action)
	if(!isitem(parent) || !allow_quick_gather)
		return
	var/obj/item/I = parent
	modeswitch_action = new(I)
	RegisterSignal(modeswitch_action, COMSIG_ACTION_TRIGGER, .proc/action_trigger)
	if(I.obj_flags & IN_INVENTORY)
		var/mob/M = I.loc
		if(!istype(M))
			return
		modeswitch_action.Grant(M)

/datum/component/storage/proc/change_master(datum/component/storage/concrete/new_master)
	if(new_master == src || (!isnull(new_master) && !istype(new_master)))
		return FALSE
	if(master)
		master.on_slave_unlink(src)
	master = new_master
	if(master)
		master.on_slave_link(src)
	return TRUE

/datum/component/storage/proc/master()
	if(master == src)
		return			//infinite loops yo.
	return master

/datum/component/storage/proc/real_location()
	var/datum/component/storage/concrete/master = master()
	return master? master.real_location() : null

//What players can access
//this proc can probably eat a refactor at some point.
/datum/component/storage/proc/accessible_items(random_access = TRUE)
	var/list/contents = contents()
	if(contents)
		if(limited_random_access && random_access)
			if(limited_random_access_stack_position && (length(contents) > limited_random_access_stack_position))
				if(limited_random_access_stack_bottom_up)
					contents.Cut(1, limited_random_access_stack_position + 1)
				else
					contents.Cut(1, length(contents) - limited_random_access_stack_position + 1)
	return contents

/datum/component/storage/proc/canreach_react(datum/source, list/next)
	var/datum/component/storage/concrete/master = master()
	if(!master)
		return
	. = COMPONENT_BLOCK_REACH
	next += master.parent
	for(var/i in master.slaves)
		var/datum/component/storage/slave = i
		next += slave.parent

/datum/component/storage/proc/attack_self(datum/source, mob/M)
	if(check_locked(source, M, TRUE))
		return FALSE
	if((M.get_active_held_item() == parent) && allow_quick_empty)
		quick_empty(M)

/datum/component/storage/proc/preattack_intercept(datum/source, obj/O, mob/M, params)
	if(!isitem(O) || !click_gather || SEND_SIGNAL(O, COMSIG_CONTAINS_STORAGE))
		return FALSE
	. = COMPONENT_NO_ATTACK
	if(check_locked(source, M, TRUE))
		return FALSE
	var/atom/A = parent
	var/obj/item/I = O
	if(collection_mode == COLLECT_ONE)
		if(can_be_inserted(I, null, M))
			handle_item_insertion(I, null, M)
			A.do_squish()
		return
	if(!isturf(I.loc))
		return
	var/list/things = I.loc.contents.Copy()
	if(collection_mode == COLLECT_SAME)
		things = typecache_filter_list(things, typecacheof(I.type))
	var/len = length(things)
	if(!len)
		to_chat(M, "<span class='notice'>You failed to pick up anything with [parent].</span>")
		return
	var/datum/progressbar/progress = new(M, len, I.loc)
	var/list/rejections = list()
	while(do_after(M, 10, TRUE, parent, FALSE, CALLBACK(src, .proc/handle_mass_pickup, things, I.loc, rejections, progress)))
		stoplag(1)
	qdel(progress)
	to_chat(M, "<span class='notice'>You put everything you could [insert_preposition] [parent].</span>")
	A.do_squish(1.4, 0.4)

/datum/component/storage/proc/handle_mass_item_insertion(list/things, datum/component/storage/src_object, mob/user, datum/progressbar/progress)
	var/atom/source_real_location = src_object.real_location()
	for(var/obj/item/I in things)
		things -= I
		if(I.loc != source_real_location)
			continue
		if(user.active_storage != src_object)
			if(I.on_found(user))
				break
		if(can_be_inserted(I,FALSE,user))
			handle_item_insertion(I, TRUE, user)
		if (TICK_CHECK)
			progress.update(progress.goal - things.len)
			return TRUE

	progress.update(progress.goal - things.len)
	return FALSE

/datum/component/storage/proc/handle_mass_pickup(list/things, atom/thing_loc, list/rejections, datum/progressbar/progress)
	var/atom/real_location = real_location()
	for(var/obj/item/I in things)
		things -= I
		if(I.loc != thing_loc)
			continue
		if(I.type in rejections) // To limit bag spamming: any given type only complains once
			continue
		if(!can_be_inserted(I, stop_messages = TRUE))	// Note can_be_inserted still makes noise when the answer is no
			if(real_location.contents.len >= max_items)
				break
			rejections += I.type	// therefore full bags are still a little spammy
			continue

		handle_item_insertion(I, TRUE)	//The TRUE stops the "You put the [parent] into [S]" insertion message from being displayed.

		if (TICK_CHECK)
			progress.update(progress.goal - things.len)
			return TRUE

	progress.update(progress.goal - things.len)
	return FALSE

/datum/component/storage/proc/quick_empty(mob/M)
	var/atom/A = parent
	if(!M.canUseStorage() || !A.Adjacent(M) || M.incapacitated())
		return
	if(check_locked(null, M, TRUE))
		return FALSE
	A.add_fingerprint(M)
	to_chat(M, "<span class='notice'>You start dumping out [parent].</span>")
	var/turf/T = get_turf(A)
	var/list/things = contents()
	var/datum/progressbar/progress = new(M, length(things), T)
	while (do_after(M, 10, TRUE, T, FALSE, CALLBACK(src, .proc/mass_remove_from_storage, T, things, progress)))
		stoplag(1)
	qdel(progress)
	A.do_squish(0.8, 1.2)

/datum/component/storage/proc/mass_remove_from_storage(atom/target, list/things, datum/progressbar/progress, trigger_on_found = TRUE)
	var/atom/real_location = real_location()
	for(var/obj/item/I in things)
		things -= I
		if(I.loc != real_location)
			continue
		remove_from_storage(I, target)
		if(trigger_on_found && I.on_found())
			return FALSE
		if(TICK_CHECK)
			progress.update(progress.goal - length(things))
			return TRUE
	progress.update(progress.goal - length(things))
	return FALSE

/datum/component/storage/proc/do_quick_empty(atom/_target)
	if(!_target)
		_target = get_turf(parent)
	if(usr)
		ui_hide(usr)
	var/list/contents = contents()
	var/atom/real_location = real_location()
	for(var/obj/item/I in contents)
		if(I.loc != real_location)
			continue
		remove_from_storage(I, _target)
	return TRUE

/datum/component/storage/proc/set_locked(datum/source, new_state)
	locked = new_state
	if(check_locked())
		close_all()

/datum/component/storage/proc/close(mob/M)
	ui_hide(M)

/datum/component/storage/proc/close_all()
	. = FALSE
	for(var/mob/M in can_see_contents())
		close(M)
		. = TRUE //returns TRUE if any mobs actually got a close(M) call

/datum/component/storage/proc/check_views()
	for(var/mob/M in can_see_contents())
		if(!isobserver(M) && !M.CanReach(parent, view_only = TRUE))
			close(M)

/datum/component/storage/proc/emp_act(datum/source, severity)
	if(emp_shielded)
		return
	var/datum/component/storage/concrete/master = master()
	master.emp_act(source, severity)

//Resets something that is being removed from storage.
/datum/component/storage/proc/_removal_reset(atom/movable/thing)
	if(!istype(thing))
		return FALSE
	var/datum/component/storage/concrete/master = master()
	if(!istype(master))
		return FALSE
	return master._removal_reset(thing)

/datum/component/storage/proc/_remove_and_refresh(datum/source, atom/movable/thing)
	if(LAZYACCESS(ui_item_blocks, thing))
		var/obj/screen/storage/volumetric_box/center/C = ui_item_blocks[thing]
		for(var/i in can_see_contents())		//runtimes result if mobs can access post deletion.
			var/mob/M = i
			M.client?.screen -= C.on_screen_objects()
		ui_item_blocks -= thing
		qdel(C)
	_removal_reset(thing)		// THIS NEEDS TO HAPPEN AFTER SO LAYERING DOESN'T BREAK!
	refresh_mob_views()

//Call this proc to handle the removal of an item from the storage item. The item will be moved to the new_location target, if that is null it's being deleted
/datum/component/storage/proc/remove_from_storage(atom/movable/AM, atom/new_location)
	if(!istype(AM))
		return FALSE
	var/datum/component/storage/concrete/master = master()
	if(!istype(master))
		return FALSE
	return master.remove_from_storage(AM, new_location)

/datum/component/storage/proc/refresh_mob_views()
	var/list/seeing = can_see_contents()
	for(var/i in seeing)
		ui_show(i)
	return TRUE

/datum/component/storage/proc/can_see_contents()
	var/list/cansee = list()
	for(var/mob/M in is_using)
		if(M.active_storage == src && M.client)
			cansee |= M
		else
			LAZYREMOVE(is_using, M)
	return cansee

//Tries to dump content
/datum/component/storage/proc/dump_content_at(atom/dest_object, mob/M)
	var/atom/A = parent
	var/atom/dump_destination = dest_object.get_dumping_location()
	if(A.Adjacent(M) && dump_destination && M.Adjacent(dump_destination))
		if(check_locked(null, M, TRUE))
			return FALSE
		if(dump_destination.storage_contents_dump_act(src, M))
			playsound(A, "rustle", 50, 1, -5)
			A.do_squish(0.8, 1.2)
			return TRUE
	return FALSE

//This proc is called when you want to place an item into the storage item.
/datum/component/storage/proc/attackby(datum/source, obj/item/I, mob/M, params)
	if(istype(I, /obj/item/hand_labeler))
		var/obj/item/hand_labeler/labeler = I
		if(labeler.mode)
			return FALSE
	. = TRUE //no afterattack
	if(iscyborg(M))
		return
	if(!can_be_inserted(I, FALSE, M))
		var/atom/real_location = real_location()
		if(real_location.contents.len >= max_items) //don't use items on the backpack if they don't fit
			return TRUE
		return FALSE
	handle_item_insertion(I, FALSE, M)
	var/atom/A = parent
	A.do_squish()

/datum/component/storage/proc/return_inv(recursive)
	var/list/ret = list()
	ret |= contents()
	if(recursive)
		for(var/i in ret.Copy())
			var/atom/A = i
			SEND_SIGNAL(A, COMSIG_TRY_STORAGE_RETURN_INVENTORY, ret, TRUE)
	return ret

/datum/component/storage/proc/contents()			//ONLY USE IF YOU NEED TO COPY CONTENTS OF REAL LOCATION, COPYING IS NOT AS FAST AS DIRECT ACCESS!
	var/atom/real_location = real_location()
	return real_location.contents.Copy()

//Abuses the fact that lists are just references, or something like that.
/datum/component/storage/proc/signal_return_inv(datum/source, list/interface, recursive = TRUE)
	if(!islist(interface))
		return FALSE
	interface |= return_inv(recursive)
	return TRUE

/datum/component/storage/proc/mousedrop_onto(datum/source, atom/over_object, mob/M)
	set waitfor = FALSE
	. = COMPONENT_NO_MOUSEDROP
	var/atom/A = parent
	if(ismob(M)) //all the check for item manipulation are in other places, you can safely open any storages as anything and its not buggy, i checked
		A.add_fingerprint(M)
		if(!over_object)
			return FALSE
		if(ismecha(M.loc)) // stops inventory actions in a mech
			return FALSE
		// this must come before the screen objects only block, dunno why it wasn't before
		if(over_object == M)
			user_show_to_mob(M)
		if(!M.incapacitated())
			if(!istype(over_object, /obj/screen))
				dump_content_at(over_object, M)
				return
			if(A.loc != M)
				return
			playsound(A, "rustle", 50, 1, -5)
			A.do_jiggle()
			if(istype(over_object, /obj/screen/inventory/hand))
				var/obj/screen/inventory/hand/H = over_object
				M.putItemFromInventoryInHandIfPossible(A, H.held_index)
				return
			A.add_fingerprint(M)

/datum/component/storage/proc/user_show_to_mob(mob/M, force = FALSE, ghost = FALSE)
	var/atom/A = parent
	if(!istype(M))
		return FALSE
	A.add_fingerprint(M)
	if(!force && (check_locked(null, M) || !M.CanReach(parent, view_only = TRUE)))
		return FALSE
	ui_show(M, !ghost)

/datum/component/storage/proc/mousedrop_receive(datum/source, atom/movable/O, mob/M)
	if(isitem(O))
		var/obj/item/I = O
		if(iscarbon(M) || isdrone(M))
			var/mob/living/L = M
			if(!L.incapacitated() && I == L.get_active_held_item())
				if(!SEND_SIGNAL(I, COMSIG_CONTAINS_STORAGE) && can_be_inserted(I, FALSE))	//If it has storage it should be trying to dump, not insert.
					handle_item_insertion(I, FALSE, L)
					var/atom/A = parent
					A.do_squish()

//This proc return 1 if the item can be picked up and 0 if it can't.
//Set the stop_messages to stop it from printing messages
/datum/component/storage/proc/can_be_inserted(obj/item/I, stop_messages = FALSE, mob/M)
	if(!istype(I) || (I.item_flags & ABSTRACT))
		return FALSE //Not an item
	if(I == parent)
		return FALSE	//no paradoxes for you
	var/atom/real_location = real_location()
	var/atom/host = parent
	if(real_location == I.loc)
		return FALSE //Means the item is already in the storage item
	if(check_locked(null, M, !stop_messages))
		if(M && !stop_messages)
			host.add_fingerprint(M)
		return FALSE
	if(!length(can_hold_extra) || !is_type_in_typecache(I, can_hold_extra))
		if(length(can_hold) && !is_type_in_typecache(I, can_hold))
			if(!stop_messages)
				to_chat(M, "<span class='warning'>[host] cannot hold [I]!</span>")
			return FALSE
		if(is_type_in_typecache(I, cant_hold)) //Check for specific items which this container can't hold.
			if(!stop_messages)
				to_chat(M, "<span class='warning'>[host] cannot hold [I]!</span>")
			return FALSE
		if(storage_flags & STORAGE_LIMIT_MAX_W_CLASS && I.w_class > max_w_class)
			if(!stop_messages)
				to_chat(M, "<span class='warning'>[I] is too long for [host]!</span>")
			return FALSE
		// STORAGE LIMITS
	if(storage_flags & STORAGE_LIMIT_MAX_ITEMS)
		if(real_location.contents.len >= max_items)
			if(!stop_messages)
				to_chat(M, "<span class='warning'>[host] has too many things in it, make some space!</span>")
			return FALSE //Storage item is full
	if(storage_flags & STORAGE_LIMIT_COMBINED_W_CLASS)
		var/sum_w_class = I.w_class
		for(var/obj/item/_I in real_location)
			sum_w_class += _I.w_class //Adds up the combined w_classes which will be in the storage item if the item is added to it.
		if(sum_w_class > max_combined_w_class)
			if(!stop_messages)
				to_chat(M, "<span class='warning'>[I] won't fit in [host], make some space!</span>")
			return FALSE
	if(storage_flags & STORAGE_LIMIT_VOLUME)
		var/sum_volume = I.get_w_volume()
		for(var/obj/item/_I in real_location)
			sum_volume += _I.get_w_volume()
		if(sum_volume > get_max_volume())
			if(!stop_messages)
				to_chat(M, "<span class='warning'>[I] is too spacious to fit in [host], make some space!</span>")
			return FALSE
	/////////////////
	if(isitem(host))
		var/obj/item/IP = host
		var/datum/component/storage/STR_I = I.GetComponent(/datum/component/storage)
		if((I.w_class >= IP.w_class) && STR_I && !allow_big_nesting)
			if(!stop_messages)
				to_chat(M, "<span class='warning'>[IP] cannot hold [I] as it's a storage item of the same size!</span>")
			return FALSE //To prevent the stacking of same sized storage items.
	if(HAS_TRAIT(I, TRAIT_NODROP)) //SHOULD be handled in unEquip, but better safe than sorry.
		to_chat(M, "<span class='warning'>\the [I] is stuck to your hand, you can't put it in \the [host]!</span>")
		return FALSE
	var/datum/component/storage/concrete/master = master()
	if(!istype(master))
		return FALSE
	return master.slave_can_insert_object(src, I, stop_messages, M)

/datum/component/storage/proc/_insert_physical_item(obj/item/I, override = FALSE)
	return FALSE

//This proc handles items being inserted. It does not perform any checks of whether an item can or can't be inserted. That's done by can_be_inserted()
//The stop_warning parameter will stop the insertion message from being displayed. It is intended for cases where you are inserting multiple items at once,
//such as when picking up all the items on a tile with one click.
/datum/component/storage/proc/handle_item_insertion(obj/item/I, prevent_warning = FALSE, mob/M, datum/component/storage/remote)
	var/atom/parent = src.parent
	var/datum/component/storage/concrete/master = master()
	if(!istype(master))
		return FALSE
	if(silent)
		prevent_warning = TRUE
	if(M)
		parent.add_fingerprint(M)
	. = master.handle_item_insertion_from_slave(src, I, prevent_warning, M)

/datum/component/storage/proc/mob_item_insertion_feedback(mob/user, mob/M, obj/item/I, override = FALSE)
	if(silent && !override)
		return
	if(rustle_sound)
		playsound(parent, "rustle", 50, 1, -5)
	to_chat(user, "<span class='notice'>You put [I] [insert_preposition]to [parent].</span>")
	for(var/mob/viewing in fov_viewers(world.view, user)-M)
		if(in_range(M, viewing)) //If someone is standing close enough, they can tell what it is...
			viewing.show_message("<span class='notice'>[M] puts [I] [insert_preposition]to [parent].</span>", MSG_VISUAL)
		else if(I && I.w_class >= 3) //Otherwise they can only see large or normal items from a distance...
			viewing.show_message("<span class='notice'>[M] puts [I] [insert_preposition]to [parent].</span>", MSG_VISUAL)

/datum/component/storage/proc/update_icon()
	if(isobj(parent))
		var/obj/O = parent
		O.update_icon()

/datum/component/storage/proc/signal_insertion_attempt(datum/source, obj/item/I, mob/M, silent = FALSE, force = FALSE)
	if((!force && !can_be_inserted(I, TRUE, M)) || (I == parent))
		return FALSE
	return handle_item_insertion(I, silent, M)

/datum/component/storage/proc/signal_can_insert(datum/source, obj/item/I, mob/M, silent = FALSE)
	return can_be_inserted(I, silent, M)

/datum/component/storage/proc/show_to_ghost(datum/source, mob/dead/observer/M)
	return user_show_to_mob(M, TRUE, TRUE)

/datum/component/storage/proc/signal_show_attempt(datum/source, mob/showto, force = FALSE)
	return user_show_to_mob(showto, force)

/datum/component/storage/proc/on_check()
	return TRUE

/datum/component/storage/proc/check_locked(datum/source, mob/user, message = FALSE)
	. = locked
	if(message && . && user)
		to_chat(user, "<span class='warning'>[parent] seems to be locked!</span>")

/datum/component/storage/proc/signal_take_type(datum/source, type, atom/destination, amount = INFINITY, check_adjacent = FALSE, force = FALSE, mob/user, list/inserted)
	if(!force)
		if(check_adjacent)
			if(!user || !user.CanReach(destination) || !user.CanReach(parent))
				return FALSE
	var/list/taking = typecache_filter_list(contents(), typecacheof(type))
	if(taking.len > amount)
		taking.len = amount
	if(inserted)			//duplicated code for performance, don't bother checking retval/checking for list every item.
		for(var/i in taking)
			if(remove_from_storage(i, destination))
				inserted |= i
	else
		for(var/i in taking)
			remove_from_storage(i, destination)
	return TRUE

/datum/component/storage/proc/remaining_space_items()
	var/atom/real_location = real_location()
	return max(0, max_items - real_location.contents.len)

/datum/component/storage/proc/signal_fill_type(datum/source, type, amount = 20, force = FALSE)
	var/atom/real_location = real_location()
	if(!force)
		amount = min(remaining_space_items(), amount)
	for(var/i in 1 to amount)
		handle_item_insertion(new type(real_location), TRUE)
		CHECK_TICK
	return TRUE

/datum/component/storage/proc/on_attack_hand(datum/source, mob/user)
	var/atom/A = parent
	if(!attack_hand_interact)
		return
	if(user.active_storage == src && A.loc == user) //if you're already looking inside the storage item
		user.active_storage.close(user)
		close(user)
		. = COMPONENT_NO_ATTACK_HAND
		return

	if(rustle_sound)
		playsound(A, "rustle", 50, 1, -5)

	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(H.l_store == A && !H.get_active_held_item())	//Prevents opening if it's in a pocket.
			. = COMPONENT_NO_ATTACK_HAND
			H.put_in_hands(A)
			H.l_store = null
			return
		if(H.r_store == A && !H.get_active_held_item())
			. = COMPONENT_NO_ATTACK_HAND
			H.put_in_hands(A)
			H.r_store = null
			return

	if(A.loc == user)
		. = COMPONENT_NO_ATTACK_HAND
		if(!check_locked(source, user, TRUE))
			ui_show(user)
			A.do_jiggle()

/datum/component/storage/proc/signal_on_pickup(datum/source, mob/user)
	var/atom/A = parent
	update_actions()
	for(var/mob/M in range(1, A))
		if(M.active_storage == src)
			close(M)

/datum/component/storage/proc/signal_take_obj(datum/source, atom/movable/AM, new_loc, force = FALSE)
	if(!(AM in real_location()))
		return FALSE
	return remove_from_storage(AM, new_loc)

/datum/component/storage/proc/signal_quick_empty(datum/source, atom/loctarget)
	return do_quick_empty(loctarget)

/datum/component/storage/proc/signal_hide_attempt(datum/source, mob/target)
	return ui_hide(target)

/datum/component/storage/proc/on_alt_click(datum/source, mob/user)
	if(!isliving(user) || !user.CanReach(parent))
		return
	if(check_locked(source, user, TRUE))
		return TRUE

	var/atom/A = parent
	if(!quickdraw)
		A.add_fingerprint(user)
		user_show_to_mob(user)
		if(rustle_sound)
			playsound(A, "rustle", 50, 1, -5)
		return TRUE

	if(user.can_hold_items() && !user.incapacitated())
		var/obj/item/I = locate() in real_location()
		if(!I)
			return
		A.add_fingerprint(user)
		remove_from_storage(I, get_turf(user))
		if(!user.put_in_hands(I))
			user.visible_message("<span class='warning'>[user] fumbles with the [parent], letting [I] fall on the floor.</span>", \
								"<span class='notice'>You fumble with [parent], letting [I] fall on the floor.</span>")
			return TRUE
		user.visible_message("<span class='warning'>[user] draws [I] from [parent]!</span>", "<span class='notice'>You draw [I] from [parent].</span>")
		return TRUE

/datum/component/storage/proc/action_trigger(datum/action/source, obj/target)
	gather_mode_switch(source.owner)
	return COMPONENT_ACTION_BLOCK_TRIGGER

/datum/component/storage/proc/gather_mode_switch(mob/user)
	collection_mode = (collection_mode+1)%3
	switch(collection_mode)
		if(COLLECT_SAME)
			to_chat(user, "[parent] now picks up all items of a single type at once.")
		if(COLLECT_EVERYTHING)
			to_chat(user, "[parent] now picks up all items in a tile at once.")
		if(COLLECT_ONE)
			to_chat(user, "[parent] now picks up one item at a time.")

/**
  * Gets our max volume
  */
/datum/component/storage/proc/get_max_volume()
	return max_volume || AUTO_SCALE_STORAGE_VOLUME(max_w_class, max_combined_w_class)
