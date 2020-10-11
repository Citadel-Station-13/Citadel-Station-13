/**
  * Gets our HUD object
  */
/datum/inventory_slot/proc/get_hud_object()
	. = no_hud_object? null : (hud_object || generate_hud_object(holder, FALSE))

/**
  * Regenerates our HUD object
  */
/datum/inventory_slot/proc/regenerate_hud_object(refresh_host = TRUE)
	if(hud_object)
		QDEL_NULL(hud_object)
	. = get_hud_object()
	if(refresh_host)
		host?.hud_used?.assert_item_inventory()

/**
  * Generates our hud object with a specific hud for a holder
  */
/datum/inventory_slot/proc/generate_hud_object(datum/hud/holder, refresh_host = TRUE)
	if(hud_object)
		CRASH("Attempted to generate hud object when one already exists")
	var/icon/style = host?.hud_used?.ui_style || ui_style2icon()
	hud_object = new /obj/screen/inventory(null, src)
	hud_object.name = name
	hud_object.icon = style
	hud_object.screen_loc = hud_screen_loc()
	hud_object.icon_state = hud_icon_state()
	if(refresh_host)
		host?.hud_used?.assert_item_inventory()

/obj/screen/inventory
	layer = HUD_LAYER
	plane = HUD_PLANE
	var/datum/inventory_slot/host
	var/obj/item/item

/obj/screen/inventory/Initialize(mapload, datum/inventory_slot/slot)
	if(slot)
		host = slot
	return ..()

/obj/screen/inventory/Destroy()
	clear_item()
	if(host.hud_object == src)
		host.hud_object = null
	return ..()

/obj/screen/inventory/proc/set_item(obj/item/I)
	ASSERT(istype(I))
	item = I
	vis_contents = list(I)

/obj/screen/inventory/proc/clear_item()
	item = null
	vis_contents.len = 0

/obj/screen/inventory/Click(location, control, params)
	. = ..()
	// Redirect clicks
	if(usr != host.host)
		return
	if(item)
		item.Click(location, control, params)
	usr.attack_ui(host.id)
	return TRUE

#warn Implement hover-over stuff, maybe have it so hovering over a single slot overlays in every slot an item can be equipped in

/*
/obj/screen/inventory
	var/slot_id	// The indentifier for the slot. It has nothing to do with ID cards.
	var/icon_empty // Icon when empty. For now used only by humans.
	var/icon_full  // Icon when contains an item. For now used only by humans.
	var/list/object_overlays = list()
	layer = HUD_LAYER
	plane = HUD_PLANE

/obj/screen/inventory/Click(location, control, params)
	if(hud?.mymob && (hud.mymob != usr))
		return
	// just redirect clicks

	if(hud?.mymob && slot_id)
		var/obj/item/inv_item = hud.mymob.get_item_by_slot(slot_id)
		if(inv_item)
			return inv_item.Click(location, control, params)

	if(usr.attack_ui(slot_id))
		usr.update_inv_hands()
	return TRUE

/obj/screen/inventory/MouseEntered()
	..()
	add_overlays()

/obj/screen/inventory/MouseExited()
	..()
	cut_overlay(object_overlays)
	object_overlays.Cut()

/obj/screen/inventory/update_icon_state()
	if(!icon_empty)
		icon_empty = icon_state

	if(hud?.mymob && slot_id && icon_full)
		if(hud.mymob.get_item_by_slot(slot_id))
			icon_state = icon_full
		else
			icon_state = icon_empty

/obj/screen/inventory/proc/add_overlays()
	var/mob/user = hud?.mymob

	if(!user || !slot_id)
		return

	var/obj/item/holding = user.get_active_held_item()

	if(!holding || user.get_item_by_slot(slot_id))
		return

	var/image/item_overlay = image(holding)
	item_overlay.alpha = 92

	if(!user.can_equip(holding, slot_id, TRUE, TRUE, TRUE))
		item_overlay.color = "#FF0000"
	else
		item_overlay.color = "#00ff00"

	object_overlays += item_overlay
	add_overlay(object_overlays)
*/

