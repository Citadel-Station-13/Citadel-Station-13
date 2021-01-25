/proc/tgswho()
	var/list/message = list("Players: \n")
	var/list/player_keys = list()
	for(var/player in GLOB.clients)
		var/client/C = player
		player_keys += "[(C in GLOB.admins) ? "[C.holder.fakekey ? C.holder.fakekey : C]" : C]"

	for(var/verified_player in player_keys)
		message += "- [verified_player]\n"

	return jointext(message, "")

/proc/tgsadminwho()
	var/list/full_message = list("Connected clients: \n")
	var/list/message = list("Players: \n")
	var/list/message_admin = list("Admins: \n")
	var/list/player_keys = list()
	var/list/admin_keys = list()
	for(var/player in GLOB.clients)
		var/client/C = player
		player_keys += "[C]"

	for(var/verified_player in player_keys)
		message += "- [verified_player]\n"

	for(var/adm in GLOB.admins)
		var/client/C = adm
		admin_keys += "[C.holder.fakekey ? "[C] disguised as [C.holder.fakekey]" : "[C]"]"

	for(var/verified_admin in admin_keys)
		message_admin += "- [verified_admin]\n"

	if(message_admin)
		var/finished_admin_message = "[jointext(message_admin, "")]"
		full_message += finished_admin_message

	if(message)
		var/finished_message = "[jointext(message, "")]"
		full_message += finished_message

	return jointext(full_message, "")
