var/list/whitelist_keys=new()
proc/is_whitelisted(var/keychk)
	keychk=ckey(keychk)
	if(whitelist_keys.Find(keychk))
		return 1
	return 0