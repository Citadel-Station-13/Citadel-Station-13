/datum/player_playtime/New(mob/viewer)
	ui_interact(viewer)

/datum/player_playtime/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "PlayerPlaytimes", "Player Playtimes")
		ui.open()

/datum/player_playtime/ui_state(mob/user)
	return GLOB.admin_state

/datum/player_playtime/ui_data(mob/user)
	var/list/data = list()

	var/list/clients = list()
	for(var/client/C in GLOB.clients)
		var/list/client = list()

		client["ckey"] = C.ckey
		client["playtime"] = C.get_exp_living(TRUE)
		client["playtime_hours"] = C.get_exp_living()

		var/mob/M = C.mob
		client["observer"] = isobserver(M)
		client["ingame"] = !isnewplayer(M)
		client["name"] = M.real_name
		var/nnpa = CONFIG_GET(number/notify_new_player_age)
		if(nnpa >= 0)
			if(C.account_age >= 0 && (C.account_age < CONFIG_GET(number/notify_new_player_age)))
				client["new_account"] = "New BYOND account [C.account_age] day[(C.account_age==1?"":"s")] old, created on [C.account_join_date]"

		clients += list(client)

	clients = sort_list(clients, GLOBAL_PROC_REF(cmp_playtime))
	data["clients"] = clients
	return data

/datum/player_playtime/ui_act(action, params)
	if(..())
		return

	switch(action)
		if("view_playtime")
			var/mob/target = get_mob_by_ckey(params["ckey"])
			usr.client.holder.cmd_show_exp_panel(target.client)
		if("admin_pm")
			usr.client.cmd_admin_pm(params["ckey"])
		if("player_panel")
			var/mob/target = get_mob_by_ckey(params["ckey"])
			usr.client.holder.show_player_panel(target)
		if("view_variables")
			var/mob/target = get_mob_by_ckey(params["ckey"])
			usr.client.debug_variables(target)
		if("observe")
			if(!isobserver(usr) && !check_rights(R_ADMIN))
				return

			var/mob/target = get_mob_by_key(params["ckey"])
			if(!target)
				to_chat(usr, "<span class='notice'>Player not found.</span>")
				return

			var/client/C = usr.client
			if(!isobserver(usr) && !C.admin_ghost())
				return
			var/mob/dead/observer/A = C.mob
			A.ManualFollow(target)
