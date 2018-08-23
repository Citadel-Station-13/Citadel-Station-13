/proc/DB_IRV_poll_options_by_id(pollid)
	. = "ERROR"
	pollid = text2num(pollid)		//prevent injection
	if(!isnum(pollid))
		return
	var/datum/DBQuery/query_irv_options = SSdbcore.NewQuery("SELECT id, text FROM [format_table_name("poll_option")] WHERE pollid = [pollid]")
	if(!query_irv_options.warn_execute())
		qdel(query_irv_options)
		return
	. = list()
	while(query_irv_options.NextRow())
		var/id = text2num(query_irv_options.item[1])
		var/text = query_irv_options.item[2]
		.["[id]"] = text
