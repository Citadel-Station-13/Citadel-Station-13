/*
	MouseDrop:

	Called on the atom you're dragging.  In a lot of circumstances we want to use the
	receiving object instead, so that's the default action.  This allows you to drag
	almost anything into a trash can.
*/
/atom/MouseDrop(atom/over, src_location, over_location, src_control, over_control, params)
	if(!usr || !over)
		return
	if(SEND_SIGNAL(src, COMSIG_MOUSEDROP_ONTO, over, usr) & COMPONENT_NO_MOUSEDROP)	//Whatever is receiving will verify themselves for adjacency.
		return
	if(over == src)
		return usr.client.Click(src, src_location, src_control, params)
	if(!Adjacent(usr) || !over.Adjacent(usr))
		return // should stop you from dragging through windows

	over.MouseDrop_T(src,usr)
	return

// receive a mousedrop
/atom/proc/MouseDrop_T(atom/dropping, mob/user)
	SEND_SIGNAL(src, COMSIG_MOUSEDROPPED_ONTO, dropping, user)
	return

/client/MouseDown(datum/object, location, control, params)
	if(!control)
		return
	if(QDELETED(object)) //Yep, you can click on qdeleted things before they have time to nullspace. Fun.
		return
	SEND_SIGNAL(src, COMSIG_CLIENT_MOUSEDOWN, object, location, control, params)
	if(mouse_down_icon)
		mouse_pointer_icon = mouse_down_icon
	var/delay = mob.CanMobAutoclick(object, location, params)
	if(delay)
		selected_target[1] = object
		selected_target[2] = params
		while(selected_target[1])
			Click(selected_target[1], location, control, selected_target[2])
			sleep(delay)
	active_mousedown_item = mob.canMobMousedown(object, location, params)
	if(active_mousedown_item)
		active_mousedown_item.onMouseDown(object, location, params, mob)

/client/MouseUp(object, location, control, params)
	if(!control)
		return
	if(SEND_SIGNAL(src, COMSIG_CLIENT_MOUSEUP, object, location, control, params) & COMPONENT_CLIENT_MOUSEUP_INTERCEPT)
		click_intercept_time = world.time
	if(mouse_up_icon)
		mouse_pointer_icon = mouse_up_icon
	selected_target[1] = null
	if(active_mousedown_item)
		active_mousedown_item.onMouseUp(object, location, params, mob)
		active_mousedown_item = null

/mob/proc/CanMobAutoclick(object, location, params)

/mob/living/carbon/CanMobAutoclick(atom/object, location, params)
	if(!object.IsAutoclickable())
		return
	var/obj/item/h = get_active_held_item()
	if(h)
		. = h.CanItemAutoclick(object, location, params)

/mob/proc/canMobMousedown(atom/object, location, params)

/mob/living/carbon/canMobMousedown(atom/object, location, params)
	var/obj/item/H = get_active_held_item()
	if(H)
		. = H.canItemMouseDown(object, location, params)

/obj/item/proc/CanItemAutoclick(object, location, params)

/obj/item/proc/canItemMouseDown(object, location, params)
	if(canMouseDown)
		return src

/obj/item/proc/onMouseDown(object, location, params, mob)
	return

/obj/item/proc/onMouseUp(object, location, params, mob)
	return

/atom/proc/IsAutoclickable()
	. = 1

/atom/movable/screen/IsAutoclickable()
	. = 0

/atom/movable/screen/click_catcher/IsAutoclickable()
	. = 1

//Please don't roast me too hard
/client/MouseMove(object,location,control,params)
	mouseParams = params
	mouseLocation = location
	mouseObject = object
	mouseControlObject = control
	if(mob)
		SEND_SIGNAL(mob, COMSIG_MOB_CLIENT_MOUSEMOVE, object, location, control, params)
		// god forgive me for i have sinned - used for autoparry. currently at 5 objects.
		moused_over_objects[object] = world.time
		if(moused_over_objects.len > 7)
			moused_over_objects.Cut(1, 2)
	..()

/client/MouseDrag(src_object,atom/over_object,src_location,over_location,src_control,over_control,params)
	mouseParams = params
	mouseLocation = over_location
	mouseObject = over_object
	mouseControlObject = over_control
	if(selected_target[1] && over_object && over_object.IsAutoclickable())
		selected_target[1] = over_object
		selected_target[2] = params
	if(active_mousedown_item)
		active_mousedown_item.onMouseDrag(src_object, over_object, src_location, over_location, params, mob)
	SEND_SIGNAL(src, COMSIG_CLIENT_MOUSEDRAG, src_object, over_object, src_location, over_location, src_control, over_control, params)

/obj/item/proc/onMouseDrag(src_object, over_object, src_location, over_location, params, mob)
	return
