
GLOBAL_LIST(custom_item_list)
//Layered list in form of custom_item_list[ckey][job][items][amounts]
//ckey is key, job is specific jobs, or "ALL" for all jobs, items for items, amounts for amount of item.

//File should be in the format of ckey|exact job name/exact job name/or put ALL instead of any job names|/path/to/item=amount;/path/to/item=amount
//Each ckey should be in a different line
//if there's multiple entries of a single ckey the later ones will add to the earlier definitions.

/proc/reload_custom_roundstart_items_list(custom_filelist)
	if(!custom_filelist)
		custom_filelist = "config/custom_roundstart_items.txt"
	GLOB.custom_item_list = list()
	var/list/file_lines = world.file2list(custom_filelist)
	for(var/line in file_lines)
		try							//Lazy as fuck.
			if(length(line) == 0)	//Emptyline, no one cares.
				continue
			if(copytext(line,1,3) == "//")	//Commented line, ignore.
				continue
			var/ckey_str_sep = findtext(line, "|")						//Process our stuff..
			var/job_str_sep = findtext(line, "|", ckey_str_sep+1)
			var/item_str_sep = findtext(line, "|", job_str_sep+1)
			var/ckey_str = ckey(copytext(line, 1, ckey_str_sep))
			var/job_str = copytext(line, ckey_str_sep+1, job_str_sep)
			var/item_str = copytext(line, job_str_sep+1, item_str_sep)
			if(!ckey_str || !job_str || !item_str || !length(ckey_str) || length(job_str) || length(item_str))
				throw EXCEPTION("Errored Line")
			world << "DEBUG: Line process: [line]"
			world << "DEBUG: [ckey_str_sep], [job_str_sep], [item_str_sep], [ckey_str], [job_str], [item_str]."
			if(!islist(GLOB.custom_item_list[ckey_str]))
				GLOB.custom_item_list[ckey_str] = list()	//Initialize list for this ckey if it isn't initialized..
			var/list/jobs = splittext(job_str, "/")
			world << "DEBUG: Job string processed."
			world << "DEBUG: JOBS: [english_list(jobs)]"
			for(var/job in jobs)
				if(!islist(GLOB.custom_item_list[ckey_str][job]))
					GLOB.custom_item_list[ckey_str][job] = list()		//Initialize item list for this job of this ckey if not already initialized.
			var/list/item_strings = splittext(item_str, ";")			//Get item strings in format of /path/to/item=amount
			for(var/item_string in item_strings)
				var/path_str_sep = findtext(item_string, "=")
				var/path = copytext(item_string, 1, path_str_sep)	//Path to spawn
				var/amount = copytext(item_string, path_str_sep+1)	//Amount to spawn
				world << "DEBUG: Item string [item_string] processed"
				amount = text2num(amount)
				path = text2path(path)
				if(!ispath(path) || !isnum(amount))
					throw EXCEPTION("Errored line")
				world << "DEBUG: [path_str_sep], [path], [amount]"
				for(var/job in jobs)
					if(!GLOB.custom_item_list[ckey_str][job][path])		//Doesn't exist, make it exist!
						GLOB.custom_item_list[ckey_str][job][path] = amount
					else
						GLOB.custom_item_list[ckey_str][job][path] += amount	//Exists, we want more~
		catch	//Uh oh.
			var/msg = "Error processing line in [custom_filelist]. Line : [line]"
			message_admins(msg)
			log_game(msg)
			stack_trace(msg)
			continue
	return GLOB.custom_item_list

/proc/parse_custom_item_list_key_to_joblist(ckey)		//First stage
	if(!ckey || !GLOB.custom_item_list[ckey])
		return null
	return GLOB.custom_item_list[ckey]

/proc/parse_custom_item_list_joblist_to_items(list, job)	//Second stage
	var/list/ret = list()
	for(var/j in list)	//for job in ckey-job-item list
		if((j == job) || (j == "ALL") || (job == "ALL"))	//job matches or is all jobs or we want everything.
			for(var/i in list[j])		//for item in job-item list
				if(!ret[i])
					ret[i] = list[j][i]		//add to return with return value if not there
				else
					ret[i] += list[j][i]	//else, add to that item in return value!
	return ret	//If done properly, you'll have a list of item typepaths with how many to spawn.

/proc/parse_custom_items_by_key_and_job(ckey, job)
	return parse_custom_item_list_joblist_to_items(parse_custom_item_list_key_to_joblist(ckey), job)

/proc/debug_roundstart_items()
	reload_custom_roundstart_items_list()
