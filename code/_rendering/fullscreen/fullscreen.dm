/**
 * Adds a fullscreen overlay
 *
 * @params
 * - category - string - must exist. will overwrite any other screen in this category. defaults to type.
 * - type - the typepath of the screen
 * - severity - severity - different screen objects have differing severities
 */
/mob/proc/overlay_fullscreen(category, type, severity)
	ASSERT(type)
	if(!category)
		category = type
	var/atom/movable/screen/fullscreen/screen = fullscreens[category]
	if (!screen || screen.type != type)
		// needs to be recreated
		clear_fullscreen(category, 0)
		fullscreens[category] = screen = new type
	screen.SetSeverity(severity)
	if(client && screen.ShouldShow(src))
		screen.SetView(client.view)
		client.screen += screen
	return screen

/**
 * Wipes a fullscreen of a certain category
 *
 * Second argument is for animation delay.
 */
/mob/proc/clear_fullscreen(category, animated = 10)
	if(!fullscreens)
		return
	var/atom/movable/screen/fullscreen/screen = fullscreens[category]
	fullscreens -= category
	if(!screen)
		return
	if(animated > 0)
		animate(screen, alpha = 0, time = animated)
		addtimer(CALLBACK(src, PROC_REF(_remove_fullscreen_direct), screen), animated, TIMER_CLIENT_TIME)
	else
		if(client)
			client.screen -= screen
		qdel(screen)

/mob/proc/_remove_fullscreen_direct(atom/movable/screen/fullscreen/screen)
	if(client)
		client.screen -= screen
	qdel(screen)

/**
 * Wipes all fullscreens
 */
/mob/proc/wipe_fullscreens()
	for(var/category in fullscreens)
		clear_fullscreen(category)

/**
 * Removes fullscreens from client but not the mob
 */
/mob/proc/hide_fullscreens()
	if(client)
		for(var/category in fullscreens)
			client.screen -= fullscreens[category]

/**
 * Ensures all fullscreens are on client.
 */
/mob/proc/reload_fullscreen()
	if(client)
		var/atom/movable/screen/fullscreen/screen
		for(var/category in fullscreens)
			screen = fullscreens[category]
			if(screen.ShouldShow(src))
				screen.SetView(client.view)
				client.screen |= screen
			else
				client.screen -= screen

/atom/movable/screen/fullscreen
	icon = 'icons/screen/fullscreen_15x15.dmi'
	icon_state = "default"
	screen_loc = "CENTER-7,CENTER-7"
	layer = FULLSCREEN_LAYER
	plane = FULLSCREEN_PLANE
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	/// current view we're adapted to
	var/view_current
	/// min severity
	var/severity_min = 0
	/// max severity
	var/severity_max = INFINITY
	/// current severity
	var/severity = 0
	/// show this while dead
	var/show_when_dead = FALSE

/atom/movable/screen/fullscreen/proc/SetSeverity(severity)
	src.severity = clamp(severity, severity_min, severity_max)
	icon_state = "[initial(icon_state)][severity]"

/atom/movable/screen/fullscreen/proc/SetView(client_view)
	view_current = client_view

/atom/movable/screen/fullscreen/proc/ShouldShow(mob/M)
	if(!show_when_dead && M.stat == DEAD)
		return FALSE
	return TRUE

/atom/movable/screen/fullscreen/Destroy()
	SetSeverity(0)
	return ..()

/atom/movable/screen/fullscreen/scaled
	icon = 'icons/screen/fullscreen_15x15.dmi'
	screen_loc = "CENTER-7,CENTER-7"
	/// size of sprite in tiles
	var/size_x = 15
	/// size of sprite in tiles
	var/size_y = 15

/atom/movable/screen/fullscreen/scaled/SetView(client_view)
	if(view_current != client_view)
		var/list/actualview = getviewsize(client_view)
		view_current = client_view
		transform = matrix(actualview[1] / size_x, 0, 0, 0, actualview[2] / size_y, 0)
	return ..()

/atom/movable/screen/fullscreen/scaled/brute
	icon_state = "brutedamageoverlay"
	layer = UI_DAMAGE_LAYER
	plane = FULLSCREEN_PLANE

