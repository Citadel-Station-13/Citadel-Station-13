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

/obj/screen/storage/right
	icon_state = "storage_end"

/obj/screen/storage/continuous
	icon_state = "storage_continue"

/obj/screen/storage/volumetric_box
	icon_state = "stored_8px"
	var/obj/item/our_item

/obj/screen/storage/volumetric_box/Initialize(mapload, new_master, our_item)
	src.our_item = our_item
	return ..()

/obj/screen/storage/volumetric_box/Click(location, control, params)
	return our_item.Click(location, control, params)
