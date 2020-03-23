// yell at me later for file naming
// This file contains stuff relating to the new directional blocking and parry system.
/mob/living
	var/obj/item/blocking_item
	var/parrying = FALSE
	var/parry_frame = 0

/datum/block_parry_data

/obj/item
	/// From a point of reference of someone facing NORTH. Put in DOWN to block attacks from our tile.
	var/can_block_directions = list(NORTHWEST, NORTH, NORTHEAST)
	/// Defense flags, see __DEFINES/flags.dm
	var/defense_flags = NONE

/obj/item/Initialize(mapload)

	return ..()

/// This item can be used to parry. Only a basic check.
#define ITEM_DEFENSE_CAN_PARRY		(1<<0)
/// This item can be used in the directional blocking system. Only a basic check.
#define ITEM_DEFENSE_CAN_BLOCK		(1<<1)

/**
  * Gets the list of directions we can block. Include DOWN to block attacks from our same tile.
  */
/obj/item/proc/blockable_directions()
	return list()

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
	if(their_dir == NONE)
		return (DOWN in blockable_directions())
	return (their_dir in blockable_directions())

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