/atom/movable/screen/fullscreen/scaled/oxy
	icon_state = "oxydamageoverlay"
	layer = UI_DAMAGE_LAYER
	plane = FULLSCREEN_PLANE

/atom/movable/screen/fullscreen/scaled/crit
	icon_state = "passage"
	layer = CRIT_LAYER
	plane = FULLSCREEN_PLANE

/atom/movable/screen/fullscreen/scaled/crit/vision
	icon_state = "oxydamageoverlay"
	layer = BLIND_LAYER

/atom/movable/screen/fullscreen/scaled/blind
	icon_state = "blackimageoverlay"
	layer = BLIND_LAYER
	plane = FULLSCREEN_PLANE

/atom/movable/screen/fullscreen/scaled/curse
	icon_state = "curse"
	layer = CURSE_LAYER
	plane = FULLSCREEN_PLANE

/atom/movable/screen/fullscreen/scaled/impaired
	icon_state = "impairedoverlay"

/atom/movable/screen/fullscreen/scaled/emergency_meeting
	icon_state = "emergency_meeting"
	show_when_dead = TRUE
	layer = CURSE_LAYER
	plane = SPLASHSCREEN_PLANE

/atom/movable/screen/fullscreen/tiled/blurry
	icon = 'icons/mob/screen_gen.dmi'
	screen_loc = "WEST,SOUTH to EAST,NORTH"
	icon_state = "cloudy"

/atom/movable/screen/fullscreen/tiled/flash
	icon = 'icons/mob/screen_gen.dmi'
	screen_loc = "WEST,SOUTH to EAST,NORTH"
	icon_state = "flash"

/atom/movable/screen/fullscreen/tiled/flash/static
	icon = 'icons/mob/screen_gen.dmi'
	screen_loc = "WEST,SOUTH to EAST,NORTH"
	icon_state = "noise"

/atom/movable/screen/fullscreen/tiled/high
	icon = 'icons/mob/screen_gen.dmi'
	screen_loc = "WEST,SOUTH to EAST,NORTH"
	icon_state = "druggy"

/atom/movable/screen/fullscreen/tiled/color_vision
	icon = 'icons/mob/screen_gen.dmi'
	screen_loc = "WEST,SOUTH to EAST,NORTH"
	icon_state = "flash"
	alpha = 80

/atom/movable/screen/fullscreen/tiled/color_vision/green
	color = "#00ff00"

/atom/movable/screen/fullscreen/tiled/color_vision/red
	color = "#ff0000"

/atom/movable/screen/fullscreen/tiled/color_vision/blue
	color = "#0000ff"

/atom/movable/screen/fullscreen/tiled/cinematic_backdrop
	icon = 'icons/mob/screen_gen.dmi'
	screen_loc = "WEST,SOUTH to EAST,NORTH"
	icon_state = "flash"
	plane = SPLASHSCREEN_PLANE
	layer = SPLASHSCREEN_LAYER - 1
	color = "#000000"
	show_when_dead = TRUE

/atom/movable/screen/fullscreen/special/lighting_backdrop
	icon = 'icons/mob/screen_gen.dmi'
	icon_state = "flash"
	transform = matrix(200, 0, 0, 0, 200, 0)
	plane = LIGHTING_PLANE
	blend_mode = BLEND_OVERLAY
	show_when_dead = TRUE

//Provides darkness to the back of the lighting plane
/atom/movable/screen/fullscreen/special/lighting_backdrop/lit
	invisibility = INVISIBILITY_LIGHTING
	layer = BACKGROUND_LAYER+21
	color = "#000"
	show_when_dead = TRUE

//Provides whiteness in case you don't see lights so everything is still visible
/atom/movable/screen/fullscreen/special/lighting_backdrop/unlit
	layer = BACKGROUND_LAYER+20
	show_when_dead = TRUE

/atom/movable/screen/fullscreen/special/see_through_darkness
	icon_state = "nightvision"
	plane = LIGHTING_PLANE
	layer = LIGHTING_LAYER
	blend_mode = BLEND_ADD
	show_when_dead = TRUE
