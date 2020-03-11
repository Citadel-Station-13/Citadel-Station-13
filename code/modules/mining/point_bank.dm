/obj/machinery/point_bank
	name = "mining point bank"
	desc = "A wall mounted machine that can be used to store and transfer mining points. Sharing is caring!"
	icon = 'icons/obj/machines/mining_machines.dmi'
	icon_state = "ore_redemption"
	density = FALSE
	req_access = list(ACCESS_MINERAL_STOREROOM)
	circuit = null
	layer = BELOW_OBJ_LAYER
	var/points = 0

/obj/machinery/point_bank/ui_interact(mob/user, ui_key = "main", datum/tgui/ui = null, force_open = FALSE, datum/tgui/master_ui = null, datum/ui_state/state = GLOB.default_state)
	ui = SStgui.try_update_ui(user, src, ui_key, ui, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "point_bank", "Point Bank", 200, 100, master_ui, state)
		ui.open()

/obj/machinery/point_bank/ui_data(mob/user)
	var/list/data = list()
	data["totalPoints"] = points
	return data

/obj/machinery/mineral/ore_redemption/ui_act(action, params)
	if(..())
		return
	switch(action)
		if("Claim")
			var/mob/M = usr
			var/obj/item/card/id/I = M.get_idcard(TRUE)
			if(points)
				if(I)
					I.mining_points += points
					points = 0
				else
					to_chat(usr, "<span class='warning'>No ID detected.</span>")
			else
				to_chat(usr, "<span class='warning'>No points to claim.</span>")
			return TRUE

/obj/machinery/point_bank/power_change()
	..()
	update_icon()

/obj/machinery/point_bank/update_icon_state()
	if(powered())
		icon_state = initial(icon_state)
	else
		icon_state = "[initial(icon_state)]-off"
