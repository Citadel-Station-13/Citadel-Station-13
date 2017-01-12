var/global/list/uplinks = list()

/**
 * Uplinks
 *
 * All /obj/item(s) have a hidden_uplink var. By default it's null. Give the item one with 'new(src') (it must be in it's contents). Then add 'uses.'
 * Use whatever conditionals you want to check that the user has an uplink, and then call interact() on their uplink.
 * You might also want the uplink menu to open if active. Check if the uplink is 'active' and then interact() with it.
**/
/obj/item/device/uplink
	name = "syndicate uplink"
	desc = "There is something wrong if you're examining this."
	var/active = FALSE
	var/lockable = TRUE
	var/telecrystals = 20

	var/owner = null
	var/datum/game_mode/gamemode = null
	var/spent_telecrystals = 0
	var/purchase_log = ""

/obj/item/device/uplink/New()
	..()
	uplinks += src

/obj/item/device/uplink/Destroy()
	uplinks -= src
	return ..()

/obj/item/device/uplink/interact(mob/user)
	active = TRUE
	ui_interact(user)

/obj/item/device/uplink/ui_interact(mob/user, ui_key = "main", datum/tgui/ui = null, force_open = 0, \
									datum/tgui/master_ui = null, datum/ui_state/state = inventory_state)
	ui = SStgui.try_update_ui(user, src, ui_key, ui, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "uplink", name, 450, 750, master_ui, state)
		ui.set_autoupdate(FALSE) // This UI is only ever opened by one person, and never is updated outside of user input.
		ui.set_style("syndicate")
		ui.open()

/obj/item/device/uplink/ui_data(mob/user)
	var/list/data = list()
	data["telecrystals"] = telecrystals
	data["lockable"] = lockable

	var/list/uplink_items = get_uplink_items(gamemode)
	data["categories"] = list()
	for(var/category in uplink_items)
		var/list/cat = list(
			"name" = category,
			"items" = list(),
		)
		for(var/item in uplink_items[category])
			var/datum/uplink_item/I = uplink_items[category][item]
			cat["items"] += list(list(
				"name" = I.name,
				"cost" = I.cost,
				"desc" = I.desc,
			))
		data["categories"] += list(cat)
	return data

/obj/item/device/uplink/ui_act(action, params)
	if(!active)
		return

	switch(action)
		if("buy")
			var/item = params["item"]

			var/list/uplink_items = get_uplink_items(gamemode)
			var/list/buyable_items = list()
			for(var/category in uplink_items)
				buyable_items += uplink_items[category]

			if(item in buyable_items)
				var/datum/uplink_item/I = buyable_items[item]
				I.buy(usr, src)
				. = TRUE
		if("lock")
			active = FALSE
			SStgui.close_uis(src)


/obj/item/device/uplink/ui_host()
	return loc

// Refund certain items by hitting the uplink with it.
/obj/item/device/radio/uplink/attackby(obj/item/I, mob/user, params)
	for(var/item in subtypesof(/datum/uplink_item))
		var/datum/uplink_item/UI = item
		var/path = initial(UI.item)
		var/cost = initial(UI.cost)
		var/refundable = initial(UI.refundable)
		if(I.type == path && refundable)
			hidden_uplink.telecrystals += cost
			hidden_uplink.spent_telecrystals -= cost
			user << "<span class='notice'>[I] refunded.</span>"
			qdel(I)
			return
	..()

// A collection of pre-set uplinks, for admin spawns.
/obj/item/device/radio/uplink/New()
	..()
	icon_state = "radio"
	hidden_uplink = new(src)
	hidden_uplink.active = TRUE
	hidden_uplink.lockable = FALSE

/obj/item/device/radio/uplink/nuclear/New()
	..()
	hidden_uplink.gamemode = /datum/game_mode/nuclear

/obj/item/device/multitool/uplink/New()
	..()
	hidden_uplink = new(src)
	hidden_uplink.active = TRUE
	hidden_uplink.lockable = FALSE
