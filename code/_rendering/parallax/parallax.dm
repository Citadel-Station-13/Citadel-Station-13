/**
 * Holds parallax information.
 */
/datum/parallax
	/// List of parallax objects - these are rendered to the client.
	var/list/atom/movable/screen/parallax_layer/objects
	/// Parallax layers
	var/layers = 0
	/// Parallax is scroll/animate compatible
	var/scroll_compatible = FALSE
	/// Parallax pixelshifts on move
	var/shift_on_move = FALSE

/datum/parallax/New(create_objects = TRUE)
	if(create_objects)
		objects = CreateObjects()
		layers = objects.len

/**
 * Shift position to new position, use on normal moves.
 */
/datum/parallax/proc/ShiftTo(x, y, dx, dy)

/**
 * Reset position to absolute, use when resetting parallax entirely or changing eyeobjs.
 */
/datum/parallax/proc/Reset(x, y)

/**
 * Set parallax scroll for things like shuttle transits
 */
/datum/parallax/proc/

/datum/parallax/proc/GetObjects()
	return objects.Copy()

/**
 * Used for overrides/copying
 */
/datum/parallax/proc/Clone()
	var/datum/parallax/P = new type()
	P.objects = list()
	for(var/atom/movable/screen/parallax_layer/layer in objects)
		P.objects += layer.Clone()
	P.layers = P.objects.len
	P.scroll_compatible = scroll_compatible
	P.shift_on_move = shift_on_move
