/**
 * # Parallax holders
 *
 * Holds all the information about a client's parallax
 *
 * Not on mob because parallax is area based, not mob based.
 *
 * How parallax works:
 * - Layers - normal layers, scroll with movement to relative position, can scroll
 * - Absolute - absolute layers, scroll with movement to absolute position, cannot scroll
 * - Vis - vis_contents-like model - things in this are directly applied and get no processing whatsoever. Things like overmap ships can use this.
 */
/datum/parallax_holder
	/// Client that owns us
	var/client/owner
	/// The parallax object we're currently rendering
	var/datum/parallax/parallax
	/// Eye we were last anchored to - used to detect eye changes
	var/atom/eye
	/// force this eye as the "real" eye - useful for secondary maps
	var/atom/forced_eye
	/// last turf loc
	var/turf/last
	/// last area - for parallax scrolling/loop animations
	var/area/last_area
	/// Holder object for vis
	var/atom/movable/screen/parallax_vis/vis_holder
	/// are we not on the main map? if so, put map id here
	var/secondary_map
	/// all layers
	var/list/atom/movable/screen/parallax_layer/layers
	/// vis contents
	var/list/atom/movable/vis
	/// currently scrolling?
	var/scrolling = FALSE
	/// current scroll speed in DS per scroll
	var/scroll_speed
	/// current scroll turn - applied after angle. if angle is 0 (picture moving north) and turn is 90, it would be like if you turned your viewport 90 deg clockwise.
	var/scroll_turn

/datum/parallax_holder/New(client/C, secondary_map, forced_eye)
	owner = C
	if(!owner)
		CRASH("No client")
	src.secondary_map = secondary_map
	src.forced_eye = forced_eye
	Reset()

/datum/parallax_holder/Destroy()
	if(owner)
		if(owner.parallax_holder == src)
			owner.parallax_holder = null
		Remove()
	HardResetAnimations()
	QDEL_NULL(vis_holder)
	QDEL_NULL(parallax)
	layers = null
	vis = null
	last = null
	eye = null
	owner = null
	return ..()

/datum/parallax_holder/proc/Reset()
	if(!owner.eye)
		// if no eye, tear down
		last = eye = last_area = null
		SetParallax(null)
		return
	// first, check loc
	var/turf/T = get_turf(owner.eye)
	if(!T)
		// if in nullspace, tear down
		last = eye = last_area = null
		SetParallax(null)
		return
	// set last loc and eye
	last = T
	eye = forced_eye || owner.eye
	last_area = T.loc
	// then, check if we need to switch/set parallax
	var/expected_type = SSparallax.get_parallax_type(T.z)
	if(QDELETED(parallax) || (parallax.type != expected_type))
		SetParallaxType(expected_type)
	else
		// sync
		Remove()
		Sync()
		Apply()
	// hard reset positions to correct positions
	for(var/atom/movable/screen/parallax_layer/L in layers)
		L.ResetPosition(T.x, T.y)

// better updates via client_mobs_in_contents can be created again when important recursive contents is ported!
/datum/parallax_holder/proc/Update(full)
	if(!full && !eye || (get_turf(eye) == last))
		return
	if(!owner)	// why are we here
		if(!QDELETED(src))
			qdel(src)
		return
	if(eye != forced_eye || !owner.eye)
		// eye mismatch, reset
		Reset()
		return
	var/turf/T = get_turf(eye)
	if(!last || T.z != last.z)
		// z mismatch, reset
		Reset()
		return
	// get rel offsets
	var/rel_x = T.x - last.x
	var/rel_y = T.y - last.y
	// set last
	last = T
	// move
	for(var/atom/movable/screen/parallax_layer/L in layers)
		L.RelativePosition(T.x, T.y, rel_x, rel_y)
	// process scrolling/movedir
	if(last_area != T.loc)
		last_area = T.loc
		Sync()

/**
 * Syncs us to our parallax objects. Does NOT check if we should have those objects, that's Reset()'s job.
 *
 * Doesn't move/update positions/screen locs either.
 *
 * Also ensures movedirs are correct for the eye's pos.
 */
/datum/parallax_holder/proc/Sync()
	layers = list()
	for(var/atom/movable/screen/parallax_layer/L in parallax.objects)
		layers += L
		L.map_id = secondary_map
	if(!istype(vis_holder))
		vis_holder = new /atom/movable/screen/parallax_vis
	var/turf/T = get_turf(eye)
	vis_holder.vis_contents = vis = T? SSparallax.get_parallax_vis_contents(T.z) : list()
	if(!T)
		if(scrolling)
			HardResetAnimations()
	else
		if(!last_area)
			last_area = T.loc
		if(scrolling != last_area.parallax_moving || scroll_speed != last_area.parallax_move_speed || scroll_turn != last_area.parallax_move_angle)
			Animation(last_area.parallax_moving? last_area.parallax_move_speed : 0, last_area.parallax_move_angle, last_area.parallax_move_speed)

