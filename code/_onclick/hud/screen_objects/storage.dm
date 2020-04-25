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

/obj/screen/storage/volumetric_box/Initialize(mapload, new_master, our_item)
	src.our_item = our_item
	return ..()

/obj/screen/storage/volumetric_box/Destroy()
	our_item = null
	return ..()

/obj/screen/storage/volumetric_box/Click(location, control, params)
	return our_item.Click(location, control, params)

/obj/screen/storage/volumetric_box/MouseDrop(atom/over, src_location, over_location, src_control, over_control, params)
	return our_item.MouseDrop(over, src_location, over_location, src_control, over_control, params)

/obj/screen/storage/volumetric_box/center
	icon_state = "stored_continue"
	var/obj/screen/storage/stored_left/left
	var/obj/screen/storage/stored_right/right
	var/pixel_size

/obj/screen/storage/volumetric_box/center/Initialize(mapload, new_master, our_item)
	left = new(null, src, our_item)
	right = new(null, src, our_item)
	return ..()

/obj/screen/storage/volumetric_box/center/Destroy()
	QDEL_NULL(left)
	QDEL_NULL(right)
	return ..()

/obj/screen/storage/volumetric_box/center/proc/on_screen_objects()
	return list(src, left, right)

/**
  * Sets the size of this box screen object and regenerates its left/right borders. This includes the actual border's size!
  */
/obj/screen/storage/volumetric_box/center/proc/set_pixel_size(pixels)
	if(pixel_size == pixels)
		return
	pixel_size = pixels
	cut_overlays()
	//our icon size is 32 pixels.
	transform = matrix((pixels - (VOLUMETRIC_STORAGE_BOX_BORDER_SIZE * 2)) / VOLUMETRIC_STORAGE_BOX_ICON_SIZE, 0, 0, 0, 1, 0)
	left.pixel_x = -((pixels - VOLUMETRIC_STORAGE_BOX_ICON_SIZE) * 0.5) - VOLUMETRIC_STORAGE_BOX_BORDER_SIZE
	right.pixel_x = ((pixels - VOLUMETRIC_STORAGE_BOX_ICON_SIZE) * 0.5) + VOLUMETRIC_STORAGE_BOX_BORDER_SIZE
	add_overlay(left)
	add_overlay(right)

/obj/screen/storage/stored_left
	icon_state = "stored_start"
	appearance_flags = APPEARANCE_UI | KEEP_APART | RESET_TRANSFORM // Yes I know RESET_TRANSFORM is in APPEARANCE_UI but we're hard-asserting this incase someone changes it.

/obj/screen/storage/stored_right
	icon_state = "stored_end"
	appearance_flags = APPEARANCE_UI | KEEP_APART | RESET_TRANSFORM
