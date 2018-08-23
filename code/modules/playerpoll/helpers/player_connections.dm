/proc/DB_CountCkeyConnectionsDaysBefore(ckey, daysbefore, current_date)
	//wip

/proc/DB_CountCkeyConnectionsBetweenDates(ckey, start, end)
	. = "ERROR"
	if(!SSdbcore.IsConnected())
		return
	start = sanitizeSQL(start)
	end = sanitizeSQL(end)
	ckey = sanitizeSQL(ckey)
	var/oldusr = usr
	usr = null				//shitcode to allow admin proccalls
	var/datum/DBQuery/amount = SSdbcore.NewQuery("SELECT COUNT(id) FROM [format_table_name("connection_log")] WHERE ckey = [ckey] AND datetime BETWEEN [start] AND [end]")
	if(!amount.warn_execute())
		qdel(amount)
		return
	usr = oldusr
	return amount.item[1]
