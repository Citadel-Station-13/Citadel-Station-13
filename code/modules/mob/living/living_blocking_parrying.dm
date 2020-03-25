// yell at me later for file naming
// This file contains stuff relating to the new directional blocking and parry system.
/mob/living
	var/obj/item/blocking_item
	var/parrying = FALSE
	var/parry_frame = 0

/datum/block_parry_data


/obj/item
	/// See defines.
	var/can_block_directions = BLOCK_DIR_NORTH | BLOCK_DIR_NORTHEAST | BLOCK_DIR_NORTHWEST
	/// Defense flags, see __DEFINES/flags.dm
	var/defense_flags = NONE

/obj/item/Initialize(mapload)

	return ..()

/// This item can be used to parry. Only a basic check used to determine if we should proceed with parry chain at all.
#define ITEM_DEFENSE_CAN_PARRY		(1<<0)
/// This item can be used in the directional blocking system. Only a basic check used to determine if we should proceed with directional block handling at all.
#define ITEM_DEFENSE_CAN_BLOCK		(1<<1)



/**
  * Gets the list of directions we can block. Include DOWN to block attacks from our same tile.
  */
/obj/item/proc/blockable_directions()
	return can_block_directions

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
