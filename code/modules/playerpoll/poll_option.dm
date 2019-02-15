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
	var/PLAYERPOLL_DBQUERY_PATH/query = PLAYERPOLL_NEW_QUERY("SELECT id, text, minval, maxval, descmin, descmid, descmax, default_percentage_calc FROM [PLAYERPOLL_FORMAT_TABLE_NAME("poll_option")] WHERE pollid = [pollid]")
	if(!PLAYERPOLL_EXECUTE_QUERY(query))
		PLAYERPOLL_DELETE_DATUM(query)
		return
	. = list()
	while(PLAYERPOLL_QUERY_NEXTROW(query))
		var/datum/poll_option/P = new
		P.name = PLAYERPOLL_QUERY_GET_ITEM(P, 2)
		P.pollid = pollid
		P.id = PLAYERPOLL_QUERY_GET_ITEM(P, 1)
		P.minval = PLAYERPOLL_QUERY_GET_ITEM(P, 3)
		P.maxval = PLAYERPOLL_QUERY_GET_ITEM(P, 4)
		P.descminval = PLAYERPOLL_QUERY_GET_ITEM(P, 5)
		P.descmidval = PLAYERPOLL_QUERY_GET_ITEM(P, 6)
		P.descmaxval = PLAYERPOLL_QUERY_GET_ITEM(P, 7)
		P.default_percent_count = PLAYERPOLL_QUERY_GET_ITEM(P, 8)
		. += P
	if(!..len)
		. = null

/world/proc/playerpoll_insert_options(pollid, list/datum/poll_option/options, erase_old = FALSE)
	if(!isnum(pollid))
		pollid = text2num(pollid)
		if(!isnum(pollid))
			return
	if(!options.len)
		return
	if(erase_old)
		var/PLAYERPOLL_DBQUERY_PATH/erase_query = PLAYERPOLL_NEW_QUERY("DELETE FROM [PLAYERPOLL_FORMAT_TABLE_NAME("poll_option")] WHERE pollid = [pollid]")
		PLAYERPOLL_EXECUTE_QUERY(erase_query)
		PLAYERPOLL_DELETE_DATUM(erase_query)
	var/list/assembled = list()
	for(var/i in options)
		var/datum/poll_option/O = i
		assembled += "([O.pollid], [O.text], [O.minval], [O.maxval], [O.descminval], [O.descmidval], [O.descmaxval], [O.default_percentage_calc])"
	var/PLAYERPOLL_DBQUERY_PATH/query = PLAYERPOLL_NEW_QUERY("INSERT INTO [PLAYERPOLL_FORMAT_TABLE_NAME("poll_option")] (pollid, text, minval, maxval, descmin, descmid, descmax, default_percentage_calc) VALUES [assembled.Join(",\n")]")
	. = PLAYERPOLL_EXECUTE_QUERY(query)
	PLAYERPOLL_DELETE_QUERY(query)
