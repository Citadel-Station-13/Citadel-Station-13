/////// SS13 directions work like this: 0 NORTH, 90 EAST, 180 SOUTH, 270 WEST. Don't ask me why, it just does.

// PX/PY = pixel xy/
// V = visual aka taking into account pixel shifting
// D = difference

// See __HELPERS/angles_distances.dm for more.

/// THESE REQUIRE ATOM TYPECAST!

#define ABSOLUTE_PX_ATOM(A)			(A.x * world.icon_size)
#define ABSOLUTE_PY_ATOM(A)			(A.y * world.icon_size)

#define ABSOLUTE_VPX_ATOM(A)		(A.x * world.icon_size + A.pixel_x)
#define ABSOLUTE_VPY_ATOM(A)		(A.y * world.icon_size + A.pixel_y)

/// REQUIRES ATOM/MOVABLE TYPECAST!

#define ABSOLUTE_PX_MOVABLE(A)			(A.x * world.icon_size + A.step_x)
#define ABSOLUTE_PY_MOVABLE(A)			(A.y * world.icon_size + A.step_y)

#define ABSOLUTE_VPX_MOVABLE(A)		(A.x * world.icon_size + A.pixel_x + A.step_x)
#define ABSOLUTE_VPY_MOVABLE(A)		(A.y * world.icon_size + A.pixel_y + A.step_y)

/// The below only use tile x/y.
#define MANHATTAN_METRIC(dx, dy)				(abs(dx) + abs(dy))
#define EUCLIDEAN_METRIC(dx, dy)				sqrt((dx) ** 2 + (dy) ** 2)

#define MANHATTAN_DISTANCE(a, b)				MANHATTAN_METRIC(b.x - a.x, b.y - b.y)
#define EUCLIDEAN_DISTANCE(a, b)				EUCLIDEAN_METRIC(b.x - a.x, b.y - a.y)

#define BYOND_METRIC(dx, dy)					max(dx, dy)
//#define BYOND_DISTANCE(a, b)					BYOND_METRIC(b.x - a.x, b.y - a.y)			NO USE get_dist() NOT THIS

/// Either both have to be atoms OR atom/movables or both have to be numbers. If they're numbers, source is x, target is y.
/proc/get_angle(atom/movable/source, atom/movable/target)
	if(!isnum(source))		//assume both are either numbers or not numbers if it ain't then get memed.
		var/dx = (ismovableatom(target)? ABSOLUTE_PX_MOVABLE(target) : ABSOLUTE_PX_ATOM(target)) - (ismovableatom(source)? ABSOLUTE_PX_MOVABLE(source) : ABSOLUTE_PX_ATOM(target))
		var/dy = (ismovableatom(target)? ABSOLUTE_PY_MOVABLE(target) : ABSOLUTE_PY_ATOM(target)) - (ismovableatom(source)? ABSOLUTE_PY_MOVABLE(source) : ABSOLUTE_PY_ATOM(target))
		if(!dy)
			return (dx >= 0)? 90 : 270
		. = arctan(dx/dy)
		if(dy < 0)
			. += 180
		else if(dx < 0)
			. += 360
	else
		if(!target)
			return (source >= 0)? 90 : 270
		. = arctan(source/target)
		if(target < 0)
			. += 180
		else if(source < 0)
			. += 360

/// Either both have to be atoms OR atom/movables. If they're numbers, source is x, target is y.
/proc/get_visual_angle(atom/movable/source, atom/movable/target)
	var/dx = (ismovableatom(target)? ABSOLUTE_VPX_MOVABLE(target) : ABSOLUTE_VPX_ATOM(target)) - (ismovableatom(source)? ABSOLUTE_VPX_MOVABLE(source) : ABSOLUTE_VPX_ATOM(target))
	var/dy = (ismovableatom(target)? ABSOLUTE_VPY_MOVABLE(target) : ABSOLUTE_VPY_ATOM(target)) - (ismovableatom(source)? ABSOLUTE_VPY_MOVABLE(source) : ABSOLUTE_VPY_ATOM(target))
	if(!dy)
		return (dx >= 0)? 90 : 270
	. = arctan(dx/dy)
	if(dy < 0)
		. += 180
	else if(dx < 0)
		. += 360

/// Distance procs ///

