/proc/DB_FullAltCheckCkey(ckey, list/ckeys_found = list(), recurse = FALSE, recursing = FALSE, list/ip_searched = list(), list/cid_searched = list(), list/ckeys_searched = list())
	. = "ERROR"
	if(!SSdbcore.IsConnected())
		RETURN_ERROR
	ckey = sanitizeSQL(ckey)
	ckeys_found |= ckey
	var/oldusr = usr
	usr = null				//shitcode to allow admin proccalls
	var/list/cids = list()
	var/list/ips = list()
	var/datum/DBQuery/get_ip = SSdbcore.NewQuery("SELECT DISTINCT ip FROM [format_table_name("connection_log")] WHERE ckey = '[ckey]'")
	if(!get_ip.warn_execute())
		qdel(get_ip)
		RETURN_ERROR
	CHECK_TICK
	while(get_ip.NextRow())
		ips |= get_ip.item[1]
		CHECK_TICK
	var/datum/DBQuery/get_cid = SSdbcore.NewQuery("SELECT DISTINCT computerid FROM [format_table_name("connection_log")] WHERE ckey = '[ckey]'")
	if(!get_cid.warn_execute())
		qdel(get_cid)
		RETURN_ERROR
	CHECK_TICK
	while(get_cid.NextRow())
		cids |= get_cid.item[1]
		CHECK_TICK
	var/list/alts = list()
	cids -= cid_searched
	ips -= ip_searched
	for(var/i in cids)
		alts |= DB_CIDGetAll(i)
		cid_searched |= i
		CHECK_TICK
	for(var/i in ips)
		alts |= DB_IPGetAllRaw(i)
		ip_searched |= i
		CHECK_TICK
	ckeys_found |= alts
	ckeys_searched |= ckey
	if(recurse)
		var/list/requires_find = ckeys_found - ckeys_searched
		for(var/i in requires_find)
			DB_FullAltCheckCkey(i, ckeys_found, TRUE, TRUE, ip_searched, cid_searched, ckeys_searched)
			CHECK_TICK
	usr = oldusr
	return ckeys_found

/proc/DB_IPGetAll(ip)
	. = "ERROR"
	if(!SSdbcore.IsConnected())
		RETURN_ERROR
	ip = sanitizeSQL(ip)
	var/oldusr = usr
	usr = null				//shitcode to allow admin proccalls
	var/datum/DBQuery/get_players = SSdbcore.NewQuery("SELECT DISTINCT ckey FROM [format_table_name("connection_log")] WHERE ip = INET_ATON('[ip]')")
	if(!get_players.warn_execute())
		qdel(get_players)
		RETURN_ERROR
	. = list()
	while(get_players.NextRow())
		var/player = get_players.item[1]
		. += player
	usr = oldusr

/proc/DB_IPGetAllRaw(ip)
	. = "ERROR"
	if(!SSdbcore.IsConnected())
		RETURN_ERROR
	if(!isnum(ip))			//blocks injections
		ip = text2num(ip)
	if(!isnum(ip))
		RETURN_ERROR
	var/oldusr = usr
	usr = null				//shitcode to allow admin proccalls
	var/datum/DBQuery/get_players = SSdbcore.NewQuery("SELECT DISTINCT ckey FROM [format_table_name("connection_log")] WHERE ip = [ip])")
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
	cid = sanitizeSQL(cid)
	var/oldusr = usr
	usr = null				//shitcode to allow admin proccalls
	var/datum/DBQuery/get_players = SSdbcore.NewQuery("SELECT DISTINCT ckey FROM [format_table_name("connection_id")] WHERE computerid = '[cid]'")
	if(!get_players.warn_execute())
		qdel(get_players)
		RETURN_ERROR
	. = list()
	while(get_players.NextRow())
		var/player = get_players.item[1]
		. += player
		CHECK_TICK
	usr = oldusr
