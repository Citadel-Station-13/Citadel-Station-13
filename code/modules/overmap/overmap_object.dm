/**
  * Overmap objects
  */
/datum/overmap_object
	/// Position in x
	var/pos_x
	/// Position in y
	var/pos_y
	/// Its heading, in byond dir2angle angles.
	var/heading = 0

	/// Overmap quadtree node we're in, if any.
	var/datum/overmap_quadtree/containing_node
	/// Overmap we're in if any.
	var/datum/overmap/containing_overmap

	// Movement
	/// Is this a static object? If so, it is sent in static data when displaying things like uis. STATIC OBJECTS SHOULD NEVER MOVE WITHOUT CLOSING ALL INTERFACES.
	var/position_considered_static = FALSE
	/// Speed per decisecond, x
	var/speed_x
	/// Speed per decisecond, y
	var/speed_y

	// UI
	/// The icon state that is fed to tgui-next for drawing.
	var/ui_icon_state = ""
	/// Unique ID on an UI. Must be unique to the overmap.
	var/ui_id

/datum/overmap_object/proc/euclidean_distance(datum/overmap_object/other)
	return sqrt(((other.pos_x - pos_x) ** 2) + ((other.pos_y - pos_y) ** 2))

/datum/overmap_object/proc/objects_to_consider_collision_with()
	CRASH("Pending implementation")

/datum/overmap_object/process(wait)
	var/requires_processing = FALSE
	if(speed_x || speed_y)			//process movement
		requires_processing = TRUE
		relative_move(speed_x, speed_y)
	if(!requires_processing)
		return PROCESS_KILL

/**
  * Unique ID to identify it on an UI
  */
/datum/overmap_object/proc/UUID()
	return ui_id

/**
  * Return a data list for our UI data
  */
/datum/overmap_object/proc/encode_ui()
	return list(
	"pos_x" = pos_x,
	"pos_y" = pos_y,
	"heading" = heading,
	"icon_state" = ui_icon_state,
	"speed_x" = speed_x,
	"speed_y" = speed_y
	)

/datum/overmap_object/proc/relative_move(px, py)
