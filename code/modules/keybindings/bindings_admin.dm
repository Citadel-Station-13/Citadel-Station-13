/datum/admins/key_down(_key, client/user)
	switch(_key)
		if("F5")
			user.admin_ghost()
			return
		if("F6")
			player_panel_new()
			return
		if("F7")
			user.togglebuildmodeself()
			return
		if("F8")
			if(user.keys_held["Ctrl"])
				user.stealth()
			else
				user.invisimin()
			return
	..()
