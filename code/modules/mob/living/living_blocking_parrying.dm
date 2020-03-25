// yell at me later for file naming
// This file contains stuff relating to the new directional blocking and parry system.
/mob/living
	var/obj/item/blocking_item
	var/parrying = FALSE
	var/parry_frame = 0


GLOBAL_LIST_EMPTY(block_parry_data)

/proc/get_block_parry_data(type_or_id)
	if(ispath(type_or_id))
		. = GLOB.block_parry_data["[type_or_id]"]
		if(!.)
			. = GLOB.block_parry_data["[type_or_id]"] = new type_or_id
	else		//text id
		return GLOB.block_parry_data["[type_or_id]"]

/proc/set_block_parry_data(id, datum/block_parry_data/data)
	if(ispath(id))
		CRASH("Path-fetching of block parry data is only to grab static data, do not attempt to modify global caches of paths. Use string IDs.")
	GLOB.block_parry_data["[id]"] = data

/// Carries data like list data that would be a waste of memory if we initialized the list on every /item as we can cache datums easier.
/datum/block_parry_data
	/////////// BLOCKING ////////////
	/// See defines.
	var/can_block_directions = BLOCK_DIR_NORTH | BLOCK_DIR_NORTHEAST | BLOCK_DIR_NORTHWEST
	/// See defines.
	var/block_flags = BLOCK_FLAGS_DEFAULT
	/// Our slowdown added while blocking
	var/block_slowdown = 2
	/// Clickdelay added to user after block ends
	var/block_end_click_cd_add = 4
	/// Default damage-to-stamina coefficient, higher is better.
	var/block_efficiency = 2
	/// Override damage-to-stamina coefficient, higher is better, this should be list(ATTACK_TYPE_DEFINE = coefficient_number)
	var/list/attack_type_block_efficiency


	/////////// PARRYING ////////////



/obj/item
	/// Defense flags, see defines.
	var/defense_flags = NONE
	/// Our block parry data. Should be set in init, or something.
	var/datum/block_parry_data/block_parry_data


/obj/item/Initialize(mapload)
	block_parry_data = get_block_parry_data(/datum/block_parry_data)
	return ..()

/// This item can be used to parry. Only a basic check used to determine if we should proceed with parry chain at all.
#define ITEM_DEFENSE_CAN_PARRY		(1<<0)
/// This item can be used in the directional blocking system. Only a basic check used to determine if we should proceed with directional block handling at all.
#define ITEM_DEFENSE_CAN_BLOCK		(1<<1)



/**
  * Gets the list of directions we can block. Include DOWN to block attacks from our same tile.
  */
/obj/item/proc/blockable_directions()
	return block_parry_data.can_block_directions

/**
  * Checks if we can block from a specific direction from our direction.
  *
  * @params
  * * our_dir - our direction.
  * * their_dir - their direction. Must be a single direction, or NONE for an attack from the same tile.
  */
/obj/item/proc/can_block_direction(our_dir, their_dir)
	if(our_dir != NORTH)
		var/turn_angle = dir2angle(our_dir)
		// dir2angle(), ss13 proc is clockwise so dir2angle(EAST) == 90
		// turn(), byond proc is counterclockwise so turn(NORTH, 90) == WEST
		their_dir = turn(their_dir, turn_angle)
	return (DIR2BLOCKDIR(their_dir) in blockable_directions())

/**
  * can_block_direction but for "compound" directions to check all of them and return the number of directions that were blocked.
  *
  * @params
  * * our_dir - our direction.
  * * their_dirs - list of their directions as we cannot use bitfields here.
  */
/obj/item/proc/can_block_directions_multiple(our_dir, list/their_dirs)
	. = 0
	for(var/i in their_dirs)
		. += can_block_direction(our_dir, i)
