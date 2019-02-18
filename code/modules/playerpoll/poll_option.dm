PLAYERPOLL_PROTECT_DATUM(/datum/poll_option)
/datum/poll_option
	var/text		//Option text
	var/pollid		//ID of the poll it belongs to
	var/id			//Primary key ID
	var/minval		//Numerical minval for rating polls
	var/maxval		//Numerical maxval for rating polls
	var/descminval	//Description for minval
	var/descmidval	//Description for middle
	var/descmaxval	//Description for maxval
	var/default_percent_count		//whether the option should be counted by default in certain types of percentage counting

/world/proc/playerpoll_retrieve_options(pollid)
	if(!isnum(pollid))
		pollid = text2num(pollid)
		if(!isnum(pollid))
			return
	var/datum/playerpoll_DBQuery/query = PLAYERPOLL_NEW_QUERY("SELECT id, text, minval, maxval, descmin, descmid, descmax, default_percentage_calc FROM [PLAYERPOLL_FORMAT_TABLE_NAME("poll_option")] WHERE pollid = [pollid]")
	if(!PLAYERPOLL_EXECUTE_QUERY(query))
		PLAYERPOLL_DELETE_DATUM(query)
		return
	. = list()
	while(PLAYERPOLL_QUERY_NEXTROW(query))
		var/datum/poll_option/P = new
		P.text = PLAYERPOLL_QUERY_GETITEM(query, 2)
		P.pollid = pollid
		P.id = PLAYERPOLL_QUERY_GETITEM(query, 1)
		P.minval = PLAYERPOLL_QUERY_GETITEM(query, 3)
		P.maxval = PLAYERPOLL_QUERY_GETITEM(query, 4)
		P.descminval = PLAYERPOLL_QUERY_GETITEM(query, 5)
		P.descmidval = PLAYERPOLL_QUERY_GETITEM(query, 6)
		P.descmaxval = PLAYERPOLL_QUERY_GETITEM(query, 7)
		P.default_percent_count = PLAYERPOLL_QUERY_GETITEM(query, 8)
		. += P
	if(!length(.))
		. = null

/world/proc/playerpoll_insert_options(pollid, list/datum/poll_option/options, erase_old = FALSE)
	if(!isnum(pollid))
		pollid = text2num(pollid)
		if(!isnum(pollid))
			return
	if(!options.len)
		return
	if(erase_old)
		var/datum/playerpoll_DBQuery/erase_query = PLAYERPOLL_NEW_QUERY("DELETE FROM [PLAYERPOLL_FORMAT_TABLE_NAME("poll_option")] WHERE pollid = [pollid]")
		PLAYERPOLL_EXECUTE_QUERY(erase_query)
		PLAYERPOLL_DELETE_DATUM(erase_query)
	var/list/assembled = list()
	for(var/i in options)
		var/datum/poll_option/O = i
		assembled += "([O.pollid], '[O.text]', [O.minval], [O.maxval], [O.descminval], [O.descmidval], [O.descmaxval], [O.default_percent_count])"
	var/poll_option_table_name = PLAYERPOLL_TABLENAMEF_OPTIONS
	assembled = assembled.Join(",\n")
	var/datum/playerpoll_DBQuery/query = PLAYERPOLL_NEW_QUERY("INSERT INTO [poll_option_table_name] (pollid, text, minval, maxval, descmin, descmid, descmax, default_percentage_calc) VALUES [assembled]")
	. = PLAYERPOLL_EXECUTE_QUERY(query)
	PLAYERPOLL_DELETE_DATUM(query)
