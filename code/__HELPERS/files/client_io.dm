	// For FTP requests. (i.e. downloading runtime logs.)
	// However it'd be ok to use for accessing attack logs and such too, which are even laggier.
GLOBAL_VAR_INIT(fileaccess_timer, 0)

/**
 * Allows a client to return a path to a file.
 */
/client/proc/browse_files(root, list/valid_extensions, max_depth = 10)
	if(!length(valid_extensions) || !root)
		return
	if(!islist(valid_extensions))
		ASSERT(istext(valid_extensions))
		valid_extensions = list(valid_extensions)

	var/list/tree = list()
	var/chosen
	var/regex/R = new("\\.([valid_extensions.Join("|")])$", "i")
	do
		var/current = root + tree.Join("/") + "/"
		var/list/choices = list()
		var/safety = 1000
		for(var/name in flist(current))
			if(!--safety)
				CRASH("Uh oh, client/browse_files ran out of safety on [root + tree.Join("/")]/.")
			if(R.Find(name))
				choices += name
		var/chosen = input(src, "Choose a file to access:", "FTP Access", null) as null|anything in choices
		switch(chosen)
			if(null)
				return
			if("..")
				tree.len--
			if("/")
				tree.len = 0
			else
				if(copytext_char(chosen, -1) != "/")	// file
					break
				else
					tree += copytext_char(chosen, 1, -1)
					continue
	while(!chosen)
	return root + tree.Join("/") + chosen


#define FTPDELAY (5 SECONDS)
#define ADMIN_FTPDELAY_MODIFIER 0.5		//Admins get to spam files faster since we ~trust~ them!
/*	This proc is a failsafe to prevent spamming of file requests.
	It is just a timer that only permits a download every [FTPDELAY] ticks.
	This can be changed by modifying FTPDELAY's value above.

	PLEASE USE RESPONSIBLY, Some log files can reach sizes of 10MB!	*/
/client/proc/file_spam_check()
	var/time_to_wait = GLOB.fileaccess_timer - world.time
	if(time_to_wait > 0)
		to_chat(src, "<font color='red'>Error: file_spam_check(): Spam. Please wait [DisplayTimeText(time_to_wait)].</font>")
		return 1
	var/delay = FTPDELAY
	if(holder)
		delay *= ADMIN_FTPDELAY_MODIFIER
	GLOB.fileaccess_timer = world.time + delay
	return 0
#undef FTPDELAY
#undef ADMIN_FTPDELAY_MODIFIER
