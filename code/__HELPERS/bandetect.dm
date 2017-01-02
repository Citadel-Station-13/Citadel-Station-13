#define YOUNG 4


/client/proc/join_date_check(y,m,d)
	var/DBQuery/query = dbcon.NewQuery("SELECT DATEDIFF(Now(),'[y]-[m]-[d]')")

	if(!query.Execute())
		world.log << "SQL ERROR doing datediff. Error : \[[query.ErrorMsg()]\]\n"
		return FALSE

	if(query.NextRow())
		var/diff = text2num(query.item[1])
		if(diff < YOUNG)
			var/msg = "(IP: [address], ID: [computer_id]) is a new BYOND account made on [y]-[m]-[d]."
			if(diff < 0)
				msg += " They are also apparently from the future."
			message_admins("[key_name_admin(src)] [msg]")
	return TRUE
#undef YOUNG


/client/proc/findJoinDate()
	var/http[] = world.Export("http://byond.com/members/[src.ckey]?format=text")
	if(!http)
		world.log << "Failed to connect to byond age check for [src.ckey]"
		return FALSE

	var/F = file2text(http["CONTENT"])
	if(F)
		var/regex/R = regex("joined = \"(\\d{4})-(\\d{2})-(\\d{2})\"")
		if(!R.Find(F))
			CRASH("Age check regex failed")
		var/y = R.group[1]
		var/m = R.group[2]
		var/d = R.group[3]
		return join_date_check(y,m,d)
