/obj/screen/storage
	name = "storage"
	var/insertion_click = FALSE

/obj/screen/storage/Initialize(mapload, new_master)
	. = ..()
	master = new_master

/obj/screen/storage/Click(location, control, params)
	if(!insertion_click)
		return ..()
	if(world.time <= usr.next_move)
		return TRUE
	if(usr.incapacitated())
		return TRUE
	if (ismecha(usr.loc)) // stops inventory actions in a mech
		return TRUE
	if(master)
		var/obj/item/I = usr.get_active_held_item()
		if(I)
			master.attackby(null, I, usr, params)
	return TRUE

/obj/screen/storage/boxes
	name = "storage"
	icon_state = "block"
	screen_loc = "7,7 to 10,8"
	layer = HUD_LAYER
	plane = HUD_PLANE
	insertion_click = TRUE

/obj/screen/storage/close
	name = "close"
	layer = ABOVE_HUD_LAYER
	plane = ABOVE_HUD_PLANE
	icon_state = "backpack_close"

/obj/screen/storage/close/Click()
	var/datum/component/storage/S = master
	S.close(usr)
	return TRUE

/obj/screen/storage/left
	icon_state = "storage_start"
	insertion_click = TRUE

/obj/screen/storage/right
	icon_state = "storage_end"
	insertion_click = TRUE

/obj/screen/storage/continuous
	icon_state = "storage_continue"
	insertion_click = TRUE

/obj/screen/storage/volumetric_box
	icon_state = "stored_continue"
	var/obj/item/our_item
	var/obj/screen/storage/stored_left/left
	var/obj/screen/storage/stored_right/right

/obj/screen/storage/volumetric_box/Destroy()
	QDEL_NULL(left)
	QDEL_NULL(right)
	our_item = null
	return ..()

/obj/screen/storage/volumetric_box/Initialize(mapload, new_master, our_item)
	src.our_item = our_item
	left = new(null, src, our_item)
	right = new(null, src, our_item)
	return ..()

/obj/screen/storage/volumetric_box/Click(location, control, params)
	return our_item.Click(location, control, params)

/obj/screen/storage/volumetric_box/proc/on_screen_objects()
	return list(src, left, right)

#define BOX_ICON_PIXELS 32
/obj/screen/storage/volumetric_box/proc/set_pixel_size(pixels)
	cut_overlays()
	//our icon size is 32 pixels.
	transform = matrix(pixels / BOX_ICON_PIXELS, 0, 0, 0, 1, 0)
	left.pixel_x = -((BOX_ICON_PIXELS - pixels) * 0.5) - 4
	right.pixel_x = ((BOX_ICON_PIXELS - pixels) * 0.5) + 4
	add_overlay(left)
	add_overlay(right)
#undef BOX_ICON_PIXELS

/obj/screen/storage/stored_left
	icon_state = "stored_start"

/obj/screen/storage/stored_right
	icon_state = "stored_end"
