/datum/admins/key_down(_key, client/user)
	switch(_key)
<<<<<<< HEAD
=======
		if("F3")
			user.get_admin_say()
			return
>>>>>>> b9078e1... Makes adminsay bind F3 work (#35028)
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
