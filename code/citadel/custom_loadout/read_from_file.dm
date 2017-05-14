
GLOBAL_LIST(custom_item_list)	//Assoc list in form of ckey = delimited paramlist.

//File should be in the format of Ckey|things, where things is in the form of itempath1=amount;itempath2=amount;itempath3=amount
//Each ckey should be on a different line!!

/proc/reload_custom_item_list(custom_filelist)
	if(!custom_filelist)
		custom_filelist = "config/custom_items.txt"
	GLOB.custom_item_list = list()
	var/list/file_lines = world.file2list(custom_filelist)
	for(var/line in file_lines)
		var/list/key_separation = splittext(line, "|")
		var/key = key_separation[1]
		var/items = key_separation[2]
		if(!key)
			continue
		if(!items)
			GLOB.custom_item_list[key] = "ERROR"
			continue
		GLOB.custom_item_list[key] = list()
		var/list/item_separation = splittext(items, ";")
		for(var/item_string in item_separation)
			world << "itemstring [item_string]"
			var/list/amount_separation = splittext(item_string, "=")
			world << "separated [item_string] == [english_list(amount_separation)]"
			var/path_to_item = amount_separation[1]
			if(!ispath(text2path(path_to_item)))
				GLOB.custom_item_list[key] += "ERROR"
			var/amount_of_item = amount_separation[2]
			if(!amount_of_item)
				GLOB.custom_item_list[key][path_to_item] = "ERROR"
			var/amount_of_item_num = 0
			if(isnum(amount_of_item))
				amount_of_item_num = amount_of_item
			else
				amount_of_item_num = text2num(amount_of_item)
			if(!isnum(amount_of_item) || (amount_of_item < 1))
				GLOB.custom_item_list[key][path_to_item] = "ERROR"
			GLOB.custom_item_list[key][path_to_item] = amount_of_item_num
	return GLOB.custom_item_list

/proc/parse_custom_items_by_key(ckey)
	world << "parse_custom_items_by_key([ckey])"
	if(!ckey || !GLOB.custom_item_list[ckey])
		world << "parse_custom_items_by_key: no ckey match"
		return null
	var/list/items = GLOB.custom_item_list[ckey]
	for(var/I in items)
		if(items[I] == "ERROR")
			items -= I
			continue
	return items