/datum/parallax_holder/proc/Apply()
	if(QDELETED(owner))
		return
	. = list()
	for(var/atom/movable/screen/parallax_layer/L in layers)
		if(L.parallax_intensity > owner.prefs.parallax)
			continue
		if(!L.ShouldSee(owner, last))
			continue
		L.SetView(owner.view, TRUE)
		. |= L
	owner.screen |= .
	if(!secondary_map)		// we're the primary
		var/atom/movable/screen/plane_master/parallax_white/PM = locate() in owner.screen
		if(!PM)
			stack_trace("Couldn't find space plane master")
		else
			PM.color =  list(
				0, 0, 0, 0,
				0, 0, 0, 0,
				0, 0, 0, 0,
				1, 1, 1, 1,
				0, 0, 0, 0
			)

/datum/parallax_holder/proc/Remove()
	if(QDELETED(owner))
		return
	owner.screen -= layers
	if(!secondary_map)		// we're the primary
		var/atom/movable/screen/plane_master/parallax_white/PM = locate() in owner.screen
		if(!PM)
			stack_trace("Couldn't find space plane master")
		else
			PM.color =  initial(PM.color)

/datum/parallax_holder/proc/SetParallaxType(path)
	if(!ispath(path, /datum/parallax))
		CRASH("Invalid path")
	SetParallax(new path)

/datum/parallax_holder/proc/SetParallax(datum/parallax/P, delete_old = TRUE)
	if(P == parallax)
		return
	Remove()
	if(delete_old && istype(parallax) && !QDELETED(parallax))
		qdel(parallax)
	parallax = P
	HardResetAnimations()
	if(!parallax)
		return
	Sync()
	Apply()

/**
 * Runs a modifier to parallax as an animation.
 *
 * @params
 * speed - ds per loop
 * turn - angle clockwise from north to turn the motion to
 * windup - ds to spend on windups. 0 for immediate.
 */
/datum/parallax_holder/proc/Animation(speed = 25, turn = 0, windup = 0)
	if(speed == 0)
		StopScrolling(turn = turn, time = windup)
		return
	if(owner && turn != scroll_turn)
		// first handle turn. we turn the planemaster
		var/atom/movable/screen/plane_master/parallax/PM = locate() in owner.screen
		var/matrix/turn_transform = matrix()
		turn_transform.Turn(turn)
		animate(PM, transform = turn_transform, time = windup, easing = QUAD_EASING | EASE_IN)
	if(scroll_speed == speed)
		// we're done
		return
	// always scroll from north; turn handles everything
	for(var/atom/movable/screen/parallax_layer/P in layers)
		if(P.absolute)
			continue
		// end all previous animations, do the first segment by shifting down one screen
		P.transform = matrix()
		animate(P, transform = matrix(1, 0, 0, 0, 1, -480), time = speed / P.speed, easing = QUAD_EASING|EASE_IN, flags = ANIMATION_END_NOW)
		// queue up another incase lag makes QueueLoop not fire on time, this time by shifting up
		P.transform = matrix(1, 0, 0, 0, 1, 480)
		animate(transform = matrix(), time = speed / P.speed)
		P.QueueLoop(speed / P.speed, speed / P.speed)

/**
 * Smoothly stops the animation, turning to a certain angle as needed.
 */
/datum/parallax_holder/proc/StopScrolling(turn = 0, time = 30)
	// reset turn
	if(owner && turn != scroll_turn)
		var/atom/movable/screen/plane_master/parallax/PM = locate() in owner.screen
		var/matrix/turn_transform = matrix()
		turn_transform.Turn(turn)
		animate(PM, transform = turn_transform, time = time, flags = ANIMATION_END_NOW, easing = QUAD_EASING | EASE_OUT)
	if(scroll_speed == 0)
		// we're done
		scrolling = FALSE
		return
	// someone can do the math for "stop after a smooth iteration" later.
	for(var/atom/movable/screen/parallax_layer/P in layers)
		if(P.absolute)
			continue
		P.CancelAnimation()
		animate(P, transform = matrix(1, 0, 0, 0, 1, 480), time = 0, flags = ANIMATION_END_NOW)
		animate(transform = matrix(), time = time, easing = QUAD_EASING | EASE_OUT)

/**
 * fully resets animation state
 */
/datum/parallax_holder/proc/HardResetAnimations()
	// reset vars
	scroll_turn = 0
	scroll_speed = 0
	scrolling = FALSE
	// reset turn
	if(owner)
		var/atom/movable/screen/plane_master/parallax/PM = locate() in owner.screen
		animate(PM, transform = matrix(), time = 0, flags = ANIMATION_END_NOW)
	// reset objects
	for(var/atom/movable/screen/parallax_layer/P in layers)
		if(P.absolute)
			continue
		P.CancelAnimation()
		animate(P, transform = matrix(), time = 0, flags = ANIMATION_END_NOW)

/client/proc/CreateParallax()
	if(!parallax_holder)
		parallax_holder = new(src)
/atom/movable/screen/parallax_vis
	screen_loc = "CENTER,CENTER"
