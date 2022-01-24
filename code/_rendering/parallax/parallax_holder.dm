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
	/// animation lock - currently animating? timerid of lock if true
	var/animation_lock = FALSE
	/// animation callback queued for after animation lock
	var/datum/callback/animation_queued

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
	if(eye != forced_eye || owner.eye)
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
	for(var/atom/movable/screen/parallax_layer/L in parallax.layers)
		layers += L
		L.map_id = secondary_map
	if(!istype(vis_holder))
		vis_holder = new /atom/movable/screen/parallax_vis
	var/turf/T = get_turf(eye)
	vis_holder.vis_contents = vis = T? SSparallax.get_parallax_vis_contents(T.z) || list()
	#warn movedir

/datum/parallax_holder/proc/Apply()
	if(QDELETED(owner))
		return
	. = list()
	for(var/atom/movable/screen/parallax_layer/L in layers)
		if(L.parallax_intensity > owner.prefs.parallax)
			continue
		if(!L.ShouldSee(owner, last))
			continue
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
	if(owner && turn != scroll_turn)
		// first handle turn. we turn the planemaster
		var/atom/movable/screen/plane_master/parallax/PM = locate() in owner.screen
		animate(PM, transform = turn_transform, time = windup, easing = QUADEASING)
	if(scroll_speed == speed)
		// we're done
		return
	// always scroll towards north; turn handles everything
	var/matrix/scrolling_matrix = matrix(1, 0, 0, 0, 1, 480)


/**
 * Smoothly stops the animation, turning to a certain angle as needed.
 */
/datum/parallax_holder/proc/StopScrolling(turn = 0, time = 30)
	// reset turn
	if(owner && turn != scroll_turn)
		var/atom/movable/screen/plane_master/parallax/PM = locate() in owner.screen
		animate(PM, transform = matrix(), time = time, flags = ANIMATION_END_NOW, easing = QUAD_EASING)
	if(scroll_speed == 0)
		// we're done
		return
	// someone can do the math for "stop after a smooth iteration" later.



/**
 * fully resets animation state
 */
/datum/parallax_holder/proc/HardResetAnimations()
	// reset vars
	scroll_turn = 0
	scroll_speed = 0
	scrolling = FALSE
	loop_start_timeofday = null
	if(animation_lock)
		deltimer(animation_lock)
		animation_lock = null
	if(animation_queued)
		deltimer(animation_queued)
		animation_queued = null
	// reset turn
	if(owner)
		var/atom/movable/screen/plane_master/parallax/PM = locate() in owner.screen
		animate(PM, transform = matrix(), time = 0, flags = ANIMATION_END_NOW)
	// reset objects
	for(var/atom/movable/screen/plane_master/PM in layers)
		animate(PM, transform = matrix(), time = 0, flags = ANIMATION_END_NOW)


/**
 * Marks an animation lock.
 */
/datum/parallax_holder/proc/AnimationLock(time)
	animation_lock = addtimer(CALLBACK(src, .proc/_anim_lock_finished), time, TIMER_CLIENT_TIME)

/datum/parallax_holder/proc/_anim_lock_finished()
	animation_lock = null
	if(animation_queued)
		animation_queued.InvokeAsync()

// This sets which way the current shuttle is moving (returns true if the shuttle has stopped moving so the caller can append their animation)
/datum/hud/proc/set_parallax_movedir(new_parallax_movedir, skip_windups)
	. = FALSE
	var/client/C = mymob.client
	if(new_parallax_movedir == C.parallax_movedir)
		return
	var/animatedir = new_parallax_movedir
	if(new_parallax_movedir == FALSE)
		var/animate_time = 0
		for(var/thing in C.parallax_layers)
			var/atom/movable/screen/parallax_layer/L = thing
			L.icon_state = initial(L.icon_state)
			L.update_o(C.view)
			var/T = PARALLAX_LOOP_TIME / L.speed
			if (T > animate_time)
				animate_time = T
		C.dont_animate_parallax = world.time + min(animate_time, PARALLAX_LOOP_TIME)
		animatedir = C.parallax_movedir

	var/matrix/newtransform
	switch(animatedir)
		if(NORTH)
			newtransform = matrix(1, 0, 0, 0, 1, 480)
		if(SOUTH)
			newtransform = matrix(1, 0, 0, 0, 1,-480)
		if(EAST)
			newtransform = matrix(1, 0, 480, 0, 1, 0)
		if(WEST)
			newtransform = matrix(1, 0,-480, 0, 1, 0)

	var/shortesttimer
	if(!skip_windups)
		for(var/thing in C.parallax_layers)
			var/atom/movable/screen/parallax_layer/L = thing

			var/T = PARALLAX_LOOP_TIME / L.speed
			if (isnull(shortesttimer))
				shortesttimer = T
			if (T < shortesttimer)
				shortesttimer = T
			L.transform = newtransform
			animate(L, transform = matrix(), time = T, easing = QUAD_EASING | (new_parallax_movedir ? EASE_IN : EASE_OUT), flags = ANIMATION_END_NOW)
			if (new_parallax_movedir)
				L.transform = newtransform
				animate(transform = matrix(), time = T) //queue up another animate so lag doesn't create a shutter

	C.parallax_movedir = new_parallax_movedir
	if (C.parallax_animate_timer)
		deltimer(C.parallax_animate_timer)
	var/datum/callback/CB = CALLBACK(src, .proc/update_parallax_motionblur, C, animatedir, new_parallax_movedir, newtransform)
	if(skip_windups)
		CB.InvokeAsync()
	else
		C.parallax_animate_timer = addtimer(CB, min(shortesttimer, PARALLAX_LOOP_TIME), TIMER_CLIENT_TIME|TIMER_STOPPABLE)

/datum/hud/proc/update_parallax_motionblur(client/C, animatedir, new_parallax_movedir, matrix/newtransform)
	if(!C)
		return
	C.parallax_animate_timer = FALSE
	for(var/thing in C.parallax_layers)
		var/atom/movable/screen/parallax_layer/L = thing
		if (!new_parallax_movedir)
			animate(L)
			continue

		var/newstate = initial(L.icon_state)
		var/T = PARALLAX_LOOP_TIME / L.speed

		if (newstate in icon_states(L.icon))
			L.icon_state = newstate
			L.update_o(C.view)

		L.transform = newtransform

		animate(L, transform = matrix(), time = T, loop = -1, flags = ANIMATION_END_NOW)

/client/proc/CreateParallax()
	if(!parallax_holder)
		parallax_holder = new(src)
/atom/movable/screen/parallax_vis
	screen_loc = "CENTER,CENTER"
