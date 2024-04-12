/**
 * Holds parallax information.
 */
/datum/parallax
	/// List of parallax objects - these are cloned to a parallax holder using Clone on each.
	var/list/atom/movable/screen/parallax_layer/objects
	/// Parallax layers
	var/layers = 0

/datum/parallax/New(create_objects = TRUE)
	if(create_objects)
		objects = CreateObjects()
		layers = objects.len

/datum/parallax/Destroy()
	QDEL_LIST(objects)
	return ..()

/**
 * Gets a new version of the objects inside - used when applying to a holder.
 */
/datum/parallax/proc/GetObjects()
	. = list()
	for(var/atom/movable/screen/parallax_layer/layer in objects)
		. += layer.Clone()

/datum/parallax/proc/CreateObjects()
	. = objects = list()