/proc/get_pixel_dist_euclidean(atom/movable/source, atom/movable/target)
	var/dx = (ismovableatom(target)? ABSOLUTE_PX_MOVABLE(target) : ABSOLUTE_PX_ATOM(target)) - (ismovableatom(source)? ABSOLUTE_PX_MOVABLE(source) : ABSOLUTE_PX_ATOM(target))
	var/dy = (ismovableatom(target)? ABSOLUTE_PY_MOVABLE(target) : ABSOLUTE_PY_ATOM(target)) - (ismovableatom(source)? ABSOLUTE_PY_MOVABLE(source) : ABSOLUTE_PY_ATOM(target))
	return EUCLIDEAN_METRIC(dx, dy)

/proc/get_visual_pixel_dist_euclidean(atom/movable/source, atom/movable/target)
	var/dx = (ismovableatom(target)? ABSOLUTE_VPX_MOVABLE(target) : ABSOLUTE_VPX_ATOM(target)) - (ismovableatom(source)? ABSOLUTE_VPX_MOVABLE(source) : ABSOLUTE_VPX_ATOM(target))
	var/dy = (ismovableatom(target)? ABSOLUTE_VPY_MOVABLE(target) : ABSOLUTE_VPY_ATOM(target)) - (ismovableatom(source)? ABSOLUTE_VPY_MOVABLE(source) : ABSOLUTE_VPY_ATOM(target))
	return EUCLIDEAN_METRIC(dx, dy)

/proc/get_pixel_dist_manhattan(atom/movable/source, atom/movable/target)
	var/dx = (ismovableatom(target)? ABSOLUTE_PX_MOVABLE(target) : ABSOLUTE_PX_ATOM(target)) - (ismovableatom(source)? ABSOLUTE_PX_MOVABLE(source) : ABSOLUTE_PX_ATOM(target))
	var/dy = (ismovableatom(target)? ABSOLUTE_PY_MOVABLE(target) : ABSOLUTE_PY_ATOM(target)) - (ismovableatom(source)? ABSOLUTE_PY_MOVABLE(source) : ABSOLUTE_PY_ATOM(target))
	return MANHATTAN_METRIC(dx, dy)

/proc/get_visual_pixel_dist_manhattan(atom/movable/source, atom/movable/target)
	var/dx = (ismovableatom(target)? ABSOLUTE_VPX_MOVABLE(target) : ABSOLUTE_VPX_ATOM(target)) - (ismovableatom(source)? ABSOLUTE_VPX_MOVABLE(source) : ABSOLUTE_VPX_ATOM(target))
	var/dy = (ismovableatom(target)? ABSOLUTE_VPY_MOVABLE(target) : ABSOLUTE_VPY_ATOM(target)) - (ismovableatom(source)? ABSOLUTE_VPY_MOVABLE(source) : ABSOLUTE_VPY_ATOM(target))
	return MANHATTAN_METRIC(dx, dy)

/proc/get_pixel_dist(atom/movable/source, atom/movable/target)
	var/dx = (ismovableatom(target)? ABSOLUTE_PX_MOVABLE(target) : ABSOLUTE_PX_ATOM(target)) - (ismovableatom(source)? ABSOLUTE_PX_MOVABLE(source) : ABSOLUTE_PX_ATOM(target))
	var/dy = (ismovableatom(target)? ABSOLUTE_PY_MOVABLE(target) : ABSOLUTE_PY_ATOM(target)) - (ismovableatom(source)? ABSOLUTE_PY_MOVABLE(source) : ABSOLUTE_PY_ATOM(target))
	return BYOND_METRIC(dx, dy)

/proc/get_visual_pixel_dist(atom/movable/source, atom/movable/target)
	var/dx = (ismovableatom(target)? ABSOLUTE_VPX_MOVABLE(target) : ABSOLUTE_VPX_ATOM(target)) - (ismovableatom(source)? ABSOLUTE_VPX_MOVABLE(source) : ABSOLUTE_VPX_ATOM(target))
	var/dy = (ismovableatom(target)? ABSOLUTE_VPY_MOVABLE(target) : ABSOLUTE_VPY_ATOM(target)) - (ismovableatom(source)? ABSOLUTE_VPY_MOVABLE(source) : ABSOLUTE_VPY_ATOM(target))
	return BYOND_METRIC(dx, dy)

/// Use this instead of get_dir when things can be on the same turf
#define get_pixeldir(thingA, thingB) (get_dir(thingA, thingB) || angle2dir(get_deg(thingA, thingB)))
