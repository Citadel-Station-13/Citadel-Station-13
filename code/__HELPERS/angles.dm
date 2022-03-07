/**
 * Gets the real, movement angle between two movable atoms
 *
 * Angle is degrees clockwise from north.
 */
/proc/get_physics_angle(atom/source, atom/target)
	var/sx = source.x * world.icon_size
	var/sy = source.y * world.icon_size
	var/tx = target.x * world.icon_size
	var/ty = target.y * world.icon_size
	var/atom/movable/AM
	if(ismovable(source))
		AM = source
		sx += AM.step_x
		sy += AM.step_y
	if(ismovable(target))
		AM = target
		tx += AM.step_x
		ty += AM.step_y
	. = arctan(ty - sy, tx - sx)
	. = SIMPLIFY_DEGREES(.)

/**
 * Gets the angle clockwise from north between two sets of points
 */
/proc/get_angle_direct(x1, y1, x2, y2)
	. = arctan(y2 - y1, x2 - x1)
	. = SIMPLIFY_DEGREES(.)

/**
 * Gets the visual angle between two movable atoms
 *
 * Angle is degrees clockwise from north.
 */
/proc/get_visual_angle(atom/movable/start,atom/movable/end)
	if(!start || !end)
		return 0
	var/dy = (32 * end.y + end.pixel_y + end.step_y) - (32 * start.y + start.pixel_y + start.step_y)
	var/dx = (32 * end.x + end.pixel_x + end.step_x) - (32 * start.x + start.pixel_x + start.step_x)
	if(!dy)
		return (dx>=0)?90:270
	.=arctan(dx/dy)
	if(dy<0)
		.+=180
	else if(dx<0)
		.+=360
