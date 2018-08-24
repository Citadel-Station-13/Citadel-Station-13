/proc/DB_FullAltCheckCkey(ckey, recurse = FALSE, list/found = list(), list/recurse_searched = list(), recursing = FALSE)
	if(recursing && (ckey in recurse_searched))
		return
	. = "ERROR"
	if(!SSdbcore.IsConnected())
		RETURN_ERROR
	ckey = sanitizeSQL(ckey)
	var/oldusr = usr
	usr = null				//shitcode to allow admin proccalls
	var/list/cids = list()
	var/list/ips = list()
	var/datum/DBQuery/get_ip = SSdbcore.NewQuery("SELECT ip FROM [format_table_name("connection_log")] WHERE ckey = [ckey]")
	if(!get_ip.warn_execute())
		qdel(get_ip)
		RETURN_ERROR
	while(get_ip.NextRow())
		ips += get_ip.item[1]
	var/datum/DBQuery/get_cid = SSdbcore.NewQuery("SELECT computerid FROM [format_table_name("connection_log")] WHERE ckey = [ckey]")
	if(!get_cid.warn_execute())
		qdel(get_cid)
		RETURN_ERROR
	while(get_cid.NextRow())
		cids += get_cid.item[1]
	var/list/alts = list()
	for(var/i in cids)
		alts |= DB_CIDGetAll(i)
	for(var/i in ips)
		alts |= DB_IPGetAll(i)
	recurse_searched += ckey
	found |= alts
	if(recurse)
		var/list/requires_find = found - recurse_searched
		for(var/i in requires_find)
			DB_FullAltCheckCkey(i, TRUE, found, recurse_searched, TRUE)
	usr = oldusr
	return found

/proc/DB_IPGetAll(ip)
	. = "ERROR"
	if(!SSdbcore.IsConnected())
		RETURN_ERROR
	if(!isnum(ip))
		ip = text2num(ip)
		if(!isnum(ip))
			RETURN_ERROR
	var/oldusr = usr
	usr = null				//shitcode to allow admin proccalls
	var/datum/DBQuery/get_players = SSdbcore.NewQuery("SELECT ckey FROM [format_table_name("player")] WHERE ip = [ip]")
	if(!get_players.warn_execute())
		qdel(get_players)
		RETURN_ERROR
	. = list()
	while(get_players.NextRow())
		var/player = get_players.item[1]
		. += player
	usr = oldusr

/proc/DB_CIDGetAll(cid)
	. = "ERROR"
	if(!SSdbcore.IsConnected())
		return
	if(!isnum(cid))
		cid = text2num(cid)
		if(!isnum(cid))
			RETURN_ERROR
	var/oldusr = usr
	usr = null				//shitcode to allow admin proccalls
	var/datum/DBQuery/get_players = SSdbcore.NewQuery("SELECT ckey FROM [format_table_name("player")] WHERE cid = [cid]")
	if(!get_players.warn_execute())
		qdel(get_players)
		RETURN_ERROR
	. = list()
	while(get_players.NextRow())
		var/player = get_players.item[1]
		. += player
	usr = oldusr
