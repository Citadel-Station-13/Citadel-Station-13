PLAYERPOLL_PROTECT_DATUM(/datum/poll_option)
/datum/poll_option
	var/name		//Name of the option
	var/pollid		//ID of the poll it belongs to
	var/id			//Primary key ID

/world/proc/retrieve_poll_options_by_id(pollid)
	if(!isnum(pollid))
		pollid = text2num(pollid)
		if(!isnum(pollid))
			return
	var/PLAYERPOLL_DBQUERY_PATH/query = PLAYERPOLL_NEW_QUERY("SELECT id, text FROM [PLAYERPOLL_FORMAT_TABLE_NAME("poll_option")] WHERE pollid = [pollid]")
	if(!PLAYERPOLL_EXECUTE_QUERY(query))
		PLAYERPOLL_DELETE_DATUM(query)
		return
	. = list()
	while(PLAYERPOLL_QUERY_NEXTROW(query))
		var/id = PLAYERPOLL_QUERY_GET_ITEM(1)
		var/text = PLAYERPOLL_QUERY_GET_ITEM(2)
		var/datum/poll_option/P = new
		P.name = text
		P.pollid = pollid
		P.id = id
		. += P
	if(!..len)
		. = null

/world/proc/store_poll_options_to_id(pollid, list/datum/poll_option/options, erase_old = FALSE)
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
		assembled += "([O.pollid], [O.text])"
	var/PLAYERPOLL_DBQUERY_PATH/query = PLAYERPOLL_NEW_QUERY("INSERT INTO [PLAYERPOLL_FORMAT_TABLE_NAME("poll_option")] pollid, text VALUES [assembled.Join(",\n")]")
	. = PLAYERPOLL_EXECUTE_QUERY(query)
	PLAYERPOLL_DELETE_QUERY(query)
