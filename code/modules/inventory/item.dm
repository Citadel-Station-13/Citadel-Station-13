/obj/item
	/// currently equipped slot
	var/current_equipped_slot

/**
 * Called after an item is placed in an equipment slot.
 *
 * Note that hands count as slots.
 *
 * Arguments:
 * * user is mob that equipped it
 * * slot uses the slot_X defines found in setup.dm for items that can be placed in multiple slots
 * * Initial is used to indicate whether or not this is the initial equipment (job datums etc) or just a player doing it
 */
#warn refactor the slot to be the datums. i'm fucking done wth the old bullshit. i'm sorry sandpoot.
/obj/item/proc/equipped(mob/user, slot, initial = FALSE)
	SHOULD_CALL_PARENT(TRUE)
	var/signal_flags = SEND_SIGNAL(src, COMSIG_ITEM_EQUIPPED, user, slot)
	current_equipped_slot = slot
	// current_equipped_slot = get_inventory_slot_datum(slot)
	if(!(signal_flags & COMPONENT_NO_GRANT_ACTIONS))
		for(var/X in actions)
			var/datum/action/A = X
			if(item_action_slot_check(slot, user, A)) //some items only give their actions buttons when in a specific slot.
				A.Grant(user)
	item_flags |= IN_INVENTORY
	if((item_flags & IN_STORAGE)) // Left storage item but somehow has the bitfield active still.
		item_flags &= ~(IN_STORAGE)
	// if(!initial)
	// 	if(equip_sound && (slot_flags & slot))
	// 		playsound(src, equip_sound, EQUIP_SOUND_VOLUME, TRUE, ignore_walls = FALSE)
	// 	else if(slot == ITEM_SLOT_HANDS)
	// 		playsound(src, pickup_sound, PICKUP_SOUND_VOLUME, ignore_walls = FALSE)
	user.update_equipment_speed_mods()

/// Called when a mob drops an item.
/obj/item/proc/dropped(mob/user, silent = FALSE)
	SHOULD_CALL_PARENT(TRUE)
	for(var/X in actions)
		var/datum/action/A = X
		A.Remove(user)
	if(item_flags & DROPDEL)
		qdel(src)
	item_flags &= ~(IN_INVENTORY)
	item_flags &= ~(IN_STORAGE)
	SEND_SIGNAL(src, COMSIG_ITEM_DROPPED,user)
	if(!silent)
		playsound(src, drop_sound, DROP_SOUND_VOLUME, ignore_walls = FALSE)
	user?.update_equipment_speed_mods()

// called just as an item is picked up (loc is not yet changed)
/obj/item/proc/pickup(mob/user)
	SHOULD_CALL_PARENT(TRUE)
	SEND_SIGNAL(src, COMSIG_ITEM_PICKUP, user)
	item_flags |= IN_INVENTORY
	if(item_flags & (ITEM_CAN_BLOCK | ITEM_CAN_PARRY) && user.client && !(type in user.client.block_parry_hinted))
		var/list/dat = list("<span class='boldnotice'>You have picked up an item that can be used to block and/or parry:</span>")
		// cit change - parry/block feedback
		var/datum/block_parry_data/data = return_block_parry_datum(block_parry_data)
		if(item_flags & ITEM_CAN_BLOCK)
			dat += "[src] can be used to block damage using directional block. Press your active block keybind to use it."
			if(data.block_automatic_enabled)
				dat += "[src] is also capable of automatically blocking damage, if you are facing the right direction (usually towards your attacker)!"
		if(item_flags & ITEM_CAN_PARRY)
			dat += "[src] can be used to parry damage using active parry. Pressed your active parry keybind to initiate a timed parry sequence."
			if(data.parry_automatic_enabled)
				dat += "[src] is also capable of automatically parrying an incoming attack, if your mouse is over your attacker at the time if you being hit in a direct, melee attack."
		dat += "Examine [src] to get a full readout of its block/parry stats."
		to_chat(user, dat.Join("<br>"))
		user.client.block_parry_hinted |= type

/**
 * get the slowdown we incur when we're worn
 */
/obj/item/proc/get_equipment_speed_mod()
	return slowdown
